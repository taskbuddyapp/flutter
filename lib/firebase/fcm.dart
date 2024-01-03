import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/chat_screen.dart';
import 'package:taskbuddy/state/providers/messages.dart';
import 'package:taskbuddy/state/static/messages_state.dart';
import 'package:taskbuddy/widgets/ui/notification.dart';

class FirebaseMessagingApi {
  static Future<void> updateToken() async {
    // Get the firebase token
    String? token = await FirebaseMessaging.instance.getToken();

    // Log it
    log('FirebaseMessaging token: $token');

    String? accountToken = await AccountCache.getToken();

    // Send it to server
    if (token == null || accountToken == null) {
      log('FirebaseMessaging token or account token is null');
      return;
    }

    await Api.v1.accounts.meRoute.updateFCMToken(accountToken, token);
  }

  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
    print(message.notification?.title);
  }

  static Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    updateToken();

    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('A new onMessage event was published!');

      if (MessagesState.currentChannel == message.data['channel_uuid']) {
        return;
      }

      showOverlayNotification((ctx) =>
        CustomNotification(
          title: message.notification?.title ?? "New notification",
          subtitle: message.notification?.body,
          image: message.notification?.android?.imageUrl,
          onTap: () {
            MessagesModel model = Provider.of<MessagesModel>(ctx, listen: false);
            ChannelResponse? channel = model.getChannelByUuid(message.data['channel_uuid']!);

            if (channel == null) return;

            OverlaySupportEntry.of(ctx)!.dismiss();

            Navigator.of(ctx).push(
              CupertinoPageRoute(
                builder: (context) => ChatScreen(
                  channel: channel.clone(),
                )
              )
            );
          }
        ),
        duration: const Duration(seconds: 5)
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
    });

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  }
}
