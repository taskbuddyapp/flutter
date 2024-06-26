import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/api/requests.dart';
import 'package:taskbuddy/api/v1/accounts/me/security/forgot_password.dart';
import 'package:taskbuddy/api/v1/accounts/me/security/sessions.dart';

class Security {
  ForgotPassword get forgotPassword => ForgotPassword();
  LoginSessions get sessions => LoginSessions();

  Future<bool> deleteAccount(String token) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/security/delete-account",
      method: "POST",
      headers: {
        'Authorization': 'Bearer $token'
      }
    );

    if (response == null) {
      return false;
    }

    if (response.timedOut || response.response?.statusCode != 200) {
      return false;
    }

    return true;
  }

  Future<bool> changePassword(String token, String currentPassword, String newPassword) async {
    var response = await Requests.fetchEndpoint(
      "${ApiOptions.path}/accounts/me/security/change-password",
      method: "POST",
      headers: {
        'Authorization': 'Bearer $token'
      },
      data: {
        "current_password": currentPassword,
        "new_password": newPassword
      }
    );

    if (response == null) {
      return false;
    }

    if (response.timedOut || response.response?.statusCode != 200) {
      return false;
    }

    return true;
  }
}
