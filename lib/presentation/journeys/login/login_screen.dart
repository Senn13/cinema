import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/presentation/journeys/login/login_form.dart';
import 'package:cinema/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: Sizes.dimen_32.h.toDouble()),
              child: Logo(height: Sizes.dimen_12.h.toDouble()),
            ),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}