import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageSelectorButton extends StatefulWidget {
  const LanguageSelectorButton({super.key, this.size = 40, this.iconSize = 24});

  final double size;
  final double iconSize;

  @override
  State<LanguageSelectorButton> createState() => _LanguageSelectorButtonState();
}

class _LanguageSelectorButtonState extends State<LanguageSelectorButton> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final GetStorage box = GetStorage();

  Locale _getLocale(String isoCode) {
    switch (isoCode) {
      case 'fa':
        return const Locale('fa', 'IR');
      case 'ar':
        return const Locale('ar', 'AE');
      case 'ps':
        return const Locale('ps', 'AF');
      case 'tr':
        return const Locale('tr', 'TR');
      case 'bn':
        return const Locale('bn', 'BD');
      case 'en':
      default:
        return const Locale('en', 'US');
    }
  }

  String _currentLanguageName() {
    final storedLanguage = box.read('language')?.toString().trim() ?? '';

    if (storedLanguage.isNotEmpty) {
      return storedLanguage;
    }

    for (final raw in languagesController.alllanguagedata) {
      final data = Map<String, dynamic>.from(raw);

      final isoCode = data['isoCode']?.toString().trim().toLowerCase() ?? '';

      if (isoCode == context.locale.languageCode.toLowerCase()) {
        return data['name']?.toString() ?? '';
      }
    }

    return '';
  }

  String _currentLanguageFullName() {
    final currentName = _currentLanguageName();

    if (currentName.isEmpty) {
      return languagesController.tr('LANGUAGES');
    }

    for (final raw in languagesController.alllanguagedata) {
      final data = Map<String, dynamic>.from(raw);

      if (data['name']?.toString() == currentName) {
        return data['fullname']?.toString() ?? currentName;
      }
    }

    return currentName;
  }

  Future<void> _changeLanguage({
    required BuildContext sheetContext,
    required Map<String, dynamic> data,
  }) async {
    final languageName = data['name']?.toString().trim() ?? '';

    if (languageName.isEmpty) {
      return;
    }

    final Map<String, dynamic> matched = languagesController.alllanguagedata
        .cast<Map<String, dynamic>>()
        .firstWhere(
          (language) => language['name']?.toString() == languageName,
          orElse: () => <String, dynamic>{'isoCode': 'en', 'direction': 'ltr'},
        );

    final languageISO =
        matched['isoCode']?.toString().trim().toLowerCase() ?? 'en';

    final languageDirection =
        matched['direction']?.toString().trim().toLowerCase() ?? 'ltr';

    languagesController.changeLanguage(languageName);

    await box.write('language', languageName);

    await box.write('direction', languageDirection);

    final locale = _getLocale(languageISO);

    if (!mounted) {
      return;
    }

    await EasyLocalization.of(context)?.setLocale(locale);

    if (!mounted) {
      return;
    }

    setState(() {});

    if (Navigator.of(sheetContext).canPop()) {
      Navigator.of(sheetContext).pop();
    }
  }

  void _showLanguageSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.28),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final currentLanguage = _currentLanguageName();

            final languages = languagesController.alllanguagedata;

            return SafeArea(
              top: false,
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.78,
                ),
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.12),
                      blurRadius: 26,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 4,
                      width: 44,
                      decoration: BoxDecoration(
                        color: AppColors.fontColor.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primarycolor2,
                                AppColors.afraPayTurquoise,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.language_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: languagesController.tr('LANGUAGES'),
                                color: AppColors.primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              KText(
                                text: _currentLanguageFullName(),
                                color: AppColors.fontColor,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                          },
                          child: Container(
                            height: 34,
                            width: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.afraPayBackground,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.05),
                              ),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: AppColors.fontColor,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: languages.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 7);
                        },
                        itemBuilder: (context, index) {
                          final data = Map<String, dynamic>.from(
                            languages[index],
                          );

                          final languageName = data['name']?.toString() ?? '';

                          final fullName =
                              data['fullname']?.toString() ?? languageName;

                          final isoCode =
                              data['isoCode']
                                  ?.toString()
                                  .trim()
                                  .toUpperCase() ??
                              '';

                          final isSelected = currentLanguage == languageName;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                await _changeLanguage(
                                  sheetContext: sheetContext,
                                  data: data,
                                );

                                if (mounted) {
                                  setSheetState(() {});
                                }
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                curve: Curves.easeOutCubic,
                                padding: const EdgeInsets.fromLTRB(
                                  10,
                                  9,
                                  10,
                                  9,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.primaryColor.withOpacity(
                                          0.035,
                                        ),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : AppColors.primaryColor.withOpacity(
                                            0.055,
                                          ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      height: 38,
                                      width: 38,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.12)
                                            : AppColors.afraPayTurquoise
                                                  .withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      child: Icon(
                                        Icons.translate_rounded,
                                        size: 18,
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.afraPayTurquoise,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: fullName,
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.primaryColor,
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w700,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (isoCode.isNotEmpty) ...[
                                            const SizedBox(height: 2),
                                            KText(
                                              text: isoCode,
                                              color: isSelected
                                                  ? Colors.white.withOpacity(
                                                      0.65,
                                                    )
                                                  : AppColors.fontColor,
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w600,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      height: 28,
                                      width: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(9),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.primaryColor
                                                    .withOpacity(0.08),
                                        ),
                                      ),
                                      child: Icon(
                                        isSelected
                                            ? Icons.check_rounded
                                            : Icons.chevron_right_rounded,
                                        color: isSelected
                                            ? AppColors.primaryColor
                                            : AppColors.fontColor,
                                        size: isSelected ? 17 : 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cornerRadius = (widget.size * 0.30).clamp(10.0, 14.0);

    final indicatorSize = (widget.size * 0.18).clamp(6.0, 8.0);

    return GestureDetector(
      onTap: _showLanguageSheet,
      child: Container(
        height: widget.size,
        width: widget.size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(cornerRadius),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Center(
                child: Container(
                  height: widget.size * 0.72,
                  width: widget.size * 0.72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.afraPayTurquoise.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(cornerRadius - 2),
                  ),
                  child: Icon(
                    Icons.language_rounded,
                    color: AppColors.primaryColor,
                    size: widget.iconSize * 0.82,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                height: indicatorSize,
                width: indicatorSize,
                decoration: BoxDecoration(
                  color: AppColors.afraPayTurquoise,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
