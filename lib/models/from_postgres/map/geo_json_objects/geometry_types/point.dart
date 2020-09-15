import 'package:flutter/material.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geo_json_type.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geometry_types/geometry_object.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geometry_types/position.dart';

/// A class to represent a GeoJSON point as a kind of Geometry Object as defined by
/// https://tools.ietf.org/html/rfc7946#section-3.1.2
class GeoJsonPoint extends GeoJsonGeometryObject {
  GeoJsonPosition _coordinates;

  GeoJsonPosition get coordinates => _coordinates;

  GeoJsonPoint({@required coordsJson})
      : assert(coordsJson != null),
        super(GeoJsonType.point) {
    _coordinates = GeoJsonPosition(
        newLongitude: coordsJson[0]['longitude'],
        newLatitude: coordsJson[0]['latitude']);
  }

  @override
  toGeoJsonFile() {
    return {
      '\"type\"': '\"${type.toShortString()}\"',
      '\"coordinates\"': coordinates.toGeoJson()
    };
  }

  @override
  toGeoJson() {
    return {
      'type': type.toShortString(),
      'coordinates': coordinates.toGeoJson()
    };
  }

  @override
  extractLatLng() {
    return coordinates.extractLatLng();
  }
}
