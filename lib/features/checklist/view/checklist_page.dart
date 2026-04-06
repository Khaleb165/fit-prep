import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/size_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_logo_app_bar.dart';
import '../model/checklist_item.dart';
import '../view_model/provider/checklist_provider.dart';
import 'widgets/checklist_tile.dart';

class ChecklistPage extends StatelessWidget {
  const ChecklistPage({super.key});

  Future<void> _showItemDialog(
    BuildContext context, {
    ChecklistItem? item,
  }) async {
    final TextEditingController controller = TextEditingController(
      text: item?.title ?? '',
    );

    final String? itemTitle = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            item == null ? 'Add item' : 'Edit item',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
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
              child: Text(item == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );

    if (itemTitle == null || itemTitle.isEmpty) {
      return;
    }

    final ChecklistProvider provider = context.read<ChecklistProvider>();
    if (item == null) {
      provider.addItem(itemTitle);
      return;
    }

    if (itemTitle.trim() == item.title.trim()) {
      return;
    }

    provider.updateItem(item.id, itemTitle);
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    final List<ChecklistItem> items = context.watch<ChecklistProvider>().items;

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
                SizedBox(height: getProportionateScreenHeight(20)),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Text(
                            'No items added yet.',
                            style: TextStyle(
                              fontSize: getProportionateScreenHeight(16),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, __) => SizedBox(
                              height: getProportionateScreenHeight(10)),
                          itemBuilder: (context, index) {
                            final ChecklistItem item = items[index];
                            return Dismissible(
                              key: ValueKey(item.id),
                              direction: DismissDirection.horizontal,
                              onDismissed: (_) {
                                context
                                    .read<ChecklistProvider>()
                                    .deleteItem(item.id);
                              },
                              background: const _DeleteBackground(
                                alignment: Alignment.centerLeft,
                              ),
                              secondaryBackground: const _DeleteBackground(
                                alignment: Alignment.centerRight,
                              ),
                              child: ChecklistTile(
                                title: item.title,
                                isChecked: item.isChecked,
                                onToggle: () => context
                                    .read<ChecklistProvider>()
                                    .toggleItem(item.id),
                                onTap: () => _showItemDialog(
                                  context,
                                  item: item,
                                ),
                              ),
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
            onPressed: () => _showItemDialog(context),
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

class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground({
    required this.alignment,
  });

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      child: const Icon(
        Icons.delete_outline,
        color: Colors.white,
      ),
    );
  }
}
