import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/screens/cash_in_hand/widget/payment_method_bottom_sheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletAttentionAlert extends StatelessWidget {
  final bool isOverFlowBlockWarning;
  const WalletAttentionAlert({Key? key, required this.isOverFlowBlockWarning}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * 0.95,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: const Color(0xfffff1f1),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

        Row(children: [
          Image.asset(Images.attentionWarningIcon, width: 20, height: 20),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text('attention_please'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        isOverFlowBlockWarning ? RichText(
          text: TextSpan(
            text: '${'over_flow_block_warning_message'.tr}  ',
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color),
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()..onTap = () {
                  showModalBottomSheet(
                    isScrollControlled: true, useRootNavigator: true, context: context,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge)),
                    ),
                    builder: (context) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                        child: const PaymentMethodBottomSheet(),
                      );
                    },
                  );
                },
                text: 'pay_the_due'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ],
          ),
        ) : Text('over_flow_warning_message'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color)),
      ]),
    );
  }
}