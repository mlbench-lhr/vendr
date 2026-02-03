import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/global_unfocus_keyboard.dart';
import 'package:vendr/app/components/loading_widget.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/utils/enums.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/model/chat/chat_model.dart';
import 'package:vendr/services/common/chat_service.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/view/home/user/widgets/small_badge.dart';
import 'package:vendr/view/live_chat/widgets/message_bubble.dart';
import 'package:vendr/view/live_chat/widgets/write_and_send.dart';
import 'package:vendr/app/components/my_bottom_sheet.dart';
import 'package:vendr/view/reviews/widgets/add_review_bottom_sheet.dart';
import 'package:vendr/view/reviews/widgets/add_user_review_bottom_sheet.dart';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({
    required this.chatId,
    required this.isChatClosed,
    required this.initialMessage,
    required this.senderName,
    required this.receiverId,
    required this.vendorName,
    required this.vendorImage,
    this.hasPermit = false,
    this.userId,
    this.userAverageRating = 0.0,
    super.key,
  });
  final String chatId;
  final bool isChatClosed;
  final String initialMessage;
  final String senderName;
  final String receiverId;
  final String vendorName;
  final String vendorImage;
  final bool hasPermit;
  final String? userId;
  final double userAverageRating;
  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

final session = SessionController();

class _LiveChatScreenState extends State<LiveChatScreen> {
  bool isLoaded = false;

  bool isVendor = false; //check if current user is vendor / user
  String yourId = ''; //current user id
  final SessionController _session = SessionController();

  // Meetup request state
  final TextEditingController _verificationCodeController =
      TextEditingController();
  bool _isVerifying = false;

  // Track if vendor review sheet has been shown for the current completed meetup
  String? _lastReviewedMeetupId;

  // Real-time user average rating from Firestore
  double _userAverageRating = 0.0;

  // Get current user/vendor name dynamically
  String get yourName {
    if (_session.user != null) {
      return _session.user!.name;
    } else if (_session.vendor != null) {
      return _session.vendor!.name;
    } else {
      return '';
    }
  }

  void identifyRoleAndId() {
    if (_session.userType == UserType.vendor) {
      if (mounted) {
        setState(() {
          isVendor = true;
          yourId = session.vendor?.id ?? '';
        });
        // Clear unread count for vendor
        _chatService.markChatAsRead(widget.chatId);
      }
    } else if (_session.userType == UserType.user) {
      isVendor = false;
      yourId = session.user?.id ?? '';
    }
  }

