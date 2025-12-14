import 'package:flutter/material.dart';
import 'dart:io';

class FileListView extends StatelessWidget {
  final String? directoryPath;

  const FileListView({super.key, required this.directoryPath});

  @override
  Widget build(BuildContext context) {
    if (directoryPath == null) {
      return const Center(
        child: Text('Select a directory'),
      );
    }

    final directory = Directory(directoryPath!);
    final files = directory.listSync();

    if (files.isEmpty) {
      return const Center(
        child: Text('Directory is empty'),
      );
    }

    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return ListTile(
          title: Text(file.path.split('/').last),
          leading: Icon(file is File ? Icons.image : Icons.folder),
        );
      },
    );
  }
}
