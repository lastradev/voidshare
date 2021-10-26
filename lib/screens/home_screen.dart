import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/select_files_container.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              size: 32,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Image(
                image:
                    const AssetImage('assets/images/writer_illustration.png'),
                height: MediaQuery.of(context).size.height / 2.5,
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
            ],
          ),
        ),
      ),
    );
  }
}
