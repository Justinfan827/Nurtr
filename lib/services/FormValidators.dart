abstract class FormValidator {
  bool isValid(String val);
}

class NonEmptyValidator implements FormValidator {
  bool isValid(String val) {
    return val.isNotEmpty;
  }
}

class EmailValidator implements FormValidator {
  static String errorText = 'Enter a valid email';
  @override
  bool isValid(String val) {
    // TODO: do some basic checking of email verification.
    return val.isNotEmpty;
  }
}

class PasswordValidator implements FormValidator {
  static String errorText = 'Enter a valid password';
  @override
  bool isValid(String val) {
    return val.isNotEmpty;
  }
}

class EmailAndPasswordValidator {
  static final FormValidator emailValidator = EmailValidator();
  static final FormValidator passwordValidator = PasswordValidator();
}


