import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/checklist_item.dart';
import '../../view_model/plan_provider.dart';

const List<String> periods = ['Morning', 'Afternoon', 'Evening'];
const List<String> minutes = [
  '00',
  '05',
  '10',
  '15',
  '20',
  '25',
  '30',
  '35',
  '40',
  '45',
  '50',
  '55',
];

const List<String> gymEssentials = [
  'Water bottle',
  'Gym towel',
  'Training shoes',
  'Comfortable workout clothes',
  'Headphones or earbuds',
  'Lock for your gym locker',
];

const List<String> healthySnacks = [
  'Greek yogurt with berries',
  'Banana with peanut butter',
  'Trail mix with nuts and seeds',
  'Apple slices with almond butter',
  'Protein bar with low added sugar',
  'Boiled eggs and whole-grain crackers',
];

const Map<String, String> healthySnackDetails = {
  'Greek yogurt with berries':
      'Great before or after the gym because it combines quick carbs with protein to support energy and recovery.',
  'Banana with peanut butter':
      'A strong pre-workout option since the banana gives fast fuel and the peanut butter helps keep you satisfied for longer.',
  'Trail mix with nuts and seeds':
      'Helpful after training or between sessions when you want portable energy, healthy fats, and a little protein.',
  'Apple slices with almond butter':
      'A light snack before the gym that gives you natural carbs for fuel and a bit of fat to steady your energy.',
  'Protein bar with low added sugar':
      'Convenient after a workout when you want an easy protein boost to help support muscle repair.',
  'Boiled eggs and whole-grain crackers':
      'Best after the gym because the eggs offer protein while the crackers help top up energy stores.',
};

// Used in QuickTipDetailPage to determine how to display the list of items
enum QuickTipDetailMode {
  standard,
  addToChecklist,
  expandableInfo,
}

// Shows a dialog to add or edit a checklist item. If editing, the existing title is pre-filled in the text field.
Future<void> showItemDialog(
  BuildContext context, {
  required String planId,
  required ChecklistItem item,
}) async {
  final TextEditingController controller = TextEditingController(
    text: item.title,
  );

  final String? itemTitle = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit item'),
        content: TextField(
          autofocus: true,
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: (submittedValue) {
            final String trimmedValue = submittedValue.trim();
            if (trimmedValue.isEmpty) {
              return;
            }

            Navigator.of(context).pop(trimmedValue);
          },
          decoration: const InputDecoration(
            hintText: 'Enter item name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final String trimmedValue = controller.text.trim();
              if (trimmedValue.isEmpty) {
                return;
              }

              Navigator.of(context).pop(trimmedValue);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );

  if (itemTitle == null || itemTitle.trim() == item.title.trim()) {
    return;
  }

  await context.read<PlanProvider>().updatePlanItem(
        planId,
        item.id,
        itemTitle,
      );
}
