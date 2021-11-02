import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import '../providers/file_uploader.dart';

class UploadingScreen extends StatelessWidget {
  const UploadingScreen({Key? key}) : super(key: key);
  static const routeName = '/uploading';

  @override
  Widget build(BuildContext context) {
    final fileUploader = Provider.of<FileUploader>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  'Uploading files',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 10),
                const Text('This may take a while...'),
              ],
            ),
            Column(
              children: [
                Text(
                  '${fileUploader.uploadPercentage}%',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.blue),
                ),
                const SizedBox(height: 5),
                const SizedBox(
                  width: 60,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballSpinFadeLoader,
                    colors: [Colors.blue],
                  ),
                ),
              ],
            ),
            Image.asset('assets/images/waiting.png', width: 250),
            Container(
              width: 250,
              height: 40,
              margin: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red.shade400),
                ),
                child: Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
