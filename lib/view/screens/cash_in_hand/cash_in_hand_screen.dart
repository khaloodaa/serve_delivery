import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/helper/price_converter.dart';
import 'package:efood_multivendor_driver/helper/route_helper.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/base/custom_image.dart';
import 'package:efood_multivendor_driver/view/screens/cash_in_hand/widget/wallet_attention_alert.dart';
import 'package:efood_multivendor_driver/view/screens/cash_in_hand/widget/payment_method_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashInHandScreen extends StatefulWidget {
  const CashInHandScreen({Key? key}) : super(key: key);

  @override
  State<CashInHandScreen> createState() => _CashInHandScreenState();
}

class _CashInHandScreenState extends State<CashInHandScreen> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Get.find<AuthController>().getProfile();
    Get.find<AuthController>().getWalletPaymentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(Get.find<AuthController>().profileModel == null) {
      Get.find<AuthController>().getProfile();
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'my_account'.tr,
        isBackButtonExist: true,
        actionWidget: Container(
          height: 35, width: 35,
          margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          child: GetBuilder<AuthController>(builder: (authController) {
            return Container(
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: Theme.of(context).cardColor)),
              margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: CustomImage(
                  image: '${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}'
                      '/${(authController.profileModel != null && Get.find<AuthController>().isLoggedIn()) ? authController.profileModel!.image ?? '' : ''}',
                  width: 35, height: 35, fit: BoxFit.cover,
                ),
              ),
            );
          }),
        ),
      ),

      body: GetBuilder<AuthController>(builder: (authController) {
        return (authController.profileModel != null && authController.transactions != null) ? RefreshIndicator(
          onRefresh: () async {
            authController.getProfile();
            Get.find<AuthController>().getWalletPaymentList();
            return await Future.delayed(const Duration(seconds: 1));
          },
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(children: [

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(children: [
                    Container(
                      width: context.width, height: 129,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: const Color(0xff334257),
                        image: const DecorationImage(
                          image: AssetImage(Images.cashInHandBg),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Row(
                                children: [
                                  Image.asset(Images.walletIcon, width: 40, height: 40),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),
                                  Text('payable_amount'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor)),
                                ],
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault),

                              Text(PriceConverter.convertPrice(authController.profileModel!.payableBalance), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).cardColor)),
                            ]),
                          ),

                          Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                            authController.profileModel!.adjustable! ? InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return GetBuilder<AuthController>(builder: (controller) {
                                      return AlertDialog(
                                        title: Center(child: Text('cash_adjustment'.tr)),
                                        content: Text('cash_adjustment_description'.tr, textAlign: TextAlign.center),
                                        actions: [

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(children: [

                                              Expanded(
                                                child: CustomButton(
                                                  onPressed: () => Get.back(),
                                                  backgroundColor: Theme.of(context).disabledColor.withOpacity(0.5),
                                                  buttonText: 'cancel'.tr,
                                                ),
                                              ),
                                              const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    authController.makeWalletAdjustment();
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                    child: !controller.isLoading ? Text('ok'.tr, style: robotoBold.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeLarge),)
                                                        : const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)),
                                                  ),
                                                ),
                                              ),

                                            ]),
                                          ),

                                        ],
                                      );
                                    });
                                  }
                                );
                              },
                              child: Container(
                                width: 115,
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Text('adjust_payments'.tr, textAlign: TextAlign.center, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor)),
                              ),
                            ) : const SizedBox(),
                            SizedBox(height: authController.profileModel!.adjustable! ? Dimensions.paddingSizeLarge : 0),

                            InkWell(
                              onTap: authController.profileModel!.cashInHands! > 0 ? () {
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
                              } : null,
                              child: Container(
                                width: authController.profileModel!.adjustable! ? 115 : null,
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: authController.profileModel!.cashInHands! > 0 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withOpacity(0.8),
                                ),
                                child: Text('pay_now'.tr, textAlign: TextAlign.center, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor)),
                              ),
                            ),

                          ]),
                        ]),
                      ),

                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Row(children: [

                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).cardColor,
                            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 0.5, blurRadius: 5)],
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                            Text(
                              PriceConverter.convertPrice(authController.profileModel!.cashInHands),
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Text('cash_in_hand'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),

                          ]),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).cardColor,
                            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 0.5, blurRadius: 5)],
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                            Text(
                              PriceConverter.convertPrice(authController.profileModel!.totalWithdrawn),
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Text('withdrawal_amount'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),

                          ]),
                        ),
                      ),

                    ]),
                    const SizedBox(height:Dimensions.paddingSizeSmall),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('transaction_history'.tr, style: robotoMedium),
                      InkWell(
                        onTap: () => Get.toNamed(RouteHelper.getTransactionHistoryRoute()),
                        child: Padding(
                          padding:  const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text('view_all'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor,decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                    ]),

                    authController.transactions!.isNotEmpty ? ListView.builder(
                      itemCount: authController.transactions!.length > 25 ? 25 : authController.transactions!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                            child: Row(children: [
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(PriceConverter.convertPrice(authController.transactions![index].amount), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault), textDirection: TextDirection.ltr,),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                  Text('${'paid_via'.tr} ${authController.transactions![index].method?.replaceAll('_', ' ').capitalize??''}', style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                                  )),
                                ]),
                              ),
                              Text(authController.transactions![index].paymentTime.toString(),
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                              ),
                            ]),
                          ),

                          const Divider(height: 1),
                        ]);
                      },
                    ) : Padding(padding: const EdgeInsets.only(top: 250), child: Text('no_transaction_found'.tr)),

                  ]),

                ),
              ),

              (authController.profileModel!.overFlowWarning! || authController.profileModel!.overFlowBlockWarning!)
                  ? WalletAttentionAlert(isOverFlowBlockWarning: authController.profileModel!.overFlowBlockWarning!) : const SizedBox(),

            ]),
          ),
        ) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
