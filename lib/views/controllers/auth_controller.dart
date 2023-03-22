import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_app/constants.dart';
import 'package:tiktok_app/models/user_model.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<File?> _profilePic;

  void pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      _profilePic = Rx<File?>(File(image.path));
    }
  }

  // sign up new user
  void signUp(
    String username,
    String email,
    String password,
  ) async {
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        final userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String profilePicUrl = '';
        if (_profilePic.value != null) {
          profilePicUrl = await _uploadToStorage(_profilePic.value!);
        }

        final user = UserModel(
          uid: userCredential.user!.uid,
          username: username,
          profilePic: profilePicUrl,
          email: email,
        );

        await firestore
            .collection(UserModel.keyCollection)
            .doc(user.uid)
            .set(user.toJson());
      } else {
        Get.snackbar(
          'Error creating account',
          'Please fill all fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error creating account',
        e.toString(),
      );
    }
  }

  void signIn(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        log('Login Success');
      } else {
        Get.snackbar(
          'Error creating account',
          'Please fill all fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error creating account',
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
