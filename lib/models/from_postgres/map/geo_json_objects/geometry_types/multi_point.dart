import 'package:flutter/material.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geo_json_type.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geometry_types/geometry_object.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geometry_types/position.dart';

/// A class that represents a GeoJSON Multipoint as defined by 
/// https://tools.ietf.org/html/rfc7946#section-3.1.3
class GeoJsonMultiPoint extends GeoJsonGeometryObject {
  List<GeoJsonPosition> _coordinates;

  List<GeoJsonPosition> get coordinates => _coordinates;

  GeoJsonMultiPoint({@required coordsJson})
      : assert(coordsJson != null),
        super(GeoJsonType.multiPoint) {
    _coordinates = List.generate(
        coordsJson.length,
        (i) => GeoJsonPosition(
            newLongitude: coordsJson[i]['longitude'],
            newLatitude: coordsJson[i]['latitude']));
  }

  @override
  toGeoJsonFile() {
    return {
      '\"type\"': '\"${type.toShortString()}\"',
      '\"coordinates\"': coordinates.map((e) => e.toGeoJson()).toList()
    };
  }

  @override
  toGeoJson() {
    return {
      'type': type.toShortString(),
      'coordinates': coordinates.map((e) => e.toGeoJson()).toList()
    };
  }

  @override
  extractLatLng() {
    return coordinates.expand((e) => e.extractLatLng()).toList();
  }
}
