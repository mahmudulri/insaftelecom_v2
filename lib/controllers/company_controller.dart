import 'package:get/get.dart';
import '../models/companies_model.dart';
import '../services/company_service.dart';

class CompanyController extends GetxController {
  var isLoading = false.obs;
  var allcompanies = CompaniesModel().obs;

  var matchedCompany = Rxn<Company>();

  void fetchCompany() async {
    try {
      isLoading(true);
      final value = await CompaniesApi().fetchcompanies();
      allcompanies.value = value;
    } catch (e) {
      print('Error fetching companies: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  void matchCompanyByPhoneNumber(String input) {
    final cleaned = input.replaceAll(RegExp(r'\D'), ''); // Remove any non-digit

    // Start from longest prefixes (e.g. 4 digits → 3 → 2)
    final companyList = allcompanies.value.data?.companies ?? [];

    for (final company in companyList) {
      for (final code in company.companyCodes ?? []) {
        final prefix = code.reservedDigit ?? '';
        if (cleaned.startsWith(prefix)) {
          matchedCompany.value = company;
          return;
        }
      }
    }

    matchedCompany.value = null; // No match found
  }
}
