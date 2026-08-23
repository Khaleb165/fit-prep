import 'package:flutter/foundation.dart';

import '../core/services/remote_preset_service.dart';
import '../model/preset_data.dart';

class PresetProvider extends ChangeNotifier {
  PresetProvider({RemotePresetService? service})
      : _service = service ?? RemotePresetService() {
    refreshFromBackend();
  }

  final RemotePresetService _service;

  FitnessPresetData? _presets;
  FitnessPresetData? get presets => _presets;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<FitnessPresetData?> refreshFromBackend({
    bool rethrowErrors = false,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final presets = await _service.fetchFitnessPresets();
      _presets = presets;
      return presets;
    } catch (e) {
      _error = e.toString();
      debugPrint('Failed to fetch presets: $e');
      if (rethrowErrors) {
        rethrow;
      }

      return _presets;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retry() => refreshFromBackend();
}
