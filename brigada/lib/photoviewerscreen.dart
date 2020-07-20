
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotoViewerScreen extends StatefulWidget {

  final imgPath, requestID;

  const PhotoViewerScreen({Key key, this.imgPath, this.requestID}) : super(key: key);
  @override
  _PhotoViewerScreenState createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(txtTitle: "Request Photo"),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(widget.imgPath),
              fit: BoxFit.cover
              
            )
          ),
        ),
      ),
    );
  }
}