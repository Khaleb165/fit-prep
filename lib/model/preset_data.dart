class PresetListItem {
  const PresetListItem({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;
}

class HealthySnackPreset {
  const HealthySnackPreset({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;
}

class FitnessPresetData {
  FitnessPresetData({
    required this.gymEssentials,
    required this.healthySnacks,
  });

  final List<PresetListItem> gymEssentials;
  final List<HealthySnackPreset> healthySnacks;

  List<String> get gymEssentialTitles {
    return gymEssentials.map((item) => item.title).toList();
  }

  List<String> get healthySnackTitles {
    return healthySnacks.map((item) => item.title).toList();
  }

  Map<String, String> get healthySnackDescriptionsByTitle {
    return {
      for (final snack in healthySnacks) snack.title: snack.description,
    };
  }

  factory FitnessPresetData.fromJson(Map<String, dynamic> json) {
    final payload = json['presets'] is Map
        ? Map<String, dynamic>.from(json['presets'] as Map)
        : json;

    return FitnessPresetData(
      gymEssentials: _presetItemsFrom(
        payload['gym_essentials'] ?? payload['gymEssentials'],
      ),
      healthySnacks: _healthySnacksFrom(
        payload['healthy_snacks'] ?? payload['healthySnacks'],
      ),
    );
  }

  static List<PresetListItem> _presetItemsFrom(dynamic rawItems) {
    if (rawItems is! List) {
      return const <PresetListItem>[];
    }

    return rawItems.map(_presetItemFrom).whereType<PresetListItem>().toList();
  }

  static PresetListItem? _presetItemFrom(dynamic rawItem) {
    if (rawItem is String) {
      return PresetListItem(id: _slugFrom(rawItem), title: rawItem);
    }

    if (rawItem is Map) {
      final json = Map<String, dynamic>.from(rawItem);
      final title = (json['title'] ?? json['name'])?.toString();
      if (title == null || title.isEmpty) {
        return null;
      }

      return PresetListItem(
        id: json['id']?.toString() ?? _slugFrom(title),
        title: title,
      );
    }

    return null;
  }

  static List<HealthySnackPreset> _healthySnacksFrom(dynamic rawItems) {
    if (rawItems is! List) {
      return const <HealthySnackPreset>[];
    }

    return rawItems
        .map(_healthySnackFrom)
        .whereType<HealthySnackPreset>()
        .toList();
  }

  static HealthySnackPreset? _healthySnackFrom(dynamic rawItem) {
    if (rawItem is String) {
      return HealthySnackPreset(
        id: _slugFrom(rawItem),
        title: rawItem,
        description: '',
      );
    }

    if (rawItem is Map) {
      final json = Map<String, dynamic>.from(rawItem);
      final title = (json['title'] ?? json['name'])?.toString();
      if (title == null || title.isEmpty) {
        return null;
      }

      return HealthySnackPreset(
        id: json['id']?.toString() ?? _slugFrom(title),
        title: title,
        description: json['description']?.toString() ?? '',
      );
    }

    return null;
  }

  static String _slugFrom(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }
}
