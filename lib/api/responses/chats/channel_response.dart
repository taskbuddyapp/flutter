import 'dart:convert';

import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/api/responses/posts/post_only_response.dart';

class ChannelResponse {
  String otherUser;
  String uuid;
  PostOnlyResponse post;
  PublicAccountResponse channelCreator;
  PublicAccountResponse channelRecipient;
  DateTime createdAt;
  DateTime lastMessageTime;
  List<MessageResponse> lastMessages;
  double negotiatedPrice;
  DateTime negotiatedDate;

  ChannelResponse({
    required this.uuid,
    required this.post,
    required this.channelCreator,
    required this.channelRecipient,
    required this.createdAt,
    required this.lastMessageTime,
    required this.lastMessages,
    required this.otherUser,
    required this.negotiatedPrice,
    required this.negotiatedDate,
  });

  factory ChannelResponse.fromJson(Map<String, dynamic> json) {
    return ChannelResponse(
      uuid: json['uuid'],
      post: PostOnlyResponse.fromJson(json['post']),
      channelCreator: PublicAccountResponse.fromJson(json['channel_creator']),
      channelRecipient: PublicAccountResponse.fromJson(json['channel_recipient']),
      createdAt: DateTime.parse(json['created_at']),
      lastMessageTime: DateTime.parse(json['last_message_time']),
      lastMessages: json['last_messages'].map<MessageResponse>((message) => MessageResponse.fromJson(message)).toList(),
      otherUser: json['other_user'],
      negotiatedPrice: json['negotiated_price'],
      negotiatedDate: DateTime.parse(json['negotiated_date']),
    );
  }

  String toJson() {
    return jsonEncode({
      "uuid": uuid,
      "post": post.toJson(),
      "channel_creator": channelCreator.toJson(),
      "channel_recipient": channelRecipient.toJson(),
      "created_at": createdAt.toIso8601String(),
      "last_message_time": lastMessageTime.toIso8601String(),
      "last_messages": lastMessages.map((message) => message.toJson()).toList(),
      "other_user": otherUser,
      "negotiated_price": negotiatedPrice,
      "negotiated_date": negotiatedDate.toIso8601String(),
    });
  }
}