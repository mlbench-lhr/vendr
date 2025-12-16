import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/services/user/user_profile_service.dart';

class FavoriteChip extends StatefulWidget {
  final String vendorId;
  final String? imageUrl;
  final String name;
  final String venderType;
  final VoidCallback onRemove;
  const FavoriteChip({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.venderType,
    required this.vendorId,
    required this.onRemove,
  });

  @override
  State<FavoriteChip> createState() => _FavoriteChipState();
}

class _FavoriteChipState extends State<FavoriteChip> {
  bool isRemoving = false;
  @override
  Widget build(BuildContext context) {
    final userProfileService = UserProfileService();
    return SizedBox(
      height: 50.h,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: context.colors.buttonPrimary,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 23.r,
                  backgroundImage: widget.imageUrl != null
                      ? NetworkImage(widget.imageUrl!)
                      : null,
                  child: widget.imageUrl == null
                      ? Icon(
                          Icons.person,
                          color: context.colors.primary.withValues(alpha: .7),
                        )
                      : null,
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: context.typography.label.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.venderType,
                    style: context.typography.label.copyWith(fontSize: 13.sp),
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isRemoving = true;
                  });
                  await userProfileService.removeFromFavorites(
                    context,
                    vendorId: widget.vendorId,
                  );
                  widget.onRemove.call();
                },
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.star_rounded,
                    size: 24.w,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (isRemoving)
            Container(
              color: context.colors.primary.withValues(alpha: 0.5),
              width: double.infinity,
            ),
        ],
      ),
    );
  }
}
