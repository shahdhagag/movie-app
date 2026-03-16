import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String photoUrl,
  });

  Future<AuthUserModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> sendPasswordResetEmail({required String email});

  Future<AuthUserModel?> getCurrentUser();

  Future<void> verifyEmail();

  Future<void> updateUserProfile({
    required String displayName,
    required String? photoUrl,
  });

  Future<AuthUserModel> signInWithGoogle();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final String _googleWebClientId;

  static const String _defaultGoogleWebClientId =
      '370713648945-c5cfi1sa0j62clf5c0mjuq9bp3h95aae.apps.googleusercontent.com';
  static const List<String> _googleAuthScopes = <String>[
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    String googleWebClientId = _defaultGoogleWebClientId,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _googleWebClientId = googleWebClientId,
       _googleSignIn = GoogleSignIn.instance;

  Future<void>? _initFuture;

  Future<void> _ensureInitialized() async {
    _initFuture ??= _googleSignIn.initialize(
      clientId: kIsWeb ? _googleWebClientId : null,
    );
    await _initFuture;
  }

  Future<void> _createUserDocumentIfNew(UserCredential userCredential) async {
    if (userCredential.additionalUserInfo?.isNewUser != true) {
      return;
    }

    final user = userCredential.user;
    if (user == null) {
      return;
    }

    final now = DateTime.now().toIso8601String();
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email ?? '',
      'displayName': user.displayName ?? '',
      'phoneNumber': user.phoneNumber ?? '',
      'photoUrl': user.photoURL,
      'bio': null,
      'createdAt': now,
      'updatedAt': now,
    });
  }

  @override
  Future<AuthUserModel> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String photoUrl,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw AuthException('Failed to create user');
      }

      await user.updateDisplayName(name);
      await user.updatePhotoURL(photoUrl);
      await user.reload();

      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser == null) {
        throw AuthException('Failed to retrieve user after registration');
      }

      // Create user document in Firestore
      final now = DateTime.now().toIso8601String();
      await _firestore.collection('users').doc(updatedUser.uid).set({
        'uid': updatedUser.uid,
        'email': updatedUser.email ?? '',
        'displayName': name,
        'phoneNumber': phoneNumber,
        'photoUrl': photoUrl,
        'bio': null,
        'createdAt': now,
        'updatedAt': now,
      });

      return AuthUserModel(
        uid: updatedUser.uid,
        email: updatedUser.email ?? '',
        displayName: updatedUser.displayName ?? name,
        phoneNumber: phoneNumber,
        isEmailVerified: updatedUser.emailVerified,
        photoUrl: updatedUser.photoURL ?? photoUrl,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw AuthException('Failed to sign in user');
      }

      return AuthUserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        phoneNumber: user.phoneNumber ?? '',
        isEmailVerified: user.emailVerified,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _ensureInitialized();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException(
        'Failed to send password reset email: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return null;
      }

      return AuthUserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        phoneNumber: user.phoneNumber ?? '',
        isEmailVerified: user.emailVerified,
        photoUrl: user.photoURL,
      );
    } catch (e) {
      throw AuthException('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<void> verifyEmail() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthException('No user is currently signed in');
      }

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('Failed to send verification email: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserProfile({
    required String displayName,
    required String? photoUrl,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw AuthException('No user is currently signed in');
      }

      await user.updateDisplayName(displayName);
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }
      await user.reload();
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('Failed to update profile: ${e.toString()}');
    }
  }

  AuthException _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException('No user found with this email');
      case 'wrong-password':
        return AuthException('Wrong password provided');
      case 'email-already-in-use':
        return AuthException('An account already exists with this email');
      case 'invalid-email':
        return AuthException('Invalid email address');
      case 'weak-password':
        return AuthException('Password is too weak. Use at least 6 characters');
      case 'operation-not-allowed':
        return AuthException('This operation is not allowed');
      case 'too-many-requests':
        return AuthException('Too many login attempts. Please try again later');
      case 'network-request-failed':
        return AuthException(
          'Network error. Please check your connection and try again',
        );
      case 'account-exists-with-different-credential':
        return AuthException('Account exists with different credentials');
      case 'invalid-credential':
        return AuthException('Invalid credentials');
      case 'user-disabled':
        return AuthException('This user account has been disabled');
      default:
        return AuthException('Authentication error: ${e.message}');
    }
  }

  @override
  Future<AuthUserModel> signInWithGoogle() async {
    try {
      await _ensureInitialized();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // google_sign_in 7.x requires at least one requested scope.
      final authz = await googleUser.authorizationClient.authorizeScopes(
        _googleAuthScopes,
      );
      final String accessToken = authz.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken.isEmpty && (idToken == null || idToken.isEmpty)) {
        throw AuthException('Google sign in failed: missing auth tokens');
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      
      await _createUserDocumentIfNew(userCredential);

      final user = userCredential.user;
      if (user == null) {
        throw AuthException('Failed to sign in with Google');
      }

      return AuthUserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        phoneNumber: user.phoneNumber ?? '',
        isEmailVerified: user.emailVerified,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw AuthException('Google sign in was cancelled');
      }
      if (e.code == GoogleSignInExceptionCode.clientConfigurationError) {
        throw AuthException(
          'Google sign in failed: check OAuth client configuration',
        );
      }
      throw AuthException('Google sign in failed: ${e.description}');
    } catch (e) {
      throw AuthException('Google sign in failed: ${e.toString()}');
    }
  }
}
