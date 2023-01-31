import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------

/// TRY AND CATCH

// --------------------
/// TESTED : WORKS PERFECT
Future<void> tryAndCatch({
  @required Function functions,
  String invoker,
  ValueChanged<String> onError,
}) async {

  try {
    await functions();
  }

  on Exception catch (error) {

    blog('$invoker : tryAndCatch ERROR : $error');

    if (onError != null) {
      onError(error.toString());
    }

    // throw(error);
  }

}
// --------------------
/// TESTED : WORKS PERFECT
Future<bool> tryCatchAndReturnBool({
  @required Function functions,
  ValueChanged<String> onError,
  String invoker = 'tryCatchAndReturnBool',
}) async {
  /// IF FUNCTIONS SUCCEED RETURN TRUE, IF ERROR CAUGHT RETURNS FALSE
  bool _success = true;

  /// TRY FUNCTIONS
  try {
    await functions();
  }

  /// CATCH EXCEPTION ERROR
  on Exception catch (error) {

    blog('$invoker : tryAndCatch ERROR : $error');

    if (onError != null) {
      onError(error.toString());
    }

    _success = false;
  }

  return _success;
}
// --------------------
/// TESTED : WORKS PERFECT
void blog(dynamic msg, {String invoker}){

  assert((){
    // log(msg.toString());
    // ignore: avoid_print
    print(msg);
    return true;
  }(), '_');

  /// NOUR IDEA
  /*
    extension Printer on dynamic {
      void log() {
        return dev.log(toString());
      }
    }
     */

}
// -----------------------------------------------------------------------------

/// VALUE NOTIFIER SETTER

// --------------------
/// TESTED : WORKS PERFECT
void setNotifier({
  @required ValueNotifier<dynamic> notifier,
  @required bool mounted,
  @required dynamic value,
  bool addPostFrameCallBack = false,
  Function onFinish,
  bool shouldHaveListeners = false,
}){

  if (mounted == true){
    // blog('setNotifier : setting to ${value.toString()}');

    if (notifier != null){

      if (value != notifier.value){

        /// ignore: invalid_use_of_protected_member
        if (shouldHaveListeners == false || notifier.hasListeners == true){

          if (addPostFrameCallBack == true){
            WidgetsBinding.instance.addPostFrameCallback((_){
              notifier.value  = value;
              if(onFinish != null){
                onFinish();
              }
            });
          }

          else {
            notifier.value  = value;
            if(onFinish != null){
              onFinish();
            }
          }

        }

      }

    }

  }

}
// -----------------------------------------------------------------------------
