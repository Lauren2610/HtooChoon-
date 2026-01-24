import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificatonProvider extends ChangeNotifier {
  late TabController tabController;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot> invitations = [];
  List<QueryDocumentSnapshot> announcements = [];

  void init(TickerProvider vsync) {
    tabController = TabController(length: 2, vsync: vsync);
    fetchInvitations();
    fetchAnnouncements();
  }

  /// Fetch invitations
  Future<void> fetchInvitations() async {
    final snapshot = await _firestore
        .collection('invitations')
        .orderBy('createdAt', descending: true)
        .get();

    invitations = snapshot.docs;
    notifyListeners();
  }

  /// Fetch announcements
  Future<void> fetchAnnouncements() async {
    final snapshot = await _firestore
        .collection('announcements')
        .orderBy('createdAt', descending: true)
        .get();

    announcements = snapshot.docs;
    notifyListeners();
  }

  /// Invite user as Student or Teacher
  Future<void> inviteUser({
    required String orgId,
    required String email,
    required String role, // "student" or "teacher"
    required String title,
    required String body,
  }) async {
    await _firestore.collection('invitations').add({
      'orgId': orgId,
      'email': email,
      'role': role,
      'title': title,
      'body': body,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
