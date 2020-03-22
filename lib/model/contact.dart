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
      this.firebasePhone);

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
      );
}
