import 'package:hexacom_user/common/models/cart_model.dart';
import 'package:hexacom_user/common/widgets/custom_directionality_widget.dart';
import 'package:hexacom_user/common/widgets/custom_shadow_widget.dart';
import 'package:hexacom_user/common/widgets/custom_text_field_widget.dart';
import 'package:hexacom_user/features/cart/widgets/cart_item_widget.dart';
import 'package:hexacom_user/features/checkout/widgets/payment_info_widget.dart';
import 'package:hexacom_user/features/checkout/widgets/place_order_button_view.dart';
import 'package:hexacom_user/features/checkout/widgets/shipping_options_widget.dart';
import 'package:hexacom_user/features/order/providers/order_provider.dart';
import 'package:hexacom_user/helper/price_converter_helper.dart';
import 'package:hexacom_user/helper/responsive_helper.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsViewWidget extends StatefulWidget {
  final bool kmWiseCharge;
  final bool selfPickup;
  final double deliveryCharge;
  final double amount;
  final TextEditingController orderNoteController;
  final List<CartModel?> cartList;
  final String? orderType;
  final ScrollController? scrollController;
  final GlobalKey? dropdownKey;
  final Carrier? carierSelected;
  final String carrierShipmentID;
  final ValueNotifier<Carrier?>? carrierNotifier;

  const DetailsViewWidget(
      {super.key,
      required this.kmWiseCharge,
      required this.selfPickup,
      required this.deliveryCharge,
      required this.orderNoteController,
      required this.amount,
      required this.cartList,
      required this.orderType,
      required this.carierSelected,
      required this.carrierShipmentID,
      this.carrierNotifier,
      this.scrollController,
      this.dropdownKey});

  @override
  State<DetailsViewWidget> createState() => _DetailsViewWidgetState();
}

class _DetailsViewWidgetState extends State<DetailsViewWidget> {
  Carrier? _currentCarrier;

  @override
  void initState() {
    super.initState();
    _currentCarrier = widget.carierSelected;

    // Debug print to check initial values
    debugPrint('=== DetailsViewWidget initState ===');
    debugPrint('Initial carierSelected: ${widget.carierSelected}');
    debugPrint('Initial deliveryCharge: ${widget.deliveryCharge}');
    debugPrint('Current carrier amount: ${_currentCarrier?.amount}');
    debugPrint('Self pickup: ${widget.selfPickup}');

    widget.carrierNotifier?.addListener(_onCarrierChanged);
  }

  @override
  void dispose() {
    widget.carrierNotifier?.removeListener(_onCarrierChanged);
    super.dispose();
  }

  void _onCarrierChanged() {
    if (mounted) {
      setState(() {
        _currentCarrier = widget.carrierNotifier?.value;
      });

      // Debug print when carrier changes
      debugPrint('=== Carrier Changed ===');
      debugPrint('New carrier: $_currentCarrier');
      debugPrint('New carrier amount: ${_currentCarrier?.amount}');
    }
  }

