import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/utils/validators.dart';
import 'package:taskbuddy/widgets/appbar/blur_appbar.dart';
import 'package:taskbuddy/widgets/input/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/input/text_input.dart';
import 'package:taskbuddy/widgets/input/touchable/button.dart';
import 'package:taskbuddy/widgets/input/touchable/link_text.dart';
import 'package:taskbuddy/widgets/ui/gradient_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Login screen widget
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BlurAppbar.appBar(), // AppBar with blur effect
      body: ScrollbarSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context)
                  .size
                  .height, // Set minimum height to the screen height
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ScreenTitle(), // Display screen title and description
                SizedBox(
                  height: 26,
                ),
                _LoginForm(), // Display login form
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScreenTitle extends StatelessWidget {
  const _ScreenTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GradientText(AppLocalizations.of(context)!.loginTitle,
              gradient: GradientText.getDefaultGradient(context)),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.loginDesc,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextInput(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            label: l10n.email,
            hint: 'latinary@example.com',
            errorText: _errorText,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.emptyField(l10n.email);
              }
              if (!Validators.isEmailValid(value)) {
                return l10n.invalidEmail;
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          TextInput(
            controller: _passwordController,
            label: l10n.password,
            errorText: _errorText,
            hint: 'coolpassword123',
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.emptyField(l10n.password);
              }

              // Client-side validation for the password is not necessary
              // as the requirements can change on the server-side.
              return null;
            },
          ),
          const SizedBox(height: 26),
          Button(
              loading: loading,
              child: Text(
                l10n.loginBtn,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  final response = await Api.v1.accounts
                      .login(_emailController.text, _passwordController.text);

                  setState(() {
                    loading = false;

                    if (response.status == 500) {
                      _errorText = l10n.internalServerError;
                    } else if (response.status == 408) {
                      _errorText = l10n.requestTimedOut;
                    } else if (!response.ok) {
                      _errorText = l10n.invalidCredentials;
                    } else {
                      // Login successful
                      _errorText = null;

                      // Show the home screen
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    }
                  });
                }
              }),
          const SizedBox(
            height: 12,
          ),
          LinkText(text: l10n.forgotPassword, onTap: () {}),
          const SizedBox(
            height: 6,
          ),
          LinkText(text: l10n.dontHaveAccount, onTap: () {
            Navigator.pushReplacementNamed(context, '/register');
          }),
        ],
      ),
    );
  }
}
