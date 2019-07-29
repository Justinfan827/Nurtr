import 'dart:async';

import 'package:flash_chat/models/SignInModel.dart';
import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/models/SignInBloc.dart';
import 'package:flash_chat/screens/tabs/tab_root.dart';
import 'package:flash_chat/services/FormValidators.dart';
import 'package:flash_chat/services/AuthService.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'LoadingContainer.dart';
import 'RoundedButton.dart';

class SignInFormBloc extends StatefulWidget with EmailAndPasswordValidator {
  SignInFormBloc({@required this.bloc});

  final SignInBloc bloc;

  @override
  _SignInFormBlocState createState() => _SignInFormBlocState();
}

class _SignInFormBlocState extends State<SignInFormBloc> {
  final FocusNode _emailNode = FocusNode();
  final FocusNode _pwordNode = FocusNode();
  final FocusNode _firstNameNode = FocusNode();
  final FocusNode _lastNameNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _pwordController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Future<void> navigateToTabScreen(User me) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        // wrap with auth provider so all screens below get the auth information.
        builder: (context) => MultiProvider(
            providers: [
              Provider<User>.value(value: me),
              Provider<AuthService>.value(value: widget.bloc.authService),
            ],
            child: TabRootScreen(
              user: me,
              authService: widget.bloc.authService,
              firestoreDB: FirestoreDatabase(uid: me.uid),
            )),
      ),
    );
  }

  Future<void> submitForm() async {
    print("Submitting form");
    Me me = await widget.bloc.submitForm();
    print("navigating to screen");
    await navigateToTabScreen(me);
  }

  void clearAllTextFields() {
    _emailController.clear();
    _pwordController.clear();
    _lastNameController.clear();
    _firstNameController.clear();
  }

  Widget showBox(SignInModel model) {
    if (model.formType == FormType.Register) {
      return Container();
    } else {
      return SizedBox(
        height: 8.0,
      );
    }
  }

  shiftFocus(FocusNode node, BuildContext context) {
    FocusScope.of(context).requestFocus(node);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SignInModel>(
      stream: widget.bloc.modelStream,
      initialData: SignInModel(),
      builder: (context, snapshot) {
        SignInModel model = snapshot.data;
        if (model.loading || model == null) {
          return LoadingContainer();
        }
        bool showEmailErrorText =
            !EmailAndPasswordValidator.emailValidator.isValid(model.email) &&
                model.submittedForm;
        bool showPasswordErrorText =
            !EmailAndPasswordValidator.emailValidator.isValid(model.password) &&
                model.submittedForm;

        bool disableButton = model.loading ||
            !EmailAndPasswordValidator.emailValidator.isValid(model.email) ||
            !EmailAndPasswordValidator.emailValidator.isValid(model.password);
        return Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                showNameField(context, 'Enter first name', true, model),
                showBox(model),
                showNameField(context, 'Enter last name', false, model),
                showBox(model),
                TextField(
                  focusNode: _emailNode,
                  enabled: !model.loading,
                  onEditingComplete: () => shiftFocus(_pwordNode, context),
                  controller: _emailController,
                  onChanged: widget.bloc.updateEmail,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                  textInputAction: TextInputAction.next,
                  decoration: kFloatingTextFieldDecoration.copyWith(
                    errorText:
                        showEmailErrorText ? EmailValidator.errorText : null,
                    hintText: 'Enter Email',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  focusNode: _pwordNode,
                  enabled: !model.loading,
                  onEditingComplete: submitForm,
                  controller: _pwordController,
                  textAlign: TextAlign.center,
                  onChanged: widget.bloc.updatePassword,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: kFloatingTextFieldDecoration.copyWith(
                    hintText: 'Enter Password',
                    errorText: showPasswordErrorText
                        ? PasswordValidator.errorText
                        : null,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                RoundedButton(
                  text: model.formType == FormType.Login
                      ? model.loginText
                      : model.registerText,
                  color: Colors.black,
                  onPressed: disableButton ? null : this.submitForm,
                ),
                FlatButton(
                  onPressed: () => switchForms(model),
                  child: Text(
                    model.formType == FormType.Login
                        ? "Need an account? Register one"
                        : "Have an account? Sign in",
                    style: TextStyle(color: Color(0xff5DDC95)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget showNameField(BuildContext context, String placeholder,
      bool isFirstName, SignInModel model) {
    if (model.formType == FormType.Register) {
      FocusNode nextNode = isFirstName ? _lastNameNode : _emailNode;
      return TextField(
        controller: isFirstName ? _firstNameController : _lastNameController,
        focusNode: isFirstName ? _firstNameNode : _lastNameNode,
        onEditingComplete: () => shiftFocus(nextNode, context),
        onChanged: isFirstName
            ? widget.bloc.updateFirstName
            : widget.bloc.updateLastName,
        enabled: !model.loading,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[700],
        ),
        decoration: kFloatingTextFieldDecoration.copyWith(
          hintText: placeholder,
        ),
      );
    } else {
      return Container();
    }
  }

  void switchForms(SignInModel model) {
    widget.bloc.switchForms();
    clearAllTextFields();
  }
}
