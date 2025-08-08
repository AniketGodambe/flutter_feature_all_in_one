import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feature_all_in_one/view_source_code.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SelecteImageScreen extends StatefulWidget {
  const SelecteImageScreen({super.key});

  @override
  State<SelecteImageScreen> createState() => _SelecteImageScreenState();
}

class _SelecteImageScreenState extends State<SelecteImageScreen> {
  final ImagePicker picker = ImagePicker();

  XFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image Example"),
        actions: [
          ElevatedButton(
            onPressed: () {
              String filePath =
                  'lib/features/select_image/selecte_image_screen.dart';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SourceCodeView(filePath: filePath),
                ),
              );
            },
            child: Text('Source Code'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: selectedImage != null
                    ? Image.file(File(selectedImage!.path), fit: BoxFit.cover)
                    : Center(child: Text("Select Image")),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showImageSourceOptions();
              },
              child: Text("Select Image"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectFromGallery() async {
    var status = await Permission.photos.status;

    if (!status.isGranted) {
      status = await Permission.photos.request();
      if (!status.isGranted) {
        openAppSettings();
        return;
      }
    } else {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage = image;
        setState(() {});
      }
    }
  }

  Future<void> selectFromFiles() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        openAppSettings();
        return;
      }
    }

    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        selectedImage = file;
      });
    }
  }

  Future<void> captureImage() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        openAppSettings();
        return;
      }
    }
    XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        selectedImage = photo;
      });
    }
  }

  void showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pick from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  selectFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.folder_open),
                title: Text('Pick from Files'),
                onTap: () {
                  Navigator.of(context).pop();
                  selectFromFiles();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Capture Image'),
                onTap: () {
                  Navigator.of(context).pop();
                  captureImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
