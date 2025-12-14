import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:picturearchiveorganiser/providers/directory_provider.dart';
import 'package:picturearchiveorganiser/providers/image_organiser_provider.dart';
import '../string_constants.dart';
import '../widgets/file_list_view.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _isProcessing = false;

  Future<void> _selectSourceDirectory(WidgetRef ref) async {
    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      ref.read(sourceDirectoryProvider.notifier).set(result);
    }
  }

  Future<void> _selectTargetDirectory(WidgetRef ref) async {
    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      ref.read(targetDirectoryProvider.notifier).set(result);
    }
  }

  Future<void> _organisePictures() async {
    final sourceDir = ref.read(sourceDirectoryProvider);
    final targetDir = ref.read(targetDirectoryProvider);

    if (sourceDir == null || targetDir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select source and target directories.')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final organiser = ref.read(imageOrganiserServiceProvider);
      await organiser.organise(sourceDir, targetDir);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pictures organised successfully!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
      // Automatic refresh will be implemented in the next step.
    }
  }

  @override
  Widget build(BuildContext context) {
    final sourceDir = ref.watch(sourceDirectoryProvider);
    final targetDir = ref.watch(targetDirectoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(homePageTitle),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectSourceDirectory(ref),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: TextEditingController(text: sourceDir),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Source Directory',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTargetDirectory(ref),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: TextEditingController(text: targetDir),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Target Directory',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ), 
                          child: FileListView(directoryPath: sourceDir),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: _isProcessing ? null : _organisePictures,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FileListView(directoryPath: targetDir),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withAlpha(128),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
