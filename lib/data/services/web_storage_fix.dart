import 'dart:html' as html;

class WebStorageFix {
  static const String _key = 'autohelper_operations';

  static void saveData(String data) {
    html.window.localStorage[_key] = data;
  }

  static String? loadData() {
    return html.window.localStorage[_key];
  }

  static void clearData() {
    html.window.localStorage.remove(_key);
  }
}