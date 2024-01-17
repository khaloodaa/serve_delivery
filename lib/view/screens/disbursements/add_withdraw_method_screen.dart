import 'package:efood_multivendor_driver/controller/disbursement_controller.dart';
import 'package:efood_multivendor_driver/helper/date_converter.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/base/custom_dropdown.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_driver/view/base/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddWithDrawMethodScreen extends StatefulWidget {
  const AddWithDrawMethodScreen({Key? key}) : super(key: key);

  @override
  State<AddWithDrawMethodScreen> createState() => _AddWithDrawMethodScreenState();
}

class _AddWithDrawMethodScreenState extends State<AddWithDrawMethodScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<DisbursementController>().setMethod(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<DisbursementController>(builder: (disbursementController) {

      return Scaffold(
        appBar: CustomAppBar(title: 'add_withdraw_method'.tr),

        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text("payment_method".tr, style: robotoBold),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Theme.of(context).cardColor,
                      border: Border.all(color: Theme.of(context).primaryColor, width: 0.3),
                    ),
                    child: CustomDropdown<int>(
                      onChange: (int? value, int index) {
                        disbursementController.setMethodId(index);
                        disbursementController.setMethod();
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
                      items: disbursementController.methodList,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          disbursementController.widthDrawMethods != null && disbursementController.widthDrawMethods!.isNotEmpty
                              ? disbursementController.widthDrawMethods![0].methodName! : 'select_payment_method'.tr,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: disbursementController.methodFields.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(children: [

                        Row(
                          children: [
                            Expanded(
                              child: MyTextField(
                                titleName: disbursementController.methodFields[index].inputName.toString().replaceAll('_', ' '),
                                hintText: disbursementController.methodFields[index].placeholder,
                                controller: disbursementController.textControllerList[index],
                                capitalization: TextCapitalization.words,
                                inputType: disbursementController.methodFields[index].inputType == 'phone' ? TextInputType.phone : disbursementController.methodFields[index].inputType == 'number'
                                    ? TextInputType.number : disbursementController.methodFields[index].inputType == 'email' ? TextInputType.emailAddress : TextInputType.name,
                                focusNode: disbursementController.focusList[index],
                                nextFocus: index != disbursementController.methodFields.length-1 ? disbursementController.focusList[index + 1] : null,
                                isRequired: disbursementController.methodFields[index].isRequired == 1,
                              ),
                            ),

                            disbursementController.methodFields[index].inputType == 'date' ?
                            IconButton(
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  String formattedDate = DateConverter.dateTimeForCoupon(pickedDate);
                                  setState(() {
                                    disbursementController.textControllerList[index].text = formattedDate;
                                  });
                                }

                              },
                              icon: const Icon(Icons.date_range_sharp),
                            ) : const SizedBox(),
                          ],
                        ),
                        SizedBox(height: index != disbursementController.methodFields.length-1 ? Dimensions.paddingSizeLarge : 0),

                      ]);
                    }),

                ]),
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5)],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeSmall),
                child: !disbursementController.isLoading ? CustomButton(
                  buttonText: 'add_method'.tr,
                  onPressed: () {
                    bool fieldEmpty = false;
                    for (var element in disbursementController.methodFields) {
                      if(element.isRequired == 1){
                        if(disbursementController.textControllerList[disbursementController.methodFields.indexOf(element)].text.isEmpty){
                          fieldEmpty = true;
                        }
                      }
                    }

                    if(fieldEmpty){
                      showCustomSnackBar('required_fields_can_not_be_empty'.tr);
                    }else{
                      Map<String?, String> data = {};
                      data['withdraw_method_id'] = disbursementController.widthDrawMethods![disbursementController.selectedMethodIndex!].id.toString();
                      for (var result in disbursementController.methodFields) {
                        data[result.inputName] = disbursementController.textControllerList[disbursementController.methodFields.indexOf(result)].text.trim();
                      }
                      disbursementController.addWithdrawMethod(data);
                    }
                  },
                ) : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),

        ]),
      );
    });
  }
}
