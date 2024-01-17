import 'package:efood_multivendor_driver/data/model/response/disbursement_report_model.dart';
import 'package:efood_multivendor_driver/helper/price_converter.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentInformationDialog extends StatelessWidget {
  final Disbursements disbursement;
  const PaymentInformationDialog({Key? key, required this.disbursement,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width * 0.9,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () => Get.back(),
            hoverColor: Colors.transparent,
            child: Container(
              height: 30, width: 30,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).disabledColor.withOpacity(0.05),
              ),
              child: const Icon(Icons.close, size: 20),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(children: [

            disbursement.status == 'completed' ? Column(children: [
              Text("payment_information".tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Text(
                "you_payment_has_been_completed_your_will_receive_the_amount_within_7_day_please_wait_till_then".tr,
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(color: Colors.green),
              ),
            ]) : const SizedBox(),

            const SizedBox(height: Dimensions.paddingSizeDefault),

            Align(
              alignment: Alignment.centerLeft,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("payment_information".tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('payment_method'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),

                  Text(disbursement.withdrawMethod!.methodName!, style: robotoBold),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('amount'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),

                  Text(PriceConverter.convertPrice(disbursement.disbursementAmount), style: robotoBold),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('disbursement_id'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),

                  Text(disbursement.id.toString(), style: robotoBold),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('status'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color: Colors.green.withOpacity(0.1),
                    ),
                    child: Text(disbursement.status!.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.green)),
                  ),
                ]),

              ]),
            ),

          ]),
        ),

      ]),
    );
  }
}