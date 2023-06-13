// import 'package:bldrs_theme/bldrs_theme.dart';
// import 'package:filers/filers.dart';
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:layouts/layouts.dart';
// import 'package:talktohumanity/packages/lib/b_official_authing.dart';
//
// class FireAutherScreen extends StatelessWidget {
//
//   const FireAutherScreen({
//     Key key
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BasicLayout(
//       backgroundColor: Colorz.white255,
//       body: SignInScreen(
//         // key: ,
//         // loginViewKey: ,
//         // providers: [],
//         actions: <FirebaseUIAction>[
//
//           AuthStateChangeAction((_, AuthState state){
//             blog('AuthStateChangeAction : state : $state');
//           }),
//
//           SignedOutAction((_){
//             blog('SignedOutAction : ');
//             }),
//
//           AuthCancelledAction((_){
//             blog('AuthCancelledAction : ');
//           }),
//
//           EmailLinkSignInAction((_){
//             blog('EmailLinkSignInAction : ');
//           }),
//
//           // VerifyPhoneAction((_, AuthAction authAction){
//           //   blog('VerifyPhoneAction : authAction : $authAction');
//           // }),
//           // SMSCodeRequestedAction((_, AuthAction action, Object obj, String text){}),
//
//           EmailVerifiedAction((){
//             blog('EmailVerifiedAction : ');
//           }),
//
//           ForgotPasswordAction((_, String text){
//             blog('ForgotPasswordAction : text : $text');
//           }),
//
//         ],
//
//         auth: Authing.getFirebaseAuth(),
//         // breakpoint: 800,
//         desktopLayoutDirection: TextDirection.ltr,
//         email: 'bojo@gmail.com',
//         footerBuilder: (_, AuthAction action){
//           return Container(
//             width: 20,
//             height: 20,
//             color: Colorz.red255,
//           );
//           },
//
//         /// HEADER
//         headerMaxExtent: 50, // header max height
//         headerBuilder: (_, BoxConstraints constraints, double size){
//             return Container(
//               width: 30,
//               height: 50,
//               color: Colorz.yellow255,
//             );
//           },
//
//         sideBuilder: (_, BoxConstraints constraints){
//             return Container(
//               width: 10,
//               height: 10,
//               color: Colorz.black255,
//             );
//           },
//           // oauthButtonVariant: OAuthButtonVariant.icon_and_text,
//           // resizeToAvoidBottomInset: true,
//           showAuthActionSwitch: true,
//           subtitleBuilder: (_, AuthAction action){
//             return Container(
//               width: 5,
//               height: 5,
//               color: Colorz.green255,
//             );
//           },
//           // styles: {
//             // FirebaseUIStyle(),
//           // },
//           ),
//     );
//   }
// }
