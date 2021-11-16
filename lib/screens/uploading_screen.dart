import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/file_uploader.dart';
import '../widgets/custom_snack_bars.dart';

/// File uploading screen.
class UploadingScreen extends StatelessWidget {
  const UploadingScreen({Key? key}) : super(key: key);
  static const routeName = '/uploading';

  @override
  Widget build(BuildContext context) {
    final fileUploader = Provider.of<FileUploader>(context);
    bool isUploadAborted = fileUploader.isUploadAborted;

    return WillPopScope(
      onWillPop: () async {
        CustomSnackBars.showCustomSnackBar(
          context,
          'You must either cancel the upload or wait for it to finish.',
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Uploading'),
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: fileUploader.abortUpload,
          backgroundColor: Colors.red.shade400,
          tooltip: 'Cancel',
          child: const Icon(Icons.cancel_rounded),
        ),
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      isUploadAborted
                          ? Column(
                              children: [
                                Icon(
                                  Icons.cancel_rounded,
                                  color: Colors.red.shade400,
                                  size: 30,
                                ),
                                const Text(
                                  'Aborting upload',
                                  style: TextStyle(fontSize: 10),
                                )
                              ],
                            )
                          : Text(
                              '${fileUploader.uploadPercentage}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(color: Colors.blue),
                            ),
                      SizedBox(
                        height: 110,
                        width: 110,
                        child: CircularProgressIndicator(
                          value: fileUploader.uploadPercentage / 100,
                          backgroundColor: Colors.grey,
                          strokeWidth: 9,
                          color: isUploadAborted
                              ? Colors.red.shade400
                              : Colors.lightBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Image.asset('assets/images/waiting.webp', width: 250),
            ],
          ),
        ),
      ),
    );
  }
}
