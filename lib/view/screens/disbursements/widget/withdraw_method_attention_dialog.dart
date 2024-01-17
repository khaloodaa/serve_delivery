import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawMethodAttentionDialog extends StatelessWidget {
  final bool isFromDashboard;
  const WithdrawMethodAttentionDialog({Key? key, required this.isFromDashboard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * 0.95,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () => Get.back(),
            hoverColor: Colors.transparent,
            child: Container(
              height: 20, width: 20,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).disabledColor.withOpacity(0.05),
              ),
              child: const Icon(Icons.close, size: 15),
            ),
          ),
        ),

        Row(children: [
          Image.asset(Images.attentionWarningIcon, width: 20, height: 20),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text('attention_please'.tr, style: robotoBold.copyWith(color: Colors.black)),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        RichText(
          text: TextSpan(
            text: '${'withdraw_methods_attention_message'.tr}  ',
            style: robotoRegular.copyWith(color: Colors.black),
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()..onTap = () {

                  if(isFromDashboard){
                    Get.back();
                    Get.toNamed(RouteHelper.getWithdrawMethodRoute(isFromDashBoard: isFromDashboard));
                  }else{
                    Get.back();
                  }

                },
                text: 'set_default_withdraw_method'.tr,
                style: robotoRegular.copyWith(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}