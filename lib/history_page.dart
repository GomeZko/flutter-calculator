import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ─── Firestore service ───────────────────────────────────────────────────────

class HistoryDB {
  static CollectionReference get _col {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('history');
  }

  static Future<void> insert(String calculation, String timestamp) async {
    await _col.add({
      'calculation': calculation,
      'timestamp': timestamp,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getStream() {
    return _col.orderBy('createdAt', descending: true).snapshots();
  }

  static Future<void> clear() async {
    final snapshot = await _col.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}

// ─── History Screen ──────────────────────────────────────────────────────────

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Future<void> _clear(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Delete all entries?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Clear')),
        ],
      ),
    );
    if (ok == true) await HistoryDB.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: const Text('History', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            tooltip: 'Clear all',
            onPressed: () => _clear(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: HistoryDB.getStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No calculations yet.',
                style: TextStyle(color: Colors.white54, fontSize: 18),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) =>
                Divider(color: Colors.blueGrey[700], height: 1),
            itemBuilder: (_, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              return ListTile(
                leading: const Icon(Icons.calculate, color: Colors.orange),
                title: Text(
                  data['calculation'] as String,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  data['timestamp'] as String,
                  style: const TextStyle(color: Colors.white54),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
