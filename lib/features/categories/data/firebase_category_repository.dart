import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/data/category_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseCategoryRepository implements CategoryRepository {
  Ref ref;

  FirebaseCategoryRepository({required this.ref});

  @override
  Stream<List<Category>> getCategoriesStream() {
    return _getCollection().snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList(),
    );
  }

  @override
  Future<bool> createCategory(Category category) async {
    try {
      await _getCollection().add(category.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> removeCategory(String categoryId) async {
    try {
      await _getCollection().doc(categoryId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateDefaultCategory(Category category) async {
    final collection = _getCollection();
    final batch = FirebaseFirestore.instance.batch();

    final existingDefaults = await collection
        .where('isDefault', isEqualTo: true)
        .get();

    for (final doc in existingDefaults.docs) {
      batch.update(doc.reference, {'isDefault': false});
    }

    batch.update(collection.doc(category.id), {'isDefault': true});

    await batch.commit();
  }

  @override
  Future<void> updateCategoryColor(Category category) async {
    final snapshot = await _getCollection()
        .where('name', isEqualTo: category.name)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception('No category found with name ${category.name}');
    }

    final doc = snapshot.docs.first.reference;
    await doc.update({'color': category.color?.toARGB32()});
  }

  CollectionReference<Map<String, dynamic>> _getCollection() {
    final householdId = ref.read(currentUserProvider).householdId;
    return ref
        .read(firestoreProvider)
        .collection('households')
        .doc(householdId)
        .collection('categories');
  }
}
