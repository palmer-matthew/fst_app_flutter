import 'package:fst_app_flutter/global_const.dart';
import 'package:fst_app_flutter/models/enums/department.dart';
import 'package:fst_app_flutter/models/from_postgres/contact/contact_platform.dart';
import 'package:fst_app_flutter/models/from_postgres/contact/contact_type.dart';
import 'package:fst_app_flutter/utils/string_to_enum.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fst_app_flutter/utils/permissions.dart';

/// Contact class for parsing contacts from the database and manipulating them in the app.
///
/// A contact may have a [_name], [_website], particularly in the case of department contacts,
/// an [_email] address, a [_fax] number in the case of offices, a [_description], 
/// a [_department] it is affiliated with among the [Department]s, an assigned 
/// [ContactType], zero or more [_phones], and a unique [_id]. 
class Contact {
  /// The unique ID assigned to this contact
  int _id;
  /// The name associated with this contact
  String _name;
  /// This contact's website
  String _website;
  /// This contact's email address
  String _email;
  /// The fax number for this contact
  String _fax;
  /// A description of this contact
  String _description;
  /// The [Department] this contact is affiliated with
  Department _department;
  /// The [ContactType] of this contact
  ContactType _contactType;
  /// The [_PhoneNumber]s for this contact
  List<_PhoneNumber> _phones;

  int get id => _id;

  String get name => _name;

  String get website => _website;

  String get email => _email;

  String get fax => _fax;

  String get description => _description;

  Department get department => _department;

  ContactType get contactType => _contactType;

  List<_PhoneNumber> get phones => _phones;

  Contact(dynamic contact) {
    List<_PhoneNumber> phones =
        List.generate(contact['phone_contact_set'].length, (i) {
      return _PhoneNumber(contact['phone_contact_set'][i]);
    });
    _department = stringToDepartment(contact['department']);
    _contactType = stringToContactType(contact['contact_type']);
    _id = contact['id'];
    _name = contact['name'];
    _website = contact['website'];
    _email = contact['email'];
    _fax = contact['fax'];
    _description = contact['description'];
    _phones = phones;
  }

  /// Converts this contact's fields to a form that can be parsed for saving to the user's phone.
  Map<String, Object> toNativeMap() {
    return {
      "displayName": name,
      'note': description,
      'email': email,
      'phones': List<Map<String, String>>.generate(
          phones.length, (i) => {'label': 'work', 'value': phones[i].phone})
        ..addAll(List<Map<String, String>>.generate(
            fax != '' ? 1 : 0, (i) => {'label': 'fax work', 'value': fax})),
      'website': website,
      "date": DateTime.now().toIso8601String(),
      "lastModified": DateTime.now().toIso8601String(),
    };
  }

  /// Invokes the method to save this Contact to the user's phone.
  saveNatively() async {
    try {
      if (await requestPermission(Permission.contacts)) {
        await channel.invokeMethod('saveNatively', toNativeMap());
      }
    } catch (e) {
    }
  }
}

/// Phonenumber class for parsing phonenumbers and related information 
/// from the database and manipulating them in the app.
/// 
/// A phone number only exists when it is attached to a [Contact]. Each phonenumber has
/// a [_phone], the [ContactPlatform] it is associated with, the [Contact] it is
/// attached to via [_contactID] and its own unique [_id].
class _PhoneNumber {
  int _id;
  int _contactID;
  String _phone;
  ContactPlatform _platforms;

  int get id => _id;
  int get contactID => _contactID;
  String get phone => _phone;
  ContactPlatform get platforms => _platforms;

  _PhoneNumber(dynamic phoneSet) {
    ContactPlatform platform;
    switch (phoneSet['platforms']) {
      case 'WHATSAPP':
        platform = ContactPlatform.whatsapp;
        break;
      default:
        platform = ContactPlatform.textCall;
        break;
    }
    _id = phoneSet['id'];
    _contactID = phoneSet['contact'];
    _phone = phoneSet['phone'];
    _platforms = platform;
  }
}
