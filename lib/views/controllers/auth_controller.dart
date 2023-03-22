import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_app/constants.dart';

class AuthController extends GetxController {
  // sign up new user
  void signUp(
    String username,
    String email,
    String password,
    File? image,
  ) async {
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (image != null) {
          _uploadToStorage(image);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error creating accoung',
        e.toString(),
      );
    }
  }

  Future<String> _uploadToStorage(File image) async {
    final ref = firebaseStorage
        .ref()
        .child('profile_pics')
        .child(firebaseAuth.currentUser!.uid);
    final uploadTask = ref.putFile(image);
    final taskSnapshot = await uploadTask;
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
