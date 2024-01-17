import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/data/api/api_client.dart';
import 'package:efood_multivendor_driver/util/app_constants.dart';
import 'package:get/get.dart';

class DisbursementRepo {
  final ApiClient apiClient;

  DisbursementRepo({required this.apiClient});

  Future<Response> addWithdraw(Map<String?, String> data) async {
    return await apiClient.postData('${AppConstants.addWithdrawMethodUri}?token=${Get.find<AuthController>().getUserToken()}', data);
  }

  Future<Response> getDisbursementMethodList() async {
    return await apiClient.getData('${AppConstants.disbursementMethodListUri}?limit=10&offset=1&token=${Get.find<AuthController>().getUserToken()}');
  }

  Future<Response> makeDefaultMethod(Map<String?, String> data) async {
    return await apiClient.postData('${AppConstants.makeDefaultDisbursementMethodUri}?token=${Get.find<AuthController>().getUserToken()}', data);
  }

  Future<Response> deleteMethod(int id) async {
    return await apiClient.postData('${AppConstants.deleteDisbursementMethodUri}?token=${Get.find<AuthController>().getUserToken()}', {'_method': 'delete', 'id': id});
  }

  Future<Response> getDisbursementReport(int offset) async {
    return await apiClient.getData('${AppConstants.getDisbursementReportUri}?limit=10&offset=$offset&token=${Get.find<AuthController>().getUserToken()}');
  }

  Future<Response> getWithdrawMethodList() async {
    return await apiClient.getData('${AppConstants.withdrawRequestMethodUri}?token=${Get.find<AuthController>().getUserToken()}');
  }


}