import 'package:flutter/material.dart';
import 'package:hexacom_user/common/enums/footer_type_enum.dart';
import 'package:hexacom_user/common/widgets/custom_app_bar_widget.dart';
import 'package:hexacom_user/common/widgets/custom_web_title_widget.dart';
import 'package:hexacom_user/common/widgets/footer_web_widget.dart';
import 'package:hexacom_user/common/widgets/no_data_screen.dart';
import 'package:hexacom_user/features/cart/providers/cart_provider.dart';
import 'package:hexacom_user/features/cart/widgets/button_view_widget.dart';
import 'package:hexacom_user/features/cart/widgets/cart_details_widget.dart';
import 'package:hexacom_user/features/cart/widgets/cart_product_list_widget.dart';
import 'package:hexacom_user/features/checkout/providers/checkout_provider.dart';
import 'package:hexacom_user/features/coupon/providers/coupon_provider.dart';
import 'package:hexacom_user/features/splash/providers/splash_provider.dart';
import 'package:hexacom_user/helper/responsive_helper.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/utill/color_resources.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/images.dart';
import 'package:hexacom_user/helper/price_converter_helper.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  final bool fromDetails;
  const CartScreen({super.key, this.fromDetails = false});

  @override
  Widget build(BuildContext context) {
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<CheckoutProvider>(context, listen: false)
        .setOrderType('delivery', notify: false);
    final TextEditingController couponController = TextEditingController();
    final height = MediaQuery.of(context).size.height;
    bool isSelfPickupActive =
        Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .selfPickup ==
            1;
    bool kmWiseCharge = Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .deliveryManagement!
            .status ??
        false;

    return Scaffold(
      appBar: CustomAppBarWidget(
          title: getTranslated('my_cart', context),
          isBackButtonExist: fromDetails),
      body: Consumer2<CartProvider, CouponProvider>(
        builder: (context, cart, coupon, child) {
          double? deliveryCharge = 0;
          (Provider.of<CheckoutProvider>(context).orderType == 'delivery' &&
                  !kmWiseCharge)
              ? deliveryCharge =
                  Provider.of<SplashProvider>(context, listen: false)
                      .configModel!
                      .deliveryCharge
              : deliveryCharge = 0;
          double itemPrice = 0;
          double discount = 0;
          double tax = 0;
          for (var cartModel in cart.cartList) {
            double unitPrice = cartModel!.price!;
            double unitDiscount = cartModel.discountAmount!;
            int quantity = cartModel.quantity!;

            itemPrice += (unitPrice * quantity);
            discount += (unitDiscount * quantity);

            // Calculate tax on (Price - Discount) as requested
            double unitDiscountedPrice = unitPrice - unitDiscount;
            tax += PriceConverterHelper.calculation(
              unitDiscountedPrice,
              cartModel.product!.tax ?? 0,
              cartModel.product!.taxType ?? 'percent',
              quantity,
            );
          }

          // Round components to 2 decimal places to match display and prevent minor summation errors
          itemPrice = double.parse(itemPrice.toStringAsFixed(2));
          discount = double.parse(discount.toStringAsFixed(2));
          tax = double.parse(tax.toStringAsFixed(2));

          double total =
              itemPrice - discount + tax - coupon.discount! + deliveryCharge!;

          return cart.cartList.isNotEmpty
              ? Container(
                  color: ColorResources.getHomeScreenBackgroundColor(context),
                  padding: EdgeInsets.fromLTRB(18, 15, 18, 15),
                  child: Column(children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeSmall),
                                constraints: BoxConstraints(
                                    minHeight:
                                        !ResponsiveHelper.isDesktop(context) &&
                                                height < 600
                                            ? height
                                            : height - 400),
                                width: Dimensions.webScreenWidth,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomWebTitleWidget(
                                          title:
                                              getTranslated('cart', context)),

                                      if (!ResponsiveHelper.isDesktop(context))
                                        const CartProductListWidget(),
                                      // Product

                                      if (!ResponsiveHelper.isDesktop(context))
                                        CartDetailsWidget(
                                          isSelfPickupActive:
                                              isSelfPickupActive,
                                          kmWiseCharge: kmWiseCharge,
                                          itemPrice: itemPrice,
                                          tax: tax,
                                          discount: discount,
                                          deliveryCharge: deliveryCharge,
                                          total: total,
                                          couponController: couponController,
                                        ),

                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (ResponsiveHelper.isDesktop(
                                              context))
                                            const Expanded(
                                                flex: 6,
                                                child: CartProductListWidget()),
                                          const SizedBox(
                                              width:
                                                  Dimensions.paddingSizeLarge),
                                          if (ResponsiveHelper.isDesktop(
                                              context))
                                            Expanded(
                                                flex: 4,
                                                child: CartDetailsWidget(
                                                  isSelfPickupActive:
                                                      isSelfPickupActive,
                                                  kmWiseCharge: kmWiseCharge,
                                                  itemPrice: itemPrice,
                                                  tax: tax,
                                                  discount: discount,
                                                  deliveryCharge:
                                                      deliveryCharge,
                                                  total: total,
                                                  couponController:
                                                      couponController,
                                                )),
                                        ],
                                      ),
                                      // Order type
                                    ]),
                              ),
                            ),
                            const FooterWebWidget(
                                footerType: FooterType.nonSliver),
                          ],
                        ),
                      ),
                    ),
                    if (!ResponsiveHelper.isDesktop(context))
                      ButtonViewWidget(
                        itemPrice: itemPrice,
                        total: total,
                        deliveryCharge: deliveryCharge,
                        discount: discount,
                      ),
                  ]),
                )
              : NoDataScreen(
                  image: Images.wishListNoData,
                  title: getTranslated('empty_cart', context),
                  subTitle: getTranslated('look_like_have_not_added', context),
                  showFooter: true,
                );
        },
      ),
    );
  }
}
