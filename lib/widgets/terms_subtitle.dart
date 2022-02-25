import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsSubtitle extends StatelessWidget {
  const TermsSubtitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Files must adhere to ',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          TextSpan(
            text: 'VoidShare terms',
            style: const TextStyle(
              color: Colors.lightBlue,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => launch('http://voidshare.xyz/terms'),
          ),
        ],
      ),
    );
  }
}
