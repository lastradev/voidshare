import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:void_share/widgets/custom_snack_bar.dart';

import '../providers/file_manager.dart';
import '../providers/file_uploader.dart';
import '../widgets/custom_alert_dialog.dart';
import '../widgets/file_clearer.dart';
import '../widgets/file_loading_indicator.dart';
import '../widgets/select_files_container.dart';
import '../widgets/selected_file_card.dart';
import '../widgets/terms_subtitle.dart';
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
        visible:
            fileManager.filesData.isNotEmpty && !fileManager.isLoadingFiles,
        child: FloatingActionButton(
          tooltip: 'Upload files',
          onPressed: () async {
            if (isUploading) {
              return;
            }

            isUploading = true;
            Navigator.of(context).pushNamed(
              UploadingScreen.routeName,
            );

            try {
              final url = await fileUploader.uploadFiles(fileManager.filesData);
              Navigator.of(context).pushReplacementNamed(
                UploadedScreen.routeName,
                arguments: url.trim(),
              );
            } on HttpException catch (e) {
              Navigator.of(context).pop();
              CustomSnackBar.showSnackBar(context, e.message);
            } on SocketException {
              Navigator.of(context).pop();
              CustomSnackBar.showSnackBar(
                context,
                'Error trying to connect to the server.',
              );
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
            onPressed: () =>
                Navigator.of(context).pushNamed(HistoryScreen.routeName),
            icon: const Icon(
              Icons.history,
            ),
          ),
        ],
      ),
      // Slivers needed for performance
      // https://www.youtube.com/watch?v=LaMOIII96oU
      // https://github.com/flutter/flutter/issues/26072#issuecomment-706724534
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
                  fileData: fileManager.filesData[index],
                );
              },
              childCount: fileManager.filesData.length,
            ),
          ),
        ],
      ),
    );
  }
}
