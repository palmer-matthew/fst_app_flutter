import 'package:flutter/material.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geometry_types/line_string.dart';


// TODO: document @richtwin567
class GeoJsonLinearRing extends GeoJsonLineString {
  GeoJsonLinearRing({@required coordsJson})
      : assert(coordsJson.first['longitude'] == coordsJson.last['longitude'] &&
            coordsJson.first['latitude'] == coordsJson.last['latitude'] &&
            coordsJson.first['marker'] == 'START' &&
            coordsJson.last['marker'] == 'END'),
        assert(coordsJson.length >= 4),
        super(coordsJson: coordsJson);

  @override
  toGeoJsonFile() {
    return coordinates.map((e) => e.toGeoJson()).toList();
  }

  @override
  toGeoJson() {
    return toGeoJsonFile();
  }
  /*
    A linear ring MUST follow the right-hand rule with respect to the
      area it bounds, i.e., exterior rings are counterclockwise, and
      holes are clockwise.
   */
}
