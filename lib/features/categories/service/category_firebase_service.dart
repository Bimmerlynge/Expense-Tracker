import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/app/network/category_api.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryFirebaseService implements CategoryApi {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  CategoryFirebaseService(this._firestore, this._ref);

  @override
  Future<List<Category>> getHouseholdCategories() async {
    final householdId = _ref.watch(currentUserProvider).householdId;

    var response = await _firestore
        .collection('households')
        .doc(householdId)
        .get();

    if (!response.exists) {
      return [];
    }

    final List<dynamic> categoriesRaw = response.data()?['categories'] ?? [];
    return categoriesRaw.map((name) => Category(name: name as String)).toList();
  }

  @override
  Stream<List<Category>> getCategoryStream() {
    var response = _getCollection().snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList(),
    );

    return response;
  }

  CollectionReference<Map<String, dynamic>> _getCollection() {
    final householdId = _ref.watch(currentUserProvider).householdId;
    return _firestore
        .collection('households')
        .doc(householdId)
        .collection('categories');
  }
}
