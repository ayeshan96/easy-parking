import 'package:flutter/material.dart';

class welcomeImageAsset extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AssetImage assetImage=AssetImage('images/welcomeimage.jpg');
    Image image=Image(image: assetImage,);
    return Container(child: image,);
  }

}