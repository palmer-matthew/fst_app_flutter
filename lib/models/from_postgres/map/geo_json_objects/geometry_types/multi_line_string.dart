import 'package:flutter/material.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geo_json_type.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geometry_types/geometry_object.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geometry_types/line_string.dart';

// TODO: document @richtwin567
class GeoJsonMultiLineString extends GeoJsonGeometryObject {
  List<GeoJsonLineString> coordinates;
  GeoJsonMultiLineString({@required coordsJson})
      : assert(coordsJson != null),
        super(GeoJsonType.multiLineString) {
    coordinates = [];
    var lineStringCoords = [];
    for (var i = 0; i < coordsJson.length; i++) {
      if (coordsJson[i]['marker'] == 'END') {
        lineStringCoords.add(coordsJson[i]);
        coordinates.add(GeoJsonLineString(coordsJson: lineStringCoords));
        lineStringCoords = [];
      } else {
        lineStringCoords.add(coordsJson[i]);
      }
    }
  }

  @override
  toGeoJsonFile() {
    return {
      '\"type\"': '\"${type.toShortString()}\"',
      '\"coordinates\"': coordinates.map((e) => e.toGeoJsonFile()).toList()
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
    return coordinates.expand((e) => e.extractLatLng());
  }
}
