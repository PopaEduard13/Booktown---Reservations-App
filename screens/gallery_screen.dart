import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryScreen extends StatefulWidget {
  static const routeName = '/GalleryScreen';

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    final placeId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          "Galerie Foto",
          style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('places')
            .doc('$placeId')
            .snapshots(),
        builder: (BuildContext context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting ||
              !streamSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final document = streamSnapshot.data;
          return PhotoViewGallery.builder(
            itemCount: document.get('gallery').length,
            builder: (ctx, i) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(document.get('gallery')[i]),
              );
            },
          );
        },
      ),
    );
  }
}
