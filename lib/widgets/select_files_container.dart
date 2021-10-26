import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class SelectFilesContainer extends StatelessWidget {
  const SelectFilesContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      color: Colors.lightBlue,
      dashPattern: const [12, 8],
      child: Container(
        height: 162,
        width: 300,
        color: const Color(0xFFF2FAFF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.drive_folder_upload_rounded,
              color: Colors.blue,
              size: 70,
            ),
            Text(
              'Select files',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
