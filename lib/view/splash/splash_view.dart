import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/generated/assets/assets.gen.dart';
import 'package:vendr/services/common/auth_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  double _logoSize = 50.w;

  @override
  void initState() {
    super.initState();

    // Start animation
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _logoSize = 200.w;
      });
    });

    // Continue your authentication check

    // Future.delayed(const Duration(seconds: 2), () {
    if (mounted) {
      AuthService().checkAuthentication(context);
    }
    //});
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 2),
                curve: Curves.easeOutBack,
                width: _logoSize,
                height: _logoSize,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Assets.icons.cartLogo.svg(),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Vendr',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 42.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
