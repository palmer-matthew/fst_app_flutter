import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geo_json_type.dart';

/// A class to represent the concept of a GeoJSON object as defined by https://tools.ietf.org/html/rfc7946#section-3
abstract class GeoJsonObject {
  GeoJsonType type;
  List<int> bbox;

  GeoJsonObject(this.type);

  /// Converts this GeoJson object to a format that can be written as a valid Geo JSON file.
  toGeoJsonFile();

  /// Converts this GeoJsonObject to a format that can be used in flutter like a [Map] decoded from JSON.
  toGeoJson();
}
