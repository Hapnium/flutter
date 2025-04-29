// /// Enables the user to customize the intended pop behavior
// ///
// /// Goes to either the previous _activePages entry or the previous page entry
// ///
// /// e.g. if the user navigates to these pages
// /// 1) /home
// /// 2) /home/products/1234
// ///
// /// when popping on [History] mode, it will emulate a browser back button.
// ///
// /// so the new _activePages stack will be:
// /// 1) /home
// ///
// /// when popping on [Page] mode, it will only remove the last part of the route
// /// so the new _activePages stack will be:
// /// 1) /home
// /// 2) /home/products
// ///
// /// another pop will change the _activePages stack to:
// /// 1) /home
// enum PopMode {
//   history,
//   page,
// }
//
// /// Enables the user to customize the behavior when pushing multiple routes that
// /// shouldn't be duplicates
// enum PreventDuplicateHandlingMode {
//   /// Removes the _activePages entries until it reaches the old route
//   popUntilOriginalRoute,
//
//   /// Simply don't push the new route
//   doNothing,
//
//   /// Recommended - Moves the old route entry to the front
//   ///
//   /// With this mode, you guarantee there will be only one
//   /// route entry for each location
//   reorderRoutes,
//
//   recreate,
// }