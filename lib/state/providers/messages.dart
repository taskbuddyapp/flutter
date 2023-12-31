import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';

class MessagesModel extends ChangeNotifier {
  int _incomingOffset = 0;
  int _outgoingOffset = 0;
  
  bool _hasMoreIncoming = true;
  bool _hasMoreOutgoing = true;

  bool _loadingOutgoing = true;
  bool _loadingIncoming = true;

  List<ChannelResponse> _incomingMessages = [];
  List<ChannelResponse> _outgoingMessages = [];

  List<ChannelResponse> get incomingMessages => _incomingMessages;
  List<ChannelResponse> get outgoingMessages => _outgoingMessages;

  bool get loadingIncoming => _loadingIncoming;
  bool get loadingOutgoing => _loadingOutgoing;

  Future<void> readFromCache() async {
    FlutterSecureStorage storage = FlutterSecureStorage();

    var incomingMessages = await storage.read(key: 'incomingMessages');

    if (incomingMessages != null) {
      _incomingMessages = (incomingMessages as List<dynamic>).map((e) => ChannelResponse.fromJson(e)).toList();
    }

    var outgoingMessages = await storage.read(key: 'outgoingMessages');

    if (outgoingMessages != null) {
      _outgoingMessages = (outgoingMessages as List<dynamic>).map((e) => ChannelResponse.fromJson(e)).toList();
    }

    notifyListeners();
  }

  Future<void> saveToCache() async {
    FlutterSecureStorage storage = FlutterSecureStorage();

    await storage.write(key: 'incomingMessages', value: _incomingMessages.map((e) => e.toJson()).toList().toString());
    await storage.write(key: 'outgoingMessages', value: _outgoingMessages.map((e) => e.toJson()).toList().toString());
  }

  Future<void> fetchMessages() async {
    // Read the auth token
    String token = (await AccountCache.getToken())!;

    _loadingIncoming = true;
    notifyListeners();

    // Fetch incoming messages
    var incoming = await Api.v1.channels.getIncomingMessages(token, offset: _incomingOffset);
    
    if (incoming.ok) {
      if (incoming.data!.length < 20) {
        _hasMoreIncoming = false;
      } else {
        _incomingOffset += incoming.data!.length;
        _incomingMessages.addAll(incoming.data!);
      }
    }

    _loadingIncoming = false;
    notifyListeners();

    // Fetch outgoing messages
    _loadingOutgoing = true;
    notifyListeners();

    var outgoing = await Api.v1.channels.getOutgoingMessages(token, offset: _outgoingOffset);

    if (outgoing.ok) {
      if (outgoing.data!.length < 20) {
        _hasMoreOutgoing = false;
      } else {
        _outgoingOffset += outgoing.data!.length;
        _outgoingMessages.addAll(outgoing.data!);
      }
    }

    _loadingOutgoing = false;
    notifyListeners();
  }

  ChannelResponse? hasPost(String postUUID) {
    for (ChannelResponse channel in _incomingMessages) {
      if (channel.post.UUID == postUUID) {
        return channel;
      }
    }

    for (ChannelResponse channel in _outgoingMessages) {
      if (channel.post.UUID == postUUID) {
        return channel;
      }
    }

    return null;
  }

  void addIncomingChannel(ChannelResponse channel) {
    if (_incomingMessages.indexWhere((element) => element.uuid == channel.uuid) == -1) {
      _incomingMessages.add(channel);
    }

    // Sort by last message time
    _incomingMessages.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

    notifyListeners();
  }

  void addOutgoingChannel(ChannelResponse channel) {
    if (_outgoingMessages.indexWhere((element) => element.uuid == channel.uuid) == -1) {
      _outgoingMessages.add(channel);
    }

    // Sort by last message time
    _outgoingMessages.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

    notifyListeners();
  }

  void clearIncomingMessages() {
    _incomingMessages.clear();
    notifyListeners();
  }

  void clearOutgoingMessages() {
    _outgoingMessages.clear();
    notifyListeners();
  }

  void clearAllMessages() {
    _incomingMessages.clear();
    _outgoingMessages.clear();
    notifyListeners();
  }

  void removeIncomingChannel(ChannelResponse channel) {
    _incomingMessages.remove(channel);
    notifyListeners();
  }

  void removeOutgoingChannel(ChannelResponse channel) {
    _outgoingMessages.remove(channel);
    notifyListeners();
  }

  void removeChannel(ChannelResponse channel) {
    _incomingMessages.remove(channel);
    _outgoingMessages.remove(channel);
    notifyListeners();
  }

  void updateChannel(ChannelResponse channel) {
    int index = _incomingMessages.indexWhere((element) => element.uuid == channel.uuid);
    if (index != -1) {
      _incomingMessages[index] = channel;
    }
    notifyListeners();
  }
}