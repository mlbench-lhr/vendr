import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/menu_item_tile.dart';
import 'package:vendr/app/components/my_bottom_sheet.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/view/home/user/widgets/menu_bottom_sheet.dart';

class UserMenuScreen extends StatefulWidget {
  const UserMenuScreen({super.key, required this.menuList});
  final List<MenuItemModel> menuList;
  @override
  State<UserMenuScreen> createState() => _UserMenuScreenState();
}

class _UserMenuScreenState extends State<UserMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text(
          'Menu',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: widget.menuList.isNotEmpty
            ? SingleChildScrollView(
                child: Wrap(
                  spacing: 14.w,
                  runSpacing: 14.w,
                  children: [
                    ...widget.menuList.reversed.map((item) {
                      return MenuItemTile(
                        onTap: () {
                          //show bottom sheet
                          MyBottomSheet.show(
                            context,
                            isDismissible: true,
                            enableDrag: true,
                            isScrollControlled: true,
                            backgroundColor: context.colors.primary,
                            child: MenuBottomSheet(menuItem: item),
                            // child: AddReviewBottomSheet(),
                          );
                        },
                        name: item.itemName,
                        price: item.servings.first.servingPrice,
                        imageUrl: item.imageUrl,
                      );
                    }),
                  ],
                ),
              )
            : Center(
                child: Text(
                  'No menu items found.',
                  style: context.typography.body.copyWith(),
                ),
              ),
      ),
    );
  }
}
