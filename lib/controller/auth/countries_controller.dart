import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/auth/country_model.dart';

class CountriesController extends GetxController {
  @override
  void onInit() {
    fetchCountries();
    super.onInit();
  }

  var isLoading = false.obs;

  var countries = <CountryModel>[].obs;

  var error = Rxn<String>();

  Future<void> fetchCountries() async {
    try {
      isLoading.value = true;
      countries.value = await ApiServices.getCountriesList();
    } catch (e) {
      error.value = UiHelper.getMsgFromException(e);
    } finally {
      isLoading.value = false;
    }
  }
}
