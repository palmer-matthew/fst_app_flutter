import 'package:fst_app_flutter/models/enums/department.dart';
import 'package:fst_app_flutter/models/from_postgres/contact/contact_type.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geo_json_type.dart';


/// Takes a string and returns the appropriate [Department].
Department stringToDepartment(str) {
  switch (str) {
    case 'BIOCHEM':
      return Department.biochem;
      break;
    case 'CHEM':
      return Department.chem;
      break;
    case 'COMP':
      return Department.comp;
      break;
    case 'GEO':
      return Department.geo;
      break;
    case 'LIFE':
      return Department.life;
      break;
    case 'MATH':
      return Department.math;
      break;
    case 'PHYS':
      return Department.phys;
      break;
    default:
      return Department.other;
      break;
  }
}

/// Takes a string and returns the appropriate [ContactType].
ContactType stringToContactType(str) {
  switch (str) {
    case 'EMERGENCY':
      return ContactType.emergency;
      break;
    case 'OFFICE':
      return ContactType.office;
      break;
    case 'FACULTY_STAFF':
      return ContactType.facultyStaff;
      break;
    default:
      return ContactType.other;
      break;
  }
}

/// Takes a string and returns the appropriate [GeoJsonGeometryType].
GeoJsonType stringToGeometryType(str) {
  switch (str) {
    case "GeometryCollection":
      return GeoJsonType.geometryCollection;
      break;
    case "LineString":
      return GeoJsonType.lineString;
      break;
    case 'MultiLineString':
      return GeoJsonType.multiLineString;
      break;
    case 'MultiPoint':
      return GeoJsonType.multiPoint;
      break;
    case 'MultiPolygon':
      return GeoJsonType.multiPolygon;
      break;
    case 'Polygon':
      return GeoJsonType.polygon;
      break;
    default:
      return GeoJsonType.point;
      break;
  }
}
