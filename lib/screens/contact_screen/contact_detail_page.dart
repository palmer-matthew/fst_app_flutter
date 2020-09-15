import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fst_app_flutter/models/from_postgres/contact/contact_model.dart';
import 'package:fst_app_flutter/models/from_postgres/contact/contact_platform.dart';
import 'package:fst_app_flutter/models/sharing/vcard.dart';
import 'package:fst_app_flutter/utils/open_url.dart';
import 'package:fst_app_flutter/utils/social_media_contact_share.dart';
import 'package:fst_app_flutter/widgets/contact_widgets/contact_card.dart';
import 'package:fst_app_flutter/widgets/contact_widgets/contact_detail_image.dart';

/// A page that shows all the details for the selected contact.
/// It allows the user to open websites, call the contact, save the contact to their phones and send an email to
/// the contact directly from the app.
class ContactDetailPage extends StatelessWidget {
  /// The information [Map] for this contact
  final Contact contactDetails;

  /// [contactDetails] is passed from [RouterSettings] in [Router.generateRoute]
  ContactDetailPage(this.contactDetails, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final ContactCard contactMethods =
        _contactDetailList(contactDetails, mq, context);
    final ContactCard contactInfo =
        _aboutContactList(contactDetails, mq, context);

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            floating: false,
            pinned: true,
            snap: false,
            actions: [
              Platform.isIOS
                  ? IconButton(icon: Icon(Icons.save), onPressed: null)
                  : IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () {
                        contactDetails.saveNatively();
                      }),
              IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    shareContactToWhatsApp(VCard.fromContact(contactDetails));
                  })
            ],
            expandedHeight: mq.size.height / 2.5,
            flexibleSpace: FlexibleSpaceBar(
                background: CustomPaint(
                    painter: ContactDetailSvg(
                        start: Point(
                            mq.size.width / 2.0, (mq.size.height / 2.5) / 2.0),
                        scale:
                            (mq.devicePixelRatio / mq.size.aspectRatio) * 1.5,
                        color: Theme.of(context).accentColor)),
                title: Padding(
                  padding: EdgeInsets.only(right: mq.size.width / 4.0),
                  child: Text(
                    contactDetails.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))),
        SliverList(
          delegate:
              SliverChildListDelegate.fixed([contactMethods, contactInfo]),
        )
      ],
    ));
  } // build

  /// Creates a [ContactCard] for the phone numbers, email address and
  /// fax number if applicable.
  ContactCard _contactDetailList(
      final Contact data, final MediaQueryData mq, BuildContext context) {
    List<dynamic> phoneNumsWhatsApp = [];
    List<dynamic> phoneNums = [];
    for (var i = 0; i < data.phones.length; i++) {
      var icon;
      if (data.phones[i].platforms == ContactPlatform.whatsapp) {
        icon = Image.asset(
          'assets/WhatsApp_flat.png',
          width: IconTheme.of(context).size,
        );
        phoneNumsWhatsApp.add(ListTile(
            leading: icon,
            onTap: () => openWhatsAppChat(phone: data.phones[i].phone),
            title: Text(data.phones[i].phone)));
      } else {
        icon = Icon(
          Icons.phone,
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).accentColor
              : null,
        );
        phoneNums.add(ListTile(
            leading: icon,
            onTap: () => openUrl('tel:${data.phones[i].phone}'),
            title: Text(data.phones[i].phone)));
      }
    }

    //ensure all WhatsApp numbers are listed first
    phoneNums.insertAll(0, phoneNumsWhatsApp);

    List<dynamic> phoneNumsWithDivider = [];
    if (phoneNums.length > 1) {
      phoneNums.forEach((e) {
        phoneNumsWithDivider
            .addAll([e, Divider(indent: kMinInteractiveDimension + 24.0)]);
      });
      phoneNumsWithDivider.removeLast();
    } else {
      phoneNumsWithDivider.addAll(phoneNums);
    }

    List<dynamic> iconifiedList = [
      ...phoneNumsWithDivider,
      phoneNums.length > 0 ? Divider() : null,
      data.email != ''
          ? ListTile(
              leading: Icon(
                Icons.email,
                color: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).accentColor
                    : null,
              ),
              title: Text(data.email),
              onTap: () => openUrl('mailto:${data.email}'),
            )
          : null,
      data.fax != '' ? Divider() : null,
      data.fax != ''
          ? ListTile(
              leading: Icon(Icons.print,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Theme.of(context).accentColor
                      : null),
              title: Text(data.fax),
              subtitle: Text('Fax'),
            )
          : null
    ];

    iconifiedList.removeWhere((element) => element == null);
    if (iconifiedList.length > 0) {
      if (iconifiedList.elementAt(iconifiedList.length - 1) is Divider)
        iconifiedList.removeAt(iconifiedList.length - 1);
    }

    return ContactCard(
        margin: EdgeInsets.fromLTRB(
            mq.size.width / 18, mq.size.height / 22, mq.size.width / 18, 0.0),
        child: Column(
          children: <Widget>[...iconifiedList],
        ));
  }

  /// Creates a [ContactCard] for the website and description if applicable.
  ContactCard _aboutContactList(
      final Contact data, final MediaQueryData mq, BuildContext context) {
    List<dynamic> iconifiedList;
    if (data.website != '' || data.description != '') {
      iconifiedList = [
        ListTile(
            title: Text('About ${data.name}',
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).accentColor
                        : null))),
        data.website != '' || data.description != '' ? Divider() : null,
        data.website != ''
            ? ListTile(
                onTap: () => openUrl(data.website),
                title: Text('Website'),
                subtitle: Text(data.website,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    )),
                trailing: Icon(Icons.chevron_right),
              )
            : null,
        data.website != ''
            ? Divider(
                indent: 16.0,
              )
            : null,
        data.description != ''
            ? ListTile(
                title: Text('Additional Info'),
                subtitle: Text(data.description),
                isThreeLine: true,
              )
            : null,
      ];

      iconifiedList.removeWhere((element) => element == null);

      return ContactCard(
          margin: EdgeInsets.fromLTRB(mq.size.width / 18, mq.size.height / 22,
              mq.size.width / 18, mq.size.height / 22),
          child: Column(
            children: <Widget>[...iconifiedList],
          ));
    } else {
      return ContactCard(child: Column());
    }
  }
}
