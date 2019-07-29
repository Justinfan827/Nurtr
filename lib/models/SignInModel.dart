
enum FormType {Login, Register}

class SignInModel {

  @override
  String toString() {
    return ("loading: ${this.loading} formType: $formType submittedForm: $submittedForm loginText: $loginText"
        "registerText: $registerText email: $email password: $password firstName: $firstName lastName: $lastName");
  }
  SignInModel({
    this.loading = false,
    this.formType = FormType.Login,
    this.submittedForm = false,
    this.loginText = 'Sign In',
    this.registerText = 'Register',
    this.email = '',
    this.password = '',
    this.firstName = '',
    this.lastName = ''
  });

  final FormType formType;
  final bool loading;
  final bool submittedForm;
  final String loginText;
  final String registerText;
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  // Create a new SignInModel completely to add to the stream.
  SignInModel copyWith({
    FormType formType,
    bool loading,
    bool submittedForm,
    String loginText,
    String registerText,
    String email,
    String password,
    String firstName,
    String lastName,
}) {
    return SignInModel(
      formType: formType ?? this.formType,
      loading: loading ?? this.loading,
      submittedForm: submittedForm ?? this.submittedForm,
      loginText: loginText ?? this.loginText,
      registerText: registerText ?? this.registerText,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName
    );
}


}