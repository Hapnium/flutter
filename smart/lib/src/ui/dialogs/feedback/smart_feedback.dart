// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:smart/smart.dart';

// part 'smart_feedback_state.dart';

// class SmartFeedback<T> extends StatefulWidget {
//   final FeedbackType type;
//   final String id;
//   final String info;
//   final T data;
//   final RatingSuccessCallback? onSuccess;
//   final VoidCallback? onError;

//   const SmartFeedback({
//     super.key,
//     required this.type,
//     required this.id,
//     required this.info,
//     required this.data,
//     this.onSuccess,
//     this.onError,
//   });

//   String get param {
//     if(id.isNotEmpty) {
//       return "type=${FeedbackType.community.name}&id=$id";
//     } else {
//       return "type=${FeedbackType.community.name}";
//     }
//   }

//   @override
//   State<SmartFeedback<T>> createState() => _SmartFeedbackState<T>();

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     properties.add(EnumProperty<FeedbackType>('type', type));
//     properties.add(StringProperty('id', id));
//     properties.add(StringProperty('info', info));
//     properties.add(DiagnosticsProperty<T?>('data', data));
//     properties.add(DiagnosticsProperty<RatingSuccessCallback?>('onSuccess', onSuccess));
//     super.debugFillProperties(properties);
//   }
// }