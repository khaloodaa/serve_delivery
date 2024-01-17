import 'package:efood_multivendor_driver/helper/price_converter.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisbursementStatusCard extends StatelessWidget {
  final double amount;
  final String text;
  final bool isPending;
  final bool isCompleted;
  final bool isCanceled;
  const DisbursementStatusCard({Key? key, required this.amount, this.isPending = false, this.isCompleted = false, this.isCanceled = false, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160, width: context.width * 0.65,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 500 : 200]!, spreadRadius: 0.5, blurRadius: 0.5)],
      ),
      child: Column(children: [

        Align(alignment: Alignment.topRight, child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(color: isPending ? Colors.blue : isCompleted ? Colors.green : Colors.red, shape: BoxShape.circle),
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, shape: BoxShape.circle),
            child: Icon(Icons.info, color: isPending ? Colors.blue : isCompleted ? Colors.green : Colors.red, size: 15,),
          ),
        )),

        Expanded(
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Stack(
              children: [

                Container(
                  height: 50, width: 50,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(color: isPending ? Colors.blue : isCompleted ? Colors.green : Colors.red, shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(Images.transactionReportIcon),
                  ),
                ),

                Positioned(
                  right: 10, top: 10,
                  child: Image.asset(Images.onHoldTransactionIcon, height: 15, width: 15),
                ),
              ],
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                PriceConverter.convertPrice(amount),
                style: robotoBold.copyWith(
                  fontSize: 20, color: isPending ? Colors.blue : isCompleted ? Colors.green : Colors.red,
                ),
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text(
                text,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }
}
