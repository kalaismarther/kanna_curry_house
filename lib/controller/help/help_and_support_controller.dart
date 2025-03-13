import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/help/faq_model.dart';

class HelpAndSupportController extends GetxController {
  @override
  void onInit() {
    Future.wait([fetchContactDetails(), fetchFaq()]);
    super.onInit();
  }

  var contactDetailLoading = false.obs;
  var emailAddress = ''.obs;
  var whatsappNo = ''.obs;
  var contactDetailError = Rxn<String>();

  var faqLoading = false.obs;

  var faqList = <FaqModel>[].obs;

  var faqError = Rxn<String>();

  Future<void> fetchContactDetails() async {
    try {
      contactDetailLoading.value = true;
      contactDetailError.value = null;
      final result = await ApiServices.getHelpAndSupport();

      emailAddress.value = result['contact_email'];
      whatsappNo.value = result['contact_mobile'];
    } catch (e) {
      contactDetailError.value = UiHelper.getMsgFromException(e.toString());
    } finally {
      contactDetailLoading.value = false;
    }
  }

  Future<void> fetchFaq() async {
    try {
      faqLoading.value = true;
      contactDetailError.value = null;
      final result = await ApiServices.getFaqList();

      faqList.value = result;
    } catch (e) {
      faqError.value = UiHelper.getMsgFromException(e.toString());
    } finally {
      faqLoading.value = false;
    }
  }
}
