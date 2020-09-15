import 'package:flutter/material.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geometry_types/geometry_object.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A class to represent a GeoJSON Positon as defined by https://tools.ietf.org/html/rfc7946#section-3.1.1 
class GeoJsonPosition extends GeoJsonGeometryObject {
  double _longitude;

  double _latitude;

  double _elevation;

  double get latitude => _latitude;

  double get longitude => _longitude;

  double get elevation => _elevation;

  GeoJsonPosition(
      {@required double newLongitude,
      @required double newLatitude,
      double elevation})
      : assert(newLatitude != null && newLongitude != null), super(null) {
    _elevation = elevation;
    _longitude = newLongitude;
    _latitude = newLatitude;
  }

  @override
  int get hashCode =>
      longitude.hashCode ^ latitude.hashCode ^ elevation.hashCode;

  //cartesianLine(lon, lat) => (lon0 + (lon1 - lon0) * t, lat0 + (lat1 - lat0) * t)

  @override
  operator ==(o) =>
      o is GeoJsonPosition &&
      o.longitude == longitude &&
      o.latitude == latitude &&
      o.elevation == elevation;

  @override
  toGeoJson() => [latitude, longitude];

  List<LatLng> extractLatLng() {
    return [LatLng(latitude, longitude)];
  }

  @override
  toGeoJsonFile() {
    return '[$longitude,$latitude]';
  }
}
