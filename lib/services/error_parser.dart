class ErrorParser {
  static String parse(String errorCode) {
    String str = '';

    switch (errorCode) {
      case 'INVALID_REQUEST':
        str = 'Invalid request';
        break;
      case 'DISTRICT_NOT_FOUND':
        str = 'District not found';
        break;
      case 'GENDER_NOT_FOUND':
        str = 'Invalid gender';
        break;
      case 'EMAIL_ALREADY_USED':
        str = 'Email already used, please user another email';
        break;
      case 'USER_NOT_FOUND':
        str = 'User not found on our database';
        break;
      case 'WRONG_PASSWORD':
        str = 'Wrong password';
        break;
      default:
        str = 'Error while fetching data';
    }

    return str;
  }
}