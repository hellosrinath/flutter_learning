import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AwesomeGallery extends StatefulWidget {
  const AwesomeGallery({super.key});

  @override
  State<AwesomeGallery> createState() => _AwesomeGalleryState();
}

class _AwesomeGalleryState extends State<AwesomeGallery> {
  final storageRef = FirebaseStorage.instance.ref().child("images");
  XFile? pickedImageFile;
  List<String> urlList = [];

  @override
  void initState() {
    super.initState();
    _getAllUploadedFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined),
            SizedBox(width: 8),
            Text("Awesome Gallery"),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              urlList[index],
              width: 200,
              height: 200,
            ),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: urlList.length,
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          _addPhotoToFirebaseStorage();
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Future<void> _addPhotoToFirebaseStorage() async {
    ImagePicker imagePicker = ImagePicker();
    pickedImageFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImageFile != null) {
      final filePath = pickedImageFile!.path;
      if (await File(filePath).exists()) {
        debugPrint('imagePath: $filePath');
        final selectedFile = File(filePath);

        final uploadTask = storageRef
            .child("img-${DateTime.now().millisecondsSinceEpoch}.jpg")
            .putFile(selectedFile);

        uploadTask.snapshotEvents.listen((TaskSnapshot task) {
          switch (task.state) {
            case TaskState.running:
              final progress =
                  100.0 * (task.bytesTransferred / task.totalBytes);
              debugPrint("progress: $progress");
              break;
            case TaskState.paused:
              debugPrint("progress: upload paused");
              break;
            case TaskState.canceled:
              debugPrint("progress: upload cancelled");
              break;
            case TaskState.error:
              debugPrint("progress: upload error");
              break;
            case TaskState.success:
              debugPrint("progress: upload success");
              break;
          }
        });
      }
    }
  }

  Future<void> _getAllUploadedFile() async {
    final listResult = await storageRef.listAll();
    urlList.clear();
    for (var item in listResult.items) {
      // The items under storageRef.
      final url = await item.getDownloadURL();
      urlList.add(url);
      debugPrint("progress: $url");
    }
    setState(() {});
  }
}
