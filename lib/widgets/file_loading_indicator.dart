import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class FileLoadingIndicator extends StatelessWidget {
  const FileLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        const SizedBox(
          height: 40,
          child: LoadingIndicator(
            indicatorType: Indicator.ballSpinFadeLoader,
            colors: [Colors.lightBlue],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Loading files',
          style: TextStyle(color: Colors.grey.shade800),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
