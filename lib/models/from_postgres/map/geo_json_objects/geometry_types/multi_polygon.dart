import 'package:flutter/material.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_types/geo_json_type.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geometry_types/geometry_object.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geometry_types/polygon.dart';

// TODO: document GeoJsonMultiPolygon @richtwin567
class GeoJsonMultiPolygon extends GeoJsonGeometryObject {
  List<GeoJsonPolygon> coordinates;
  GeoJsonMultiPolygon({@required coordsJson}) : super(GeoJsonType.multiPolygon) {
    coordinates = [];
    var polygonCoords = [];
    for (var i = 0; i < coordsJson.length; i++) {
      if (coordsJson[i]['marker'] == 'END') {
        polygonCoords.add(coordsJson[i]);
        coordinates.add(GeoJsonPolygon(coordsJson: polygonCoords));
        polygonCoords = [];
      } else {
        polygonCoords.add(coordsJson[i]);
      }
    }
  }

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
  /*
  For Polygons with more than one of these rings, the first MUST be
      the exterior ring, and any others MUST be interior rings.  The
      exterior ring bounds the surface, and the interior rings (if
      present) bound holes within the surface.*/
}
