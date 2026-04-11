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
