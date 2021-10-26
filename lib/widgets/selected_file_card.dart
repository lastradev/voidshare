import 'package:flutter/material.dart';

class SelectedFileCard extends StatelessWidget {
  const SelectedFileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
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
    );
  }
}
