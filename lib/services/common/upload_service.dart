import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vendr/app/utils/service_error_handler.dart';
import 'package:vendr/repository/upload_repo.dart';

class ImageUploadService {
  final ImageRepository _repo = ImageRepository();
  static const String tag = 'ImageUploadService';

  Future<String?> uploadImage(
    BuildContext context, {
    required File file,
  }) async {
    try {
      final response = await _repo.uploadImage(file: file);

      // Extract URL from response - adjust key as per your API
      return response['imageUrl'] as String?;
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: tag);
      }
      return null;
    }
  }
}

// class DocumentUploadService {
//   final DocumentRepository _repo = DocumentRepository();
//   static const String tag = 'DocumentUploadService';

//   Future<List<String>?> uploadDocument(
//     BuildContext context, {
//     required List<File> file,
//   }) async {
//     try {
//       final response = await _repo.uploadDoc(files: file);

//       return (response['urls'] as List<dynamic>)
//           .map((url) => url as String)
//           .toList();
//     } catch (e) {
//       if (context.mounted) {
//         ErrorHandler.handle(context, e, serviceName: tag);
//       }
//       return null;
//     }
//   }
// }
