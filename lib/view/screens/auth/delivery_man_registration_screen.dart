import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/localization_controller.dart';
import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/model/body/delivery_man_body.dart';
import 'package:efood_multivendor_driver/data/model/response/config_model.dart';
import 'package:efood_multivendor_driver/helper/responsive_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/base/custom_dropdown.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_driver/view/base/custom_text_field.dart';
import 'package:efood_multivendor_driver/view/screens/auth/widget/additional_data_section.dart';
import 'package:efood_multivendor_driver/view/screens/auth/widget/pass_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_number/phone_number.dart';

class DeliveryManRegistrationScreen extends StatefulWidget {
  const DeliveryManRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryManRegistrationScreen> createState() => _DeliveryManRegistrationScreenState();
}

class _DeliveryManRegistrationScreenState extends State<DeliveryManRegistrationScreen> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _identityNumberController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _fNameNode = FocusNode();
  final FocusNode _lNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();
  final FocusNode _identityNumberNode = FocusNode();
  String? _countryDialCode;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    if(Get.find<AuthController>().showPassView){
      Get.find<AuthController>().showHidePass(isUpdate: false);
    }
    Get.find<AuthController>().pickDmImage(false, true);
    Get.find<AuthController>().setIdentityTypeIndex(Get.find<AuthController>().identityTypeList[0], false);
    Get.find<AuthController>().setDMTypeIndex(-1, false);
    Get.find<AuthController>().getZoneList();
    Get.find<AuthController>().getVehicleList();
    Get.find<AuthController>().dmStatusChange(0.4, isUpdate: false);
    Get.find<AuthController>().setDeliverymanAdditionalJoinUsPageData(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'delivery_man_registration'.tr, onBackPressed: (){
        if(Get.find<AuthController>().dmStatus != 0.4){
          Get.find<AuthController>().dmStatusChange(0.4);
        }else{
          Get.back();
        }
      }),
      body: GetBuilder<AuthController>(builder: (authController) {
        List<int> zoneIndexList = [];
        List<DropdownItem<int>> zoneList = [];
        List<DropdownItem<int>> vehicleList = [];
        List<DropdownItem<int>> dmTypeList = [];
        List<DropdownItem<int>> identityTypeList = [];

        for(int index=0; index<authController.dmTypeList.length; index++) {
          dmTypeList.add(DropdownItem<int>(value: index, child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${authController.dmTypeList[index]?.tr}'),
            ),
          )));
        }
        for(int index=0; index<authController.identityTypeList.length; index++) {
          identityTypeList.add(DropdownItem<int>(value: index, child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(authController.identityTypeList[index].tr),
            ),
          )));
        }

        if(authController.zoneList != null) {
          for(int index=0; index<authController.zoneList!.length; index++) {
            zoneIndexList.add(index);
          }
        }
        if(authController.zoneList != null) {
          for(int index=0; index<authController.zoneList!.length; index++) {
            zoneIndexList.add(index);
            zoneList.add(DropdownItem<int>(value: index, child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${authController.zoneList![index].name}'),
              ),
            )));
          }
        }
        if(authController.vehicles != null){
          for(int index=0; index<authController.vehicles!.length; index++) {
            vehicleList.add(DropdownItem<int>(value: index + 1, child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${authController.vehicles![index].type}'),
              ),
            )));
          }
        }

        return Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical:  Dimensions.paddingSizeSmall),
            child: Column(children: [
              Text(
                'complete_registration_process_to_serve_as_delivery_man_in_this_platform'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
              ),

              const SizedBox(height: Dimensions.paddingSizeSmall),

              LinearProgressIndicator(
                backgroundColor: Theme.of(context).disabledColor, minHeight: 2,
                value: authController.dmStatus,
              ),
              // const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            ]),
          ),


          Expanded(child: SingleChildScrollView(
            padding:  EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),
            physics: const BouncingScrollPhysics(),
            child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Column(
                children: [
                  Visibility(
                    visible: authController.dmStatus == 0.4,
                    child: Column(children: [

                      Align(alignment: Alignment.center, child: Stack(clipBehavior: Clip.none, children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: authController.pickedImage != null ? GetPlatform.isWeb ? Image.network(
                            authController.pickedImage!.path, width: 150, height: 120, fit: BoxFit.cover,
                          ) : Image.file(
                            File(authController.pickedImage!.path), width: 150, height: 120, fit: BoxFit.cover,
                          ) : SizedBox(
                            width: 150, height: 120,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                              Icon(Icons.photo_camera, size: 38, color: Theme.of(context).disabledColor),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Text(
                                'upload_deliveryman_photo'.tr,
                                style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                              ),
                            ]),
                          ),
                        ),

                        Positioned(
                          bottom: 0, right: 0, top: 0, left: 0,
                          child: InkWell(
                            onTap: () => authController.pickDmImage(true, false),
                            child: DottedBorder(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 1,
                              strokeCap: StrokeCap.butt,
                              dashPattern: const [5, 5],
                              padding: const EdgeInsets.all(0),
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(Dimensions.radiusDefault),
                              child: Visibility(
                                visible: authController.pickedImage != null,
                                child: Center(
                                  child: Container(
                                    margin: const EdgeInsets.all(25),
                                    decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.white), shape: BoxShape.circle,),
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                    child: const Icon(Icons.camera_alt, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        authController.pickedImage != null ? Positioned(
                          bottom: -10, right: -10,
                          child: InkWell(
                            onTap: () => authController.removeDmImage(),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).cardColor, width: 2),
                                shape: BoxShape.circle, color: Theme.of(context).colorScheme.error,
                              ),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              child:  Icon(Icons.remove, size: 18, color: Theme.of(context).cardColor,),
                            ),
                          ),

                        ) : const SizedBox(),
                      ])),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Row(children: [
                        Expanded(child: CustomTextField(
                          titleText: 'first_name'.tr,
                          controller: _fNameController,
                          capitalization: TextCapitalization.words,
                          inputType: TextInputType.name,
                          focusNode: _fNameNode,
                          nextFocus: _lNameNode,
                          prefixIcon: Icons.person,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: CustomTextField(
                          titleText: 'last_name'.tr,
                          controller: _lNameController,
                          capitalization: TextCapitalization.words,
                          inputType: TextInputType.name,
                          focusNode: _lNameNode,
                          nextFocus: _phoneNode,
                          prefixIcon: Icons.person,
                        )),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextField(
                        titleText: ResponsiveHelper.isDesktop(context) ? 'phone'.tr : 'enter_phone_number'.tr,
                        controller: _phoneController,
                        focusNode: _phoneNode,
                        nextFocus: _emailNode,
                        inputType: TextInputType.phone,
                        isPhone: true,
                        onCountryChanged: (CountryCode countryCode) {
                          _countryDialCode = countryCode.dialCode;
                        },
                        countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                            : Get.find<LocalizationController>().locale.countryCode,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextField(
                        titleText: 'email'.tr,
                        controller: _emailController,
                        focusNode: _emailNode,
                        nextFocus: _passwordNode,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextField(
                        titleText: 'password'.tr,
                        controller: _passwordController,
                        focusNode: _passwordNode,
                        nextFocus: _confirmPasswordNode,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        prefixIcon: Icons.lock,
                        onChanged: (value){
                          if(value != null && value.isNotEmpty){
                            if(!authController.showPassView){
                              authController.showHidePass();
                            }
                            authController.validPassCheck(value);
                          }else{
                            if(authController.showPassView){
                              authController.showHidePass();
                            }
                          }
                        },
                      ),

                      authController.showPassView ? const PassView() : const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextField(
                        titleText: 'confirm_password'.tr,
                        hintText: '',
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordNode,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.visiblePassword,
                        prefixIcon: Icons.lock,
                        isPassword: true,
                      ),

                    ]),
                  ),

                  Visibility(
                    visible: authController.dmStatus != 0.4,
                    child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [

                      Row(children: [
                        Expanded(child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).cardColor,
                              border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                          ),
                          child: CustomDropdown<int>(
                            onChange: (int? value, int index) {
                              authController.setDMTypeIndex(index, true);
                            },
                            dropdownButtonStyle: DropdownButtonStyle(
                              height: 45,
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraSmall,
                                horizontal: Dimensions.paddingSizeExtraSmall,
                              ),
                              primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            dropdownStyle: DropdownStyle(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            ),
                            items: dmTypeList,
                            child: Text('select_delivery_type'.tr),
                          ),
                        ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: authController.zoneList != null ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).cardColor,
                              border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                          ),
                          child: CustomDropdown<int>(
                            onChange: (int? value, int index) {
                              authController.setZoneIndex(value);
                            },
                            dropdownButtonStyle: DropdownButtonStyle(
                              height: 45,
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraSmall,
                                horizontal: Dimensions.paddingSizeExtraSmall,
                              ),
                              primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            dropdownStyle: DropdownStyle(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            ),
                            items: zoneList,
                            child: Text('${authController.zoneList![0].name}'),
                          ),
                        ) : const Center(child: CircularProgressIndicator())),
                      ]),

                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      authController.vehicleIds != null ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                        ),
                        child: CustomDropdown<int>(
                          onChange: (int? value, int index) {
                            authController.setVehicleIndex(value, true);
                          },
                          dropdownButtonStyle: DropdownButtonStyle(
                            height: 45,
                            padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraSmall,
                              horizontal: Dimensions.paddingSizeExtraSmall,
                            ),
                            primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          dropdownStyle: DropdownStyle(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          ),
                          items: vehicleList,
                          child: Text('select_vehicle'.tr),
                        ),
                      ) : const CircularProgressIndicator(),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                        ),
                        child: CustomDropdown<int>(
                          onChange: (int? value, int index) {
                            authController.setIdentityTypeIndex(authController.identityTypeList[index], true);
                          },
                          dropdownButtonStyle: DropdownButtonStyle(
                            height: 45,
                            padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraSmall,
                              horizontal: Dimensions.paddingSizeExtraSmall,
                            ),
                            primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          dropdownStyle: DropdownStyle(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          ),
                          items: identityTypeList,
                          child: Text(authController.identityTypeList[0].tr),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextField(
                        titleText: authController.identityTypeIndex == 0 ? 'Ex: XXXXX-XXXXXXX-X'
                            : authController.identityTypeIndex == 1 ? 'L-XXX-XXX-XXX-XXX.' : 'XXX-XXXXX',
                        controller: _identityNumberController,
                        focusNode: _identityNumberNode,
                        inputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: authController.pickedIdentities.length+1,
                        itemBuilder: (context, index) {
                          XFile? file = index == authController.pickedIdentities.length ? null : authController.pickedIdentities[index];
                          if(index == authController.pickedIdentities.length) {
                            return InkWell(
                              onTap: () => authController.pickDmImage(false, false),
                              child: DottedBorder(
                                color: Theme.of(context).primaryColor,
                                strokeWidth: 1,
                                strokeCap: StrokeCap.butt,
                                dashPattern: const [5, 5],
                                padding: const EdgeInsets.all(5),
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(Dimensions.radiusDefault),
                                child: SizedBox(
                                  height: 120, width: double.infinity,
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Icon(Icons.camera_alt, color: Theme.of(context).disabledColor, size: 38),
                                    Text('upload_identity_image'.tr, style: robotoMedium.copyWith(color: Theme.of(context).disabledColor)),
                                  ]),
                                ),
                              ),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                            child: DottedBorder(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 1,
                              strokeCap: StrokeCap.butt,
                              dashPattern: const [5, 5],
                              padding: const EdgeInsets.all(5),
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(Dimensions.radiusDefault),
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: GetPlatform.isWeb ? Image.network(
                                    file!.path, width: double.infinity, height: 120, fit: BoxFit.cover,
                                  ) : Image.file(
                                    File(file!.path), width: double.infinity, height: 120, fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 0, top: 0,
                                  child: InkWell(
                                    onTap: () => authController.removeIdentityImage(index),
                                    child: const Padding(
                                      padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                      child: Icon(Icons.delete_forever, color: Colors.red),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      AdditionalDataSection(authController: authController, scrollController: _scrollController),

                      const SizedBox(height: Dimensions.paddingSizeSmall),

                    //  ConditionCheckBox(authController: authController, fromSignUp: true),
                    ]),
                  ),
                ],
              ),

              const SizedBox(height: Dimensions.paddingSizeLarge),
              //(ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb()) ? buttonView() : const SizedBox(),
              
            ]))),
          )),
          !authController.isLoading ? CustomButton(
            buttonText: authController.dmStatus == 0.4 ? 'next'.tr : 'submit'.tr,
            margin: EdgeInsets.all((ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb()) ? 0 : Dimensions.paddingSizeSmall),
            height: 50,
            onPressed: () => _addDeliveryMan(authController),
          ) : const Center(child: CircularProgressIndicator()),

          const SizedBox(height: Dimensions.paddingSizeSmall),

        ]);
      }),
    );
  }

  void _addDeliveryMan(AuthController authController) async {
    String fName = _fNameController.text.trim();
    String lName = _lNameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPass = _confirmPasswordController.text.trim();
    String identityNumber = _identityNumberController.text.trim();

    bool customFieldEmpty = false;

    Map<String, dynamic> additionalData = {};
    List<FilePickerResult> additionalDocuments = [];
    List<String> additionalDocumentsInputType = [];

    if(authController.dmStatus != 0.4) {
      for (Data data in authController.dataList!) {
        bool isTextField = data.fieldType == 'text' || data.fieldType == 'number' || data.fieldType == 'email' || data.fieldType == 'phone';
        bool isDate = data.fieldType == 'date';
        bool isCheckBox = data.fieldType == 'check_box';
        bool isFile = data.fieldType == 'file';
        int index = authController.dataList!.indexOf(data);
        bool isRequired = data.isRequired == 1;

        if(isTextField) {
          if (kDebugMode) {
            print('=====check text field : ${authController.additionalList![index].text == ''}');
          }
          if(authController.additionalList![index].text != '') {
            additionalData.addAll({data.inputData! : authController.additionalList![index].text});
          } else {
            if(isRequired) {
              customFieldEmpty = true;
              showCustomSnackBar('${data.placeholderData} ${'can_not_be_empty'.tr}');
              break;
            }
          }
        } else if(isDate) {
          if (kDebugMode) {
            print('---check date : ${authController.additionalList![index]}');
          }
          if(authController.additionalList![index] != null) {
            additionalData.addAll({data.inputData! : authController.additionalList![index]});
          } else {
            if(isRequired) {
              customFieldEmpty = true;
              showCustomSnackBar('${data.placeholderData} ${'can_not_be_empty'.tr}');
              break;
            }
          }
        } else if(isCheckBox) {
          List<String> checkData = [];
          bool noNeedToGoElse = false;
          for(var e in authController.additionalList![index]) {
            if(e != 0) {
              checkData.add(e);
              customFieldEmpty = false;
              noNeedToGoElse = true;
            } else if(!noNeedToGoElse) {
              customFieldEmpty = true;
            }
          }
          if(customFieldEmpty && isRequired) {
            showCustomSnackBar( '${'please_set_data_in'.tr} ${authController.camelToSentence(authController.dataList![index].inputData!)} ${'field'.tr}');
            break;
          } else {
            additionalData.addAll({data.inputData! : checkData});
          }

        } else if(isFile) {
          if (kDebugMode) {
            print('---check file : ${authController.additionalList![index]}');
          }
          if(authController.additionalList![index].length == 0 && isRequired) {
            customFieldEmpty = true;
            showCustomSnackBar('${'please_add'.tr} ${authController.camelToSentence(authController.dataList![index].inputData!)}');
            break;
          } else {
            authController.additionalList![index].forEach((file) {
              additionalDocuments.add(file);
              additionalDocumentsInputType.add(authController.dataList![index].inputData!);
            });
          }
        }
      }
    }

    String numberWithCountryCode = _countryDialCode!+phone;
    bool isValid = GetPlatform.isAndroid ? false : true;
    if(GetPlatform.isAndroid) {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(numberWithCountryCode);
        numberWithCountryCode = '+${phoneNumber.countryCode}${phoneNumber.nationalNumber}';
        isValid = true;
      } catch (_) {}
    }
    if(authController.dmStatus == 0.4) {
      if(fName.isEmpty) {
        showCustomSnackBar('enter_delivery_man_first_name'.tr);
      }else if(lName.isEmpty) {
        showCustomSnackBar('enter_delivery_man_last_name'.tr);
      }else if(email.isEmpty) {
        showCustomSnackBar('enter_delivery_man_email_address'.tr);
      }else if(!GetUtils.isEmail(email)) {
        showCustomSnackBar('enter_a_valid_email_address'.tr);
      }else if(phone.isEmpty) {
        showCustomSnackBar('enter_delivery_man_phone_number'.tr);
      }else if(!isValid) {
        showCustomSnackBar('enter_a_valid_phone_number'.tr);
      }else if(password.isEmpty) {
        showCustomSnackBar('enter_password_for_delivery_man'.tr);
      }else if(password.length < 6) {
        showCustomSnackBar('password_should_be'.tr);
      }else if(password != confirmPass) {
        showCustomSnackBar('password_does_not_match'.tr);
      } else if(authController.pickedImage == null) {
        showCustomSnackBar('upload_delivery_man_image'.tr);
      }else{
        authController.dmStatusChange(0.8);
      }
    } else {
      if(authController.dmTypeIndex == -1) {
        showCustomSnackBar('please_select_delivery_type'.tr);
      }else if(authController.vehicleIndex!-1 == -1) {
        showCustomSnackBar('please_select_vehicle_for_the_deliveryman'.tr);
      }else if(identityNumber.isEmpty) {
        showCustomSnackBar('enter_delivery_man_identity_number'.tr);
      }else if(authController.pickedIdentities.isEmpty) {
        showCustomSnackBar('please_add_your_identity_image'.tr);
      }else if(customFieldEmpty) {
        if (kDebugMode) {
          print('not provide addition data');
        }
      }else {

        Map<String, String> data = {};

        data.addAll(DeliveryManBody(
          fName: fName, lName: lName, password: password, phone: numberWithCountryCode, email: email,
          identityNumber: identityNumber, identityType: authController.identityTypeList[authController.identityTypeIndex],
          earning: authController.dmTypeIndex == 1 ? '1' : '0', zoneId: authController.zoneList![authController.selectedZoneIndex!].id.toString(),
          vehicleId: authController.vehicles![authController.vehicleIndex! - 1].id.toString(),
        ).toJson());

        data.addAll({
          'additional_data': jsonEncode(additionalData),
        });

        if (kDebugMode) {
          print('-------final data-- :  $data');
        }

        authController.registerDeliveryMan(data, additionalDocuments, additionalDocumentsInputType);

      }
    }
  }
}



