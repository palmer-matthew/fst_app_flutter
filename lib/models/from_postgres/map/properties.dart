import 'package:fst_app_flutter/models/enums/department.dart';

/// Each GeoJSON [Feature] has Properties as defined under https://tools.ietf.org/html/rfc7946#section-3.2.
/// Each [Feature] on the campus map has a [title], a [Department] it is 
/// [associatedWith], a [description], and an [altName].
class Properties {
  /// The name of this [Feature].
  final String title;
  /// The [Department] this feature is associated with/attached to.
  final Department associatedWith;
  /// A description of this feature.
  final String description;
  /// Other names you may see or hear this feature being referred to by.
  final String altName;

  Properties(
      {this.title = '',
      this.description = '',
      this.associatedWith = Department.other,
      this.altName = ''});

  /// Converts the [Properties] of this [Feature] to a format that can be written as a valid Geo JSON file.
  toGeoJsonFile() {
    return {
      '\"title\"': '\"$title\"',
      '\"associatedWith\"': '\"${associatedWith.toShortString()}\"',
      '\"description\"': '\"$description\"',
      '\"altName\"': '\"$altName\"'
    };
  }

  /// Converts the [Properties] of this [Feature] to a format that can be used in flutter like a [Map] decoded from JSON.
  toGeoJson() {
    return {
      'title': title,
      'associatedWith': associatedWith.toShortString(),
      'description': description,
      'altName': altName
    };
  }
}
