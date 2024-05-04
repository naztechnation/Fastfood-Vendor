class UrlValidator {
  static bool isValidUrl(String url) {
    return !RegExp(r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?', caseSensitive: false).hasMatch(url);
  }
}