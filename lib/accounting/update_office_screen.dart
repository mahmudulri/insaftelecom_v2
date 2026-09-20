import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/language_changer.dart';
import '../utils/colors.dart';
import '../widgets/accountextfield.dart';
import '../widgets/custom_text.dart';
import 'controllers/accounting_currency_controller.dart';
import 'controllers/update_office_controller.dart';

class UpdateOfficeScreen extends StatefulWidget {
  const UpdateOfficeScreen({
    super.key,
    this.officeid,
    this.officeName,
    this.defaultAccountName,
    this.phoneNumber,
    this.codeNumber,
    this.location,
    this.address,
    this.isActive,
    this.notes,
    this.currencyCode,
    this.openingBalance,
  });

  final String? officeid;
  final String? officeName;
  final String? defaultAccountName;
  final String? phoneNumber;
  final String? codeNumber;
  final String? location;
  final String? address;
  final String? isActive;
  final String? notes;
  final String? currencyCode;
  final String? openingBalance;

  @override
  State<UpdateOfficeScreen> createState() => _UpdateOfficeScreenState();
}

class _UpdateOfficeScreenState extends State<UpdateOfficeScreen> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final AccountingCurrencyController currencyController =
      Get.find<AccountingCurrencyController>();

  final UpdateOfficeController updateController = Get.put(
    UpdateOfficeController(),
  );

  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();

    currencyController.fetchCurrencyList();

    updateController.nameController.text = widget.officeName.toString();
    updateController.phoneController.text = widget.phoneNumber.toString();
    updateController.idController.text = widget.codeNumber.toString();
    updateController.locationController.text = widget.location.toString();
    updateController.addressController.text = widget.address.toString();
    updateController.isActive.value = widget.isActive.toString();
    updateController.notesController.text = widget.notes.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.afraPayBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(12, 9, 12, 14),
          children: [
            _buildOfficeOverview(),
            const SizedBox(height: 10),
            _buildOfficeInformationCard(),
            const SizedBox(height: 10),
            _buildStatusCard(),
            const SizedBox(height: 10),
            _buildCurrencyCard(),
            const SizedBox(height: 10),
            _buildNotesCard(),
            const SizedBox(height: 82),
          ],
        ),
      ),
      bottomNavigationBar: _buildUpdateButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 58,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      titleSpacing: 12,
      title: Row(
        children: [
          _appBarButton(icon: Icons.arrow_back_rounded, onTap: Get.back),
          const SizedBox(width: 10),
          Expanded(
            child: KText(
              text: languagesController.tr('UPDATE_OFFICE'),
              color: AppColors.primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: AppColors.afraPayBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.05),
              ),
            ),
            child: const LanguageSelectorButton(size: 38, iconSize: 21),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.primaryColor.withOpacity(0.045),
        ),
      ),
    );
  }

  Widget _appBarButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.afraPayBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.afraPayTurquoise.withOpacity(0.10),
          ),
        ),
        child: Icon(icon, color: AppColors.primaryColor, size: 21),
      ),
    );
  }

  Widget _buildOfficeOverview() {
    final officeName = widget.officeName?.trim() ?? '';
    final officeCode = widget.codeNumber?.trim() ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.16),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.business_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  text: officeName.isNotEmpty
                      ? officeName
                      : languagesController.tr('OFFICE'),
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (officeCode.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  KText(
                    text: officeCode,
                    color: Colors.white.withOpacity(0.66),
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Obx(() {
            final isActive = updateController.isActive.value == '1';

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: KText(
                text: isActive
                    ? languagesController.tr('ACTIVE')
                    : languagesController.tr('IN_ACTIVE'),
                color: Colors.white,
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOfficeInformationCard() {
    return _sectionCard(
      icon: Icons.edit_note_rounded,
      title: languagesController.tr('UPDATE_OFFICE'),
      child: Column(
        children: [
          Accountextfield(
            controller: updateController.nameController,
            label: languagesController.tr('NAME'),
            hint: languagesController.tr('NAME_OF_THE_OFFICE'),
            height: 55,
          ),
          const SizedBox(height: 13),
          Accountextfield(
            keyboardType: TextInputType.number,
            controller: updateController.phoneController,
            label: languagesController.tr('PHONE_NUMBER'),
            hint: languagesController.tr('ENTER_PHONE_NUMBER'),
            height: 55,
          ),
          const SizedBox(height: 13),
          Accountextfield(
            controller: updateController.idController,
            label: languagesController.tr('ID_NUMBER'),
            hint: languagesController.tr('ENTER_ID_NUMBER'),
            height: 55,
          ),
          const SizedBox(height: 13),
          Accountextfield(
            controller: updateController.locationController,
            label: languagesController.tr('LOCATION'),
            hint: languagesController.tr('ENTER_LOCATION'),
            height: 55,
          ),
          const SizedBox(height: 13),
          Accountextfield(
            controller: updateController.addressController,
            label: languagesController.tr('ADDRESS'),
            hint: languagesController.tr('ENTER_ADDRESS'),
            height: 120,
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return _sectionCard(
      icon: Icons.toggle_on_outlined,
      title: languagesController.tr('STATUS'),
      child: Obx(() {
        final isActive = updateController.isActive.value == '1';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(11, 9, 9, 9),
          decoration: BoxDecoration(
            color: AppColors.afraPayBackground,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                height: 34,
                width: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.afraPayTurquoise.withOpacity(0.08)
                      : const Color(0xFFE05263).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isActive
                      ? Icons.check_circle_outline_rounded
                      : Icons.pause_circle_outline_rounded,
                  color: isActive
                      ? AppColors.afraPayTurquoise
                      : const Color(0xFFE05263),
                  size: 17,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KText(
                      text: isActive
                          ? languagesController.tr('ACTIVE')
                          : languagesController.tr('IN_ACTIVE'),
                      color: AppColors.primaryColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 2),
                    KText(
                      text: isActive
                          ? languagesController.tr('ACTIVE')
                          : languagesController.tr('IN_ACTIVE'),
                      color: AppColors.fontColor,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Switch(
                value: isActive,
                activeColor: Colors.white,
                activeTrackColor: AppColors.afraPayTurquoise,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: AppColors.fontColor.withOpacity(0.34),
                onChanged: (value) {
                  updateController.isActive.value = value ? '1' : '0';
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCurrencyCard() {
    return _sectionCard(
      icon: Icons.currency_exchange_rounded,
      title: languagesController.tr('CURRENCY'),
      child: Obx(() {
        if (currencyController.isLoading.value) {
          return Container(
            height: 52,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.afraPayBackground,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.afraPayTurquoise,
              ),
            ),
          );
        }

        final currencies =
            currencyController.allcurrencylist.value.data?.currencies ?? [];

        if (currencies.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.afraPayBackground,
              borderRadius: BorderRadius.circular(13),
            ),
            child: KText(
              text: languagesController.tr('NO_DATA_FOUND'),
              color: AppColors.fontColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
          );
        }

        return SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: currencies.length,
            separatorBuilder: (context, index) {
              return const SizedBox(width: 6);
            },
            itemBuilder: (context, index) {
              final data = currencies[index];
              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    updateController.currencyController.text = data.code
                        .toString();
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  constraints: const BoxConstraints(minWidth: 60),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.afraPayTurquoise
                        : AppColors.afraPayBackground,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.afraPayTurquoise
                          : AppColors.primaryColor.withOpacity(0.07),
                    ),
                  ),
                  child: KText(
                    text: data.code?.toString() ?? '--',
                    color: isSelected ? Colors.white : AppColors.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildNotesCard() {
    return _sectionCard(
      icon: Icons.notes_rounded,
      title: languagesController.tr('NOTES'),
      child: Accountextfield(
        controller: updateController.notesController,
        label: languagesController.tr('NOTES'),
        hint: languagesController.tr('ENTER_NOTES'),
        height: 120,
        maxLines: 5,
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.055)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.afraPayTurquoise.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: AppColors.afraPayTurquoise),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: KText(
                  text: title,
                  color: AppColors.primaryColor,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(12, 7, 12, 8),
        child: Obx(() {
          final isLoading = updateController.isLoading.value;

          return GestureDetector(
            onTap: isLoading
                ? null
                : () {
                    updateController.updatenow(widget.officeid.toString());
                  },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isLoading
                      ? [
                          AppColors.primarycolor2.withOpacity(0.58),
                          AppColors.afraPayTurquoise.withOpacity(0.58),
                        ]
                      : const [
                          AppColors.primarycolor2,
                          AppColors.afraPayTurquoise,
                        ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.afraPayTurquoise.withOpacity(0.16),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
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
                          Icons.save_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        KText(
                          text: languagesController.tr('UPDATE_OFFICE_NOW'),
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
            ),
          );
        }),
      ),
    );
  }
}
