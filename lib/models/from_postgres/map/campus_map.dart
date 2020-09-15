import 'dart:io';

import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/feature.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/feature_collection.dart';
import 'package:fst_app_flutter/services/handle_heroku_requests.dart';

// TODO: document @richtwin567
class CampusMap {
  static const String _herokuFeatures = 'feature/';

  static Future<FeatureCollection> get locations async {
    HerokuRequest<Feature> request = HerokuRequest();
    var locations = FeatureCollection(
        features: await request.getResults(
            _herokuFeatures, true, (data) => Feature(data)));
    return locations;
  }

  static downloadMap() async {
    File file =
        await File('${Directory.systemTemp.parent.path}/cache/campus.geojson')
            .create();
    await file.writeAsString((await locations).toGeoJsonFile());
  }
}
