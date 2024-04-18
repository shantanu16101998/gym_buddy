String? validateSimpleText(String inputText,String fieldName) {
  if (inputText == "") {
    return "$fieldName cannot be empty";
  } else {
    return null;
  }
}
