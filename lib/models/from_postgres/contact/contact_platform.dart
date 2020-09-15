/// The platforms that a [_Phonenumber] may be available on.
/// Either the number is available for [textCall] or [whatsapp].
enum ContactPlatform { textCall, whatsapp }

/// Extra methods attached to [ContactPlatform].
extension PlatformShortString on ContactPlatform {
  /// The default toString for enums creates a string in the format EnumName.value.
  /// This method creates a string with the value only.
  String toShortString() {
    return this.toString().split('.').last;
  }
}
