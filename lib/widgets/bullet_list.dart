import 'package:flutter/material.dart';

class BulletList extends StatelessWidget {
  final List<String> strings;

  const BulletList(this.strings, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: strings.map((str) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '\u2022',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  str,
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
