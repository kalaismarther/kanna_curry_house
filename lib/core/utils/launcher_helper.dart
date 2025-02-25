import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LauncherHelper {
  static void openMailApp(String email) {
    try {
      launchUrl(Uri(scheme: 'mailto', path: email));
    } catch (e) {
      //
    }
  }

  static void openDialerApp(String mobile) {
    try {
      launchUrl(Uri(scheme: 'tel', path: mobile));
    } catch (e) {
      //
    }
  }

  static Future<void> openWhatsApp(String mobile) async {
    try {
      await launchUrlString('https://wa.me/$mobile');
    } catch (e) {
      //
    }
  }
}
