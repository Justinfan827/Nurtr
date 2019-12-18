import 'package:flash_chat/components/SignInForm.dart';
import 'package:flash_chat/components/SignInFormBloc.dart';
import 'package:flash_chat/services/AuthService.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/intro/login_screen.dart';
import 'package:flash_chat/screens/intro/registration_screen.dart';
import 'package:flash_chat/components/RoundedButton.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:flash_chat/viewmodels/SignInBloc.dart';
import 'package:provider/provider.dart';


class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                'Nurtr.',
                style: TextStyle(
                    color: Color(0xFF5DDC95),
                    fontSize: 100,
                    fontFamily: 'Lato'),
              ),
            ),
            _buildSignInForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Provider<SignInBloc>(
      builder: (_) => SignInBloc(),
      dispose: (_, bloc) {
        print("disposing sign in bloc.");
        bloc.dispose();
        },
      child: Consumer<SignInBloc>(
        builder: (context, bloc, _) => SignInFormBloc(
          bloc: bloc,
        ),
      ),
    );
  }
}
