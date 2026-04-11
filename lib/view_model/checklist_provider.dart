import 'package:flutter/foundation.dart';

import '../model/checklist_item.dart';
import '../data/offline/hive.dart';

class ChecklistProvider extends ChangeNotifier {
  ChecklistProvider({
    required HiveStorage storage,
  }) : _storage = storage {
    _items = _storage.getChecklistItems();
  }

  final HiveStorage _storage;
  late final List<ChecklistItem> _items;

  List<ChecklistItem> get items => List.unmodifiable(_items);

  bool containsTitle(String title) {
    final String trimmedTitle = title.trim().toLowerCase();
    if (trimmedTitle.isEmpty) {
      return false;
    }

    return _items.any(
      (item) => item.title.trim().toLowerCase() == trimmedTitle,
    );
  }

  Future<void> addItem(String title) async {
    final String trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return;
    }

    _items.add(
      ChecklistItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: trimmedTitle,
      ),
    );
    await _persistItems();
    notifyListeners();
  }

  Future<bool> addItemIfAbsent(String title) async {
    if (containsTitle(title)) {
      return false;
    }

    await addItem(title);
    return true;
  }

  Future<void> updateItem(String id, String title) async {
    final String trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return;
    }

    final int index = _items.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }

    if (_items[index].title == trimmedTitle) {
      return;
    }

    _items[index] = _items[index].copyWith(title: trimmedTitle);
    await _persistItems();
    notifyListeners();
  }

  Future<void> toggleItem(String id) async {
    final int index = _items.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }

    final ChecklistItem item = _items[index];
    _items[index] = item.copyWith(isChecked: !item.isChecked);
    await _persistItems();
    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    await _persistItems();
    notifyListeners();
  }

  Future<void> clearItems() async {
    _items.clear();
    await _persistItems();
    notifyListeners();
  }

  Future<void> _persistItems() async {
    await _storage.saveChecklistItems(_items);
  }
}
