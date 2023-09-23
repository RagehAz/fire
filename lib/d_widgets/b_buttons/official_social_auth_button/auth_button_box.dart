part of super_fire;
/// SOCIAL_AUTHING_DISASTER
class AuthButtonBox extends StatelessWidget {
  // --------------------------------------------------------------------------
  const AuthButtonBox({
    this.child,
    this.size = 50,
    super.key,
  });
  // --------------------
  final Widget? child;
  final double size;
  // --------------------------------------------------------------------------
  static const corners = 19 / 3; /// mimics the corners of sign in buttons, do not change this
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[

        Container(
          width: size,
          height: size+10,
          /// NOTE : SOCIAL BUTTONS FROM FIRE UI PACKAGE ALREADY INCLUDE
          /// EdgeInsets.symmetric(horizontal: 5)
          /// so you can not have SocialAuthButton without margins
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: child,
        ),

        IgnorePointer(
          child: SuperBox(
            width: size,//width,
            height: size,
            // color: Colorz.bloodTest,
            // margins: EdgeInsets.symmetric(vertical: 0),
            corners: corners,
          ),
        ),

      ],
    );


  }
  // --------------------------------------------------------------------------
}
