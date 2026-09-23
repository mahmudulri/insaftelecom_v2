import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import '../global_controller/languages_controller.dart';
import '../utils/colors.dart';

class LanguageNumberDialog extends StatelessWidget {
  LanguageNumberDialog({super.key, required this.languagesController});

  final LanguagesController languagesController;

  final GetStorage box = GetStorage();

  final List<Map<String, String>> numberFormats = [
    {"name": "En", "fullname": "English", "example": "123456"},
    {"name": "Fa", "fullname": "فارسی", "example": "۱۲۳۴۵۶"},
    {"name": "Ar", "fullname": "العربية", "example": "١٢٣٤٥٦"},
    {"name": "Tr", "fullname": "Türkçe", "example": "123456"},
    {"name": "Ps", "fullname": "پښتو", "example": "۱۲۳۴۵۶"},
    {"name": "Bn", "fullname": "বাংলা", "example": "১২৩৪৫৬"},
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: screenWidth,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Row(
              children: [
                Expanded(
                  child: NText(
                    text: languagesController.tr("LANGUAGES"),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close, size: 22),
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// TITLES
            Row(
              children: [
                /// Language
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.language,
                        size: 18,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      NText(
                        text: "Language",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                /// Number Format
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.numbers,
                        size: 18,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      NText(
                        text: "Number Format",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// LANGUAGE + NUMBER FORMAT
            Flexible(
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// =========================
                    /// LEFT SIDE - LANGUAGE
                    /// =========================
                    Expanded(
                      child: Obx(
                        () => Column(
                          children: List.generate(
                            languagesController.alllanguagedata.length,
                            (index) {
                              final data =
                                  languagesController.alllanguagedata[index];

                              final String languageName = data["name"]
                                  .toString();

                              final bool isSelected =
                                  languagesController.selectedlan.value ==
                                  languageName;

                              return GestureDetector(
                                onTap: () async {
                                  final matched = languagesController
                                      .alllanguagedata
                                      .firstWhere(
                                        (lang) => lang["name"] == languageName,
                                        orElse: () => {
                                          "isoCode": "en",
                                          "region": "US",
                                          "direction": "ltr",
                                        },
                                      );

                                  final String languageISO =
                                      matched["isoCode"] ?? "en";

                                  final String languageRegion =
                                      matched["region"] ?? "US";

                                  final String languageDirection =
                                      matched["direction"] ?? "ltr";

                                  /// Change your JSON language
                                  languagesController.changeLanguage(
                                    languageName,
                                  );

                                  /// Save
                                  box.write("language", languageName);

                                  box.write("direction", languageDirection);

                                  /// Change EasyLocalization locale
                                  await EasyLocalization.of(context)!.setLocale(
                                    Locale(languageISO, languageRegion),
                                  );

                                  print(
                                    "🌐 Language changed to "
                                    "$languageName "
                                    "($languageISO-$languageRegion)",
                                  );
                                },
                                child: Container(
                                  height: 52,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryColor.withOpacity(
                                            0.08,
                                          )
                                        : Colors.transparent,
                                    border: Border.all(
                                      width: 1,
                                      color: isSelected
                                          ? AppColors.primaryColor
                                          : Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: NText(
                                          text: data["fullname"].toString(),
                                          fontSize: 13,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          size: 18,
                                          color: AppColors.primaryColor,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// =========================
                    /// RIGHT SIDE - NUMBER FORMAT
                    /// =========================
                    Expanded(
                      child: Obx(
                        () => Column(
                          children: List.generate(numberFormats.length, (
                            index,
                          ) {
                            final data = numberFormats[index];

                            final String numberLanguage = data["name"]
                                .toString();

                            final bool isSelected =
                                languagesController
                                    .selectedNumberLanguage
                                    .value ==
                                numberLanguage;

                            return GestureDetector(
                              onTap: () {
                                languagesController.changeNumberLanguage(
                                  numberLanguage,
                                );

                                print(
                                  "🔢 Number format changed to: "
                                  "$numberLanguage",
                                );
                              },
                              child: Container(
                                height: 52,
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor.withOpacity(0.08)
                                      : Colors.transparent,
                                  border: Border.all(
                                    width: 1,
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          NText(
                                            text: data["fullname"].toString(),
                                            fontSize: 11,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            data["example"].toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: isSelected
                                                  ? AppColors.primaryColor
                                                  : Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        size: 18,
                                        color: AppColors.primaryColor,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
