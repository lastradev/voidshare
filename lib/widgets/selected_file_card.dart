import 'package:flutter/material.dart';

class SelectedFileCard extends StatelessWidget {
  const SelectedFileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                'assets/images/0066.jpg',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              )
            ],
          ),
        ),
      ),
    );
  }
}
