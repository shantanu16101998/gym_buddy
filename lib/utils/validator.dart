String? validateSimpleText(String inputText, String fieldName) {
  if (inputText == "") {
    return "$fieldName cannot be empty";
  } else {
    return null;
  }
}

String? validateUPIId(String inputText) {
  RegExp regex = RegExp(r"^[a-zA-Z0-9.-]{2, 256}@[a-zA-Z][a-zA-Z]{2, 64}");
  if (!regex.hasMatch(inputText)) {
    return 'Enter Valid UPI Id';
  } else {
    return null;
  }
}

