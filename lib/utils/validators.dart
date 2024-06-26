import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Validators {
  static final RegExp _emailRegex = RegExp(
      r"^[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$");

  static final RegExp _usernameRegex = RegExp(r'^([A-Za-z0-9_](?:(?:[A-Za-z0-9_]|(?:\.(?!\.))){0,30}(?:[A-Za-z0-9_]))?)$');

  static bool isEmailValid(String email) {
    return email.length <= 256 && _emailRegex.hasMatch(email);
  }

  static String? validatePassword(BuildContext context, String password) {
    // Get the localized strings
    AppLocalizations l10n = AppLocalizations.of(context)!;

    // Password must be between 8 and 64 characters
    if (password.length < 8) {
      return l10n.passwordTooShort(8);
    }
    if (password.length > 64) {
      return l10n.passwordTooLong(64);
    }

    // Password must contain at least one number
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return l10n.passwordMustContainNumber;
    }

    return null;
  }

  static bool validatePhoneNumber(String phoneNumber) {
    var n = phoneNumber.replaceAll(RegExp('[ .,\\-]'), '');

    String patttern =
        r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)';
    RegExp regExp = RegExp(patttern);

    if (!regExp.hasMatch(n)) {
      return false;
    }
    return true;
  }

  static String? validateUsername(BuildContext context, String username) {
    // Get the localized strings
    AppLocalizations l10n = AppLocalizations.of(context)!;

    // Username must be between 3 and 32 characters
    if (username.length < 3) {
      return l10n.usernameTooShort(3);
    }
    if (username.length > 32) {
      return l10n.usernameTooLong(32);
    }

    // Username must only contain alphanumeric characters and underscores
    if (!_usernameRegex.hasMatch(username)) {
      return l10n.invalidUsername;
    }

    return null;
  }

  static bool isUsernameValid(String username) {
    return _usernameRegex.hasMatch(username);
  }

  static bool isNumber(String value) {
    return double.tryParse(value) != null;
  }
}
