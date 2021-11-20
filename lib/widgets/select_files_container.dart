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

    return Container(
      margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: GestureDetector(
        onTap: () async => await fileManager.selectFiles(),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(10),
          color: isLoadingFiles
              ? Colors.lightBlue.withOpacity(0.4)
              : Colors.lightBlue,
          dashPattern: const [12, 8],
          child: Container(
            height: _getContainerHeight(context),
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
                        child: _buildFolderImage(context),
                      )
                    : _buildFolderImage(context),
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
      ),
    );
  }
}

Image _buildFolderImage(BuildContext context) {
  return Image.asset(
    'assets/images/folder.png',
    height: MediaQuery.of(context).size.height > 680 ? 70 : 55,
  );
}

double _getContainerHeight(BuildContext context) {
  if (MediaQuery.of(context).size.height < 600) {
    return 130;
  } else if (MediaQuery.of(context).size.height < 680) {
    return 152;
  } else {
    return 162;
  }
}
