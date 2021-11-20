import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/upload.dart';
import '../providers/file_manager.dart';
import '../widgets/file_clearer.dart';
import '../widgets/file_loading_indicator.dart';
import '../widgets/select_files_container.dart';
import '../widgets/selected_file_card.dart';
import '../widgets/terms_subtitle.dart';
import 'about_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fileManager = Provider.of<FileManager>(context);

    return Scaffold(
      floatingActionButton: Visibility(
        visible: fileManager.files.isNotEmpty && !fileManager.isLoadingFiles,
        child: FloatingActionButton(
          tooltip: 'Upload files',
          onPressed: () => beginUpload(context),
          child: const Icon(Icons.file_upload_rounded),
        ),
      ),
      appBar: AppBar(
        title: const Text('VoidShare'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AboutScreen.routeName),
            tooltip: 'About',
            icon: const Icon(Icons.info_outline_rounded),
          ),
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(HistoryScreen.routeName),
            tooltip: 'History',
            icon: const Icon(Icons.history),
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
                    height: _getWriterHeight(context),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Upload files',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const TermsSubtitle(),
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

double _getWriterHeight(BuildContext context) {
  if (MediaQuery.of(context).size.height < 600) {
    return 180;
  } else if (MediaQuery.of(context).size.height < 680) {
    return 224;
  } else {
    return 284;
  }
}
