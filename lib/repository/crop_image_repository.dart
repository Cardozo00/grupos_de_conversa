import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CropImageRepository {
  cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    croppedFile != null ? XFile(croppedFile.path) : null;
  }

  Future<void> salvarFoto(ImageSource source, String nomeSala) async {
    var db = FirebaseFirestore.instance;
    XFile? photo;
    final ImagePicker _image = ImagePicker();
    photo = await _image.pickImage(source: source);
    if (photo != null) {
      cropImage(photo);
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('uploads/${DateTime.now().millisecondsSinceEpoch}.png');
      await storageRef.putFile(File(photo.path));
      String downloadUrl = await storageRef.getDownloadURL();
      await db
          .collection('chats')
          .doc(nomeSala)
          .update({'imagem_grupo': downloadUrl});
    }
  }
}
