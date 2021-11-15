import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/file_manager.dart';

class SelectFilesContainer extends StatelessWidget {
  const SelectFilesContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fileManager = Provider.of<FileManager>(context);
    bool isLoadingFiles = fileManager.isLoadingFiles;

    return GestureDetector(
      onTap: () async => await fileManager.selectFiles(),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        color: isLoadingFiles
            ? Colors.lightBlue.withOpacity(0.4)
            : Colors.lightBlue,
        dashPattern: const [12, 8],
        child: Container(
          height: 162,
          width: 300,
          color: isLoadingFiles
              ? const Color(0xFFF2FAFF).withOpacity(0.5)
              : const Color(0xFFF2FAFF),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoadingFiles
                  ? Opacity(
                      opacity: 0.3,
                      child: _buildFolderImage(),
                    )
                  : _buildFolderImage(),
              Text(
                'Select files',
                style: TextStyle(
                  color: isLoadingFiles
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.lightBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Image _buildFolderImage() {
    return Image.asset('assets/images/folder.png', height: 70);
  }
}
