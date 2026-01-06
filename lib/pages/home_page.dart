import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:picturearchiveorganiser/providers/directory_provider.dart';
import 'package:picturearchiveorganiser/providers/image_organiser_provider.dart';
import 'package:picturearchiveorganiser/providers/progress_provider.dart';
import '../string_constants.dart';
import '../widgets/file_list_view.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _refreshToken = 0;

  Future<void> _selectSourceDirectory(WidgetRef ref) async {
    // Ensure the window is focused before opening the picker
    await Future.delayed(const Duration(milliseconds: 100));
    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      ref.read(sourceDirectoryProvider.notifier).set(result);
    }
  }

  Future<void> _selectTargetDirectory(WidgetRef ref) async {
    // Ensure the window is focused before opening the picker
    await Future.delayed(const Duration(milliseconds: 100));
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

    final progressNotifier = ref.read(processingProgressProvider.notifier);
    progressNotifier.reset();

    try {
      final organiser = ref.read(imageOrganiserServiceProvider);
      await organiser.organise(
        sourceDir,
        targetDir,
        onProgress: (processed, total) {
          if (total > 0) {
            progressNotifier.start(total);
            progressNotifier.update(processed);
          }
        },
      );

      if (!mounted) return;
      progressNotifier.complete();
      setState(() {
        _refreshToken++; // force list views to rebuild with fresh directory contents
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pictures organised successfully!')),
      );
    } catch (e) {
      if (!mounted) return;
      progressNotifier.complete();
      setState(() {
        _refreshToken++; // still refresh to reflect any partial changes
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sourceDir = ref.watch(sourceDirectoryProvider);
    final targetDir = ref.watch(targetDirectoryProvider);
    final progress = ref.watch(processingProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(homePageTitle),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withAlpha((0.9 * 255).round()),
                  Theme.of(context).colorScheme.secondary.withAlpha((0.8 * 255).round()),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
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
                      const SizedBox(height: 12),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary.withAlpha((0.3 * 255).round()),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ), 
                                child: KeyedSubtree(
                                  key: ValueKey('source_$_refreshToken'),
                                  child: FileListView(directoryPath: sourceDir),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                height: 48,
                                width: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: const CircleBorder(),
                                  ),
                                  onPressed: progress.isProcessing ? null : _organisePictures,
                                  child: const Icon(Icons.arrow_forward),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.secondary.withAlpha((0.3 * 255).round()),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: KeyedSubtree(
                                  key: ValueKey('target_$_refreshToken'),
                                  child: FileListView(directoryPath: targetDir),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (progress.isProcessing || progress.total > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LinearProgressIndicator(
                                value: progress.progress,
                                backgroundColor: Theme.of(context).colorScheme.surface,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Processed: ${progress.processed} / ${progress.total} (${progress.remaining} remaining)',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (progress.isProcessing)
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
