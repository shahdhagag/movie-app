import 'package:firebase_auth/firebase_auth.dart';
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
  Future<void>? _googleSignInInitFuture;

  AuthRemoteDataSourceImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  Future<void> _ensureGoogleSignInInitialized() async {
    _googleSignInInitFuture ??= GoogleSignIn.instance.initialize();
    await _googleSignInInitFuture;
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

      // Update user profile with display name and photo URL
      await user.updateDisplayName(name);
      await user.updatePhotoURL(photoUrl);
      await user.reload();

      final updatedUser = _firebaseAuth.currentUser;

      return AuthUserModel(
        uid: updatedUser!.uid,
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
      throw AuthException('Failed to send password reset email: ${e.toString()}');
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
      await _ensureGoogleSignInInitialized();

      final googleSignIn = GoogleSignIn.instance;

      // Sign in with Google
      final googleUser = await googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      // Get authentication details (idToken)
      final googleAuth = googleUser.authentication;

      // Get authorization details (accessToken)
      final googleAuthz = await googleUser.authorizationClient.authorizeScopes(['email', 'profile']);

      // Create credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuthz.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

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
    } on AuthException {
      rethrow;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw AuthException('Google sign in was cancelled');
      }
      throw AuthException('Google sign in failed: ${e.description ?? e.code}');
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException('Google sign in failed: ${e.toString()}');
    }
  }
}
