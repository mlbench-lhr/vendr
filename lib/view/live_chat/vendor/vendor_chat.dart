import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/loading_widget.dart';
import 'package:vendr/app/routes/routes_name.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/services/common/chat_service.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';

class VendorChatScreen extends StatefulWidget {
  const VendorChatScreen({super.key});

  @override
  State<VendorChatScreen> createState() => _VendorChatScreenState();
}

class _VendorChatScreenState extends State<VendorChatScreen> {
  final _chatService = LiveChatService();
  final _sessionController = SessionController();
  String _selectedFilter = 'all'; // 'all', 'active', 'closed'
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final vendorId = _sessionController.vendor?.id ?? '';
    debugPrint('VendorChatScreen - vendorId: $vendorId');

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF20232a),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.only(left: 6.w),
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF2e323d),
                      ),
                      child: Center(
                        child: Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 90.w),
                  Text(
                    'Messages',
                    style: context.typography.body.copyWith(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                style: context.typography.body.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 17.0),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  hintText: 'Search conversations...',
                  hintStyle: context.typography.body.copyWith(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                ),
                cursorColor: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),
            StreamBuilder<List<ChatSummary>>(
              stream: _chatService.getVendorChats(vendorId),
              builder: (context, snapshot) {
                final chats = snapshot.data ?? [];
                final allCount = chats.length;
                final activeCount = chats
                    .where((c) => c.status == 'active')
                    .length;
                final closedCount = chats
                    .where((c) => c.status == 'closed')
                    .length;

                return Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _selectedFilter = 'all'),
                        child: FilterCard(
                          title: 'All ($allCount)',
                          color: _selectedFilter == 'all'
                              ? Colors.blue
                              : Color(0xFF2b2e35),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _selectedFilter = 'active'),
                        child: FilterCard(
                          title: 'Active ($activeCount)',
                          color: _selectedFilter == 'active'
                              ? Colors.blue
                              : Color(0xFF2b2e35),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _selectedFilter = 'closed'),
                        child: FilterCard(
                          title: 'Closed ($closedCount)',
                          color: _selectedFilter == 'closed'
                              ? Colors.blue
                              : Color(0xFF2b2e35),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: StreamBuilder<List<ChatSummary>>(
                stream: _chatService.getVendorChats(vendorId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: LoadingWidget(color: Colors.white));
                  }

                  if (snapshot.hasError) {
                    debugPrint('VendorChatScreen ERROR: ${snapshot.error}');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error loading chats',
                            style: TextStyle(color: Colors.white54),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${snapshot.error}',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  var chats = snapshot.data ?? [];

                  // Apply filter
                  if (_selectedFilter == 'active') {
                    chats = chats.where((c) => c.status == 'active').toList();
                  } else if (_selectedFilter == 'closed') {
                    chats = chats.where((c) => c.status == 'closed').toList();
                  }

                  // Apply search
                  if (_searchQuery.isNotEmpty) {
                    chats = chats
                        .where(
                          (c) =>
                              c.userName.toLowerCase().contains(_searchQuery) ||
                              c.lastMessage.toLowerCase().contains(
                                _searchQuery,
                              ),
                        )
                        .toList();
                  }

                  if (chats.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white24,
                            size: 64.w,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No conversations yet',
                            style: context.typography.body.copyWith(
                              color: Colors.white54,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: chats.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return ChatTile(
                        userName: chat.userName,
                        lastMessage: chat.lastMessage,
                        timestamp: LiveChatService.formatChatTimestamp(
                          chat.lastMessageTime,
                        ),
                        unreadCount: chat.unreadCount,
                        isOnline: chat.status == 'active',
                        avatarUrl: chat.userImage.isNotEmpty
                            ? chat.userImage
                            : null,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutesName.liveChat,
                            arguments: {
                              'chatId': chat.chatId,
                              'vendorName': chat.userName,
                              'vendorImage': chat.userImage,
                              'isChatClosed': chat.status == 'closed',
                              'initialMessage': '',
                              'senderName':
                                  _sessionController.vendor?.name ?? 'Vendor',
                              'receiverId': chat.userId,
                              'hasPermit': false, // Users don't have permits
                              'userId': chat.userId,
                              'userAverageRating': chat.userAverageRating,
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterCard extends StatelessWidget {
  final String title;
  final Color color;
  const FilterCard({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Text(title),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String userName;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;
  final bool isOnline;
  final String? avatarUrl;
  final VoidCallback? onTap;

  const ChatTile({
    super.key,
    required this.userName,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
    this.isOnline = false,
    this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Color(0xFF2b2e35),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 26.r,
                  backgroundColor: Colors.grey.shade700,
                  backgroundImage: avatarUrl != null
                      ? NetworkImage(avatarUrl!)
                      : null,
                  child: avatarUrl == null
                      ? Icon(Icons.person, color: Colors.white, size: 28.w)
                      : null,
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFF2b2e35), width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          userName,
                          overflow: TextOverflow.ellipsis,
                          style: context.typography.body.copyWith(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        timestamp,
                        style: context.typography.body.copyWith(
                          color: Colors.white54,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.typography.body.copyWith(
                            color: unreadCount > 0
                                ? Colors.white
                                : Colors.white54,
                            fontSize: 14.sp,
                            fontWeight: unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (unreadCount > 0) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
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
