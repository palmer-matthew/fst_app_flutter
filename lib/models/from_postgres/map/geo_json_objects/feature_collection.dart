import 'package:flutter/material.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/feature.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geo_json_object.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geo_json_type.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fst_app_flutter/models/enums/department.dart';

/// A class that represents a GeoJSON Feature Collection as a type of [GeoJsonObject] 
/// as defined by https://tools.ietf.org/html/rfc7946#section-3.3
class FeatureCollection extends GeoJsonObject {
  List<Feature> features;
  FeatureCollection({@required this.features})
      : assert(features != null),
        super(GeoJsonType.featureCollection);

  /// Converts all [Feature]s in this collection to JSON in a String. This can be written 
  /// as a valid geojson file.
  @override
  String toGeoJsonFile() {
    return {
      '\"type\"': '\"${type.toShortString()}\"',
      '\"features\"': features.map((e) => e.toGeoJsonFile()).toList()
    }.toString();
  }

  /// Converts the [Feature]s in this collection to a GeoJSON like [Map].
  @override
  Map<String, Object> toGeoJson() {
    return {
      'type': type.toShortString(),
      'features': features.map((e) => e.toGeoJson()).toList()
    };
  }

  /// Converts the [GeoJsonPoint]s in this collection to Google Maps [Marker]s.
  Set<Marker> exportPointsToGoogleMaps() {
    return features
        .where((feature) => feature.geometry.type == GeoJsonType.point)
        .map((e) => Marker(
            onDragEnd: (value) {},
            markerId: MarkerId('${e.id}'),
            infoWindow: InfoWindow(
                snippet:
                    'Alternative name: ${e.properties.altName}\nDescription: ${e.properties.description}',
                title: e.properties.title),
            draggable: false,
            position: e.geometry.extractLatLng()[0],
            alpha: 0.8))
        .toSet();
  }

  /// Converts the [GeoJsonPolygon]s in this collection to Google Maps [Polygon]s.
  Set<Polygon> exportPolygonsToGoogleMaps() {
    return features
        .where(
            (feature) => feature.geometry.type == GeoJsonType.polygon)
        .map((e) => Polygon(
            polygonId: PolygonId('${e.id}'),
            fillColor:
                e.properties.associatedWith.departmentColour.withAlpha(70),
            strokeWidth: 1,
            strokeColor:
                e.properties.associatedWith.departmentColour.withAlpha(70),
            points: e.geometry.extractLatLng()))
        .toSet();
  }

  /// Converts the [GeoJsonLineString]s in this collection to Google Maps [PolyLine]s.
  Set<Polyline> exportLineStringsToGoogleMaps() {
    return features
        .where((feature) =>
            feature.geometry.type == GeoJsonType.lineString)
        .map((e) => Polyline(
              polylineId: PolylineId('${e.id}'),
              color: e.properties.associatedWith.departmentColour.withAlpha(90),
              jointType: JointType.round,
              endCap: Cap.roundCap,
              startCap: Cap.roundCap,
              width: 30,
              points: e.geometry.extractLatLng(),
            ))
        .toSet();
  }

}


