import 'dart:async';
import 'dart:convert';

import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/api/api_checker.dart';
import 'package:efood_multivendor_driver/data/api/api_client.dart';
import 'package:efood_multivendor_driver/data/model/body/record_location_body.dart';
import 'package:efood_multivendor_driver/data/model/response/address_model.dart';
import 'package:efood_multivendor_driver/data/model/response/config_model.dart';
import 'package:efood_multivendor_driver/data/model/response/profile_model.dart';
import 'package:efood_multivendor_driver/data/model/response/response_model.dart';
import 'package:efood_multivendor_driver/data/model/response/shift_model.dart';
import 'package:efood_multivendor_driver/data/model/response/vehicle_model.dart';
import 'package:efood_multivendor_driver/data/model/response/wallet_payment_model.dart';
import 'package:efood_multivendor_driver/data/model/response/zone_model.dart';
import 'package:efood_multivendor_driver/data/model/response/zone_response_model.dart';
import 'package:efood_multivendor_driver/data/repository/auth_repo.dart';
import 'package:efood_multivendor_driver/helper/custom_print.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor_driver/view/base/custom_alert_dialog.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart' as geo_coding;

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo}) {
    _notification = authRepo.isNotificationActive();
  }

  bool _isLoading = false;
  bool _shiftLoading = false;
  bool _notification = true;
  ProfileModel? _profileModel;
  XFile? _pickedFile;
  Timer? _timer;
  // Position _location = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
  XFile? _pickedImage;
  List<XFile> _pickedIdentities = [];
  final List<String> _identityTypeList = ['passport', 'driving_license', 'nid'];
  int _identityTypeIndex = 0;
  final List<String?> _dmTypeList = ['freelancer', 'salary_based'];
  int _dmTypeIndex = -1;
  XFile? _pickedLogo;
  XFile? _pickedCover;
  List<ZoneModel>? _zoneList;
  int? _selectedZoneIndex = 0;
  LatLng? _restaurantLocation;
  List<int>? _zoneIds;
  bool _loading = false;
  bool _inZone = false;
  int _zoneID = 0;
  List<VehicleModel>? _vehicles;
  List<int?>? _vehicleIds;
  int? _vehicleIndex = 0;
  List<ShiftModel>? _shifts;
  int? _shiftId;
  double _dmStatus = 0.4;
  bool _showPassView = false;
  bool _lengthCheck = false;
  bool _numberCheck = false;
  bool _uppercaseCheck = false;
  bool _lowercaseCheck = false;
  bool _spatialCheck = false;
/*  List<TextEditingController> _textControllerList = [];
  List<FocusNode> _focusList = [];*/
  int _paymentIndex = 0;
  String? _digitalPaymentName;
  List<Transactions>? _transactions;
  List<Data>? _dataList;
  List<dynamic>? _additionalList;
  RecordLocationBody? _recordLocation;

  bool get isLoading => _isLoading;
  bool get shiftLoading => _shiftLoading;
  bool get notification => _notification;
  ProfileModel? get profileModel => _profileModel;
  XFile? get pickedFile => _pickedFile;
  XFile? get pickedImage => _pickedImage;
  List<XFile> get pickedIdentities => _pickedIdentities;
  List<String> get identityTypeList => _identityTypeList;
  int get identityTypeIndex => _identityTypeIndex;
  List<String?> get dmTypeList => _dmTypeList;
  int get dmTypeIndex => _dmTypeIndex;
  XFile? get pickedLogo => _pickedLogo;
  XFile? get pickedCover => _pickedCover;
  List<ZoneModel>? get zoneList => _zoneList;
  int? get selectedZoneIndex => _selectedZoneIndex;
  LatLng? get restaurantLocation => _restaurantLocation;
  List<int>? get zoneIds => _zoneIds;
  bool get loading => _loading;
  bool get inZone => _inZone;
  int get zoneID => _zoneID;
  List<VehicleModel>? get vehicles => _vehicles;
  List<int?>? get vehicleIds => _vehicleIds;
  int? get vehicleIndex => _vehicleIndex;
  List<ShiftModel>? get shifts => _shifts;
  int? get shiftId => _shiftId;
  double get dmStatus => _dmStatus;
  bool get showPassView => _showPassView;
  bool get lengthCheck => _lengthCheck;
  bool get numberCheck => _numberCheck;
  bool get uppercaseCheck => _uppercaseCheck;
  bool get lowercaseCheck => _lowercaseCheck;
  bool get spatialCheck => _spatialCheck;
