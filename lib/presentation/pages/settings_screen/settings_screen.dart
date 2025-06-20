import 'package:flutter/material.dart';
import 'package:weatherandnewsaggregatorapp/data/colors/colors.dart';
import 'package:weatherandnewsaggregatorapp/data/components/custom_apptext.dart';
import 'package:get/get.dart';
import 'package:weatherandnewsaggregatorapp/presentation/controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        centerTitle: true,
        title: AppText(
          'Settings',
          color: textPrimary,
          size: 22,
          weight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Temperature Unit Section - Old UI Style
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppText(
                          'Temperature Unit',
                          size: 18,
                          weight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap:
                                () => settingsController.setTemperatureUnit(
                                  'Celsius',
                                ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value:
                                      settingsController
                                          .temperatureUnit
                                          .value ==
                                      'Celsius',
                                  onChanged:
                                      (_) => settingsController
                                          .setTemperatureUnit('Celsius'),
                                  activeColor: sunYellow,
                                ),
                                AppText(
                                  'Celsius',
                                  size: 16,
                                  weight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap:
                                () => settingsController.setTemperatureUnit(
                                  'Fahrenheit',
                                ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value:
                                      settingsController
                                          .temperatureUnit
                                          .value ==
                                      'Fahrenheit',
                                  onChanged:
                                      (_) => settingsController
                                          .setTemperatureUnit('Fahrenheit'),
                                  activeColor: sunYellow,
                                ),
                                AppText(
                                  'Fahrenheit',
                                  size: 16,
                                  weight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // News Categories Section - Old UI Style
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          'News Categories',
                          size: 18,
                          weight: FontWeight.w600,
                          color: textPrimary,
                        ),
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: sunYellow.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: AppText(
                              '${settingsController.selectedCategories.length}/5',
                              size: 12,
                              weight: FontWeight.w600,
                              color: sunYellow,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        AppText(
                          'Choose up to 5 categories for personalized news',
                          size: 14,
                          color: textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Categories List with Checkboxes
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: settingsController.availableCategories.length,
                      itemBuilder: (context, index) {
                        final category =
                            settingsController.availableCategories[index];
                        return Obx(() {
                          final isSelected = settingsController
                              .isCategorySelected(category);
                          final canSelect =
                              settingsController.canAddMoreCategories ||
                              isSelected;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged:
                                      canSelect
                                          ? (_) => settingsController
                                              .toggleCategory(category)
                                          : null,
                                  activeColor: sunYellow,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  settingsController.getCategoryIcon(category),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: !canSelect ? Colors.grey : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppText(
                                    settingsController.getCategoryDisplayName(
                                      category,
                                    ),
                                    size: 16,
                                    weight: FontWeight.w500,
                                    color:
                                        !canSelect ? Colors.grey : textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    // Info message
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.blue[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppText(
                                settingsController.canAddMoreCategories
                                    ? 'You can select ${settingsController.remainingCategorySlots} more categories'
                                    : 'Maximum reached. Deselect a category to choose another.',
                                size: 12,
                                color: Colors.blue[700]!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

    

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
