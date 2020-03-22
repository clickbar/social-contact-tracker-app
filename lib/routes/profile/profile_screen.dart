import 'package:flutter/material.dart';
import 'package:social_contact_tracker/dialogs/info_dialog.dart';
import 'package:social_contact_tracker/model/contact.dart';
import 'package:social_contact_tracker/model/covid_status.dart';
import 'package:social_contact_tracker/widgets/contact_avatar.dart';
import 'package:social_contact_tracker/widgets/flat_round_icon_button.dart';
import 'package:social_contact_tracker/extensions/list.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contact = Contact(1, '', 'AH', null, Color(0xFF123456), 'Adrian',
        '+49 1234567', null, null, null, null);
    final covidStatus = CovidStatus.NO_CONTACT;

    final contactForStatusShareCount = 17;
    final shareContacts =
        List.generate(contactForStatusShareCount, (i) => contact);
    int possibleContactCount = 0;

    bool enoughSpace = false;
    final availableWidth =
        MediaQuery.of(context).size.width - 2 * 16.0 - 2 * 16.0;
    final neededWidth =
        contactForStatusShareCount * 24 + (contactForStatusShareCount - 1) * 10;
    if (neededWidth > availableWidth) {
      // --> Not enough space
      final difference = neededWidth - availableWidth;
      final removeAmount = (difference / (24.0 + 10.0)).ceil();
      possibleContactCount = contactForStatusShareCount - removeAmount - 1;
    } else {
      // --> Enough Space
      enoughSpace = true;
    }

    final livingTogetherContacts = List.generate(3, (i) => contact);

    return Scaffold(
      backgroundColor: Color(0xFFF3F5FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: Material(
          elevation: 4,
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ContactAvatar(
                contact,
                size: 84,
                radius: 24,
              ),
              const SizedBox(height: 16),
              Text('Gude ${contact.displayName}',
                  style: TextStyle(
                      color: Color(0xFF2D3748),
                      fontSize: 28,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 24)
            ],
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Du bist angemeldet mit der Nr.',
                      style: TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text('+49 176 12345678',
                        style: TextStyle(
                            color: Color(0xFF718096),
                            fontSize: 24,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Dein Status',
                                style: TextStyle(
                                    color: Color(0xFF718096),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, right: 2.0),
                              child: IconButton(
                                icon:
                                    Icon(Icons.info, color: Color(0xFFCBD5E0)),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      child: InfoDialog(
                                        onlyCovidStatus: true,
                                      ));
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: covidStatus.toBackgroundColor(),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              covidStatus.toDispalyText(),
                              style: TextStyle(
                                color: covidStatus.toTextColor(),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.only(right: 16),
                          alignment: Alignment.bottomRight,
                          child: FlatRoundIconButton(
                            child: Text('Status Update'),
                            onTap: () {},
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Dein Status wird geteilt mit',
                      style: TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        text: '$contactForStatusShareCount ',
                        style: TextStyle(
                            color: Color(0xFF2C5282),
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                              text: contactForStatusShareCount == 1
                                  ? 'Kontakt'
                                  : 'Kontakten',
                              style: TextStyle(color: Color(0xFF718096))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        if (enoughSpace)
                          ...shareContacts.separated(
                              element: (e, _) =>
                                  ContactAvatar(e, size: 24, radius: 99),
                              separator: (_) => const SizedBox(width: 10)),
                        if (!enoughSpace) ...[
                          for (var i = 0; i < possibleContactCount * 2; i++)
                            i.isEven
                                ? ContactAvatar(shareContacts[i ~/ 2],
                                    size: 24, radius: 99)
                                : const SizedBox(width: 10),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Color(0xFFE6EBF8),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Icon(
                              Icons.add,
                              color: Color(0xFF718096),
                              size: 16,
                            )),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: FlatRoundIconButton(
                        child: Text('Liste bearbeiten'),
                        onTap: () {},
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'In deinem Haushalt leben',
                      style: TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: livingTogetherContacts.separated(
                            element: (c, _) => Row(
                                  children: <Widget>[
                                    ContactAvatar(c, size: 24, radius: 99),
                                    const SizedBox(width: 10),
                                    Text(
                                      c.displayName,
                                      style: (TextStyle(
                                        color: Color(0xFF718096),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      )),
                                    ),
                                  ],
                                ),
                            separator: (_) => const SizedBox(height: 12.0))),
                    const SizedBox(height: 24),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: FlatRoundIconButton(
                        child: Text('Haushalt bearbeiten'),
                        onTap: () {},
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