/*  List<TextEditingController> get textControllerList => _textControllerList;
  List<FocusNode> get focusList => _focusList;*/
  int get paymentIndex => _paymentIndex;
  String? get digitalPaymentName => _digitalPaymentName;
  List<Transactions>? get transactions => _transactions;
  List<Data>? get dataList => _dataList;
  List<dynamic>? get additionalList => _additionalList;
  RecordLocationBody? get recordLocationBody => _recordLocation;

  String camelToSentence(String text) {
    var result = text.replaceAll('_', " ");
    var finalResult = result[0].toUpperCase() + result.substring(1);
    return finalResult;
  }

  void setDeliverymanAdditionalJoinUsPageData({bool isUpdate = true}){
    _dataList = [];
    _additionalList = [];
    if(Get.find<SplashController>().configModel!.deliverymanAdditionalJoinUsPageData != null) {
      for (var data in Get.find<SplashController>().configModel!.deliverymanAdditionalJoinUsPageData!.data!) {
        int index = Get.find<SplashController>().configModel!.deliverymanAdditionalJoinUsPageData!.data!.indexOf(data);
        _dataList!.add(data);
        if(data.fieldType == 'text' || data.fieldType == 'number' || data.fieldType == 'email' || data.fieldType == 'phone'){
          _additionalList!.add(TextEditingController());
        } else if(data.fieldType == 'date') {
          _additionalList!.add(null);
        } else if(data.fieldType == 'check_box') {
          _additionalList!.add([]);
          if(data.checkData != null) {
            for (var element in data.checkData!) {
              _additionalList![index].add(0);
            }
          }
        } else if(data.fieldType == 'file') {
          _additionalList!.add([]);
        }
      }
    }

    if (kDebugMode) {
      print('---ss---s---: $_additionalList');
    }
    if(isUpdate) {
      update();
    }
  }

  void setAdditionalDate(int index, String date) {
    _additionalList![index] = date;
    update();
  }

  void setAdditionalCheckData(int index, int i, String date) {
    if(_additionalList![index][i] == date){
      _additionalList![index][i] = 0;
    } else {
      _additionalList![index][i] = date;
    }
    update();
  }

  Future<void> pickFile(int index, MediaData mediaData) async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['jpg', 'pdf', 'doc'],
    //   allowMultiple: false,
    // );
    List<String> permission = [];
    if(mediaData.image == 1) {
      permission.add('jpg');
    }
    if(mediaData.pdf == 1) {
      permission.add('pdf');
    }
    if(mediaData.docs == 1) {
      permission.add('doc');
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: permission,
      allowMultiple: false,
    );
    if(result != null) {
      if (kDebugMode) {
        print('===file size : ${result.files.single.size}');
      }
      if(result.files.single.size > 2000000) {
        showCustomSnackBar('please_upload_lower_size_file'.tr);
      } else {
        _additionalList![index].add(result);
      }
    }
    update();
  }

  void removeAdditionalFile(int index, int subIndex) {
    _additionalList![index].removeAt(subIndex);
    update();
  }

  void showHidePass({bool isUpdate = true}){
    _showPassView = ! _showPassView;
    if(isUpdate) {
      update();
    }
  }

  Future<ResponseModel> login(String phone, String password) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(phone, password);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body['token'], response.body['topic']);
      await authRepo.updateToken();
      responseModel = ResponseModel(true, 'successful');
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> getProfile() async {
    Response response = await authRepo.getProfileInfo();
    if (response.statusCode == 200) {
      _profileModel = ProfileModel.fromJson(response.body);
      if (_profileModel!.active == 1) {
        LocationPermission permission = await Geolocator.checkPermission();
        if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever
            || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
          Get.dialog(ConfirmationDialog(
            icon: Images.locationPermission,
            iconSize: 200,
            hasCancel: false,
            description: 'this_app_collects_location_data'.tr,
            onYesPressed: () {
              Get.back();
              _checkPermission(() => startLocationRecord());
            },
          ), barrierDismissible: false);
        }else {
          startLocationRecord();
        }
      } else {
        stopLocationRecord();
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<bool> updateUserInfo(ProfileModel updateUserModel, String token) async {
    _isLoading = true;
    update();
    http.StreamedResponse response = await authRepo.updateProfile(updateUserModel, _pickedFile, token);
    _isLoading = false;
    bool isSuccess;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map["message"];
      _profileModel = updateUserModel;
      showCustomSnackBar(message, isError: false);
      isSuccess = true;
    } else {
      ApiChecker.checkApi(Response(statusCode: response.statusCode, statusText: '${response.statusCode} ${response.reasonPhrase}'));
      isSuccess = false;
    }
    update();
    return isSuccess;
  }

  void pickImage() async {
    _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    update();
  }

  Future<bool> changePassword(ProfileModel updatedUserModel, String password) async {
    _isLoading = true;
    update();
    bool isSuccess;
    Response response = await authRepo.changePassword(updatedUserModel, password);
    _isLoading = false;
    if (response.statusCode == 200) {
      String? message = response.body["message"];
      showCustomSnackBar(message, isError: false);
      isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      isSuccess = false;
    }
    update();
    return isSuccess;
  }

  Future<bool> updateActiveStatus({int? shiftId, bool isUpdate = false}) async {
    _shiftLoading = true;
    if(isUpdate){
      update();
    }
    Response response = await authRepo.updateActiveStatus(shiftId: shiftId);
    bool isSuccess;
    if (response.statusCode == 200) {
      _profileModel!.active = _profileModel!.active == 0 ? 1 : 0;
      showCustomSnackBar(response.body['message'], isError: false);
      isSuccess = true;
      if (_profileModel!.active == 1) {
        LocationPermission permission = await Geolocator.checkPermission();
        if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever
            || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
          Get.dialog(ConfirmationDialog(
            icon: Images.locationPermission,
            iconSize: 200,
            hasCancel: false,
            description: 'this_app_collects_location_data'.tr,
            onYesPressed: () {
              Get.back();
              _checkPermission(() => startLocationRecord());
            },
          ), barrierDismissible: false);
        }else {
          startLocationRecord();
        }
      } else {
        stopLocationRecord();
      }
    } else {
      ApiChecker.checkApi(response);
      isSuccess = false;
    }
    _shiftLoading = false;
    update();
    return isSuccess;
  }

  void startLocationRecord() {
    // _location.enableBackgroundMode(enable: true);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      recordLocation();
    });
  }

  void stopLocationRecord() {
    // _location.enableBackgroundMode(enable: false);
    _timer?.cancel();
  }

  Future<void> recordLocation() async {
    //customPrint('--------------Adding location');
    final Position locationResult = await Geolocator.getCurrentPosition();

    customPrint('This is current Location: Latitude: ${locationResult.latitude} Longitude: ${locationResult.longitude}');
    String address;
    try{
      List<geo_coding.Placemark> addresses = await geo_coding.placemarkFromCoordinates(locationResult.latitude, locationResult.longitude);
      geo_coding.Placemark placeMark = addresses.first;
      address = '${placeMark.name}, ${placeMark.subAdministrativeArea}, ${placeMark.isoCountryCode}';
    }catch(e) {
      address = 'Unknown Location Found';
    }
    _recordLocation = RecordLocationBody(
      location: address, latitude: locationResult.latitude, longitude: locationResult.longitude,
    );

    Response response = await authRepo.recordLocation(_recordLocation!);
    if(response.statusCode == 200) {
      customPrint('--------------Added record Lat: ${_recordLocation!.latitude} Lng: ${_recordLocation!.longitude} Loc: ${_recordLocation!.location}');
    }else {
      customPrint('--------------Failed record');
    }
  }


  double getRestaurantDistance(LatLng storeLatLng, {LatLng? customerLatLng}) {
    double distance = 0;
    distance = Geolocator.distanceBetween(storeLatLng.latitude, storeLatLng.longitude,
        customerLatLng?.latitude ?? _recordLocation?.latitude ?? 0,
        customerLatLng?.longitude ?? _recordLocation?.longitude??0
    ) / 1000;

    return distance;
  }

  Future<ResponseModel> forgetPassword(String? email) async {
    _isLoading = true;
    update();
    Response response = await authRepo.forgetPassword(email);

    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> updateToken() async {
    await authRepo.updateToken();
  }

  Future<ResponseModel> verifyToken(String? number) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyToken(number, _verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> resetPassword(String? resetToken, String phone, String password, String confirmPassword) async {
    _isLoading = true;
    update();
    Response response = await authRepo.resetPassword(resetToken, phone, password, confirmPassword);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  String _verificationCode = '';

  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    update();
  }


  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    return await authRepo.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password, String countryCode) {
    authRepo.saveUserNumberAndPassword(number, password, countryCode);
  }

  String getUserNumber() {
    return authRepo.getUserNumber();
  }

  String getUserCountryCode() {
    return authRepo.getUserCountryCode();
  }

  String getUserPassword() {
    return authRepo.getUserPassword();
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    authRepo.setNotificationActive(isActive);
    update();
    return _notification;
  }

  void initData() {
    _pickedFile = null;
    _shiftId = null;
  }

  void _checkPermission(Function callback) async {
    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied
        || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
      Get.dialog(CustomAlertDialog(description: 'you_denied'.tr, onOkPressed: () async {
        Get.back();
        await Geolocator.requestPermission();
        _checkPermission(callback);
      }), barrierDismissible: false);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(CustomAlertDialog(description: 'you_denied_forever'.tr, onOkPressed: () async {
        Get.back();
        await Geolocator.openAppSettings();
        _checkPermission(callback);
      }), barrierDismissible: false);
    }else {
      callback();
    }
  }

  Future removeDriver() async {
    _isLoading = true;
    update();
    Response response = await authRepo.deleteDriver();
    _isLoading = false;
    if (response.statusCode == 200) {
      showCustomSnackBar('your_account_remove_successfully'.tr, isError: false);
      Get.find<AuthController>().clearSharedData();
      Get.find<AuthController>().stopLocationRecord();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }else{
      Get.back();
      ApiChecker.checkApi(response);
    }
  }

  void setDMTypeIndex(int? dmType, bool notify) {
    _dmTypeIndex = dmType!;
    if(notify) {
      update();
    }
  }

  void removeDmImage(){
    _pickedImage = null;
    update();
  }

  void setZoneIndex(int? index) {
    _selectedZoneIndex = index;
    update();
  }

  Future<void> getZoneList() async {
    _pickedLogo = null;
    _pickedCover = null;
    _selectedZoneIndex = 0;
    _restaurantLocation = null;
    _zoneIds = null;
    Response response = await authRepo.getZoneList();
    if (response.statusCode == 200) {
      _zoneList = [];
      response.body.forEach((zone) => _zoneList!.add(ZoneModel.fromJson(zone)));
      setLocation(LatLng(
        double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
        double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
      ));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getShiftList() async {
    _shifts = null;
    _isLoading = true;
    Response response = await authRepo.getShiftList();
    if (response.statusCode == 200) {
      _shifts = [];
      response.body.forEach((shift) => _shifts!.add(ShiftModel.fromJson(shift)));
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void setShiftId(int? id){
    _shiftId = id;
    update();
  }

  void setLocation(LatLng location) async {
    ZoneResponseModel response = await getZone(
      location.latitude.toString(), location.longitude.toString(), false,
    );
    if(response.isSuccess && response.zoneIds.isNotEmpty) {
      _restaurantLocation = location;
      _zoneIds = response.zoneIds;
      for(int index=0; index<_zoneList!.length; index++) {
        if(_zoneIds!.contains(_zoneList![index].id)) {
          _selectedZoneIndex = index;
          break;
        }
      }
    }else {
      _restaurantLocation = null;
      _zoneIds = null;
    }
    update();
  }

  Future<ZoneResponseModel> getZone(String lat, String long, bool markerLoad, {bool updateInAddress = false}) async {
    if(markerLoad) {
      _loading = true;
    }else {
      _isLoading = true;
    }
    if(!updateInAddress){
      update();
    }
    ZoneResponseModel responseModel;
    Response response = await authRepo.getZone(lat, long);
    if(response.statusCode == 200) {
      _inZone = true;
      _zoneID = int.parse(jsonDecode(response.body['zone_id'])[0].toString());
      List<int> zoneIds = [];
      jsonDecode(response.body['zone_id']).forEach((zoneId){
        zoneIds.add(int.parse(zoneId.toString()));
      });
      List<ZoneData> zoneData = [];
      response.body['zone_data'].forEach((zone) => zoneData.add(ZoneData.fromJson(zone)));
      responseModel = ZoneResponseModel(true, '' , zoneIds, zoneData);
      if(updateInAddress) {
        AddressModel address = getUserAddress()!;
        address.zoneData = zoneData;
        saveUserAddress(address);
      }
    }else {
      _inZone = false;
      responseModel = ZoneResponseModel(false, response.statusText, [], []);
    }
    if(markerLoad) {
      _loading = false;
    }else {
      _isLoading = false;
    }
    update();
    return responseModel;
  }

  AddressModel? getUserAddress() {
    AddressModel? addressModel;
    try {
      addressModel = AddressModel.fromJson(jsonDecode(authRepo.getUserAddress()!));
    }catch(_) {}
    return addressModel;
  }

  Future<bool> saveUserAddress(AddressModel address) async {
    String userAddress = jsonEncode(address.toJson());
    return await authRepo.saveUserAddress(userAddress);
  }

  void setIdentityTypeIndex(String? identityType, bool notify) {
    int index0 = 0;
    for(int index=0; index<_identityTypeList.length; index++) {
      if(_identityTypeList[index] == identityType) {
        index0 = index;
        break;
      }
    }
    _identityTypeIndex = index0;
    if(notify) {
      update();
    }
  }

  void pickDmImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedImage = null;
      _pickedIdentities = [];
    }else {
      if (isLogo) {
        XFile? pickLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
        if(pickLogo != null) {
          pickLogo.length().then((value) {
            if(value > 2000000) {
              showCustomSnackBar('please_upload_lower_size_file'.tr);
            }else {
              _pickedImage = pickLogo;
            }
          });
        }

      } else {
        XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
        if(xFile != null) {
          xFile.length().then((value) {
            if(value > 2000000) {
              showCustomSnackBar('please_upload_lower_size_file'.tr);
            } else {
              _pickedIdentities.add(xFile);
            }
          });
        }
      }
      update();
    }
  }

  void removeIdentityImage(int index) {
    _pickedIdentities.removeAt(index);
    update();
  }

  Future<void> registerDeliveryMan(Map<String, String> data, List<FilePickerResult> additionalDocuments, List<String> inputTypeList) async {
    _isLoading = true;
    update();
    List<MultipartBody> multiParts = [];
    multiParts.add(MultipartBody('image', _pickedImage));
    for(XFile file in _pickedIdentities) {
      multiParts.add(MultipartBody('identity_image[]', file));
    }

    List<MultipartDocument> multiPartsDocuments = [];
    List<String> dataName = [];
    for(String data in inputTypeList) {
      dataName.add('additional_documents[$data]');
    }
    for(FilePickerResult file in additionalDocuments) {
      int index = additionalDocuments.indexOf(file);
      multiPartsDocuments.add(MultipartDocument('${dataName[index]}[]', file));
    }

    Response response = await authRepo.registerDeliveryMan(data, multiParts, multiPartsDocuments);
    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getSignInRoute());
      showCustomSnackBar('delivery_man_registration_successful'.tr, isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> getVehicleList() async {
    Response response = await authRepo.getVehicleList();
    if (response.statusCode == 200) {
      _vehicles = [];
      _vehicleIds = [];
      _vehicleIds!.add(0);
      response.body.forEach((vehicle) => _vehicles!.add(VehicleModel.fromJson(vehicle)));
      response.body.forEach((vehicle) => _vehicleIds!.add(VehicleModel.fromJson(vehicle).id));

    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setVehicleIndex(int? index, bool notify) {
    _vehicleIndex = index;
    if(notify) {
      update();
    }
  }

  void validPassCheck(String pass, {bool isUpdate = true}) {
    _lengthCheck = false;
    _numberCheck = false;
    _uppercaseCheck = false;
    _lowercaseCheck = false;
    _spatialCheck = false;

    if(pass.length > 7){
      _lengthCheck = true;
    }
    if(pass.contains(RegExp(r'[a-z]'))){
      _lowercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[A-Z]'))){
      _uppercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[ .!@#$&*~^%]'))){
      _spatialCheck = true;
    }
    if(pass.contains(RegExp(r'[\d+]'))){
      _numberCheck = true;
    }
    if(isUpdate) {
      update();
    }
  }


  void dmStatusChange(double value, {bool isUpdate = true}){
    _dmStatus = value;
    if(isUpdate) {
      update();
    }
  }

  void setPaymentIndex(int index){
    _paymentIndex = index;
    update();
  }

  void changeDigitalPaymentName(String? name, {bool canUpdate = true}){
    _digitalPaymentName = name;
    if(canUpdate) {
      update();
    }
  }

  Future<ResponseModel> makeCollectCashPayment(double amount, String paymentGatewayName) async {
    _isLoading = true;
    update();
    Response response = await authRepo.makeCollectCashPayment(amount, paymentGatewayName);
    ResponseModel responseModel;
    if (response.statusCode == 200) {

      String redirectUrl = response.body['redirect_link'];
      Get.back();
      if(GetPlatform.isWeb) {

        // html.window.open(redirectUrl,"_self");
      } else{
        Get.toNamed(RouteHelper.getPaymentRoute(redirectUrl));
      }
      responseModel = ResponseModel(true, response.body.toString());
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> makeWalletAdjustment() async {
    _isLoading = true;
    update();
    Response response = await authRepo.makeWalletAdjustment();
    if(response.statusCode == 200) {
      Get.find<AuthController>().getProfile();
      Get.back();
      showCustomSnackBar('wallet_adjustment_successfully'.tr, isError: false);
    }else {
      Get.back();
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> getWalletPaymentList() async {
    _transactions = null;
    Response response = await authRepo.getWalletPaymentList();
    if(response.statusCode == 200) {
      _transactions = [];
      WalletPaymentModel walletPaymentModel = WalletPaymentModel.fromJson(response.body);
      _transactions!.addAll(walletPaymentModel.transactions!);
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


}