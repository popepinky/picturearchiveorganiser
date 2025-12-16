import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class FileListView extends StatefulWidget {
  final String? directoryPath;

  const FileListView({super.key, required this.directoryPath});

  @override
  State<FileListView> createState() => _FileListViewState();
}

class _FileListViewState extends State<FileListView> {
  late String? _currentPath;
  int _refreshCounter = 0;

  @override
  void initState() {
    super.initState();
    _currentPath = widget.directoryPath;
  }

  @override
  void didUpdateWidget(covariant FileListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.directoryPath != widget.directoryPath) {
      setState(() {
        _currentPath = widget.directoryPath;
        _refreshCounter++;
      });
    }
  }

  void _refreshDirectory() {
    setState(() {
      _refreshCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPath == null) {
      return const Center(child: Text('Select a directory'));
    }

    // Force rebuild when refresh counter changes
    final directory = Directory(_currentPath!);
    final entries = directory.existsSync() 
        ? directory.listSync() 
        : <FileSystemEntity>[];
    
    // Use refresh counter to force ListView rebuild
    final refreshKey = ValueKey('$_currentPath$_refreshCounter');

    // Sort directories first, then files alphabetically
    entries.sort((a, b) {
      final aIsDir = a is Directory;
      final bIsDir = b is Directory;
      if (aIsDir != bIsDir) return aIsDir ? -1 : 1;
      return a.path.toLowerCase().compareTo(b.path.toLowerCase());
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (_currentPath != widget.directoryPath)
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                tooltip: 'Back',
                onPressed: () {
                  final parent = Directory(_currentPath!).parent.path;
                  setState(() {
                    if (parent.startsWith(widget.directoryPath!)) {
                      _currentPath = parent;
                    } else {
                      _currentPath = widget.directoryPath;
                    }
                    _refreshCounter++;
                  });
                },
              ),
            Expanded(
              child: Text(
                _currentPath!,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ],
        ),
        const Divider(height: 1),
        if (entries.isEmpty)
          const Expanded(
            child: Center(child: Text('Directory is empty')),
          )
        else
          Expanded(
            child: ListView.builder(
              key: refreshKey,
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entity = entries[index];
                final name = entity.path.split('/').last;
                final isDir = entity is Directory;
                
                if (isDir) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        debugPrint('Tapped on folder: ${entity.path}');
                        setState(() {
                          _currentPath = entity.path;
                          _refreshCounter++;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.folder,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                name,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 24,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.image,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            name,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
      ],
    );
  }
}
