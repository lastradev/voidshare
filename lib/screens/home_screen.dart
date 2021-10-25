import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/custom_app_bar.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(
              HistoryScreen.routeName,
              // Necessary for PageTransition
              // https://pub.dev/packages/page_transition#usage-for-predefined-routes
              arguments: 'arguments data',
            ),
            icon: Icon(
              Icons.history,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
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
            )
          ],
        ),
      ),
    );
  }
}
