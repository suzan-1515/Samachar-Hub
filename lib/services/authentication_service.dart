import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');

  AuthenticationService(this._firebaseAuth, this._googleSignIn);

  Future<AuthResult> loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResult> signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
    @required String avatar,
  }) async {
    return await _firebaseAuth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((auth) {
      if (auth != null) {
        return _usersCollectionReference.document(auth.user.uid).setData({
          'id': auth.user.uid,
          'full_name': fullName,
          'email': email,
          'avatar': avatar
        }, merge: true).then((onValue) => auth);
      }
      return auth;
    });
  }

  Future<AuthResult> signInAnonymously() async {
    return (await _firebaseAuth.signInAnonymously());
  }

  Future<AuthResult> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return (await _firebaseAuth.signInWithCredential(credential));
  }

  // Future<AuthResult> _signInWithFacebook() async {
  //   final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   return (await _firebaseAuth.signInWithCredential(credential));
  // }

  // Future<AuthResult> _signInWithTwitter() async {
  //   final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   return (await _firebaseAuth.signInWithCredential(credential));
  // }

  Future<DocumentSnapshot> getUserProfile({@required String uid}) async {
    return await _usersCollectionReference.document(uid).get();
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }

  Future<void> logout() async {
    return await _firebaseAuth.signOut();
  }

  DocumentReference getUserDocumentReference({@required String userId}) =>
      _usersCollectionReference.document(userId);
}
