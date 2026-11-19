import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  static const String allowedDomain = 'iba.edu.pk';

  AuthService({FirebaseAuth? auth, FirebaseFirestore? db})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = db ?? FirebaseFirestore.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  bool isAllowedEmail(String email) {
    return email.trim().toLowerCase().endsWith('@$allowedDomain');
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!normalizedEmail.endsWith('@$allowedDomain')) {
      throw Exception('Only @$allowedDomain email addresses are allowed.');
    }

    final cred = await _auth.createUserWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );

    final uid = cred.user!.uid;
    final userDoc = AppUserModel(
      uid: uid,
      name: name.trim(),
      email: normalizedEmail,
      role: 'student',
    );

    await _db.collection('users').doc(uid).set(userDoc.toMap());
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!normalizedEmail.endsWith('@$allowedDomain')) {
      throw Exception('Only @$allowedDomain email addresses are allowed.');
    }

    await _auth.signInWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );
  }

  Future<void> signOut() => _auth.signOut();

  Stream<AppUserModel?> watchUserProfile(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return AppUserModel.fromMap(snap.id, snap.data()!);
    });
  }
}