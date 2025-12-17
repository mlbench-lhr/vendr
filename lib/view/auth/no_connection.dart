import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/services/common/auth_service.dart';

class NoConnectionScreen extends StatefulWidget {
  const NoConnectionScreen({super.key});

  @override
  State<NoConnectionScreen> createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen> {
  bool isLoading = false;
  final _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(),
              Icon(Icons.signal_wifi_connected_no_internet_4, size: 80),
              const SizedBox(height: 6),
              Text(
                'No Connection',
                style: context.typography.title.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                textAlign: TextAlign.center,
                'Please connect to the internet and press the "Retry" button below.',
                style: context.typography.body.copyWith(fontSize: 14.sp),
              ),
              const Spacer(),
              MyButton(
                isLoading: isLoading,
                label: 'Retry',
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await _authService.checkAuthentication(context);
                  if (!mounted) return;
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
