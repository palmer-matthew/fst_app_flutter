import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geo_json_object.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geo_json_type.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geometry_types/geometry_object.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geometry_types/line_string.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geometry_types/multi_point.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geometry_types/point.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geometry_types/polygon.dart';
import 'package:fst_app_flutter/models/from_postgres/map/properties.dart';
import 'package:fst_app_flutter/utils/string_to_enum.dart';

/// A class that represents a GeoJSON Feature as defined by https://tools.ietf.org/html/rfc7946#section-3.2
class Feature extends GeoJsonObject {
  GeoJsonGeometryObject geometry;
  Properties properties;
  int id;

  Feature(dynamic feature) : super(GeoJsonType.feature) {
    properties = Properties(
        title: feature['code'],
        description: feature['title'],
        associatedWith: stringToDepartment(feature['associated_with']),
        altName: feature['alt_name']);
    id = feature['id'];
    var uknGeometry = feature['geometry'];
    var newCoords = uknGeometry['coordinates'];
    switch (stringToGeometryType(uknGeometry['geometry_type'])) {
      case GeoJsonType.point:
        geometry = GeoJsonPoint(coordsJson: newCoords);
        break;
      case GeoJsonType.multiPoint:
        geometry = GeoJsonMultiPoint(coordsJson: newCoords);
        break;
      case GeoJsonType.lineString:
        geometry = GeoJsonLineString(coordsJson: newCoords);
        break;
      case GeoJsonType.multiLineString:
        throw UnimplementedError();
        //geometry = MultiLineString(coordsJSON: newCoords);
        break;
      case GeoJsonType.polygon:
        geometry = GeoJsonPolygon(coordsJson: newCoords);
        break;
      case GeoJsonType.multiPolygon:
        throw UnimplementedError();
        //geometry = MultiPolygon(coordsJSON: newCoords);
        break;
      case GeoJsonType.geometryCollection:
        throw UnimplementedError();
        break;
      case GeoJsonType.feature:
        break;
      case GeoJsonType.featureCollection:
        break;
    }
  }

  @override
  toGeoJsonFile() {
    return {
      '\"id\"': id,
      '\"type\"': '\"${type.toShortString()}\"',
      '\"geometry\"': geometry.toGeoJsonFile(),
      '\"properties\"': properties.toGeoJsonFile()
    };
  }

  @override
  Map<String, Object> toGeoJson() {
    return {
      'id': id,
      'type': type.toShortString(),
      'geometry': geometry.toGeoJson(),
      'properties': properties.toGeoJson()
    };
  }
}
