import 'network_error.dart';

class NetworkException implements Exception {
  var message;

  NetworkException(this.message);
}

void throwNetworkException(error) {
  switch (error.code) {
    case "Error 14":
    case "INTERNAL":
    case "ERROR_NETWORK_REQUEST_FAILED":
      throw NetworkException(NetworkError.CONNECTIVITY_ERROR);
    case "Error 16":
      throw NetworkException(NetworkError.AUTHENTICATION_ERROR);
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      throw NetworkException(NetworkError.INVALID_EMAIL);
    case "ERROR_EMAIL_ALREADY_IN_USE":
      throw NetworkException(NetworkError.EMAIL_ALREADY_IN_USE);
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      throw NetworkException(NetworkError.WRONG_PASSWORD);
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      throw NetworkException(NetworkError.USER_NOT_FOUND);
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      throw NetworkException(NetworkError.USER_DISABLED);
    case "ERROR_TOO_MANY_REQUESTS":
    case "operation-not-allowed":
    case "operation-not-allowed":
      throw NetworkException(NetworkError.TOO_MANY_REQUESTS);
    default:
      throw NetworkException(NetworkError.UNHANDLED);
  }
}
