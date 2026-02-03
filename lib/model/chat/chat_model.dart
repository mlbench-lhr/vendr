import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatMessage {
  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
  });

  /// JSON serialization
  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  /// Firestore factory
  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      text: data['text'].toString(),
      senderId: data['senderId'].toString(),
      senderName: data['senderName'].toString(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  /// Firestore map
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
