import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class MarkdownMessage extends StatelessWidget {
  final String content;
  const MarkdownMessage({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: MarkdownWidget(data: content),
    );
  }
}
