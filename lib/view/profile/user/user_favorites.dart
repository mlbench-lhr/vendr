import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/model/user/user_model.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/view/profile/user/widgets/favorite_chip.dart';

class UserFavouritsScreen extends StatefulWidget {
  const UserFavouritsScreen({super.key});

  @override
  State<UserFavouritsScreen> createState() => _UserFavouritsScreenState();
}

class _UserFavouritsScreenState extends State<UserFavouritsScreen> {
  final _sessionController = SessionController();
  @override
  Widget build(BuildContext context) {
    final List<FavoriteVendorModel> favoriteVendors =
        _sessionController.user?.favoriteVendors ?? [];
    return MyScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Favorite Vendors',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: favoriteVendors.isNotEmpty
            ? ListView.builder(
                itemCount: favoriteVendors.length,
                itemBuilder: (context, index) {
                  final vendor = favoriteVendors[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: FavoriteChip(
                      vendorId: vendor.id,
                      name: vendor.name,
                      venderType: vendor.vendorType ?? '',
                      imageUrl: vendor.imageUrl,
                      onRemove: () {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  'No Favorite vendors found.',
                  style: context.typography.body.copyWith(),
                ),
              ),
      ),
    );
  }
}
