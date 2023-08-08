
import 'package:e_commerce_app/models/users_model.dart';
import 'package:e_commerce_app/services/auth_services.dart';
import 'package:e_commerce_app/view_model/register/mail_verification_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../myapp.dart';
import '../utils/constants/constant_color.dart';
import '../utils/show_snackbar.dart';

class AuthenticateViewModel with ChangeNotifier {
  AuthService authService = AuthService();

  final loginFormFiledKey = GlobalKey<FormState>(debugLabel: 'loginUp');
  final TextEditingController logEmailCtrl = TextEditingController();
  final TextEditingController logPasswordCtrl = TextEditingController();
  bool _passToggle = true;

  bool get passToggle => _passToggle;

  setLogPassToggle() {
    _passToggle = !_passToggle;
    notifyListeners();
  }

  UsersModel? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    } else {
      return UsersModel(id: user.uid, email: user.email);
    }
  }

  Stream<UsersModel?>? get user {
    return authService.firebase.userChanges().map(_userFromFirebase);
  }

  Future/*<UsersModel>*/ signInWithEmailAndPassword(UsersModel usersModel,BuildContext context) async {
      showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.transparent,
          builder: (context) => ColorFiltered(
            colorFilter: const ColorFilter.mode(
              AppColor.kMainColor,
              BlendMode.srcIn,
            ),
            child: Lottie.asset(
              'assets/lottie_files/loading_icon.json',
              width: 15.h,
              height: 15.h,
            ),
          ));


    try {
      final credential = await authService.firebase.signInWithEmailAndPassword(
        email: usersModel.email!,
        password: usersModel.password!,
      );
      return _userFromFirebase(credential.user!)!;
    } on auth.FirebaseAuthException catch (e) {
      print(e);
      ShowSnackBar.shSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    //return _userFromFirebase(credential.user!)!;
  }

  Future<void> signOut() async {
    await authService.firebase.signOut();
  }

  //// Sign in With Google Gmail -----------------------------------------------
  GoogleSignInAccount? _gUser;

  GoogleSignInAccount? get gUser => _gUser;

  Future signInWithGoogle() async {
    final googleUser = await authService.googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }
    _gUser = googleUser;
    notifyListeners();
  }

  Future signOutGoogle() async {
    await authService.googleSignIn.signOut();
    _gUser = null;
    notifyListeners();
  }
}