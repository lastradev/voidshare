import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/file_manager.dart';
import '../providers/file_uploader.dart';
import '../widgets/custom_snack_bars.dart';
import '../widgets/file_clearer.dart';
import '../widgets/file_loading_indicator.dart';
import '../widgets/select_files_container.dart';
import '../widgets/selected_file_card.dart';
import '../widgets/terms_subtitle.dart';
import 'error_screen.dart';
import 'history_screen.dart';
import 'uploaded_screen.dart';
import 'uploading_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fileManager = Provider.of<FileManager>(context);
    final fileUploader = Provider.of<FileUploader>(context, listen: false);
    bool isUploading = false;

    return Scaffold(
      floatingActionButton: Visibility(
        visible: fileManager.files.isNotEmpty && !fileManager.isLoadingFiles,
        child: FloatingActionButton(
          tooltip: 'Upload files',
          onPressed: () async {
            if (isUploading) {
              return;
            }

            if (fileManager.files.isExcedingMaxSize) {
              CustomSnackBars.showCustomSnackBar(
                context,
                'Files total size must be under 512 MB.',
              );
              return;
            }

            isUploading = true;

            /// Keep retrying until success or abort.
            // Note: Should probably move this business logic from this file.
            while (true) {
              try {
                Navigator.of(context).pushNamed(
                  UploadingScreen.routeName,
                );
                final url = await fileUploader.uploadFiles(fileManager.files);
                Navigator.of(context).pushReplacementNamed(
                  UploadedScreen.routeName,
                  arguments: url.trim(),
                );
                break;
                /// Catch abort operation.
              } on HttpException {
                Navigator.of(context).pop();
                CustomSnackBars.showCustomSnackBar(context, 'Upload canceled.');
                break;
              } on SocketException {
                /// Don't retry if abort.
                if (fileUploader.isUploadAborted) {
                  Navigator.of(context).pop();
                  break;
                }

                final retry = await Navigator.of(context).pushReplacementNamed(
                  ErrorScreen.routeName,
                );
                if (retry == null) break;
              } on FileSystemException {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                CustomSnackBars.showCustomSnackBar(
                  context,
                  'Could not retrieve file(s).',
                );
                break;
              }
            }

            isUploading = false;
          },
          child: const Icon(Icons.file_upload_rounded),
        ),
      ),
      appBar: AppBar(
        title: const Text('VoidShare'),
        actions: [
          IconButton(
            tooltip: 'History',
            onPressed: () =>
                Navigator.of(context).pushNamed(HistoryScreen.routeName),
            icon: const Icon(
              Icons.history,
            ),
          ),
        ],
      ),

      /// Slivers needed for performance.
      /// https://www.youtube.com/watch?v=LaMOIII96oU.
      /// https://github.com/flutter/flutter/issues/26072#issuecomment-706724534.
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/writer.png',
                    width: 200,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Upload files',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const TermsSubtitle(),
                  const SizedBox(height: 30),
                  const SelectFilesContainer(),
                  const FileClearer(),
                  if (fileManager.isLoadingFiles) const FileLoadingIndicator(),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return SelectedFileCard(
                  file: fileManager.files[index],
                );
              },
              childCount: fileManager.files.length,
            ),
          ),
        ],
      ),
    );
  }
}
