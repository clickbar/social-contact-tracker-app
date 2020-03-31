import 'package:social_contact_tracker/model/covid_status.dart';

class CovidStatusUpdate {
  final CovidStatus status;
  final DateTime updatedAt;
  final String internalIdentifier;

  CovidStatusUpdate(this.status, this.updatedAt, this.internalIdentifier);

  factory CovidStatusUpdate.fromDatabase(Map<String, dynamic> data) {
    return CovidStatusUpdate(
        covidStatusFromDatabaseString(data['covid_status']),
        DateTime.fromMillisecondsSinceEpoch(data['updated_at']),
        data["contact_id"].toString());
  }
}
