import 'package:url_launcher/url_launcher.dart' as urlLauncher;

///Opens the specified [url] (which could be a website, email, phone call or sms) if possible, in the appropriate application.
///
/// To open a web page the [url] must be in the format:
///
/// `http:<URL>` OR `https:<URL>`
///
/// To send an email the [url] must be in the format: `mailto:<email address>`.
///
/// To make a call the [url] must be in the format: `tel:<phone number>`.
///
/// To send an sms the [url] must be in the format: `sms:<phone number>`
///
openUrl(String url) async {
  if (await urlLauncher.canLaunch(url)) {
    try {
      await urlLauncher.launch(url);
    } catch (e) {
      // TODO
    }
  }
}
