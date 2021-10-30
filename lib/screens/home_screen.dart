import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/formatters.dart';
import '../providers/file_manager.dart';
import '../widgets/file_loading_indicator.dart';
import '../widgets/select_files_container.dart';
import '../widgets/selected_file_card.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fileManager = Provider.of<FileManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('VoidShare'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(
              HistoryScreen.routeName,
              // Necessary for PageTransition
              // https://pub.dev/packages/page_transition#usage-for-predefined-routes
              arguments: 'arguments data',
            ),
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
                  const SizedBox(height: 30),
                  Image.asset(
                    'assets/images/writer_illustration.png',
                    width: 200,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Upload files',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Files must adhere to ',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        TextSpan(
                          text: '0x0.st terms',
                          style: const TextStyle(
                            color: Colors.lightBlue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launch('https://0x0.st/'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    child: const SelectFilesContainer(),
                    onTap: () async {
                      await fileManager.selectFiles();
                    },
                  ),
                  Visibility(
                    visible: fileManager.filesData.isNotEmpty,
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: Text(
                              'Selected files - ${Formatters.formatBytes(fileManager.totalSize, 2)}',
                            ),
                          ),
                          TextButton(
                            child: const Text('Clear'),
                            onPressed: () {
                              fileManager.removeFiles();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (fileManager.isLoadingFiles) const FileLoadingIndicator(),
                  const SizedBox(height: 30),
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
