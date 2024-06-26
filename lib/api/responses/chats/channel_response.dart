import 'dart:convert';

import 'package:taskbuddy/api/responses/account/public_account_response.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/api/responses/posts/post_only_response.dart';

class ChannelStatus {
  static const int PENDING = 0;
  static const int ACCEPTED = 1;
  static const int REJECTED = 2;
  static const int COMPLETED = 3;
  static const int CANCELLED = 4;
}

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
  bool isPostCreator;
  int status;

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
    required this.isPostCreator,
    required this.status,
  });

  PublicAccountResponse get otherUserAccount => otherUser == "recipient" ? channelRecipient : channelCreator;

  PublicAccountResponse get postCreator => isPostCreator ? channelCreator : channelRecipient;

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
      negotiatedPrice: double.parse(json['negotiated_price'].toString()),
      negotiatedDate: DateTime.parse(json['negotiated_date']),
      isPostCreator: json['is_post_creator'],
      status: json['status'],
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
      "is_post_creator": isPostCreator,
      "status": status,
    });
  }

  ChannelResponse clone() {
    List<MessageResponse> list = [];

    for (var message in lastMessages) {
      list.add(message.clone());
    }

    return ChannelResponse(
      uuid: uuid,
      post: post.clone(),
      channelCreator: channelCreator,
      channelRecipient: channelRecipient,
      createdAt: createdAt,
      lastMessageTime: lastMessageTime,
      lastMessages: list,
      otherUser: otherUser,
      negotiatedPrice: negotiatedPrice,
      negotiatedDate: negotiatedDate,
      isPostCreator: isPostCreator,
      status: status,
    );
  }
}
