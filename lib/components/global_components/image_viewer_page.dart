import 'package:flutter/material.dart';

class ImageViewerPage extends StatefulWidget {

  final String imageName;
  final String imageUrl;
  const ImageViewerPage({super.key, required this.imageName, required this.imageUrl});

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.imageName),),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 7,
                child: Image.network(widget.imageUrl)
                ),
            ),
          ],
        )
      ),
    );
  }
}