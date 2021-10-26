import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/select_files_container.dart';
import '../widgets/selected_file_card.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Image(
                image: AssetImage('assets/images/writer_illustration.png'),
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
              const SelectFilesContainer(),
              const SizedBox(height: 30),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Selected files'),
                    TextButton(
                      child: const Text('Clear'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SelectedFileCard(),
            ],
          ),
        ),
      ),
    );
  }
}
