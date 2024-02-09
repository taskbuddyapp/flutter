import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiOptions {
  static String get domain => 'taskbuddy.latinary.com';
  static String get fullDomain => 'https://$domain';
  static String get baseUrl => kReleaseMode ? 'https://$domain' : 'http://192.168.1.18:9500';
  // static String get baseUrl => 'http://192.168.1.18:9500';
  static String get socketUrl => 'http://192.168.1.18:9500/socket.io/?EIO=4&transport=polling';
  static String get version => '/v1';
  static String get path => '$baseUrl$version';
  static String userAgent = '${Platform.operatingSystem}/${Platform.operatingSystemVersion}';
}
