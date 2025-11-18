import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/menu_item_tile.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/services/vendor/vendor_profile_service.dart';

class VendorMyMenuScreen extends StatefulWidget {
  const VendorMyMenuScreen({super.key});

  @override
  State<VendorMyMenuScreen> createState() => _VendorMyMenuScreenState();
}

class _VendorMyMenuScreenState extends State<VendorMyMenuScreen> {
  List<Map<String, dynamic>> items = [
    {
      'id': 1,
      'name': 'Veggie tomato mix',
      'price': '\$100',
      'imageUrl':
          'https://assets.bonappetit.com/photos/5d4356436f98a4000898782b/4:3/w_3376,h_2532,c_limit/Basically-Ratatouille-Pasta.jpg',
    },
    {
      'id': 2,
      'name': 'Moi-moi and ekpa.',
      'price': '\$150',
      'imageUrl':
          'https://img-global.cpcdn.com/recipes/ca64e4220565f1b8/680x781cq80/ekuru-white-moi-moi-recipe-main-photo.jpg',
    },
    {
      'id': 3,
      'name': 'Egg and cucumber recipe',
      'price': '\$80',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSLE0q7GC9bUMkvUVCNH0tmVRaohM_jTeEyw&s',
    },
    {
      'id': 4,
      'name': 'Veggie tomato mix',
      'price': '\$100',
      'imageUrl':
          'https://assets.bonappetit.com/photos/5d4356436f98a4000898782b/4:3/w_3376,h_2532,c_limit/Basically-Ratatouille-Pasta.jpg',
    },
    {
      'id': 5,
      'name': 'Moi-moi and ekpa.',
      'price': '\$150',
      'imageUrl':
          'https://img-global.cpcdn.com/recipes/ca64e4220565f1b8/680x781cq80/ekuru-white-moi-moi-recipe-main-photo.jpg',
    },
    {
      'id': 6,
      'name': 'Egg and cucumber recipe',
      'price': '\$80',
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSLE0q7GC9bUMkvUVCNH0tmVRaohM_jTeEyw&s',
    },
  ];
  @override
  Widget build(BuildContext context) {
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
                VendorProfileService.gotoVendorAddProduct(context, false);
              },
              icon: Icon(Icons.add_circle_outline, color: Colors.white),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Wrap(
          spacing: 14.w,
          runSpacing: 14.w,
          children: [
            ...items.map((item) {
              return MenuItemTile(
                onTap: () {
                  VendorProfileService.gotoVendorAddProduct(
                    context,
                    true,
                  ); //isEdit = true
                },
                name: item['name'],
                price: item['price'],
                imageUrl: item['imageUrl'],
              );
            }),
          ],
        ),
      ),
    );
  }
}
