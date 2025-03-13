import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  static Future<String> downloadFragment(
      {required String fileUrl,
      required String id,
      required String type,
      required CancelToken cancelToken,
      String folder = '/fragments/',
      Function(int, int)? onReceiveProgress}) async {
    final dirExists = await _createDirectoryIfDoesNotExist(path: folder);
    if (dirExists) {
      final path = await _getSavePath(id, type, path: folder);
      final downloadedFilePath = await _downloadAndSaveFile(fileUrl, path, cancelToken, onReceiveProgress);
      final fileExists = await checkIfFileExists(id: id, type: type, downloadedPath: folder);
      return downloadedFilePath;
    } else {
      return '';
    }
  }

  static Future<String> checkIfFileExists({
    required String id,
    required String type,
    required String downloadedPath,
  }) async {
    final path = await _getSavePath(id, type, path: downloadedPath);
    final doesExist = io.File(path).existsSync();
    if (doesExist) {
      return path;
    } else {
      return '';
    }
  }

  static Future<String> _getDownloadFolderPath({required String path}) async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final folderName = path;
      final downloadFolderPath = (documentsDir.path) + folderName;
      return downloadFolderPath;
    } on Exception {
      return '';
    }
  }

  static Future<bool> _checkIfDirectoryExists({required String path}) async {
    final downloadDir = await _getDownloadFolderPath(path: path);

    final doesDirExist = io.Directory(downloadDir).existsSync();
    return doesDirExist;
  }

  static Future<bool> _createDirectoryIfDoesNotExist({required String path}) async {
    try {
      final dirExists = await _checkIfDirectoryExists(path: path);

      if (dirExists) {
        return true;
      }

      final downloadedPath = await _getDownloadFolderPath(path: path);
      final downloadDirectory = await io.Directory(downloadedPath).create();
      if (downloadDirectory.path.isNotEmpty) {
        return true;
      }
      return false;
    } on Exception catch (e) {
      return false;
    }
  }

  static Future<String> _downloadAndSaveFile(String url, String savePath, CancelToken cancelToken,
      [Function(int, int)? onReceiveInProgress]) async {
    try {
      await Dio().download(url, savePath, onReceiveProgress: onReceiveInProgress, cancelToken: cancelToken);
      return savePath;
    } on Exception catch (e) {
      return '';
    }
  }

  static Future<String> _getSavePath(String id, String type, {required String path}) async {
    final downloadFolder = await _getDownloadFolderPath(path: path);
    final fileName = shortHash(UniqueKey());
    final completePath = downloadFolder + fileName;
    return completePath;
  }
}
