import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {

  final screenHeight;

  const HomeBackground({Key key, this.screenHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomShapeClipper(),
         child: Container(
        height: screenHeight * 0.5,
        color: Colors.deepOrange,
      ),
      
    );
  }
}

class BottomShapeClipper extends CustomClipper<Path>{
  @override
 Path getClip(Size size) {
    Path path = Path();
    Offset curveStartPoint = Offset(0, size.height * 0.40);
    Offset curveEndPoint = Offset(size.width, size.height * 0.90);
    path.lineTo(curveStartPoint.dx, curveStartPoint.dy);
    path.quadraticBezierTo(size.width/2, size.height, curveEndPoint.dx, curveEndPoint.dy);
    path.lineTo(size.width, 0);
    return path;

}

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}