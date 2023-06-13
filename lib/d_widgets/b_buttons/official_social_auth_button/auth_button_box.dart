part of super_fire;

class _AuthButtonBox extends StatelessWidget {
  // --------------------------------------------------------------------------
  const _AuthButtonBox({
    this.child,
    this.size,
    Key key
  }) : super(key: key);
  // --------------------
  final Widget child;
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
          height: size,
          /// NOTE : SOCIAL BUTTONS FROM FIRE UI PACKAGE ALREADY INCLUDE
          /// EdgeInsets.symmetric(horizontal: 5)
          /// so you can not have SocialAuthButton without margins
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: child,
        ),

        IgnorePointer(
          child: SuperBox(
            width: size - 8,//width,
            height: size - 10,
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
