import 'package:hexacom_user/features/auth/providers/auth_provider.dart';
import 'package:hexacom_user/features/cart/widgets/button_view_widget.dart';
import 'package:hexacom_user/features/cart/widgets/cart_coupon_widget.dart';
import 'package:hexacom_user/features/cart/widgets/select_delivery_type_widget.dart';
import 'package:hexacom_user/features/coupon/providers/coupon_provider.dart';
import 'package:hexacom_user/helper/price_converter_helper.dart';
import 'package:hexacom_user/helper/responsive_helper.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item_widget.dart';

class CartDetailsWidget extends StatelessWidget {
  final bool isSelfPickupActive;
  final bool kmWiseCharge;
  final double itemPrice;
  final double tax;
  final double discount;
  final double deliveryCharge;
  final double total;
  final TextEditingController couponController;

  const CartDetailsWidget({
    super.key,
    required this.isSelfPickupActive,
    required this.kmWiseCharge,
    required this.itemPrice,
    required this.tax,
    required this.discount,
    required this.deliveryCharge,
    required this.total,
    required this.couponController,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Column(
      children: [
        isSelfPickupActive
            ? Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).shadowColor, blurRadius: 10)
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getTranslated('delivery_option', context),
                          style: rubikBold.copyWith(fontSize: 18)),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      SelectDeliveryTypeWidget(
                          value: 'delivery',
                          title: getTranslated('delivery', context),
                          kmWiseFee: kmWiseCharge),
                      SelectDeliveryTypeWidget(
                          value: 'self_pickup',
                          title: getTranslated('self_pickup', context),
                          kmWiseFee: kmWiseCharge),
                    ]),
              )
            : const SizedBox(),
        SizedBox(
            height: isSelfPickupActive ? Dimensions.paddingSizeDefault : 0),
        Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 10)
            ],
          ),
          child: Column(
            children: [
              if (isLoggedIn)
                const SizedBox(height: Dimensions.paddingSizeSmall),
              CartCouponWidget(
                  couponTextController: couponController, totalAmount: total),
              //
              const SizedBox(height: Dimensions.paddingSizeLarge),

              // Total
              CartItemWidget(
                title: getTranslated('items_price', context),
                subTitle: PriceConverterHelper.convertPrice(itemPrice),
                style:
                    rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: 10),

              CartItemWidget(
                title: getTranslated('tax', context),
                subTitle: PriceConverterHelper.convertPrice(tax),
                style:
                    rubikMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
              ),
              const SizedBox(height: 10),

              CartItemWidget(
                title: getTranslated('discount', context),
                subTitle: '- ${PriceConverterHelper.convertPrice(discount)}',
                style:
                    rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: 10),

              if (isLoggedIn) ...[
                CartItemWidget(
                  title: getTranslated('coupon_discount', context),
                  subTitle:
                      '- ${PriceConverterHelper.convertPrice(Provider.of<CouponProvider>(context).discount)}',
                  style: rubikMedium.copyWith(
                      fontSize: Dimensions.fontSizeDefault),
                ),
                const SizedBox(height: 10),
              ],

              // kmWiseCharge ? const SizedBox() : CartItemWidget(
              //   title: getTranslated('1delivery_fee', context),
              //   subTitle: PriceConverterHelper.convertPrice(deliveryCharge),
              // ),

              const Divider(
                height: 20,
                thickness: 2,
              ),

              CartItemWidget(
                title: getTranslated(
                    kmWiseCharge ? 'subtotal' : 'total_amount', context),
                subTitle: PriceConverterHelper.convertPrice(total),
                style: rubikBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),

              SizedBox(height: ResponsiveHelper.isDesktop(context) ? 10 : 0),
              if (ResponsiveHelper.isDesktop(context))
                ButtonViewWidget(
                  itemPrice: itemPrice,
                  total: total,
                  deliveryCharge: deliveryCharge,
                  discount: discount,
                ),
            ],
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
      ],
    );
  }
}
