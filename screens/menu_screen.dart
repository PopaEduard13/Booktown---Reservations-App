import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/place_widget.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuScreen extends StatefulWidget {
  static const routeName = '/MenuScreen';

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  AnimationController _animationController;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);

    // Start the animation after a delay
    Future.delayed(Duration(seconds: 2), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as MenuArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meniu",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('places')
              .doc("Categories")
              .collection(args.category)
              .doc(args.place)
              .snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting ||
                !streamSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final document = streamSnapshot.data;
            return Stack(
              children: [
                PhotoViewGallery.builder(
                  pageController: _pageController,
                  itemCount:
                      document['menu'].length, // numărul de imagini din galerie
                  builder: (context, i) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(document['menu'][i]),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered,
                    );
                  },
                ),
                Positioned(
                  top: 50,
                  // bottom: 50,
                  left: MediaQuery.of(context).size.width / 2 - 150,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      "Swipe pentru a vedea pagina urmatoare  ->",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class MenuArguments {
  final String place;
  final String category;

  MenuArguments(this.place, this.category);
}
