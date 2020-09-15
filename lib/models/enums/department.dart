import 'package:flutter/material.dart';
import 'package:fst_app_flutter/global_const.dart';

/// The Faculty of Science and Technology departments and sections.
///
/// [biochem] = Biochemistry section
///
/// [chem]    = Chemistry department
///
/// [comp]    = Computing Department
///
/// [geo]     = Geography and Geology department
///
/// [life]    = Life Sciences department
///
/// [math]    = Mathematics department
///
/// [phys]    = Physics department
///
/// [other]   = Faculty wide or a doesn't fall under any of the other departments
enum Department { biochem, chem, comp, geo, life, math, phys, other }

/// Extra methods attached to the [Department] enum
extension DepartmentExt on Department {
  /// The default toString for enums creates a string in the format EnumName.value. 
  /// This method creates a string with the value only.
  String toShortString() {
    return this.toString().split('.').last;
  }

  /// Returns the theme colour for this [Department].
  /// See global_const.dart for the colours.
  Color get departmentColour {
    switch (this) {
      case Department.biochem:
        return biochemColour;
        break;
      case Department.chem:
        return chemColour;
        break;
      case Department.comp:
        return compColour;
        break;
      case Department.geo:
        return geoColour;
        break;
      case Department.life:
        return lifeSciColour;
        break;
      case Department.math:
        return mathColour;
        break;
      case Department.phys:
        return physColour;
        break;
      case Department.other:
        return Colors.grey;
        break;
      default:
        return Colors.grey;
        break;
    }
  }
}
