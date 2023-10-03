import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageSelectionScreen extends StatefulWidget {
  @override
  _ImageSelectionScreenState createState() => _ImageSelectionScreenState();
}

class _ImageSelectionScreenState extends State<ImageSelectionScreen> {
  List<AssetEntity>? selectedImages;
  int? selectedIndex; // Index of the initially selected image

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!mounted) {
      return;
    }
    if (!ps.hasAccess) {
      return;
    }

    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
    );

    if (!mounted) {
      return;
    }

    if (paths.isEmpty) {
      return;
    }

    final AssetPathEntity recentAlbum = paths.firstWhere(
          (album) => album.isAll,
      orElse: () => paths.first,
    );

    final List<AssetEntity> entities = await recentAlbum.getAssetListPaged(
      page: 0,
      size: 50, // Adjust the number of images to load per page
    );

    if (!mounted) {
      return;
    }

    setState(() {
      selectedImages = entities;
      selectedIndex = 0; // Select the first image by default
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Selection'),
      ),
      body: Column(
        children: [
          Expanded(
            child: selectedImages != null && selectedImages!.isNotEmpty
                ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Adjust the number of images per row
              ),
              itemCount: selectedImages!.length,
              itemBuilder: (context, index) {
                final AssetEntity entity = selectedImages![index];
                return GestureDetector(
                  onTap: () {
                    // Handle image selection here
                    setState(() {
                      selectedIndex = index;
                    });
                    print('Selected image path: ${entity.file}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: index == selectedIndex
                          ? Border.all(
                        color: Colors.blue,
                        width: 2.0,
                      )
                          : null,
                    ),
                    child: FutureBuilder<File?>(
                      future: entity.file,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          final file = snapshot.data!;
                          return Image.file(
                            file,
                            key: ValueKey<int>(index),
                            fit: BoxFit.cover,
                          );
                        } else {
                          // Handle the loading state or any potential errors here
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                );
              },
            )
                : Center(
              child: Text('No images found.'),
            ),
          ),
        ],
      ),
    );
  }
}
