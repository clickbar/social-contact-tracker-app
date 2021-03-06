import 'package:flutter/material.dart';
import 'package:social_contact_tracker/model/covid_status.dart';

class InfoDialog extends StatelessWidget {
  final bool onlyCovidStatus;

  const InfoDialog({Key key, this.onlyCovidStatus = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headlineTextStyle = TextStyle(
      color: Color(0xFF2D3748),
      fontSize: 24,
      fontWeight: FontWeight.w600,
    );

    final contentTextStyle = TextStyle(
      color: Color(0xFF718096),
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOutCirc,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 100 - 100 * value),
          child: Transform.scale(
              scale: 0.7 + 0.3 * value,
              child: Opacity(
                opacity: value,
                child: child,
              )),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Icon(
                      Icons.info,
                      color: Color(0xFFCBD5E0),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!onlyCovidStatus) ...[
                    Text(
                      'Wieso diese App?',
                      style: headlineTextStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Du erkrankst an Covid19 und möchtest die Kontaktpersonen der letzten Tage natürlich darüber informieren.',
                      style: contentTextStyle,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Datenschutz?',
                      style: headlineTextStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Deine Begegnungen werde nur auf deinem Gerät gespeichert und werden nie versendet.\n\nBei deinem Status kannst du auswählen, mit wem du ihn teilen möchtest.',
                      style: contentTextStyle,
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    'Was ist ein Covid Status?',
                    style: headlineTextStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Das Robert-Koch-Institut kategorisiert Personen danach ob und wie eng der Kontakt zu einer positiv getesteten Person war. Danach wird auch entschieden ob ein Test notwendig ist oder wie stark man sich in Selbstisolation begeben sollte.\n\nDie Zeit hat zur Einstufung eine Grafik erstellt die wir als Hilfe genommen haben.\n\nEine sehr grobe Beschreibung:',
                    style: contentTextStyle,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: CovidStatus.NO_CONTACT.toBackgroundColor(),
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        CovidStatus.NO_CONTACT.toDispalyText(),
                        style: TextStyle(
                            color: CovidStatus.NO_CONTACT.toTextColor(),
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keinen Kontakt zu einer infizierten Person gehabt',
                    style: contentTextStyle,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: CovidStatus.CONTACT_2.toBackgroundColor(),
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        CovidStatus.CONTACT_2.toDispalyText(),
                        style: TextStyle(
                            color: CovidStatus.CONTACT_2.toTextColor(),
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Du hast dich mit einer infizierten Person im selben Raum aufgehalten.',
                    style: contentTextStyle,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: CovidStatus.CONTACT_1.toBackgroundColor(),
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        CovidStatus.CONTACT_1.toDispalyText(),
                        style: TextStyle(
                            color: CovidStatus.CONTACT_1.toTextColor(),
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Du hattest direkten Kontakt mit einer infizierten Person. D.h. zu hattest ein min. 15 Minuten langes Gespäch oder hast Körperflüssigkeiten ausgetauscht.',
                    style: contentTextStyle,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: CovidStatus.POSITIVE.toBackgroundColor(),
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        CovidStatus.POSITIVE.toDispalyText(),
                        style: TextStyle(
                            color: CovidStatus.POSITIVE.toTextColor(),
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Du bist positiv auf COVID19 getestet worden.',
                    style: contentTextStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
