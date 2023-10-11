abstract class Constants {
  static String baseUrl = 'https://api.fpt-ec.click/parkx/api/v1/app/';
  static String baseUrlAuth = 'https://api.fpt-ec.click/parkx/api/v1/auth/';
  static Map<String, String> header(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}

