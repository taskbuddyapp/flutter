import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/api/socket/socket.dart';
import 'package:taskbuddy/screens/chat_screen.dart';
import 'package:taskbuddy/screens/home/pages/chats/incoming_chats.dart';
import 'package:taskbuddy/screens/home/pages/chats/outgoing_chats.dart';
import 'package:taskbuddy/state/providers/messages.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/navigation/blur_parent.dart';

class ChatsAppbar extends StatelessWidget {
  const ChatsAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppbarTitle(l10n.chats)
      ],
    );
  }
}

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  void _onMessage(dynamic data) {
    MessagesModel model = Provider.of<MessagesModel>(context, listen: false);
    MessageResponse response = MessageResponse.fromJson(data["message"]);

    model.onMessage(response.channelUUID, response);
  }

  void _onNewChannel(dynamic data) {
    MessagesModel model = Provider.of<MessagesModel>(context, listen: false);
    ChannelResponse response = ChannelResponse.fromJson(data["channel"]);

    model.addIncomingChannel(response);

    print("New channel received: ${response.uuid}");
  }

  Future<void> _checkInitialNotification() async {
    // Open notifications if the user tapped on a notification
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // If the initial message is not null, then the user tapped on a notification
      // So open the chat
      _handleMessage(initialMessage);
    }

    // Also listen for new notifications
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // Handle the message
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ChatScreen(
          channelUuid: message.data["channel_uuid"]!,
        )
      )
    );
  }

  @override
  void initState() {
    super.initState();

    _checkInitialNotification();

    SocketClient.addListener("chat", _onMessage);
    SocketClient.addListener("new_channel", _onNewChannel);
  }

  @override
  void dispose() {
    SocketClient.disposeListener("chat", _onMessage);
    SocketClient.disposeListener("new_channel", _onNewChannel);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const TabBarView(
              children: [
                OutgoingChats(),
                IncomingChats()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: BlurParent(
              child: TabBar(
                tabs: [
                  Tab(text: l10n.outgoing),
                  Tab(text: l10n.incoming)
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}
