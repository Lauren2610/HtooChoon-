import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvitationProvider extends ChangeNotifier {
  late TabController tabController;
  bool isDisposed = false;

  void safeChangeNotifier() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot> invitations = [];
  List<QueryDocumentSnapshot> announcements = [];

  StreamSubscription? _invitationSub;

  void init({required TickerProvider vsync, required String email}) {
    tabController = TabController(length: 2, vsync: vsync);

    _listenToInvitations(email);
    fetchAnnouncements();
  }

  ///  Invite from org Create
  /// Read Fetch Invitations From Org
  /// Read Fetch User's Invitations
  ///  Accept (Update status)
  /// Delete Cancel From Org
  /// Delete Reject From User

  void _listenToInvitations(String? email) {
    if (email == null) return;

    _invitationSub?.cancel();

    _invitationSub = _db
        .collectionGroup('invitations')
        .where('email', isEqualTo: email)
        .where('status', whereIn: ['pending', 'accepted'])
        .snapshots()
        .listen((snapshot) {
          invitations = snapshot.docs;
          notifyListeners();
        });
  }

  Future<void> fetchAnnouncements() async {
    final snapshot = await _db
        .collection('announcements')
        .orderBy('createdAt', descending: true)
        .get();

    announcements = snapshot.docs;
    notifyListeners();
  }

  Future acceptInvitation({
    required String orgId,
    required String inviteId,
    required String userId,
    required String email,
  }) async {
    final batch = _db.batch();

    // 1. Get invitation data
    final inviteRef = _db
        .collection('organizations')
        .doc(orgId)
        .collection('invitations')
        .doc(inviteId);

    final inviteSnap = await inviteRef.get();
    if (!inviteSnap.exists) {
      throw Exception('Invitation not found');
    }

    final data = inviteSnap.data()!;
    final role = data['role'] as String;
    final classId = data['classId'] as String?;

    // 2. Update invitation status
    batch.update(inviteRef, {
      'status': 'accepted',
      'respondedAt': FieldValue.serverTimestamp(),
    });

    // 3. Add member based on role
    if (role == 'teacher') {
      // Teachers get org-wide access
      final orgMemberRef = _db
          .collection('organizations')
          .doc(orgId)
          .collection('members')
          .doc(userId);

      batch.set(orgMemberRef, {
        'uid': userId,
        'email': email,
        'role': 'teacher',
        'status': 'active',
        'joinedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } else if (role == 'student') {
      // Students MUST have classId
      if (classId == null) {
        throw Exception('Student invitation missing classId');
      }

      // Add to class members
      final classMemberRef = _db
          .collection('organizations')
          .doc(orgId)
          .collection('classes')
          .doc(classId)
          .collection('members')
          .doc(userId);

      batch.set(classMemberRef, {
        'uid': userId,
        'email': email,
        'role': 'student',
        'status': 'active',
        'joinedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Optional: Add to user's enrolled classes for quick lookup
      final userClassRef = _db
          .collection('users')
          .doc(userId)
          .collection('enrolledClasses')
          .doc(classId);

      batch.set(userClassRef, {
        'organizationId': orgId,
        'classId': classId,
        'role': 'student',
        'joinedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  Future<void> rejectInvitation({
    required String orgId,
    required String inviteId,
  }) async {
    await _db
        .collection('organizations')
        .doc(orgId)
        .collection('invitations')
        .doc(inviteId)
        .update({
          'status': 'rejected',
          'respondedAt': FieldValue.serverTimestamp(),
        });
  }

  @override
  void dispose() {
    _invitationSub?.cancel();
    tabController.dispose();
    super.dispose();
  }
}
