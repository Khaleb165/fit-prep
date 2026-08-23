import 'package:fit_prep/model/preset_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses the backend fitness presets response', () {
    final presets = FitnessPresetData.fromJson(
      <String, dynamic>{
        'presets': <String, dynamic>{
          'gym_essentials': <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 'water-bottle',
              'title': 'Water bottle',
            },
          ],
          'healthy_snacks': <Map<String, dynamic>>[
            <String, dynamic>{
              'id': 'greek-yogurt-with-berries',
              'title': 'Greek yogurt with berries',
              'description': 'Protein and carbs for recovery.',
            },
          ],
        },
      },
    );

    expect(presets.gymEssentialTitles, <String>['Water bottle']);
    expect(presets.healthySnackTitles, <String>['Greek yogurt with berries']);
    expect(
      presets.healthySnackDescriptionsByTitle,
      <String, String>{
        'Greek yogurt with berries': 'Protein and carbs for recovery.',
      },
    );
  });

  test('keeps compatibility with the first presets response shape', () {
    final presets = FitnessPresetData.fromJson(
      <String, dynamic>{
        'gymEssentials': <String>['Gym towel'],
        'healthySnacks': <Map<String, dynamic>>[
          <String, dynamic>{
            'name': 'Banana with peanut butter',
            'description': 'Fast fuel before training.',
          },
        ],
      },
    );

    expect(presets.gymEssentials.single.id, 'gym-towel');
    expect(presets.gymEssentialTitles, <String>['Gym towel']);
    expect(presets.healthySnacks.single.id, 'banana-with-peanut-butter');
    expect(presets.healthySnackTitles, <String>['Banana with peanut butter']);
  });
}
