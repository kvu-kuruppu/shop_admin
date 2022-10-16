import 'package:flutter/material.dart';

class RowHeader extends StatelessWidget {
  final String text;
  final int flex;

  const RowHeader({
    Key? key,
    required this.text,
    required this.flex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade500,
          border: Border.all(
            color: Colors.grey.shade700,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}