  Future<void> createChatIfDontExist() async {
    // Get user image and average rating if available
    final userImage = _session.user?.imageUrl ?? '';
    final userAverageRating = _session.user?.averageRating ?? 0.0;

    await _chatService.ensureChatExists(
      context,
      widget.chatId,
      yourId,
      yourName,
      widget.initialMessage,
      widget.receiverId,
      userImage: userImage,
      userAverageRating: userAverageRating,
    );
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  final _chatService = LiveChatService();

  Timer? _timer;

  // Handle Request Meetup button press (User action)
  Future<void> _handleRequestMeetup() async {
    // Check if user has requests remaining
    final requestsRemaining = _session.user?.requestsRemaining ?? 0;
    if (requestsRemaining <= 0) {
      if (mounted) {
        // Show dialog when limit is reached
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFF2e323d),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 28.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Daily Limit Reached',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Text(
                'You have used all your meetup requests for today. Your requests will be reset tomorrow.',
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
      return;
    }

    final request = await _chatService.createMeetupRequest(
      chatId: widget.chatId,
      userId: yourId,
      vendorId: widget.receiverId,
    );
    if (request != null) {
      // Decrement requests remaining locally (default 10 per user per day)
      await _session.decrementRequestsRemaining();
      debugPrint(
        'Meetup request created successfully. Remaining requests: ${(_session.user?.requestsRemaining ?? 0)}',
      );
    }
  }

  // Handle Accept button press (Vendor action)
  Future<void> _handleAcceptMeetup(String requestId) async {
    await _chatService.acceptMeetupRequest(widget.chatId, requestId);
  }

  // Handle Reject button press (Vendor action)
  Future<void> _handleRejectMeetup(String requestId) async {
    await _chatService.rejectMeetupRequest(widget.chatId, requestId);
  }

  // Handle verification code submission (User action)
  Future<void> _handleVerifyCode(String requestId) async {
    final code = _verificationCodeController.text.trim();
    if (code.isEmpty || code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit code')),
      );
      return;
    }

    setState(() => _isVerifying = true);

    final success = await _chatService.verifyMeetupCode(
      widget.chatId,
      requestId,
      code,
    );

    if (mounted) {
      setState(() => _isVerifying = false);
      if (success) {
        _verificationCodeController.clear();
        context.flushBarSuccessMessage(
          message: "Meetup verified successfully!",
        );
        // Show review bottom sheet for user to rate the vendor
        if (!isVendor && mounted) {
          await MyBottomSheet.show(
            context,
            isDismissible: true,
            isScrollControlled: true,
            enableDrag: true,
            backgroundColor: context.colors.primary,
            child: AddReviewBottomSheet(
              vendorId: widget.receiverId,
              parentContext: context,
              onSuccess: () {
                debugPrint('Review submitted successfully');
              },
            ),
          );
        }
      } else {
        context.flushBarErrorMessage(
          message: "Invalid verification code. Please try again.",
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    identifyRoleAndId();
    createChatIfDontExist();
    // Initialize user average rating from widget
    _userAverageRating = widget.userAverageRating;
    // Rebuild every 1 minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) setState(() {});
      debugPrint('Screen Refreshed...');
    });

    // Listen for meetup completion to show vendor review sheet
    _listenForMeetupCompletion();
  }

  /// Listen for meetup status changes to show review sheet to both vendor and user
  void _listenForMeetupCompletion() {
    _chatService.getLatestMeetupRequest(widget.chatId).listen((request) {
      // Only proceed if request exists and is completed
      if (request == null || request.status != MeetupStatus.completed) {
        return;
      }

      // Already showed sheet for this meetup in this session
      if (_lastReviewedMeetupId == request.requestId) {
        return;
      }

      // Show review sheet for VENDOR (to rate the user)
      if (isVendor && widget.userId != null && !request.vendorReviewed) {
        _lastReviewedMeetupId = request.requestId;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _showVendorReviewSheet(request.requestId);
          }
        });
      }

      // Show review sheet for USER (to rate the vendor)
      if (!isVendor && !request.userReviewed) {
        _lastReviewedMeetupId = request.requestId;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _showUserReviewSheet(request.requestId);
          }
        });
      }
    });
  }

  /// Show the review bottom sheet for vendor to rate the user
  Future<void> _showVendorReviewSheet(String requestId) async {
    await MyBottomSheet.show(
      context,
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: context.colors.primary,
      child: AddUserReviewBottomSheet(
        userId: widget.userId!,
        parentContext: context,
        onSuccess: () {
          debugPrint('Vendor review submitted successfully');
          // Mark meetup as vendor reviewed in Firestore
          _chatService.markMeetupAsVendorReviewed(widget.chatId, requestId);
        },
      ),
    );
  }

  /// Show the review bottom sheet for user to rate the vendor
  Future<void> _showUserReviewSheet(String requestId) async {
    await MyBottomSheet.show(
      context,
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: context.colors.primary,
      child: AddReviewBottomSheet(
        vendorId: widget.receiverId,
        parentContext: context,
        onSuccess: () {
          debugPrint('User review submitted successfully');
          // Mark meetup as user reviewed in Firestore
          _chatService.markMeetupAsUserReviewed(widget.chatId, requestId);
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _verificationCodeController.dispose();
    super.dispose();
  }

  /// Build the appropriate meetup widget based on request status
  Widget _buildMeetupWidget(MeetupRequest request) {
    switch (request.status) {
      case MeetupStatus.pending:
        // Vendor sees OrderPlacedBox with Accept/Reject
        if (isVendor) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 40.w),
            child: OrderPlacedBox(
              timestamp: request.createdAt,
              onAccept: () => _handleAcceptMeetup(request.requestId),
              onReject: () => _handleRejectMeetup(request.requestId),
            ),
          );
        }
        // User sees waiting message
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Color(0xFF2e323d),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.schedule, color: Colors.blue, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Meetup Request Sent',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Waiting for vendor response...',
                    style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    LiveChatService.formatChatTimestamp(request.createdAt),
                    style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                  ),
                ],
              ),
            ),
          ),
        );

      case MeetupStatus.accepted:
        // Vendor sees VerificationCodeBox
        if (isVendor) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: VerificationCodeBox(
              verificationCode: request.verificationCode,
              timestamp: request.updatedAt,
            ),
          );
        }
        // User sees MeetupRequestInputBox to enter code
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: OrderAcceptedBox(),
        );

      case MeetupStatus.rejected:
        // Both see OrderRejected
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: OrderRejected(),
        );

      case MeetupStatus.completed:
        // Both see OrderCompleted
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: OrderCompleted(
            timestamp: request.completedAt ?? DateTime.now(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20232a),
      appBar: AppBar(
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: NetworkImage(widget.vendorImage),
                ),
                if (widget.hasPermit)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CustomPaint(
                      size: Size(26 * 0.525, 26 * 0.525),
                      painter: SmallRPSCustomPainter(radius: 21.0),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 10.w),
            Column(
              children: [
                Text(
                  widget.vendorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typography.headline.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                isVendor
                    ? RatingBarIndicator(
                        itemPadding: EdgeInsets.only(right: 3.w),
                        rating: _userAverageRating,
                        itemSize: 17.w,
                        itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ],
        ),
        centerTitle: true,
        // actions: [
        //   if (isVendor && !widget.isChatClosed)
        //     CloseChatBtn(chatId: widget.chatId, currentUserId: yourId),
        // ],
      ),
      body: isLoaded
          ? GlobalUnfocusKeyboard(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF20232a),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black,
                                  Colors.black,
                                  Colors.transparent,
                                ],
                                stops: [
                                  0.0,
                                  0.05,
                                  0.95,
                                  1.0,
                                ], // adjust fade thickness
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            // Combined stream for messages and meetup requests
                            child: StreamBuilder<MeetupRequest?>(
                              stream: _chatService.getLatestMeetupRequest(
                                widget.chatId,
                              ),
                              builder: (context, meetupSnapshot) {
                                final meetupRequest = meetupSnapshot.data;

                                return StreamBuilder<List<ChatMessage>>(
                                  stream: _chatService.getMessages(
                                    widget.chatId,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          'Error: ${snapshot.error}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: context.colors.primary,
                                        ),
                                      );
                                    }
                                    final messages = snapshot.data ?? [];

                                    // Calculate total items: messages + meetup widget (if exists)
                                    final hasMeetupWidget =
                                        meetupRequest != null;
                                    final totalItems =
                                        messages.length +
                                        (hasMeetupWidget ? 1 : 0);

                                    return ListView.builder(
                                      reverse: true,
                                      itemCount: totalItems,
                                      itemBuilder: (context, index) {
                                        // Show meetup widget at the top (index 0 in reversed list)
                                        if (hasMeetupWidget && index == 0) {
                                          return _buildMeetupWidget(
                                            meetupRequest,
                                          );
                                        }

                                        // Adjust index for messages when meetup widget exists
                                        final messageIndex = hasMeetupWidget
                                            ? index - 1
                                            : index;
                                        final message = messages[messageIndex];
                                        final isMe = message.senderId == yourId;
                                        return ChatMessageBubble(
                                          message: message.text,
                                          time: message.timestamp,
                                          isRecieved: !isMe,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        //END: messages
                        SizedBox(height: 70.h), // Space for input area
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Bottom controls: Request Meetup button or Code Input
                      StreamBuilder<MeetupRequest?>(
                        stream: _chatService.getLatestMeetupRequest(
                          widget.chatId,
                        ),
                        builder: (context, snapshot) {
                          final request = snapshot.data;

                          // No request or completed/rejected - show Request Meetup button for user
                          if (request == null ||
                              request.status == MeetupStatus.completed ||
                              request.status == MeetupStatus.rejected) {
                            return !isVendor
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MyButton(
                                      label: "Request Meetup",
                                      icon: Icon(Icons.person),
                                      onPressed: _handleRequestMeetup,
                                    ),
                                  )
                                : SizedBox.shrink();
                          }

                          // User needs to enter code when request is accepted
                          if (request.status == MeetupStatus.accepted &&
                              !isVendor) {
                            return Padding(
                              padding: EdgeInsets.all(8.w),
                              child: MeetupRequestInputBox(
                                controller: _verificationCodeController,
                                isLoading: _isVerifying,
                                onConfirm: () =>
                                    _handleVerifyCode(request.requestId),
                                onCancel: () =>
                                    _verificationCodeController.clear(),
                              ),
                            );
                          }

                          // Other statuses (pending, accepted for vendor) - no bottom control needed
                          return SizedBox.shrink();
                        },
                      ),
                      SizedBox(height: 10.h),
                      WriteAndSend(
                        chatId: widget.chatId,
                        yourId: yourId,
                        yourName: yourName,
                        receiverId: widget.receiverId,
                      ),
                    ],
                  ),
                  // UserInfoSection(senderName: widget.senderName),
                ],
              ),
            )
          : const Center(child: LoadingWidget(color: Colors.white)),
    );
  }
}

