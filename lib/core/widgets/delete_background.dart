import 'package:flutter/material.dart';

class DeleteBackground extends StatelessWidget {
  const DeleteBackground({
    required this.alignment,
    super.key,
  });

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      child: const Icon(
        Icons.delete_outline,
        color: Colors.white,
      ),
    );
  }
}
