// TODO: document GeoJsonType @richtwin567
enum GeoJsonType {
  feature,
  featureCollection,
  point,
  multiPoint,
  lineString,
  multiLineString,
  polygon,
  multiPolygon,
  geometryCollection
}

extension GeoJSONTypeShortString on GeoJsonType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
