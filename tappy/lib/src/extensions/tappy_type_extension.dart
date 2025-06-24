import '../enums/tappy_type.dart';

extension TappyTypeX on TappyType {
  /// Whether the notification type is [TappyType.DEFAULT].
  bool get isDefault => this == TappyType.DEFAULT;

  /// Whether the notification type is [TappyType.DEFAULT_CALL].
  bool get isDefaultCall => this == TappyType.DEFAULT_CALL;

  /// Whether the notification type is [TappyType.TRANSACTION].
  bool get isTransaction => this == TappyType.TRANSACTION;

  /// Whether the notification type is [TappyType.TRIP].
  bool get isTrip => this == TappyType.TRIP;

  /// Whether the notification type is [TappyType.NEARBY_BCAP].
  bool get isNearbyBCap => this == TappyType.NEARBY_BCAP;

  /// Whether the notification type is [TappyType.NEARBY_ACTIVITY].
  bool get isNearbyActivity => this == TappyType.NEARBY_ACTIVITY;

  /// Whether the notification type is [TappyType.NEARBY_TREND].
  bool get isNearbyTrend => this == TappyType.NEARBY_TREND;

  /// Whether the notification type is [TappyType.NEARBY_TOURNAMENT].
  bool get isNearbyTournament => this == TappyType.NEARBY_TOURNAMENT;

  /// Whether the notification type is [TappyType.SCHEDULE].
  bool get isSchedule => this == TappyType.SCHEDULE;

  /// Whether the notification type is [TappyType.CHAT].
  bool get isChat => this == TappyType.CHAT;

  /// Whether the notification type is [TappyType.CALL].
  bool get isCall => this == TappyType.CALL;

  /// Whether the notification type is [TappyType.OTHERS].
  bool get isOthers => this == TappyType.OTHERS;

  /// Whether the type is any "nearby" type.
  bool get isNearby => isNearbyBCap || isNearbyActivity || isNearbyTrend || isNearbyTournament;
}