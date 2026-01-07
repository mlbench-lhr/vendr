import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/menu_item_tile.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/services/vendor/vendor_profile_service.dart';

class VendorMyMenuScreen extends StatefulWidget {
  const VendorMyMenuScreen({super.key});

  @override
  State<VendorMyMenuScreen> createState() => _VendorMyMenuScreenState();
}

class _VendorMyMenuScreenState extends State<VendorMyMenuScreen> {
  List<MenuItemModel> menuItems = [
    // MenuItemModel(
    //   itemId: '1',
    //   itemName: 'First Item Name',
    //   itemDescription: 'This is the description for first menu item',
    //   itemImageUrl:
    //       'https://assets.bonappetit.com/photos/5d4356436f98a4000898782b/4:3/w_3376,h_2532,c_limit/Basically-Ratatouille-Pasta.jpg',
    //   servings: [
    //     ServingModel(servingQuantity: 'Single Serving', servingPrice: '\$23'),
    //     ServingModel(servingQuantity: 'Double Serving', servingPrice: '\$34'),
    //     ServingModel(servingQuantity: 'Triple Serving', servingPrice: '\$48'),
    //   ],
    // ),
  ];
  @override
  void initState() {
    super.initState();
    sessionController.addListener(_onSessionChanged);
  }

  final sessionController = SessionController();

  void _onSessionChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    sessionController.removeListener(_onSessionChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendor = sessionController.vendor!;
    if (vendor.menu != null) {
      menuItems = vendor.menu!;
    }
    return MyScaffold(
      appBar: AppBar(
        title: Text(
          'My Menu',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.white24,
            child: IconButton(
              onPressed: () {
                //add new product
                VendorProfileService.gotoAddEditProduct(context, false, null);
              },
              icon: Icon(Icons.add_circle_outline, color: Colors.white),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: menuItems.isNotEmpty
            ? SingleChildScrollView(
                child: Wrap(
                  spacing: 14.w,
                  runSpacing: 14.w,
                  children: [
                    ...menuItems.reversed.map((item) {
                      return MenuItemTile(
                        onTap: () {
                          //edit product
                          VendorProfileService.gotoAddEditProduct(
                            context,
                            true,
                            item,
                          ); //isEdit = true
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
                  textAlign: TextAlign.center,
                  'No item addded yet.',
                  // 'No item addded yet.\nPlease add the button on the top-right corner of the screen to add a new item.',
                ),
              ),
      ),
    );
  }
}
