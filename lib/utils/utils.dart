abstract class Utils {
  static String hiddenPrice(dynamic price, bool hidden) {
    if (hidden) {
      return "******";
    }
    return price;
  }
}
