import 'package:flutter/material.dart';
import 'package:fst_app_flutter/utils/open_url.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:fst_app_flutter/models/sharing/vcard.dart';
import 'package:fst_app_flutter/utils/permissions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

/// Opens WhatsApp to the chat of the specified [phone] number.
openWhatsAppChat({@required String phone, String message = ''}) async {
  /// Formats the [phone] number into a string url that can be used to open
  /// WhatsApp on iOS or Android.
  String formatUrl() {
    if (Platform.isIOS) {
      return 'whatsapp://wa.me/$phone/?text=${Uri.parse(message)}';
    } else {
      return 'whatsapp://send?phone=$phone&text=${Uri.parse(message)}';
    }
  }

  await openUrl(formatUrl());
}

/// Creates a saves a [VCard] version of a [Contact] to the app's temporary
/// folder and shares it to WhatsApp.
shareContactToWhatsApp(VCard vCard) async {
  try {
    final RegExp filenameCheck = RegExp(r'^([><":?\/\\*|,;\[\]]*)$');
    var filename = (vCard.name.toLowerCase().split(' ')
          ..removeWhere((e) => e == '-' || e == '_'))
        .reduce((value, element) => value + '-' + element)
        .toString();
    // Ensure that the filename is legal
    if (filenameCheck.hasMatch(filename)) {
      filename = 'temp';
    }
    if (await requestPermission(Permission.storage)) {
      String filepath =
          join((await getTemporaryDirectory()).path, '$filename.vcf');
      File vcf = File(filepath)..createSync();
      vcf.writeAsStringSync(vCard.vcf);
      await Share.shareFiles([filepath],
          mimeTypes: ['text/directory'],
          subject: vCard.name + "'s contact",
          text: vCard.name);
    }
  } catch (e) {
    // TODO
  }
}
