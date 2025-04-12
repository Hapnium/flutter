import 'package:connectify/connectify.dart';

/// A data model that represents the response from an authentication API.
/// The `AuthResponse` class contains details about the authenticated user,
/// including their session, profile, and role information.
///
/// This class helps manage user data like session tokens, user roles,
/// personal information (first and last name), and security details such as
/// multi-factor authentication (MFA) and recovery codes.
class AuthResponse {
  /// Constructs an [AuthResponse] object with the provided parameters.
  ///
  /// The [id] is a unique identifier for the user, [role] indicates their
  /// role in the system, [session] stores the session information,
  /// [firstName] and [lastName] represent the user's name, [hasMfa] checks if
  /// MFA is enabled, and [image], [category], [avatar], and [rating] provide
  /// additional user information.
  AuthResponse({
    required this.id,
    required this.role,
    required this.session,
    required this.firstName,
    required this.hasMfa,
    required this.category,
    required this.image,
    required this.hasRecoveryCodes,
    required this.lastName,
    required this.rating,
    required this.avatar,
  });

  /// Unique identifier for the user.
  final String id;

  /// The user's role within the application, such as "PROVIDER" or "ASSOCIATE_PROVIDER".
  final String role;

  /// Contains the session data (access and refresh tokens) for the user.
  final SessionResponse session;

  /// The first name of the user.
  final String firstName;

  /// Indicates if the user has multi-factor authentication (MFA) enabled.
  final bool hasMfa;

  /// URL to the user's profile image.
  final String image;

  /// Category associated with the user (for example, a user type).
  final String category;

  /// Indicates if the user has set up recovery codes for account recovery.
  final bool hasRecoveryCodes;

  /// The last name of the user.
  final String lastName;

  /// The user's rating (typically on a scale from 0 to 5).
  final double rating;

  /// URL to the user's avatar.
  final String avatar;

  /// Creates a new [AuthResponse] object by copying the existing fields and
  /// allowing some fields to be updated.
  ///
  /// For example, you can update the user's [role] while keeping all other
  /// fields the same:
  /// ```dart
  /// AuthResponse updatedResponse = authResponse.copyWith(role: "NEW_ROLE");
  /// ```
  AuthResponse copyWith({
    String? id,
    String? role,
    SessionResponse? session,
    String? firstName,
    bool? hasMfa,
    bool? hasRecoveryCodes,
    String? category,
    String? image,
    String? lastName,
    double? rating,
    String? avatar,
  }) {
    return AuthResponse(
      id: id ?? this.id,
      role: role ?? this.role,
      session: session ?? this.session,
      firstName: firstName ?? this.firstName,
      hasMfa: hasMfa ?? this.hasMfa,
      image: image ?? this.image,
      category: category ?? this.category,
      lastName: lastName ?? this.lastName,
      rating: rating ?? this.rating,
      avatar: avatar ?? this.avatar,
      hasRecoveryCodes: hasRecoveryCodes ?? this.hasRecoveryCodes,
    );
  }

  /// A factory constructor that returns an empty [AuthResponse] with default
  /// values. This can be useful for initializing a placeholder or default state.
  ///
  /// Example:
  /// ```dart
  /// AuthResponse emptyUser = AuthResponse.empty();
  /// ```
  factory AuthResponse.empty() {
    return AuthResponse(
      id: "",
      role: "",
      session: SessionResponse.empty(),
      firstName: "",
      hasMfa: false,
      image: "",
      category: "",
      hasRecoveryCodes: false,
      lastName: "",
      rating: 5.0,
      avatar: "",
    );
  }

  /// A factory constructor that creates an [AuthResponse] object from a
  /// JSON map, typically received from an API response.
  ///
  /// If any fields are missing in the JSON, default values are used.
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      id: json["id"] ?? "",
      role: json["role"] ?? "",
      session: json["session"] == null
          ? SessionResponse.empty()
          : SessionResponse.fromJson(json["session"]),
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      hasMfa: json["has_mfa"] ?? false,
      image: json["image"] ?? "",
      category: json["category"] ?? "",
      avatar: json["avatar"] ?? "",
      rating: json["rating"] ?? 5.0,
      hasRecoveryCodes: json["has_recovery_codes"] ?? false,
    );
  }

  /// Converts the current [AuthResponse] object into a JSON map that can
  /// be serialized, typically for sending data to an API.
  ///
  /// This method serializes all the fields in the class to JSON.
  Map<String, dynamic> toJson() => {
    "id": id,
    "role": role,
    "session": session.toJson(),
    "first_name": firstName,
    "last_name": lastName,
    "has_mfa": hasMfa,
    "category": category,
    "avatar": avatar,
    "image": image,
    "rating": rating,
    "has_recovery_codes": hasRecoveryCodes,
  };

  /// Returns the full name of the user by combining the first and last names.
  String get name => "$firstName $lastName";

  /// Checks if the user is a provider. This method checks if the user's role
  /// is equal to "PROVIDER".
  ///
  /// Example:
  /// ```dart
  /// bool isProvider = authResponse.isProvider;
  /// ```
  bool get isProvider => role == "PROVIDER";

  /// Checks if the user is an associate provider. This method checks if the user's role
  /// is equal to "ASSOCIATE_PROVIDER".
  ///
  /// Example:
  /// ```dart
  /// bool isAssociate = authResponse.isAssociate;
  /// ```
  bool get isAssociate => role == "ASSOCIATE_PROVIDER";
}