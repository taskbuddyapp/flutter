import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskbuddy/api/responses/responses.dart';

// Define Dart equivalent classes for the TypeScript interfaces
class AccountResponseUser {
  final String uuid;
  final String email;
  final String username;
  final String phoneNumber;
  final DateTime lastLogin;
  final String firstName;
  final String lastName;
  final String role;
  final DateTime createdAt;

  AccountResponseUser({
    required this.uuid,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.lastLogin,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.createdAt,
  });

  factory AccountResponseUser.fromJson(Map<String, dynamic> json) {
    return AccountResponseUser(
      uuid: json['uuid'],
      email: json['email'],
      username: json['username'],
      phoneNumber: json['phone_number'],
      lastLogin: DateTime.parse(json['last_login']),
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class AccountResponseRequiredActions {
  final bool verifyPhoneNumber;
  final bool verifyEmail;

  AccountResponseRequiredActions({
    required this.verifyPhoneNumber,
    required this.verifyEmail,
  });

  factory AccountResponseRequiredActions.fromJson(Map<String, dynamic> json) {
    return AccountResponseRequiredActions(
      verifyPhoneNumber: json['verify_phone_number'],
      verifyEmail: json['verify_email'],
    );
  }
}

class AccountResponse {
  final AccountResponseUser user;
  final AccountResponseRequiredActions requiredActions;
  final String token;

  AccountResponse({
    required this.user,
    required this.requiredActions,
    required this.token,
  });

  factory AccountResponse.fromJson(Map<String, dynamic> json) {
    return AccountResponse(
      user: AccountResponseUser.fromJson(json['user']),
      requiredActions:
          AccountResponseRequiredActions.fromJson(json['required_actions']),
      token: json['token'],
    );
  }
}

// Define a function similar to `fetch` in TypeScript
Future<http.Response> fetchEndpoint(String endpoint, dynamic data) async {
  final response =
      await http.post(Uri.parse(endpoint), body: json.encode(data));
  return response;
}

// Define a function to build the Dart equivalent of `ApiResponse<AccountResponse>`
Future<ApiResponse> buildAccountResponse(String endpoint, dynamic data) async {
  final response = await fetchEndpoint(endpoint, data);

  final json = jsonDecode(response.body);

  if (response.statusCode != 200) {
    return ApiResponse(
        status: response.statusCode, message: json.message, ok: false);
  }

  return ApiResponse(
      status: 200,
      message: json.message,
      ok: true,
      data: AccountResponse.fromJson(json));
}