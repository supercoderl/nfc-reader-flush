import 'package:flutter/material.dart';

enum CircleImageType { network, asset }

class CircleImage extends StatefulWidget {
  final double width;
  final double height;
  final String path;
  final CircleImageType type; // network, asset

  const CircleImage(
      {super.key,
      required this.width,
      required this.height,
      required this.path,
      required this.type});

  @override
  State<CircleImage> createState() {
    return CircleImageState();
  }
}

class CircleImageState extends State<CircleImage> {
  @override
  Widget build(BuildContext context) {
    Image img;
    if (widget.type == CircleImageType.network) {
      img = Image.network(widget.path,
          width: widget.width, height: widget.height);
    } else {
      img =
          Image.asset(widget.path, width: widget.width, height: widget.height);
    }
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
        image: DecorationImage(image: img.image, fit: BoxFit.cover),
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
      ),
    );
  }
}
