part of super_fire;

/// => NEVER USED
// class OfficialRealStream {
//   // -----------------------------------------------------------------------------
//
//   const OfficialRealStream();
//
//   // -----------------------------------------------------------------------------
//
//   /// STREAMING
//
//   // --------------------
//   ///
//   static StreamSubscription streamOnChildAddedToPath({
//     required String path,
//     required ValueChanged<dynamic> onChildAdded,
//     bool cancelOnError,
//     Function onDone,
//     Function(Object error) onError,
//   }){
//     final f_db.DatabaseReference _ref = OfficialReal._getRefByPath(path: path);
//
//     final StreamSubscription _sub = _ref.onChildAdded.listen((f_db.DatabaseEvent event) {
//       final dynamic _data = event.snapshot.value;
//       onChildAdded(_data);
//     },
//       cancelOnError: cancelOnError,
//       onDone: onDone,
//       onError: onError,
//     );
//
//     return _sub;
//   }
//   // --------------------
//   ///
//   static StreamSubscription streamOnChildChangedInPath({
//     required String path,
//     required ValueChanged<dynamic> onChildChanged,
//     bool cancelOnError,
//     Function onDone,
//     Function(Object error) onError,
//   }){
//     final f_db.DatabaseReference _ref = OfficialReal._getRefByPath(path: path);
//
//     final StreamSubscription _sub = _ref.onChildChanged.listen((f_db.DatabaseEvent event) {
//       final dynamic _data = event.snapshot.value;
//       onChildChanged(_data);
//     },
//       cancelOnError: cancelOnError,
//       onDone: onDone,
//       onError: onError,
//     );
//
//     return _sub;
//   }
//   // --------------------
//   ///
//   static StreamSubscription streamOnChildMovedInPath({
//     required String path,
//     required ValueChanged<dynamic> onChildMoved,
//     bool cancelOnError,
//     Function onDone,
//     Function(Object error) onError,
//   }){
//     final f_db.DatabaseReference _ref = OfficialReal._getRefByPath(path: path);
//
//     final StreamSubscription _sub = _ref.onChildMoved.listen((f_db.DatabaseEvent event) {
//       final dynamic _data = event.snapshot.value;
//       onChildMoved(_data);
//     },
//       cancelOnError: cancelOnError,
//       onDone: onDone,
//       onError: onError,
//     );
//
//     return _sub;
//   }
//   // --------------------
//   ///
//   static StreamSubscription streamOnChildRemovedFromPath({
//     required String path,
//     required ValueChanged<dynamic> onChildRemoved,
//     bool cancelOnError,
//     Function onDone,
//     Function(Object error) onError,
//   }){
//     final f_db.DatabaseReference _ref = OfficialReal._getRefByPath(path: path);
//
//     final StreamSubscription _sub = _ref.onChildRemoved.listen((f_db.DatabaseEvent event) {
//       final dynamic _data = event.snapshot.value;
//       onChildRemoved(_data);
//     },
//       cancelOnError: cancelOnError,
//       onDone: onDone,
//       onError: onError,
//     );
//
//     return _sub;
//   }
//   // --------------------
//   ///
//   static StreamSubscription streamOnValueOfPath({
//     required String path,
//     required ValueChanged<dynamic> onValue,
//     bool cancelOnError,
//     Function onDone,
//     Function(Object error) onError,
//   }){
//     final f_db.DatabaseReference _ref = OfficialReal._getRefByPath(path: path);
//
//     final StreamSubscription _sub = _ref.onValue.listen((f_db.DatabaseEvent event) {
//       final dynamic _data = event.snapshot.value;
//       onValue(_data);
//     },
//       cancelOnError: cancelOnError,
//       onDone: onDone,
//       onError: onError,
//     );
//
//     return _sub;
//   }
//   // -----------------------------------------------------------------------------
// }
