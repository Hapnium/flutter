// part of 'smart_feedback.dart';

// class _SmartFeedbackState<T> extends State<SmartFeedback<T>> {
//   final TextEditingController _commentController = TextEditingController();
//   final ConnectService _connect = Connect();

//   double _rating = 0.0;
//   bool _isSending = false;
//   bool _showComment = true;
//   List<String> _selectedComments = [];

//   @protected
//   FeedbackType get type => widget.type;

//   @protected
//   T get data => widget.data;

//   @protected
//   String get id => widget.id;

//   @protected
//   String get info => widget.info;

//   @protected
//   RatingSuccessCallback get onSuccess => widget.onSuccess ?? (comment, rating) {
//     console.log("Success: $comment, $rating", from: "[SMART FEEDBACK ::: ${type.name.toUpperCase()}]");
//   };

//   @protected
//   VoidCallback get onError => widget.onError ?? () {
//     console.log("Error just occurred", from: "[SMART FEEDBACK ::: ${type.name.toUpperCase()}]");
//   };

//   @protected
//   List<String> get comments => type.isTrip ? [
//     "Respectful during the trip",
//     "Followed safety guidelines",
//     "Good communication throughout",
//     "Punctual arrival",
//     "Helpful with directions",
//     "Cooperative and easy-going",
//     "Provided accurate information",
//     "Could improve time management",
//     "Friendly and polite",
//     "Rescheduled without much notice"
//   ] : [
//     "Awesome user experience",
//     "Easy to navigate and use",
//     "Fast and reliable",
//     "Occasionally crashes",
//     "Useful features, but some bugs need fixing",
//     "Great design but could be more intuitive"
//   ];

//   @protected
//   bool get showComments => type.isApp && _showComment;

//   @protected
//   String get buttonText => (type.isAccount || type.isShop) ? "Report" : "Send feedback";

//   @protected
//   String get title => (type.isAccount || type.isShop)
//       ? "Report $info"
//       : type.isTrip ? "Rate trip"
//       : type.isApp ? "How do you like this app?"
//       : "Your feedback matters";

//   @protected
//   int get commentLength => 20;

//   @protected
//   bool get hideField => _selectedComments.isNotEmpty && (type.isTrip || type.isApp);

//   @protected
//   bool get showRatingBar => type.isTrip || type.isApp;

//   @protected
//   String get comment => _selectedComments.isNotEmpty ? _selectedComments.join(", ") : _commentController.text.trim();

//   @override
//   void initState() {
//     _commentController.addListener(() {
//       setState(() {
//         _showComment = _commentController.text.isNotEmpty;
//       });
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _commentController.dispose();

//     super.dispose();
//   }

//   @override
//   void didUpdateWidget(covariant SmartFeedback oldWidget) {
//     if(oldWidget.type.notEquals(widget.type)
//         || oldWidget.id.notEquals(widget.id)
//         || oldWidget.info.notEquals(widget.info)
//         || oldWidget.activityResponse.notEquals(widget.activityResponse)
//         || oldWidget.clubResponse.notEquals(widget.clubResponse)
//         || oldWidget.communityResponse.notEquals(widget.communityResponse)
//         || oldWidget.onSuccess.notEquals(widget.onSuccess)
//         || oldWidget.onError.notEquals(widget.onError)
//     ) {
//       setState(() {});
//     }

//     super.didUpdateWidget(oldWidget);
//   }

//   void _updateRating(double value) => setState(() => _rating = value);

//   void _pickComment(String comment) {
//     List<String> comments = List.from(_selectedComments);
//     comments.contains(comment) ? comments.remove(comment) : comments.add(comment);

//     setState(() {
//       _selectedComments = comments;
//     });
//   }

//   void _updateSending(bool value) => setState(() => _isSending = value);

//   void _sendFeedback() async {
//     if(type.isApp) {
//       _updateSending(true);
//       JsonMap payload = {
//         "rating": _rating,
//         "comment": comment
//       };

//       Outcome response = await _connect.post(endpoint: "/rating/rate/app", body: payload);
//       _updateSending(false);

//       if(response.isOk) {
//         // AppRating rating = AppRating.fromJson(response.data);
//         // Database.instance.saveAppRating(rating);

//         onSuccess(comment, _rating);
//       } else {
//         onError();
//       }

//       return;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ModalBottomSheet(
//       useSafeArea: (config) => config.copyWith(top: true),
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       borderRadius: type.isTrip ? BorderRadius.zero : null,
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GoBack(icon: Icons.arrow_back, color: Theme.of(context).primaryColor),
//             Spacing.vertical(20),
//             TextBuilder(
//               text: title,
//               color: Theme.of(context).primaryColor,
//               size: Sizing.font(22),
//               weight: FontWeight.bold,
//             ),
//             TextBuilder(
//               text: "Always remember to say your mind!",
//               color: Theme.of(context).primaryColor,
//               size: Sizing.font(14),
//             ),
//             Spacing.vertical(30),
//             Column(
//               spacing: 10,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if(showRatingBar) ...[
//                   Center(
//                     child: RatingBar.builder(
//                       allowHalfRating: true,
//                       itemCount: 5,
//                       itemPadding: EdgeInsets.symmetric(horizontal: Sizing.space(4)),
//                       itemBuilder: (context, _) => Icon(
//                         Icons.star,
//                         color: Theme.of(context).primaryColorLight,
//                       ),
//                       onRatingUpdate: _updateRating,
//                     ),
//                   )
//                 ],
//                 if(showComments) ...[
//                   SearchFilter<String>.short(
//                     list: comments.map((String comment) => ButtonView(header: comment, index: comments.indexOf(comment))).toList(),
//                     selectedList: _selectedComments,
//                     onSelect: (view) => _pickComment(view.header),
//                   )
//                 ],
//                 if(hideField.isFalse) ...[
//                   Field(
//                     hint: "Let us know what you're thinking",
//                     replaceHintWithLabel: false,
//                     inputConfigBuilder: (config) => config.copyWith(
//                       labelColor: Theme.of(context).primaryColor,
//                       labelSize: 14
//                     ),
//                     inputDecorationBuilder: (dec) => dec.copyWith(
//                       enabledBorderSide: BorderSide(color: CommonColors.instance.hint),
//                       focusedBorderSide: BorderSide(color: Theme.of(context).primaryColor),
//                     ),
//                     onTapOutside: (activity) => CommonUtility.unfocus(context),
//                     controller: _commentController,
//                   )
//                 ],
//                 InteractiveButton(
//                   text: buttonText,
//                   borderRadius: 24,
//                   width: MediaQuery.sizeOf(context).width,
//                   textSize: Sizing.font(14),
//                   buttonColor: CommonColors.instance.color,
//                   textColor: CommonColors.instance.lightTheme,
//                   onClick: _sendFeedback,
//                   loading: _isSending
//                 ),
//               ],
//             )
//           ],
//         ),
//       )
//     );
//   }
// }