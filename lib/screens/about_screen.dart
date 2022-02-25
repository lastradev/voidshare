import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  static const routeName = '/about';

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String? appVersion;

  @override
  void initState() {
    fetchAppVersion();
    super.initState();
  }

  Future<void> fetchAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/appIcon.png',
                height: MediaQuery.of(context).size.height / 7,
              ),
              const SizedBox(height: 10),
              Text(
                'VoidShare',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text('v$appVersion'),
            ],
          ),
          Column(
            children: [
              const Text(
                'This is an open-source project\n and can be found on',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              TextButton(
                onPressed: () =>
                    launch('https://github.com/lastra-dev/void-share'),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Image(
                    image: Theme.of(context).brightness == Brightness.dark
                        ? const AssetImage(
                            'assets/images/github-logo-white.png',
                          )
                        : const AssetImage('assets/images/github-logo.png'),
                  ),
                ),
              ),
              const Text(
                'If you liked my work,\nshow some ♥ and ⭐ the repo.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Column(
            children: [
              TextButton(
                onPressed: () =>
                    launch('https://www.buymeacoffee.com/lastradev'),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: const Image(
                    image: AssetImage('assets/images/coffe-button.png'),
                  ),
                ),
              ),
              const Text(
                'Sponsor this project.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Folder icon by ',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    TextSpan(
                      text: 'icons8.',
                      style: const TextStyle(
                        color: Colors.lightBlue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launch('https://icons8.com/'),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Backend forked from ',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    TextSpan(
                      text: '0x0.st.',
                      style: const TextStyle(
                        color: Colors.lightBlue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launch('https://0x0.st/'),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => launch('http://voidshare.xyz/'),
                child: const Text('VoidShare Website'),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(5, 30, 5, 20),
            child: Center(
              child: Text(
                'Made with ♥ by Oscar Lastra.',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
