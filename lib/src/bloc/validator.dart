import 'dart:async';

class Validator {
  //
  //Login
  final loginEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains("@")) {
      sink.add(email);
    } else if (email.length == 0) {
      sink.addError("Enter Email");
    } else {
      sink.addError("Enter Valid Email");
    }
  });

  final loginPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length == 0) {
      sink.addError("Enter Password");
    } else {
      sink.add(password);
    }
  });

  final mobileValidation = StreamTransformer<String, String>.fromHandlers(
      handleData: (mobile, sink) {
    if (mobile.length == 0) {
      sink.addError("Enter mobile number");
    } else if (mobile.length < 10) {
      sink.addError("Enter 10 digit mobile number");
    } else {
      sink.add(mobile);
    }
  });

  final booleanTrue =
      StreamTransformer<bool, bool>.fromHandlers(handleData: (boolean, sink) {
    if (boolean) {
      sink.add(boolean);
    } else {
      sink.addError('');
    }
  });

  final checkEmpty =
      StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) {
    if (text.length == 0) {
      sink.addError("Enter Data");
    } else {
      sink.add(text);
    }
  });
}
