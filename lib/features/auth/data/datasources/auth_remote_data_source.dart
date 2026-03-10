import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
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
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<AuthUserModel> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
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

      // Update user profile with display name
      await user.updateDisplayName(name);
      await user.reload();

      return AuthUserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: name,
        phoneNumber: phoneNumber,
        isEmailVerified: user.emailVerified,
        photoUrl: user.photoURL,
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
}

