import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/api/api_checker.dart';
import 'package:efood_multivendor_driver/data/model/response/disbursement_method_model.dart' as d;
import 'package:efood_multivendor_driver/data/model/response/withdraw_method_model.dart';
import 'package:efood_multivendor_driver/data/model/response/disbursement_report_model.dart' as r;
import 'package:efood_multivendor_driver/data/repository/disbursement_repo.dart';
import 'package:efood_multivendor_driver/view/base/custom_dropdown.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisbursementController extends GetxController implements GetxService {
  final DisbursementRepo disbursementRepo;

  DisbursementController({required this.disbursementRepo});

  bool _isLoading = false;
  bool _isDeleteLoading = false;
  int? _selectedMethodIndex = 0;
  List<DropdownItem<int>> _methodList = [];
  List<TextEditingController> _textControllerList = [];
  List<MethodFields> _methodFields = [];
  List<FocusNode> _focusList = [];
  List<WidthDrawMethodModel>? _widthDrawMethods;
  d.DisbursementMethodBody? _disbursementMethodBody;
  int? _index = -1;
  r.DisbursementReportModel? _disbursementReportModel;

  bool get isLoading => _isLoading;
  bool get isDeleteLoading => _isDeleteLoading;
  int? get selectedMethodIndex => _selectedMethodIndex;
  List<DropdownItem<int>> get methodList => _methodList;
  List<TextEditingController> get textControllerList => _textControllerList;
  List<MethodFields> get methodFields => _methodFields;
  List<FocusNode> get focusList => _focusList;
  List<WidthDrawMethodModel>? get widthDrawMethods => _widthDrawMethods;
  d.DisbursementMethodBody? get disbursementMethodBody => _disbursementMethodBody;
  int? get index =>_index;
  r.DisbursementReportModel? get disbursementReportModel => _disbursementReportModel;

  void setMethodId(int? id, {bool canUpdate = true}) {
    _selectedMethodIndex = id;
    if(canUpdate){
      update();
    }
  }

  Future<void> setMethod({bool isUpdate = true}) async {
    _methodList = [];
    _textControllerList = [];
    _methodFields = [];
    _focusList = [];

    if(_widthDrawMethods == null) {
      _widthDrawMethods = await getWithdrawMethodList();
    } else {
      _widthDrawMethods = widthDrawMethods;
    }
    if(_widthDrawMethods != null && _widthDrawMethods!.isNotEmpty){
      for(int i=0; i < _widthDrawMethods!.length; i++){
        _methodList.add(DropdownItem<int>(value: i, child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${_widthDrawMethods![i].methodName}'),
          ),
        )));
      }

      _textControllerList = [];
      _methodFields = [];
      if (kDebugMode) {
        print('=====check : $_selectedMethodIndex //${_widthDrawMethods![_selectedMethodIndex!].methodFields}');
      }
      for (var field in _widthDrawMethods![_selectedMethodIndex!].methodFields!) {
        _methodFields.add(field);
        _textControllerList.add(TextEditingController());
        _focusList.add(FocusNode());
      }
    }
    if(isUpdate) {
      update();
    }
  }

  Future<void> addWithdrawMethod(Map<String?, String> data) async {
    _isLoading = true;
    update();
    Response response = await disbursementRepo.addWithdraw(data);
    if(response.statusCode == 200) {
      Get.back();
      getDisbursementMethodList();
      showCustomSnackBar('add_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<bool> getDisbursementMethodList() async {
    bool success = false;
    Response response = await disbursementRepo.getDisbursementMethodList();
    if(response.statusCode == 200) {
      success = true;
      _disbursementMethodBody = d.DisbursementMethodBody.fromJson(response.body);
    }else {
      ApiChecker.checkApi(response);
    }
    update();
    return success;
  }

  Future<void> makeDefaultMethod(Map<String, String> data, int index) async {
    _index = index;
    _isLoading = true;
    update();
    Response response = await disbursementRepo.makeDefaultMethod(data);
    if(response.statusCode == 200) {
      _index = -1;
      getDisbursementMethodList();
      showCustomSnackBar('set_default_method_successful'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteMethod(int id) async {
    _isDeleteLoading = true;
    update();
    Response response = await disbursementRepo.deleteMethod(id);
    if(response.statusCode == 200) {
      getDisbursementMethodList();
      Get.back();
      showCustomSnackBar('method_delete_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _isDeleteLoading = false;
    update();
  }

  Future<void> getDisbursementReport(int offset) async {
    Response response = await disbursementRepo.getDisbursementReport(offset);
    if(response.statusCode == 200) {
      _disbursementReportModel = r.DisbursementReportModel.fromJson(response.body);
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<List<WidthDrawMethodModel>?> getWithdrawMethodList() async {
    Response response = await disbursementRepo.getWithdrawMethodList();
    if(response.statusCode == 200) {
      _widthDrawMethods = [];
      response.body.forEach((method) {
        WidthDrawMethodModel withdrawMethod = WidthDrawMethodModel.fromJson(method);
        _widthDrawMethods!.add(withdrawMethod);
      });
    }else {
      ApiChecker.checkApi(response);
    }
    update();
    return _widthDrawMethods;
  }

  Future<bool> disbursementWarningMessage() async{

    bool showWarning = false;

    Get.find<SplashController>().configModel!.disbursementType == 'automated' && (Get.find<AuthController>().profileModel!.type! != 'restaurant_wise' && Get.find<AuthController>().profileModel!.earnings != 0)
        ? showWarning = true : showWarning = false;

    if(Get.find<SplashController>().configModel!.disbursementType == 'automated' && Get.find<AuthController>().profileModel!.type! != 'restaurant_wise' && Get.find<AuthController>().profileModel!.earnings != 0){
      getDisbursementMethodList().then((success) {
        if(success){
          for (var method in disbursementMethodBody!.methods!) {
            if(method.isDefault == 1){
              showWarning = false;
              break;
            } else {
              showWarning = true;
            }
          }
        }
      });
    } else {
      showWarning = false;
    }
    update();
    return showWarning;
  }

}