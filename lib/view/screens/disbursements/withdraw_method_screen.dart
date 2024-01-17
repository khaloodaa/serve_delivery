import 'package:efood_multivendor_driver/controller/disbursement_controller.dart';
import 'package:efood_multivendor_driver/data/model/response/disbursement_method_model.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_driver/view/screens/disbursements/widget/confirm_dialog.dart';
import 'package:efood_multivendor_driver/view/screens/disbursements/widget/withdraw_method_attention_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawMethodScreen extends StatefulWidget {
  final bool isFromDashboard;
  const WithdrawMethodScreen({Key? key, required this.isFromDashboard}) : super(key: key);

  @override
  State<WithdrawMethodScreen> createState() => _WithdrawMethodScreenState();
}

class _WithdrawMethodScreenState extends State<WithdrawMethodScreen> {

  @override
  void initState() {
    super.initState();
    initCall();
  }

  initCall() async {
    Get.find<DisbursementController>().getWithdrawMethodList();

    bool warningMessage = widget.isFromDashboard ? false : await Get.find<DisbursementController>().disbursementWarningMessage();
    if (warningMessage) {
      Get.dialog(
        Dialog(
          alignment: Alignment.bottomCenter,
          backgroundColor: const Color(0xfffff1f1),
          insetPadding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
          //this right here
          child: const WithdrawMethodAttentionDialog(isFromDashboard: false),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'withdraw_methods'.tr),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(RouteHelper.getAddWithdrawMethodRoute()),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: GetBuilder<DisbursementController>(builder: (disbursementController) {
        return disbursementController.disbursementMethodBody != null ? disbursementController.disbursementMethodBody!.methods!.isNotEmpty ? ListView.builder(
          itemCount: disbursementController.disbursementMethodBody!.methods!.length,
          shrinkWrap: true,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          // physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Methods method = disbursementController.disbursementMethodBody!.methods![index];
            return Container(
              width: context.width,
              margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(2, 3))],
              ),
              child: Column(children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                    Flexible(
                      child: Text(
                        '${'payment_method'.tr} : ${method.methodName}',
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                    ),

                    method.isDefault == 1 ?  Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      padding: const EdgeInsets.all(Dimensions.fontSizeSmall),
                      child: Text('default_method'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),),
                    ) : InkWell(
                      onTap: () {
                        disbursementController.makeDefaultMethod({'id': '${method.id}', 'is_default': '1'}, index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        padding: const EdgeInsets.all(Dimensions.fontSizeSmall),
                        child: !(disbursementController.isLoading && (index == disbursementController.index))
                            ? Text(
                          'make_default'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor),
                        ) : SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Theme.of(context).cardColor)),
                      ),
                    ),

                  ]),
                ),

                const Divider(height: 1, thickness: 0.5),

                Padding(
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: method.methodFields!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                            child: Row(children: [
                              Expanded(
                                child: Text(method.methodFields![index].userInput!.replaceAll('_', ' '),
                                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                              ),
                              const Text(' :  ', style: robotoRegular),

                              Expanded(
                                child: Text('${method.methodFields![index].userData}',
                                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,),
                              ),

                            ]),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    InkWell(
                      onTap: () {
                        Get.dialog(ConfirmDialog(id: method.id!));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
                        child: Icon(CupertinoIcons.delete, color: Theme.of(context).colorScheme.error, size: 20),
                      ),
                    )
                  ]),
                ),

              ]),

            );
          },
        ) : Center(child: Text('no_method_found'.tr, style: robotoMedium)) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
