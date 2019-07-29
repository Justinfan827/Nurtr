import 'dart:async';
import 'package:flash_chat/models/SignInModel.dart';
import 'package:flash_chat/services/AuthService.dart';
import 'package:flash_chat/services/FirebaseDatabase.dart';

import 'datamodels.dart';

class SignInBloc {
  SignInBloc({this.authService});
  final AuthService authService;
  final StreamController<SignInModel> _modelController = StreamController<SignInModel>();
  Stream<SignInModel> get modelStream => _modelController.stream;
  SignInModel _model = SignInModel(); // initialize with default values

  void dispose() {
    _modelController.close();
  }


  Future<Me> submitForm() async {
    print("bloc submitting form");
    updateWith(submittedForm: true);
    try {
      if (_model.formType == FormType.Login) {
        return loginHandler();
      } else {
        return  registrationHandler();
      }
    } catch (e) {
      print(e);
      rethrow;
    }

  }

  void switchForms() {
    if (_model.formType == FormType.Login) {
      updateWith(submittedForm: false, formType: FormType.Register, email: '', password: '', firstName: '', lastName: '');
    } else {
      updateWith(submittedForm: false, formType: FormType.Login, email: '', password: '', firstName: '', lastName: '');
    }
  }

  Future<Me>loginHandler() async {
    try {
      updateWith(loading: true);
      Me user = await authService.signInUser(_model.email, _model.password);
      return user;
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      updateWith(loading: false);
    }
  }

  Future<Me> registrationHandler() async {
    // TODO: error catching on signin.
    try {
      updateWith(loading: true);
      await authService.createUser(_model.email, _model.password, _model.firstName, _model.lastName);
      return await loginHandler();
    } catch (e) {
      print(e);
    } finally {
      updateWith(loading: false);
    }
  }


  void updatePassword(String password) => updateWith(password: password);
  void updateEmail(String email) => updateWith(email: email);
  void updateFirstName(String firstName) => updateWith(firstName: firstName);
  void updateLastName(lastName) => updateWith(lastName: lastName);

  // add a new model to the stream.
  void updateWith({
    FormType formType,
    bool loading,
    bool submittedForm,
    String loginText,
    String registerText,
    String email,
    String password,
    String firstName,
    String lastName
  }) {

    _model = _model.copyWith(
      formType: formType,
      loading: loading,
      submittedForm: submittedForm,
      loginText: loginText,
      registerText: registerText,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password
    );
    _modelController.add(_model); // push new model on the stream.
  }
}
