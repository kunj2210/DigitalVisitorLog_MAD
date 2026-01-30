import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/visitor_model.dart';

class DatabaseService {
  final CollectionReference _visitorsCollection =
      FirebaseFirestore.instance.collection('visitors');

  // CREATE: Add a new visitor
  Future<void> addVisitor(Visitor visitor) async {
    try {
      await _visitorsCollection.add(visitor.toMap());
    } catch (e) {
      print("Error adding visitor: $e");
      rethrow;
    }
  }

  // READ: Get stream of visitors
  Stream<List<Visitor>> getVisitors() {
    return _visitorsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Visitor.fromDocument(doc)).toList();
    });
  }

  // UPDATE: Update existing visitor
  Future<void> updateVisitor(Visitor visitor) async {
    try {
      await _visitorsCollection.doc(visitor.id).update(visitor.toMap());
    } catch (e) {
      print("Error updating visitor: $e");
      rethrow;
    }
  }

  // DELETE: Delete visitor
  Future<void> deleteVisitor(String id) async {
    try {
      await _visitorsCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting visitor: $e");
      rethrow;
    }
  }
}
