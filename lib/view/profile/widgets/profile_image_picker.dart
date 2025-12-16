import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendr/app/components/loading_widget.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/generated/assets/assets.gen.dart';
import 'package:vendr/services/common/image_picker.dart';
import 'package:vendr/services/common/upload_service.dart';

class ImagePickerAvatar extends StatefulWidget {
  const ImagePickerAvatar({
    super.key,
    this.onImageChanged,
    this.initialUrl,
    this.size = 100,
    this.readOnly = false,
  });

  final void Function(String? url)? onImageChanged;
  final String? initialUrl;
  final bool readOnly;
  final double size;

  @override
  State<ImagePickerAvatar> createState() => _ImagePickerAvatarState();
}

class _ImagePickerAvatarState extends State<ImagePickerAvatar> {
  File? _localImage;
  String? _uploadedUrl;
  bool _isBusy = false;

  final _pickerService = ImagePickerService();
  final _uploadService = ImageUploadService();

  @override
  void initState() {
    super.initState();
    _uploadedUrl = widget.initialUrl;
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: context.colors.primary,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text('Gallery', style: context.typography.title),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text('Camera', style: context.typography.title),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final file = await _pickerService.pickImage(source: source);
    if (file == null || !mounted) return;
    if (mounted) {
      setState(() => _isBusy = true);
    }

    String? url;
    if (context.mounted) {
      url = await _uploadService.uploadImage(context, file: file);
    }

    if (!mounted) return;
    if (mounted) {
      setState(() {
        _isBusy = false;
        if (url != null) {
          _localImage = file;
          _uploadedUrl = url;
          widget.onImageChanged?.call(_uploadedUrl);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage =
        _localImage != null ||
        (_uploadedUrl != null && _uploadedUrl!.isNotEmpty);

    final imageProvider = _localImage != null
        ? FileImage(_localImage!)
        : _uploadedUrl != null
        ? NetworkImage(_uploadedUrl!) as ImageProvider
        : null;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: widget.size,
            width: widget.size,
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.inputBackground,
              border: Border.all(color: context.colors.onSurface, width: 2),
              image: hasImage
                  ? DecorationImage(image: imageProvider!, fit: BoxFit.cover)
                  : DecorationImage(
                      image: AssetImage(Assets.icons.userPlaceholder.path),
                      fit: BoxFit.contain,
                    ),
            ),
            child: _isBusy
                ? const Center(child: LoadingWidget(color: Colors.white))
                : null,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton.filled(
              onPressed: _isBusy || widget.readOnly
                  ? null
                  : () => _pickAndUploadImage(context),
              icon: const Icon(Icons.edit),
              style: IconButton.styleFrom(
                backgroundColor: context.colors.onSurface,
                foregroundColor: context.colors.surface,
                padding: EdgeInsets.all(8.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
