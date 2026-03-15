import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/movie_item_model.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();

  Future<void> updateUserProfile({
    required String displayName,
    required String phoneNumber,
    String? bio,
    String? photoUrl,
  });

  Future<List<MovieItemModel>> getWatchList();

  Future<List<MovieItemModel>> getHistory();

  Future<void> addToWatchList({
    required int movieId,
    required String title,
    required String posterPath,
  });

  Future<void> addToHistory({
    required int movieId,
    required String title,
    required String posterPath,
  });

  Future<void> removeFromWatchList({required int movieId});

  Future<void> removeFromHistory({required int movieId});

  Future<bool> isMovieInWatchList({required int movieId});

  Future<bool> isMovieInHistory({required int movieId});

  Future<void> deleteAccount();

  Future<void> logout();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  ProfileRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  String get _userId => _firebaseAuth.currentUser?.uid ?? '';

  Future<void> _deleteUserCollection({required String collectionPath}) async {
    const int batchSize = 400;

    while (true) {
      final snapshot = await _firestore
          .collection(collectionPath)
          .limit(batchSize)
          .get();

      if (snapshot.docs.isEmpty) {
        break;
      }

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      if (_userId.isEmpty) {
        throw AuthException('User not authenticated');
      }

      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .get(const GetOptions(source: Source.server));

      final data = doc.data() ?? {};
      
      // If document doesn't exist, create a default one from Auth data
      if (!doc.exists) {
        final user = _firebaseAuth.currentUser;
        final newData = {
          'uid': _userId,
          'email': user?.email ?? '',
          'displayName': user?.displayName ?? '',
          'phoneNumber': user?.phoneNumber ?? '',
          'photoUrl': user?.photoURL,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };
        await _firestore.collection('users').doc(_userId).set(newData);
        return UserProfileModel.fromJson(newData);
      }

      // Get counts from subcollections
      final watchListQuery = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('watchlist')
          .count()
          .get();
      
      final historyQuery = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('history')
          .count()
          .get();

      final model = UserProfileModel.fromJson(data);
      
      return UserProfileModel(
        uid: model.uid,
        email: model.email,
        displayName: model.displayName,
        phoneNumber: model.phoneNumber,
        photoUrl: model.photoUrl,
        bio: model.bio,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        watchListCount: watchListQuery.count ?? 0,
        historyCount: historyQuery.count ?? 0,
      );
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw ServerException(message: 'Permission denied. Please check your Firestore rules.');
      }
      throw ServerException(message: 'Failed to fetch profile: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error fetching profile: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserProfile({
    required String displayName,
    required String phoneNumber,
    String? bio,
    String? photoUrl,
  }) async {
    try {
      if (_userId.isEmpty) {
        throw AuthException('User not authenticated');
      }

      final updateData = {
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'bio': bio,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (photoUrl != null) {
        updateData['photoUrl'] = photoUrl;
      }

      await _firestore.collection('users').doc(_userId).set(updateData, SetOptions(merge: true));

      // Also update Firebase Auth profile
      await _firebaseAuth.currentUser?.updateDisplayName(displayName);
      if (photoUrl != null) {
        await _firebaseAuth.currentUser?.updatePhotoURL(photoUrl);
      }
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to update profile: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error updating profile: ${e.toString()}');
    }
  }

  @override
  Future<List<MovieItemModel>> getWatchList() async {
    try {
      if (_userId.isEmpty) {
        throw AuthException('User not authenticated');
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('watchlist')
          .orderBy('addedAt', descending: true)
          .get(const GetOptions(source: Source.server));

      return snapshot.docs
          .map((doc) => MovieItemModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to fetch watchlist: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error fetching watchlist: ${e.toString()}');
    }
  }

  @override
  Future<List<MovieItemModel>> getHistory() async {
    try {
      if (_userId.isEmpty) {
        throw AuthException('User not authenticated');
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('history')
          .orderBy('addedAt', descending: true)
          .get(const GetOptions(source: Source.server));

      return snapshot.docs
          .map((doc) => MovieItemModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to fetch history: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error fetching history: ${e.toString()}');
    }
  }

  @override
  Future<void> addToWatchList({
    required int movieId,
    required String title,
    required String posterPath,
  }) async {
    try {
      if (_userId.isEmpty) {
        throw AuthException('User not authenticated');
      }

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('watchlist')
          .doc(movieId.toString())
          .set({
        'movieId': movieId,
        'title': title,
        'posterPath': posterPath,
        'addedAt': DateTime.now().toIso8601String(),
      });
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to add to watchlist: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error adding to watchlist: ${e.toString()}');
    }
  }

  @override
  Future<void> addToHistory({
    required int movieId,
    required String title,
    required String posterPath,
  }) async {
    try {
      if (_userId.isEmpty) {
        throw AuthException('User not authenticated');
      }

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('history')
          .doc(movieId.toString())
          .set({
        'movieId': movieId,
        'title': title,
        'posterPath': posterPath,
        'addedAt': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to add to history: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error adding to history: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFromWatchList({required int movieId}) async {
    try {
      if (_userId.isEmpty) {
        throw AuthException('User not authenticated');
      }

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('watchlist')
          .doc(movieId.toString())
          .delete();
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to remove from watchlist: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error removing from watchlist: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFromHistory({required int movieId}) async {
    try {
      if (_userId.isEmpty) {
        throw AuthException('User not authenticated');
      }

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('history')
          .doc(movieId.toString())
          .delete();
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to remove from history: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error removing from history: ${e.toString()}');
    }
  }

  @override
  Future<bool> isMovieInWatchList({required int movieId}) async {
    try {
      if (_userId.isEmpty) {
        throw AuthException('User not authenticated');
      }

      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('watchlist')
          .doc(movieId.toString())
          .get();

      return doc.exists;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: 'Failed to check watchlist: ${e.message}',
      );
    } catch (e) {
      throw ServerException(
        message: 'Error checking watchlist: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> isMovieInHistory({required int movieId}) async {
    try {
      if (_userId.isEmpty) {
        throw AuthException('User not authenticated');
      }

      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('history')
          .doc(movieId.toString())
          .get();

      return doc.exists;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: 'Failed to check history: ${e.message}',
      );
    } catch (e) {
      throw ServerException(
        message: 'Error checking history: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to logout: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error during logout: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null || _userId.isEmpty) {
        throw AuthException('User not authenticated');
      }

      // Firestore does not cascade-delete subcollections, so clear known data first.
      await _deleteUserCollection(collectionPath: 'users/$_userId/watchlist');
      await _deleteUserCollection(collectionPath: 'users/$_userId/history');
      await _firestore.collection('users').doc(_userId).delete();

      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw AuthException('For security reasons, please sign in again then try deleting your account.');
      }
      throw AuthException('Failed to delete account: ${e.message ?? 'Unknown authentication error'}');
    } on FirebaseException catch (e) {
      throw ServerException(message: 'Failed to delete account data: ${e.message}');
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error deleting account: ${e.toString()}');
    }
  }
}