  @override
  void didUpdateWidget(DetailsViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.carierSelected != widget.carierSelected) {
      setState(() {
        _currentCarrier = widget.carierSelected;
      });

      // Debug print when widget updates
      debugPrint('=== Widget Updated ===');
      debugPrint('Old carrier: ${oldWidget.carierSelected}');
      debugPrint('New carrier: ${widget.carierSelected}');
      debugPrint('New carrier amount: ${_currentCarrier?.amount}');
    }
  }

  // Modified delivery fee calculation with fallback options
  double get _deliveryFee {
    // Option 1: Use current carrier amount
    if (_currentCarrier?.amount != null && _currentCarrier!.amount > 0) {
      debugPrint('Using carrier amount: ${_currentCarrier!.amount}');
      return _currentCarrier!.amount;
    }

    // Option 2: Use widget deliveryCharge as fallback
    if (widget.deliveryCharge > 0 && !widget.selfPickup) {
      debugPrint('Using widget deliveryCharge: ${widget.deliveryCharge}');
      return widget.deliveryCharge;
    }

    // Option 3: Return 0 for self pickup or no delivery fee
    debugPrint('No delivery fee applied');
    return 0.0;
  }

  double get _totalAmount => widget.amount + _deliveryFee;

  @override
  Widget build(BuildContext context) {
    // Debug print in build method
    debugPrint('=== Build Method ===');
    debugPrint('Current carrier: $_currentCarrier');
    debugPrint('Delivery fee: $_deliveryFee');
    debugPrint('Total amount: $_totalAmount');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PaymentInfoWidget(),
        CustomShadowWidget(
          margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall,
              vertical: Dimensions.paddingSizeSmall),
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall,
              vertical: Dimensions.paddingSizeSmall),
          boxShadow: BoxShadow(
              offset: const Offset(0, 0),
              blurRadius: 0,
              color: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(getTranslated('add_delivery_note', context),
                  style:
                      rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              CustomTextFieldWidget(
                // fillColor: Colors.white,
                isShowBorder: true,
                controller: widget.orderNoteController,
                hintText: getTranslated('type', context),
                maxLines: 5,
                inputType: TextInputType.multiline,
                inputAction: TextInputAction.newline,
                capitalization: TextCapitalization.sentences,
              ),
            ]),
          ),
        ),
        CustomShadowWidget(
          margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall,
              vertical: Dimensions.paddingSizeSmall),
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall,
              vertical: Dimensions.paddingSizeDefault),
          boxShadow: BoxShadow(
              offset: const Offset(0, 0),
              blurRadius: 0,
              color: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
            child: Column(children: [
              CartItemWidget(
                title: getTranslated('subtotal', context),
                subTitle: PriceConverterHelper.convertPrice(widget.amount),
                style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: 10),
              if (!widget.selfPickup) ...[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated('delivery_fee', context),
                              style: rubikMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge),
                            ),
                            if (_currentCarrier != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                _currentCarrier!.servicelevelName,
                                style: rubikRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                            // Debug info (remove in production)
                            if (_deliveryFee == 0.0) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Debug: Carrier null: ${_currentCarrier == null}, Amount: ${_currentCarrier?.amount}',
                                style:
                                    TextStyle(fontSize: 10, color: Colors.red),
                              ),
                            ],
                          ],
                        ),
                      ),
                      CustomDirectionalityWidget(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '(+) ${PriceConverterHelper.convertPrice(_deliveryFee)}',
                              style: rubikRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                // Highlight if zero for debugging
                                color: _deliveryFee == 0.0 ? Colors.red : null,
                              ),
                            ),
                            if (_currentCarrier != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Est. ${_currentCarrier!.estimatedDays} day${_currentCarrier!.estimatedDays > 1 ? 's' : ''}',
                                style: rubikRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ]),
              ],
              const Padding(
                padding:
                    EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Divider(),
              ),
              CartItemWidget(
                title: getTranslated('total_amount', context),
                subTitle: PriceConverterHelper.convertPrice(_totalAmount),
                style:
                    rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              if (ResponsiveHelper.isDesktop(context))
                const SizedBox(height: Dimensions.paddingSizeDefault),
              if (ResponsiveHelper.isDesktop(context))
                PlaceOrderButtonView(
                  amount: widget.amount,
                  deliveryCharge: _deliveryFee,
                  orderType: widget.orderType,
                  kmWiseCharge: widget.kmWiseCharge,
                  cartList: widget.cartList,
                  orderNote: widget.orderNoteController.text,
                  scrollController: widget.scrollController,
                  dropdownKey: widget.dropdownKey,
                  shippment_id: widget.carrierShipmentID,
                  rate_id: _currentCarrier?.rateId ?? '',
                  carrier_id: _currentCarrier?.carrierAccount ?? '',
                )
            ]),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
      ],
    );
  }
}

// Additional debugging widget you can use temporarily
class CarrierDebugWidget extends StatelessWidget {
  final Carrier? carrier;

  const CarrierDebugWidget({Key? key, this.carrier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DEBUG INFO:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          Text('Carrier: ${carrier != null ? 'Not null' : 'NULL'}'),
          if (carrier != null) ...[
            Text('Amount: ${carrier!.amount}'),
            Text('Service: ${carrier!.servicelevelName}'),
            Text('Rate ID: ${carrier!.rateId}'),
            Text('Carrier Account: ${carrier!.carrierAccount}'),
          ],
        ],
      ),
    );
  }
}
