import 'package:flutter/material.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_types/geo_json_type.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geometry_types/geometry_object.dart';

// TODO: document GeoJsonGeometryCollection @richtwin567
class GeoJsonGeometryCollection extends GeoJsonGeometryObject {
  List<GeoJsonGeometryObject> geometries;
  GeoJsonGeometryCollection({@required geometries})
      : super(GeoJsonType.geometryCollection);

  @override
  toGeoJsonFile() {
    throw UnimplementedError();
  }

  @override
  toGeoJson() {
    throw UnimplementedError();
  }

  @override
  extractLatLng() {
    throw UnimplementedError();
  }
}
