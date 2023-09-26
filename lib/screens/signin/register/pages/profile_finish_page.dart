import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/state/static/register_state.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/input/pfp_input.dart';
import 'package:taskbuddy/widgets/input/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/input/text_input.dart';
import 'package:taskbuddy/widgets/input/touchable/button.dart';
import 'package:taskbuddy/widgets/screens/register/screen_title.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/snackbars.dart';

class ProfileFinishPage extends StatelessWidget {
  const ProfileFinishPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BlurAppbar.appBar(
        child: Text(
          l10n.finalRegisterAppbar,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ),
      body: ScrollbarSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizing.horizontalPadding,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: max(MediaQuery.of(context).size.height, 700),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScreenTitle(
                  title: l10n.finalRegisterTitle,
                  description: l10n.finalRegisterDesc,
                ),
                const SizedBox(height: Sizing.formSpacing),
                const _OptionalForm(),
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _OptionalForm extends StatefulWidget {
  const _OptionalForm({Key? key}) : super(key: key);

  @override
  __OptionalFormState createState() => __OptionalFormState();
}

class __OptionalFormState extends State<_OptionalForm> {
  final _formKey = GlobalKey<FormState>();

  XFile? _image = RegisterState.profilePicture == '' ? null : XFile(RegisterState.profilePicture);
  final TextEditingController _bioController = TextEditingController(text: RegisterState.bio);
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          ProfilePictureInput(
            onSelected: (file) {
              setState(() {
                _image = file;
                RegisterState.profilePicture = file?.path ?? '';
              });
            },
            image: _image,
          ),
          const SizedBox(height: Sizing.inputSpacing,),
          // Biograpy text field
          TextInput(
            controller: _bioController,
            optional: true,
            label: l10n.biography,
            hint: l10n.bioPlaceholder,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLength: 150,
            minLines: 3,
            onChanged: (v) {
              RegisterState.bio = v;
            },
            maxLines: null,
          ),
          const SizedBox(height: Sizing.formSpacing,),
          Button(
            loading: _loading,
            child: Text(
              AppLocalizations.of(context)!.signUpBtnFinish,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _loading = true;
                });
                var response = await Api.v1.accounts.create(
                  email: RegisterState.email,
                  username: RegisterState.username,
                  phoneNumber: RegisterState.phoneNumber,
                  firstName: RegisterState.firstName,
                  lastName: RegisterState.lastName,
                  password: RegisterState.password,
                  bio: RegisterState.bio,
                  profilePicture: _image != null ? File(_image!.path) : null,
                );

                print(response.message);

                if (response.ok) {
                  // Save the data
                  await AccountCache.saveAccountResponse(response.data!);

                  Phoenix.rebirth(context);
                }

                else {
                  var _errorText = l10n.internalServerError;

                  if (response.status == 408) {
                    _errorText = l10n.requestTimedOut;
                  } else if (!response.ok) {
                    _errorText = l10n.invalidCredentials;
                  }

                  SnackbarPresets.show(context, _errorText);
                }

                setState(() {
                  _loading = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}