import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

// ─── Database ───────────────────────────────────────────────────────────────

class HistoryDB {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      p.join(dbPath, 'calculator_history.db'),
      version: 1,
      onCreate: (db, _) => db.execute(
        'CREATE TABLE history('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'calculation TEXT,'
        'timestamp TEXT'
        ')',
      ),
    );
  }

  static Future<void> insert(String calculation, String timestamp) async {
    final db = await database;
    await db.insert('history', {
      'calculation': calculation,
      'timestamp': timestamp,
    });
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    final db = await database;
    return db.query('history', orderBy: 'id DESC');
  }

  static Future<void> clear() async {
    final db = await database;
    await db.delete('history');
  }
}

// ─── History Screen ──────────────────────────────────────────────────────────

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _entries = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await HistoryDB.getAll();
    setState(() => _entries = data);
  }

  Future<void> _clear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Delete all entries?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clear')),
        ],
      ),
    );
    if (ok == true) {
      await HistoryDB.clear();
      _load();
    }
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
          if (_entries.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              tooltip: 'Clear all',
              onPressed: _clear,
            ),
        ],
      ),
      body: _entries.isEmpty
          ? const Center(
              child: Text(
                'No calculations yet.',
                style: TextStyle(color: Colors.white54, fontSize: 18),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _entries.length,
              separatorBuilder: (_, __) =>
                  Divider(color: Colors.blueGrey[700], height: 1),
              itemBuilder: (_, i) {
                final e = _entries[i];
                return ListTile(
                  leading: const Icon(Icons.calculate, color: Colors.orange),
                  title: Text(
                    e['calculation'] as String,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    e['timestamp'] as String,
                    style: const TextStyle(color: Colors.white54),
                  ),
                );
              },
            ),
    );
  }
}
