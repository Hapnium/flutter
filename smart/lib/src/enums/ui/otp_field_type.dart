/// This specifies the kind of ui to be displayed in the `OtpField`.
/// 
/// The three major values cannot be chosen at the same time.
enum OtpFieldType {
  /// Creates an `OtpField` with box design with a transparent color fill
  box,

  /// Creates an `OtpField` where the box is filled with a color
  filled,

  /// Creates an `OtpField` designed with a bottom dash liner.
  bottom
}