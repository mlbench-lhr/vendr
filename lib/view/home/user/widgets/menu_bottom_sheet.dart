import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/view/home/user/widgets/serving_counter.dart';

class MenuBottomSheet extends StatefulWidget {
  const MenuBottomSheet({super.key, required this.menuItem});
  final MenuItemModel menuItem;

  @override
  State<MenuBottomSheet> createState() => _MenuBottomSheetState();
}

class _MenuBottomSheetState extends State<MenuBottomSheet> {
  int selectedServing = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.w),
      height: 500.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(AppRadiuses.hundredRadius),
            ),
          ),
          SizedBox(height: 16.w),
          //Category
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            widget.menuItem.category ?? '',
                            style: context.typography.body.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(
                            width: 250.w,
                            child: Text(
                              textAlign: TextAlign.left,
                              widget.menuItem.itemName,
                              style: context.typography.body.copyWith(
                                fontSize: 34.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        textAlign: TextAlign.left,
                        widget.menuItem.servings[selectedServing].servingPrice,
                        style: context.typography.body.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Serving counter
                    ServingCounter(
                      onServingChanged: (int value) {
                        setState(() {
                          selectedServing = value;
                          debugPrint(
                            'selectedServing UPDATED : $selectedServing',
                          );
                        });
                      },
                      servingsLength: widget.menuItem.servings.length,
                    ),
                    MenuDetailsImage(imageUrl: widget.menuItem.imageUrl),
                  ],
                ),
                12.height,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: context.typography.title.copyWith(),
                      ),
                      12.height,
                      Text(
                        widget.menuItem.itemDescription ?? '',
                        style: context.typography.bodySmall.copyWith(),
                      ),
                      16.height,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuDetailsImage extends StatelessWidget {
  const MenuDetailsImage({super.key, required this.imageUrl});
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.w,
      height: 250.h,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadiuses.hundredRadius),
        ),
        border: Border.all(color: Colors.white12, width: 1.w),
        image: imageUrl != null
            ? DecorationImage(fit: BoxFit.cover, image: NetworkImage(imageUrl!))
            : null,
      ),
      child: imageUrl == null ? Icon(Icons.restaurant_menu, size: 72.w) : null,
    );
  }
}
