import 'package:flutter/material.dart';

import 'custom_snack_bar.dart';

class SelectedFileCard extends StatefulWidget {
  const SelectedFileCard({Key? key}) : super(key: key);

  @override
  State<SelectedFileCard> createState() => _SelectedFileCardState();
}

class _SelectedFileCardState extends State<SelectedFileCard> {
  bool dismissed = false;

  @override
  Widget build(BuildContext context) {
    return dismissed
        ? Container()
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Dismissible(
              key: ValueKey(widget.key),
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4,
                ),
                child: const Icon(
                  Icons.delete_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              child: Card(
                elevation: 3,
                shadowColor: Colors.grey.shade50.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/0066.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'hot_air_balloon.jpg',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const Text('219.4 KB'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              onDismissed: (_) {
                setState(() {
                  dismissed = true;
                });
                CustomSnackBar().showSnackBar(
                  context,
                  'File removed',
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      setState(() {
                        dismissed = false;
                      });
                    },
                  ),
                );
              },
            ),
          );
  }
}
