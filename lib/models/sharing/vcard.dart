import 'package:fst_app_flutter/models/from_postgres/contact/contact_model.dart';
import 'package:fst_app_flutter/models/from_postgres/contact/contact_platform.dart';
import 'package:fst_app_flutter/models/from_postgres/contact/contact_type.dart';

/// A class for sharing contacts to WhatsApp in vCard format. 
/// The format is based off of the specifications here https://tools.ietf.org/html/rfc2426
class VCard {
  final String vcf;
  final String name;

  VCard(this.vcf, this.name);

  factory VCard.fromContact(Contact contact) {
    String rawPhoneNumber(String phone) {
      String rawPhone = '';
      for (var i = 0; i < phone.length; i++) {
        if (int.tryParse(phone[i]) != null) {
          rawPhone += phone[i];
        }
      }
      return rawPhone;
    }

    String vCard = 'BEGIN:VCARD\nVERSION:3.0\n';
    if (contact.contactType == ContactType.facultyStaff) {
      vCard += 'KIND:individual\n';
    } else {
      vCard += 'KIND:org\n';
    }
    vCard += 'FN:${contact.name}\n';
    if (contact.contactType == ContactType.facultyStaff) {
      List<String> nameParts = contact.name.split(' ');
      int numParts = nameParts.length;
      if (numParts == 4) {
        vCard +=
            'N:${nameParts[3]};${nameParts[1]};${nameParts[2]};${nameParts[0]};;\n';
      } else {
        vCard += 'N:${nameParts[2]};${nameParts[1]};;${nameParts[0]};;\n';
      }
    } else {
      vCard += 'N:;${contact.name};;;\n';
    }
    if (contact.email != '') {
      vCard += 'EMAIL;TYPE=internet;TYPE=work:${contact.email}\n';
    }
    if (contact.phones.length > 0) {
      contact.phones.forEach((phone) {
        if (phone.platforms == ContactPlatform.whatsapp) {
          vCard +=
              'TEL;TYPE=cell;TYPE=voice;TYPE=video;TYPE=text;waid=${rawPhoneNumber(phone.phone)}:${phone.phone}\n';
        } else {
          vCard +=
              'TEL;TYPE=cell;TYPE=voice;TYPE=video;TYPE=text:${phone.phone}\n';
        }
      });
    }
    if (contact.fax != '') {
      vCard += 'TEL;TYPE=fax:${contact.fax}\n';
    }
    if (contact.website != '') {
      vCard += 'URL:${contact.website}\n';
    }
    vCard += 'END:VCARD';

    return VCard(vCard, contact.name);
  }
}
