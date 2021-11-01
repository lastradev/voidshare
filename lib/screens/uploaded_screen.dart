import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_snack_bar.dart';

class UploadedScreen extends StatelessWidget {
  const UploadedScreen({Key? key}) : super(key: key);
  static const routeName = '/uploaded';

  @override
  Widget build(BuildContext context) {
    final url = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  'Uploaded successfully!',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Image.asset(
                  'assets/images/success.png',
                  height: MediaQuery.of(context).size.height / 2.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 250,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                      child: Text(url),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      color: Colors.blue,
                      onPressed: () =>
                          Clipboard.setData(ClipboardData(text: url)).then((_) {
                        CustomSnackBar.showSnackBar(
                          context,
                          'Url copied to Clipboard!',
                        );
                      }),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      color: Colors.blue,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 250,
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: const Text('Go Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
