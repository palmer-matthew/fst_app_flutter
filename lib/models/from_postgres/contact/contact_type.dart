/// The different types of [Contact]s.
/// 
/// A [Contact] can be an [emergency] contact, 
/// an [office], [facultyStaff], or faculty wide or uncategorized as [other].
enum ContactType { emergency, office, facultyStaff, other }

/// Extra methods attached to [ContactType]. 
extension ContactTypeShortString on ContactType {
  /// The default toString for enums creates a string in the format EnumName.value. 
  /// This method creates a string with the value only.
  String toShortString() {
    return this.toString().split('.').last;
  }
}
