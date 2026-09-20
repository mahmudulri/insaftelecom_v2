import 'package:insaftelecom/accounting/accounting_base.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/global_controller/verify_pin_controller.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

LanguagesController languagesController = Get.put(LanguagesController());

class AccountingPinPad {
  static void show(BuildContext context) {
    String enteredNumber = '';

    final VerifyPinController verifyPinController =
        Get.isRegistered<VerifyPinController>()
        ? Get.find<VerifyPinController>()
        : Get.put(VerifyPinController());

    verifyPinController.clearError();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.46),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setState) {
            void addNumber(String number) {
              if (enteredNumber.length >= 4) {
                return;
              }

              verifyPinController.clearError();

              setState(() {
                enteredNumber += number;
              });
            }

            void removeNumber() {
              verifyPinController.clearError();

              if (enteredNumber.isEmpty) {
                return;
              }

              setState(() {
                enteredNumber = enteredNumber.substring(
                  0,
                  enteredNumber.length - 1,
                );
              });
            }

            void clearNumber() {
              verifyPinController.clearError();

              if (enteredNumber.isEmpty) {
                return;
              }

              setState(() {
                enteredNumber = '';
              });
            }

            Future<void> submitPin() async {
              if (enteredNumber.length != 4) {
                Get.snackbar(
                  languagesController.tr('INVALID_PIN'),
                  languagesController.tr('PIN_MUST_BE_4_DIGITS'),
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(15),
                );
                return;
              }

              final pin = enteredNumber;

              final isCorrect = await verifyPinController.verifyPin(pin);

              if (!sheetContext.mounted) {
                return;
              }

              if (isCorrect) {
                Navigator.of(bottomSheetContext).pop();
                Get.to(() => AccountingBaseScreen());
              } else {
                setState(() {
                  enteredNumber = '';
                });
              }
            }

            return Obx(() {
              final isLoading = verifyPinController.isLoading.value;
              final errorMessage = verifyPinController.errorMessage.value;

              return SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(sheetContext).size.height * 0.88,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.afraPayBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        14,
                        10,
                        14,
                        14 + MediaQuery.of(sheetContext).viewInsets.bottom,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 4,
                            width: 42,
                            decoration: BoxDecoration(
                              color: AppColors.fontColor.withOpacity(0.24),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          const SizedBox(height: 13),
                          _buildHeader(
                            isLoading: isLoading,
                            onClose: () {
                              if (isLoading) {
                                return;
                              }

                              verifyPinController.clearError();
                              Navigator.of(bottomSheetContext).pop();
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildSecurityCard(
                            enteredNumber: enteredNumber,
                            errorMessage: errorMessage,
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: errorMessage.isNotEmpty
                                ? Padding(
                                    key: ValueKey(errorMessage),
                                    padding: const EdgeInsets.only(top: 9),
                                    child: _buildErrorBanner(errorMessage),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 13),
                          _buildKeypad(
                            enabled: !isLoading,
                            onNumberTap: addNumber,
                            onBackspace: removeNumber,
                            onClear: clearNumber,
                          ),
                          const SizedBox(height: 14),
                          _buildSubmitButton(
                            isLoading: isLoading,
                            enabled: enteredNumber.length == 4,
                            onTap: submitPin,
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: isLoading
                                ? null
                                : () {
                                    verifyPinController.clearError();
                                    Navigator.of(bottomSheetContext).pop();
                                  },
                            child: Container(
                              height: 42,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: KText(
                                text: languagesController.tr('CANCEL'),
                                color: isLoading
                                    ? AppColors.fontColor.withOpacity(0.55)
                                    : AppColors.fontColor,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
          },
        );
      },
    );
  }

  static Widget _buildHeader({
    required bool isLoading,
    required VoidCallback onClose,
  }) {
    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primarycolor2, AppColors.afraPayTurquoise],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
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
                text: languagesController.tr('ENTER_PIN'),
                color: AppColors.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              KText(
                text: languagesController.tr('ENTER_YOUR_ACCOUNTING_PIN'),
                color: AppColors.fontColor,
                fontSize: 9,
                fontWeight: FontWeight.w500,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: isLoading ? null : onClose,
          child: Container(
            height: 34,
            width: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.05),
              ),
            ),
            child: Icon(
              Icons.close_rounded,
              size: 18,
              color: isLoading
                  ? AppColors.fontColor.withOpacity(0.45)
                  : AppColors.fontColor,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildSecurityCard({
    required String enteredNumber,
    required String errorMessage,
  }) {
    final hasError = errorMessage.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 13),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.13),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 34,
                width: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Colors.white,
                  size: 17,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: KText(
                  text: languagesController.tr('ENTER_YOUR_ACCOUNTING_PIN'),
                  color: Colors.white.withOpacity(0.72),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: KText(
                  text: '${enteredNumber.length}/4',
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final filled = index < enteredNumber.length;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                height: 46,
                width: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: hasError
                      ? Colors.white.withOpacity(0.09)
                      : filled
                      ? Colors.white
                      : Colors.white.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: hasError
                        ? const Color(0xFFE05263)
                        : filled
                        ? Colors.white
                        : Colors.white.withOpacity(0.12),
                  ),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: filled ? 11 : 7,
                  width: filled ? 11 : 7,
                  decoration: BoxDecoration(
                    color: hasError
                        ? const Color(0xFFE05263)
                        : filled
                        ? AppColors.primaryColor
                        : Colors.white.withOpacity(0.36),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  static Widget _buildErrorBanner(String errorMessage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDEC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE05263).withOpacity(0.14)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 17,
            color: Color(0xFFE05263),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: KText(
              text: errorMessage,
              color: const Color(0xFFE05263),
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildKeypad({
    required bool enabled,
    required ValueChanged<String> onNumberTap,
    required VoidCallback onBackspace,
    required VoidCallback onClear,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.03),
            blurRadius: 11,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _keypadRow(
            enabled: enabled,
            values: const ['1', '2', '3'],
            onNumberTap: onNumberTap,
          ),
          const SizedBox(height: 8),
          _keypadRow(
            enabled: enabled,
            values: const ['4', '5', '6'],
            onNumberTap: onNumberTap,
          ),
          const SizedBox(height: 8),
          _keypadRow(
            enabled: enabled,
            values: const ['7', '8', '9'],
            onNumberTap: onNumberTap,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _actionKey(
                  icon: Icons.refresh_rounded,
                  enabled: enabled,
                  onTap: onClear,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _numberKey(
                  number: '0',
                  enabled: enabled,
                  onTap: () => onNumberTap('0'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _actionKey(
                  icon: Icons.backspace_outlined,
                  enabled: enabled,
                  onTap: onBackspace,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _keypadRow({
    required bool enabled,
    required List<String> values,
    required ValueChanged<String> onNumberTap,
  }) {
    return Row(
      children: [
        for (int index = 0; index < values.length; index++) ...[
          Expanded(
            child: _numberKey(
              number: values[index],
              enabled: enabled,
              onTap: () => onNumberTap(values[index]),
            ),
          ),
          if (index != values.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }

  static Widget _numberKey({
    required String number,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.afraPayBackground
                : AppColors.afraPayBackground.withOpacity(0.55),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.045),
            ),
          ),
          child: KText(
            text: number,
            color: enabled
                ? AppColors.primaryColor
                : AppColors.fontColor.withOpacity(0.55),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  static Widget _actionKey({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(enabled ? 0.055 : 0.025),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.045),
            ),
          ),
          child: Icon(
            icon,
            size: 19,
            color: enabled
                ? AppColors.primaryColor
                : AppColors.fontColor.withOpacity(0.45),
          ),
        ),
      ),
    );
  }

  static Widget _buildSubmitButton({
    required bool isLoading,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final canSubmit = !isLoading && enabled;

    return GestureDetector(
      onTap: canSubmit ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: canSubmit
                ? const [AppColors.primarycolor2, AppColors.afraPayTurquoise]
                : [
                    AppColors.primarycolor2.withOpacity(0.45),
                    AppColors.afraPayTurquoise.withOpacity(0.45),
                  ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: canSubmit
              ? [
                  BoxShadow(
                    color: AppColors.afraPayTurquoise.withOpacity(0.16),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_open_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                  const SizedBox(width: 6),
                  KText(
                    text: languagesController.tr('SUBMIT'),
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
      ),
    );
  }
}
