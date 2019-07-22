import 'dart:async';

import 'package:flash_chat/models/datamodels.dart';
import 'package:flash_chat/screens/tabs/tab_root.dart';
import 'package:flash_chat/services/FormValidators.dart';
import 'package:flash_chat/services/auth_service.dart';
import 'package:flash_chat/services/database_service.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'RoundedButton.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm>
    with EmailAndPasswordValidator {
  bool handlingLogin;
  bool loading;
  bool submittedForm;
  String loginText;
  String registerText;
  AuthService authService;
  DatabaseService databaseService;

  FocusNode _emailNode = FocusNode();
  FocusNode _pwordNode = FocusNode();
  FocusNode _firstNameNode = FocusNode();
  FocusNode _lastNameNode = FocusNode();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _pwordController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  get email => _emailController.text;

  get pword => _pwordController.text;

  get firstName => _firstNameController.text;

  get lastName => _lastNameController.text;

  @override
  void initState() {
    super.initState();
    submittedForm = false;
    handlingLogin = true;
    loginText = 'Sign In';
    registerText = "Register";
    loading = false;
    authService = AuthService();
    databaseService = DatabaseService();
  }

  Future<void> loginHandler() async {
    try {
      setInAsyncCall(true);
      await authService.signInUser(this.email, this.pword);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TabRootScreen(
              authService: authService, dbService: databaseService),
        ),
      );
    } catch (e) {
      print(e.toString());
    } finally {
      setInAsyncCall(false);
    }
  }


  void clearAllTextFields() {
    _emailController.clear();
    _pwordController.clear();
    _lastNameController.clear();
    _firstNameController.clear();
  }

  Widget showBox() {
    if (this.handlingLogin) {
      return Container();
    } else {
      return SizedBox(
        height: 8.0,
      );
    }
  }

  shiftFocus(FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  void submitForm() async {
    this.submittedForm = !this.submittedForm;
    this.handlingLogin ? loginHandler() : registrationHandler();
  }

  void updateState() {
    print("Email: $email pword: $pword");
    setState(() {
    });
  }

  void setInAsyncCall(bool bl) {
    setState(() {
      this.loading = bl;
    });
  }

  Future<void> registrationHandler() async {
    // TODO: error catching on signin.
    try {
      setInAsyncCall(true);
      User user =
          await databaseService.createUser(email, pword, firstName, lastName);
    } catch (e) {
    } finally {
    }
    loginHandler();
  }

  void switchHandler() {
    setState(() {
      this.handlingLogin = !this.handlingLogin;
      this.submittedForm = false;
      FocusNode node = this.handlingLogin ? _emailNode : _firstNameNode;
      FocusScope.of(context).requestFocus(node);
      clearAllTextFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: Container(
          child: CircularProgressIndicator(
            backgroundColor: mainGreen,
          ),
        ),
      );
    }
    bool showEmailErrorText =
        !EmailAndPasswordValidator.emailValidator.isValid(email) &&
            submittedForm;
    bool showPasswordErrorText =
        !EmailAndPasswordValidator.emailValidator.isValid(pword) &&
            submittedForm;
    bool disableButton = loading ||
        !EmailAndPasswordValidator.emailValidator.isValid(email) ||
        !EmailAndPasswordValidator.emailValidator.isValid(pword);

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            showNameField(context, 'Enter first name', true),
            showBox(),
            showNameField(context, 'Enter last name', false),
            showBox(),
            TextField(
              focusNode: _emailNode,
              enabled: !loading,
              onEditingComplete: () => shiftFocus(_pwordNode),
              controller: _emailController,
              onChanged: (value) {
                setState(() {

                });
              },
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[700],
              ),
              textInputAction: TextInputAction.next,
              decoration: kFloatingTextFieldDecoration.copyWith(
                errorText: showEmailErrorText ? EmailValidator.errorText : null,
                hintText: 'Enter Email',
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              focusNode: _pwordNode,
              enabled: !loading,
              onEditingComplete: submitForm,
              controller: _pwordController,
              textAlign: TextAlign.center,
              onChanged: (value) {
                setState(() {

                });
              },
              style: TextStyle(
                color: Colors.grey[700],
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              decoration: kFloatingTextFieldDecoration.copyWith(
                hintText: 'Enter Password',
                errorText:
                    showPasswordErrorText ? PasswordValidator.errorText : null,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            RoundedButton(
              text: this.handlingLogin ? loginText : registerText,
              color: Colors.black,
              onPressed: disableButton ? null : submitForm,
            ),
            FlatButton(
              onPressed: switchHandler,
              child: Text(
                this.handlingLogin
                    ? "Need an account? Register one"
                    : "Have an account? Sign in",
                style: TextStyle(color: Color(0xff5DDC95)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showNameField(
      BuildContext context, String placeholder, bool isFirstName) {
    if (!handlingLogin) {
      FocusNode nextNode = isFirstName ? _lastNameNode : _emailNode;
      return TextField(
        controller: isFirstName ? _firstNameController : _lastNameController,
        focusNode: isFirstName ? _firstNameNode : _lastNameNode,
        onEditingComplete: () => shiftFocus(nextNode),
        onChanged: (value) => updateState,
        enabled: !loading,
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
}
