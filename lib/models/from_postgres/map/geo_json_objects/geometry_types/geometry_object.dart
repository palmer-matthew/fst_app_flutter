import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geo_json_object.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geo_json_type.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A class to represent a GeoJSON Geometry Object as a type of [GeoJsonObject]
/// as defined by https://tools.ietf.org/html/rfc7946#section-3.1
abstract class GeoJsonGeometryObject extends GeoJsonObject {
  GeoJsonGeometryObject(GeoJsonType type) : super(type);

  /// Extracts a list of [LatLng] from the coordinates of this [GeoJsonGeometryObject]
  List<LatLng> extractLatLng();
}
