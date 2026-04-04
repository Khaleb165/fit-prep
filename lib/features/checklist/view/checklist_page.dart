import 'package:flutter/material.dart';

import '../../../core/constants/size_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_logo_app_bar.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final List<_ChecklistItem> _items = [];

  Future<void> _showAddItemDialog() async {
    String value = '';

    final String? itemTitle = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add item',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              )),
          content: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (newValue) {
              value = newValue;
            },
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
                final String trimmedValue = value.trim();
                if (trimmedValue.isEmpty) {
                  return;
                }

                Navigator.of(context).pop(trimmedValue);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (itemTitle == null || itemTitle.isEmpty) {
      return;
    }

    setState(() {
      _items.add(_ChecklistItem(title: itemTitle));
    });
  }

  void _toggleItem(int index) {
    setState(() {
      _items[index] = _items[index].copyWith(
        isChecked: !_items[index].isChecked,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);

    return Scaffold(
      appBar: const GradientLogoAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundLightGrey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pack Your Gym Bag',
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(22),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _items.isEmpty
                      ? const Center(
                          child: Text(
                            'No items added yet.',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final _ChecklistItem item = _items[index];
                            return _ChecklistTile(
                              title: item.title,
                              isChecked: item.isChecked,
                              onToggle: () => _toggleItem(index),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.ctaButtonGradient,
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            onPressed: _showAddItemDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Add Item',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({
    required this.title,
    required this.isChecked,
    required this.onToggle,
  });

  final String title;
  final bool isChecked;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: _CircularCheckbox(
          isChecked: isChecked,
          onTap: onToggle,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: getProportionateScreenHeight(16),
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: _CircularCheckbox(
          isChecked: isChecked,
          onTap: onToggle,
        ),
        onTap: onToggle,
      ),
    );
  }
}

class _CircularCheckbox extends StatelessWidget {
  const _CircularCheckbox({
    required this.isChecked,
    required this.onTap,
  });

  final bool isChecked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChecked ? AppColors.vibrantGreen : AppColors.borderDivider,
        ),
        child: isChecked
            ? const Icon(
                Icons.check,
                size: 18,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}

class _ChecklistItem {
  const _ChecklistItem({
    required this.title,
    this.isChecked = false,
  });

  final String title;
  final bool isChecked;

  _ChecklistItem copyWith({
    String? title,
    bool? isChecked,
  }) {
    return _ChecklistItem(
      title: title ?? this.title,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
