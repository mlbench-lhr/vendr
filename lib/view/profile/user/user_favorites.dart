import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/view/profile/user/widgets/favorite_chip.dart';

class UserFavouritsScreen extends StatefulWidget {
  const UserFavouritsScreen({super.key});

  @override
  State<UserFavouritsScreen> createState() => _UserFavouritsScreenState();
}

class _UserFavouritsScreenState extends State<UserFavouritsScreen> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Favorite Venders',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            FavoriteChip(
              name: 'Harry Brook',
              venderType: 'Product Vender',
              imageUrl:
                  'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=761&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            ),
            SizedBox(height: 16.h),
            FavoriteChip(
              name: 'James Smith',
              venderType: 'Fast food vender',
              imageUrl:
                  'https://images.unsplash.com/photo-1716068107414-fad614ac83a3?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            ),
            SizedBox(height: 16.h),
            FavoriteChip(
              name: 'William Persons',
              venderType: 'Fruit Vender',
              imageUrl:
                  'https://media.istockphoto.com/id/2209841249/photo/refrigeration-chamber-with-close-up-of-fruits-and-vegetables-in-the-crates.jpg?s=2048x2048&w=is&k=20&c=mGv4KJiTGVTTSdi6RJoDKz6bZe5BaMPMu8WdjJcXiro=',
            ),
          ],
        ),
      ),
    );
  }
}
