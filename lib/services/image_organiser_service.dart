import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class ImageOrganiserService {
  Future<void> organise(String sourceDirPath, String targetDirPath) async {
    final sourceDir = Directory(sourceDirPath);
    final targetDir = Directory(targetDirPath);

    if (!await sourceDir.exists() || !await targetDir.exists()) {
      return;
    }

    final Set<String> targetHashes = await _calculateTargetHashes(targetDir);

    await for (final file in sourceDir.list(recursive: true)) {
      if (file is File && (p.extension(file.path).toLowerCase() == '.jpg' || p.extension(file.path).toLowerCase() == '.jpeg')) {
        await _processImage(file, targetDir, targetHashes);
      }
    }
  }

  Future<Set<String>> _calculateTargetHashes(Directory targetDir) async {
    final Set<String> hashes = {};
    await for (final file in targetDir.list(recursive: true)) {
      if (file is File && (p.extension(file.path).toLowerCase() == '.jpg' || p.extension(file.path).toLowerCase() == '.jpeg')) {
        final bytes = await file.readAsBytes();
        hashes.add(sha256.convert(bytes).toString());
      }
    }
    return hashes;
  }

  Future<void> _processImage(File file, Directory targetDir, Set<String> targetHashes) async {
    final bytes = await file.readAsBytes();
    final hash = sha256.convert(bytes).toString();

    if (targetHashes.contains(hash)) {
      return; // Skip duplicate
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
      }

      final newPath = p.join(newDir.path, newFileName);
      await file.copy(newPath);
      targetHashes.add(hash); // Add hash to set after successful copy.
    } else {
      // Log EXIF data only if date is not found, then move to NoDate.
      debugPrint('Could not find a date for ${file.path}. Moving to NoDate folder.');
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
      }
      final newPath = p.join(noDateDir.path, p.basename(file.path));

      if (await File(newPath).exists()) {
        return;
      }

      await file.copy(newPath);
      targetHashes.add(hash);
    }
  }

  DateTime? _getExifDate(Map<String, IfdTag> tags) {
    final dateTag = tags['EXIF DateTimeOriginal'] ?? tags['Image DateTime'];

    if (dateTag != null) {
      final dateString = dateTag.toString();

      if (dateString.length >= 19) {
        final parsableDateString = dateString.substring(0, 10).replaceAll(':', '-') + 'T' + dateString.substring(11, 19);
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
