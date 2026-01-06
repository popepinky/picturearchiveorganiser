import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class ImageOrganiserService {
  Future<void> organise(
    String sourceDirPath,
    String targetDirPath, {
    void Function(int processed, int total)? onProgress,
  }) async {
    final sourceDir = Directory(sourceDirPath);
    final targetDir = Directory(targetDirPath);

    if (!await sourceDir.exists()) {
      throw Exception('Source directory does not exist: $sourceDirPath');
    }

    if (!await targetDir.exists()) {
      throw Exception('Target directory does not exist: $targetDirPath');
    }

    debugPrint(
      'Starting image organisation from $sourceDirPath to $targetDirPath',
    );

    // First, count total images
    int totalImages = 0;
    await for (final file in sourceDir.list(recursive: true)) {
      if (file is File &&
          (p.extension(file.path).toLowerCase() == '.jpg' ||
              p.extension(file.path).toLowerCase() == '.jpeg')) {
        totalImages++;
      }
    }

    debugPrint('Found $totalImages images to process');

    if (totalImages == 0) {
      debugPrint('No images found in source directory');
      onProgress?.call(0, 0);
      throw Exception(
        'No images found in source directory. Only .jpg and .jpeg files are supported.',
      );
    }

    final Set<String> targetHashes = await _calculateTargetHashes(targetDir);
    debugPrint(
      'Found ${targetHashes.length} existing images in target directory',
    );

    int processedImages = 0;
    int copiedImages = 0;
    int skippedImages = 0;

    await for (final file in sourceDir.list(recursive: true)) {
      if (file is File &&
          (p.extension(file.path).toLowerCase() == '.jpg' ||
              p.extension(file.path).toLowerCase() == '.jpeg')) {
        try {
          final wasCopied = await _processImage(file, targetDir, targetHashes);
          if (wasCopied) {
            copiedImages++;
          } else {
            skippedImages++;
          }
          processedImages++;
          onProgress?.call(processedImages, totalImages);
        } catch (e) {
          debugPrint('Error processing ${file.path}: $e');
          processedImages++;
          onProgress?.call(processedImages, totalImages);
        }
      }
    }

    debugPrint(
      'Organisation complete: $copiedImages copied, $skippedImages skipped',
    );
  }

  Future<Set<String>> _calculateTargetHashes(Directory targetDir) async {
    final Set<String> hashes = {};
    await for (final file in targetDir.list(recursive: true)) {
      if (file is File &&
          (p.extension(file.path).toLowerCase() == '.jpg' ||
              p.extension(file.path).toLowerCase() == '.jpeg')) {
        final bytes = await file.readAsBytes();
        hashes.add(sha256.convert(bytes).toString());
      }
    }
    return hashes;
  }

  Future<bool> _processImage(
    File file,
    Directory targetDir,
    Set<String> targetHashes,
  ) async {
    try {
      final bytes = await file.readAsBytes();
      final hash = sha256.convert(bytes).toString();

      if (targetHashes.contains(hash)) {
        debugPrint('Skipping duplicate: ${file.path}');
        return false; // Skip duplicate
      }

      final tags = await readExifFromBytes(bytes);
      final DateTime? date = _getExifDate(tags);

      if (date != null) {
        final year = date.year.toString();
        final month = date.month.toString().padLeft(2, '0');
        final day = date.day.toString().padLeft(2, '0');

        final subfolderName = '$year-$month';
        final newFileName = '$year-$month-${day}_${p.basename(file.path)}';

        final newDir = Directory(p.join(targetDir.path, subfolderName));
        if (!await newDir.exists()) {
          await newDir.create(recursive: true);
          debugPrint('Created directory: ${newDir.path}');
        }

        final newPath = p.join(newDir.path, newFileName);
        await file.copy(newPath);
        debugPrint('Copied: ${file.path} -> $newPath');
        targetHashes.add(hash); // Add hash to set after successful copy.
        return true;
      } else {
        // Log EXIF data only if date is not found, then move to NoDate.
        debugPrint(
          'Could not find a date for ${file.path}. Moving to NoDate folder.',
        );
        debugPrint('--- EXIF Data for ${p.basename(file.path)} ---');
        if (tags.isEmpty) {
          debugPrint('  -> No EXIF data found.');
        } else {
          tags.forEach((key, value) {
            debugPrint('  -> $key: $value');
          });
        }
        debugPrint('--- End of EXIF Data ---');

        final noDateDir = Directory(p.join(targetDir.path, 'NoDate'));
        if (!await noDateDir.exists()) {
          await noDateDir.create(recursive: true);
          debugPrint('Created NoDate directory: ${noDateDir.path}');
        }
        final newPath = p.join(noDateDir.path, p.basename(file.path));

        if (await File(newPath).exists()) {
          debugPrint('File already exists in NoDate: $newPath');
          return false;
        }

        await file.copy(newPath);
        debugPrint('Copied to NoDate: ${file.path} -> $newPath');
        targetHashes.add(hash);
        return true;
      }
    } catch (e, stackTrace) {
      debugPrint('Error processing image ${file.path}: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  DateTime? _getExifDate(Map<String, IfdTag> tags) {
    final dateTag = tags['EXIF DateTimeOriginal'] ?? tags['Image DateTime'];

    if (dateTag != null) {
      final dateString = dateTag.toString();

      if (dateString.length >= 19) {
        final parsableDateString =
            '${dateString.substring(0, 10).replaceAll(':', '-')}T${dateString.substring(11, 19)}';
        try {
          return DateTime.parse(parsableDateString);
        } catch (e) {
          return null;
        }
      }
    }
    return null;
  }
}
