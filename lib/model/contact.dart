import 'dart:ui';

class Contact {
  final int id;
  final String internalIdentifier;
  final String initials;
  final String picturePath;
  final Color avatarColor;
  final String displayName;
  final String phone;
  final String firebaseUid;
  final String firebasePhone;
  final bool shareStatus;
  final bool livingTogether;

  bool get hasPicture => picturePath != null;

  Contact(
    this.id,
    this.internalIdentifier,
    this.initials,
    this.picturePath,
    this.avatarColor,
    this.displayName,
    this.phone,
    this.firebaseUid,
    this.firebasePhone,
    this.shareStatus,
    this.livingTogether,
  );

  factory Contact.fromDatabase(Map<String, dynamic> data) => Contact(
        data['id'],
        data['internal_identifier'].toString(),
        data['initials'],
        data['picture_path'],
        Color(data['avatar_color']),
        data['display_name'],
        data['phone'],
        data['firebase_uid'],
        data['firebase_phone'],
        data['share_status'] == 1,
        data['living_together'] == 1,
      );

  @override
  String toString() {
    return 'Contact{id: $id, internalIdentifier: $internalIdentifier, initials: $initials, picturePath: $picturePath, avatarColor: $avatarColor, displayName: $displayName, phone: $phone, firebaseUid: $firebaseUid, firebasePhone: $firebasePhone, shareStatus: $shareStatus, livingTogether: $livingTogether}';
  }
}
