import 'package:cinema/common/constants/route_constants.dart';
import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/constants/translation_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/common/extensions/string_extensions.dart';
import 'package:cinema/data/data_sources/authentication_local_data_source.dart';
import 'package:cinema/di/get_it.dart';
import 'package:cinema/presentation/blocs/login/login_bloc.dart';
import 'package:cinema/presentation/journeys/login/label_field_widget.dart';
import 'package:cinema/presentation/theme/theme_text.dart';
import 'package:cinema/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _userNameController, _passwordController;
  bool enableSignIn = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _loadSavedCredentials();

    _userNameController.addListener(() {
      setState(() {
        enableSignIn = _userNameController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        enableSignIn = _userNameController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty;
      });
    });
  }

  Future<void> _loadSavedCredentials() async {
    final authLocalDataSource = getItInstance<AuthenticationLocalDataSource>();
    final credentials = await authLocalDataSource.getLoginCredentials();
    if (credentials != null) {
      setState(() {
        _userNameController.text = credentials['username'] ?? '';
        _passwordController.text = credentials['password'] ?? '';
        _rememberMe = true;
        enableSignIn = true;
      });
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.dimen_32.w.toDouble(),
          vertical: Sizes.dimen_24.h.toDouble(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: Sizes.dimen_8.h.toDouble()),
              child: Text(
                TranslationConstants.loginToMovieApp.t(context),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            LabelFieldWidget(
              label: TranslationConstants.username.t(context),
              hintText: TranslationConstants.enterTMDbUsername.t(context),
              controller: _userNameController,
            ),
            LabelFieldWidget(
              label: TranslationConstants.password.t(context),
              hintText: TranslationConstants.enterPassword.t(context),
              controller: _passwordController,
              isPasswordField: true,
            ),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                  fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.black;
                    }
                    return Colors.white;
                  }),
                  checkColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                Text(
                  'Remember me',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            BlocConsumer<LoginBloc, LoginState>(
              buildWhen: (previous, current) => current is LoginError,
              builder: (context, state) {
                if (state is LoginError) {
                  return Text(
                    state.message.t(context),
                    style: Theme.of(context).textTheme.orangeSubtitle1,
                  );
                }
                return const SizedBox.shrink();
              },
              listenWhen: (previous, current) => current is LoginSuccess,
              listener: (context, state) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteList.home,
                  (route) => false,
                );
              },
            ),
            Button(
              onPressed: () {
                final authLocalDataSource = getItInstance<AuthenticationLocalDataSource>();
                
                if (_rememberMe) {
                  // Lưu thông tin đăng nhập nếu remember me được chọn
                  authLocalDataSource.saveLoginCredentials(
                    _userNameController.text,
                    _passwordController.text,
                  ).then((_) {
                    BlocProvider.of<LoginBloc>(context).add(
                      LoginInitiateEvent(
                        _userNameController.text,
                        _passwordController.text,
                      ),
                    );
                  });
                } else {
                  // Xóa thông tin đăng nhập nếu remember me không được chọn
                  authLocalDataSource.clearLoginCredentials().then((_) {
                    BlocProvider.of<LoginBloc>(context).add(
                      LoginInitiateEvent(
                        _userNameController.text,
                        _passwordController.text,
                      ),
                    );
                  });
                }
              },
              text: TranslationConstants.signIn,
              isEnabled: enableSignIn,
            ),
          ],
        ),
      ),
    );
  }
}