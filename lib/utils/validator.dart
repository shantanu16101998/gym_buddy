String? validateSimpleText(String inputText, String fieldName) {
  if (inputText == "") {
    return "$fieldName cannot be empty";
  } else {
    return null;
  }
}

String? validateEmailId(String emailId) {
  RegExp regExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  if (regExp.hasMatch(emailId)) {
    return null;
  } else {
    return "Please enter a valid email";
  }
}

String? contactValidator(String contact) {
  if (contact.length < 10) {
    return "Phone number should be 10 digits long";
  }
  return null;
}

String? validateUPIId(String inputText) {
  RegExp regex = RegExp(r"^[a-zA-Z0-9.-]{2, 256}@[a-zA-Z][a-zA-Z]{2, 64}");
  if (!regex.hasMatch(inputText)) {
    return 'Enter Valid UPI Id';
  } else {
    return null;
  }
}