/// Order Placed Box
class OrderPlacedBox extends StatelessWidget {
  const OrderPlacedBox({
    required this.onAccept,
    required this.onReject,
    required this.timestamp,
    super.key,
  });

  final VoidCallback onAccept;
  final VoidCallback onReject;
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 255.h,
      width: 230.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Color(0xFF2e323d),
        border: Border.all(color: Colors.blue, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            height: 60.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              color: Color(0xFF2c3d62),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart_checkout_outlined,
                  color: Colors.blue,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Order Placed',
                  style: context.typography.title.copyWith(
                    color: Colors.blue,
                    fontSize: 16.sp,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 8.h,
                  ),
                  height: 33.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Color(0xFF2a467f),
                  ),
                  child: Center(
                    child: Text(
                      "Pending",
                      style: context.typography.title.copyWith(
                        color: Colors.blue,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Message
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            child: Text(
              "The buyer has placed an order and is ready to pick up.",
              style: context.typography.labelSmall.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          // Divider
          Container(height: 1.5.h, color: Color(0xFF393d48)),
          // Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onReject,
                  child: Container(
                    width: 100.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 0.3),
                      color: Color(0xFF52383b),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.clear, color: Colors.red, size: 20.sp),
                        SizedBox(width: 5.w),
                        Text(
                          "Reject",
                          style: context.typography.title.copyWith(
                            color: Colors.red,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onAccept,
                  child: Container(
                    width: 100.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: Colors.green, width: 0.3),
                      color: Color(0xFF2a4e43),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check, color: Colors.green, size: 20.sp),
                        SizedBox(width: 5.w),
                        Text(
                          "Accept",
                          style: context.typography.title.copyWith(
                            color: Colors.green,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Container(height: 1.5.h, color: Color(0xFF393d48)),
          // Timestamp
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LiveChatService.formatChatTimestamp(timestamp),
                  style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
                ),
                Icon(Icons.check, color: Colors.green, size: 20.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Order Accepted Box
class OrderAcceptedBox extends StatelessWidget {
  const OrderAcceptedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 75.h),
            height: 195.h,
            width: 270.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Color(0xFF2e323d),
              border: Border.all(color: Colors.green, width: 0.5),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Text(
                    "Order accepted by vendor. Ready for pickup.",
                    style: context.typography.labelSmall.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0.5,
            top: 0.5,
            child: Container(
              height: 60,
              width: 268.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                color: Color(0xFF2a4e43),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_cart_checkout_outlined,
                      color: Colors.green,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Order Placed',
                      style: context.typography.title.copyWith(
                        color: Colors.green,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(width: 30.w),
                    Container(
                      padding: EdgeInsets.only(left: 10.w, top: 8.w),
                      height: 33.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Color(0xFF276448),
                      ),
                      child: Text(
                        "ACCEPTED",
                        style: context.typography.title.copyWith(
                          color: Colors.green,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 1,
            right: 1,
            top: 150,
            child: Container(
              width: 269.w,
              height: 1.5.h,
              color: Color(0xFF393d48),
            ),
          ),
          Positioned(
            left: 30,
            right: 1,
            top: 168,
            child: Text('10:33 AM', style: TextStyle(color: Colors.grey[500])),
          ),
          Positioned(
            right: 30,
            top: 168,
            child: Icon(Icons.check, color: Colors.green, size: 20.sp),
          ),
        ],
      ),
    );
  }
}

///Order Rejected Widget
class OrderRejected extends StatelessWidget {
  const OrderRejected({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            height: 85.h,
            width: 270.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Color(0xFF472c2c),
              border: Border.all(color: Colors.red, width: 0.5),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Icon(Icons.cancel_outlined, color: Colors.red),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Rejected',
                      style: context.typography.title.copyWith(
                        color: Colors.red,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Order rejected by vendor.',
                      style: context.typography.body.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Meetup Request Input Box Widget (User side - to enter verification code)
class MeetupRequestInputBox extends StatelessWidget {
  const MeetupRequestInputBox({
    required this.controller,
    required this.onConfirm,
    required this.onCancel,
    this.isLoading = false,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        height: 300.h,
        width: 290.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Color(0xFF2e323d),
          border: Border.all(color: Colors.blue, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm Meetup Request',
              style: context.typography.title.copyWith(
                color: Colors.white,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Flexible(
              child: Text(
                'Please enter the verification code shown on the vendor\'s screen to complete the meetup.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.typography.body.copyWith(fontSize: 12.sp),
              ),
            ),
            SizedBox(height: 25.h),
            Text(
              'Verification Code',
              style: context.typography.title.copyWith(
                color: Colors.white54,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 10.h),
            MyTextField(
              controller: controller,
              fillColor: Color(0xFF20232a),
              hint: 'Enter 6-digit code',
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                SizedBox(
                  height: 50.h,
                  width: 110.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF20232a),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: isLoading ? null : onCancel,
                    child: Text(
                      "Cancel",
                      style: context.typography.title.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 25.w),
                SizedBox(
                  height: 50.h,
                  width: 110.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: isLoading ? null : onConfirm,
                    child: isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Confirm",
                            style: context.typography.title.copyWith(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Verification Code Box Widget (Vendor side - shows OTP code like WhatsApp)
class VerificationCodeBox extends StatelessWidget {
  const VerificationCodeBox({
    required this.verificationCode,
    required this.timestamp,
    super.key,
  });

  final String verificationCode;
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Color(0xFF2e323d),
        border: Border.all(color: Colors.green, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Color(0xFF2a4e43),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.verified_outlined,
                  color: Colors.green,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verification Code',
                      style: context.typography.title.copyWith(
                        color: Colors.green,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Show this code to the buyer',
                      style: context.typography.body.copyWith(
                        color: Colors.white54,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // OTP Style Code Display
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: Color(0xFF20232a),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: verificationCode.split('').map((digit) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF2a4e43),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    digit,
                    style: context.typography.title.copyWith(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LiveChatService.formatChatTimestamp(timestamp),
                style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
              ),
              Row(
                children: [
                  Icon(Icons.lock_outline, color: Colors.green, size: 14.sp),
                  SizedBox(width: 4.w),
                  Text(
                    'Secure Code',
                    style: TextStyle(color: Colors.green, fontSize: 11.sp),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Order Completed Widget (Shows when transaction is verified)
class OrderCompleted extends StatelessWidget {
  const OrderCompleted({required this.timestamp, super.key});

  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100.h,
        width: 270.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Color(0xFF1d3a2f),
          border: Border.all(color: Colors.green, width: 0.5),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Color(0xFF2a4e43),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 28.sp,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meetup Completed!',
                    style: context.typography.title.copyWith(
                      color: Colors.green,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Transaction verified successfully.',
                    style: context.typography.body.copyWith(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    LiveChatService.formatChatTimestamp(timestamp),
                    style: TextStyle(color: Colors.grey[500], fontSize: 10.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ChatCancelledMessage extends StatelessWidget {
//   const ChatCancelledMessage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       width: double.infinity,
//       margin: EdgeInsets.symmetric(horizontal: 16.w),
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//       decoration: BoxDecoration(
//         color: Colors.grey,
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Text(
//         textAlign: TextAlign.center,
//         'Chat Closed',
//         style: TextStyle(
//           color: context.colors.textOnDark,
//           fontSize: 16.sp,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }

// class UserInfoSection extends StatelessWidget {
//   const UserInfoSection({required this.senderName, super.key});
//   final String senderName;
//   @override
//   Widget build(BuildContext context) {
//     return Positioned.fill(
//       top: 10.h,
//       child: Column(
//         children: [
//           Container(
//             width: 86.w,
//             height: 86.w,
//             padding: EdgeInsets.all(20.w),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   context.colors.primary,
//                   const Color.fromARGB(255, 62, 62, 64),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(100),
//             ),
//             child: Assets.icons.chat.svg(),
//           ),
//           SizedBox(height: 10.h),
//           Text(
//             senderName,
//             style: context.typography.title.copyWith(
//               color: context.colors.textOnLight,
//               fontSize: 20.sp,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
