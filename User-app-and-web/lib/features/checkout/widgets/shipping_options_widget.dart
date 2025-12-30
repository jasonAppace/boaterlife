import 'package:flutter/material.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/models/cart_model.dart';
import '../../../common/models/order_model.dart';


// --------------------- SHIPPING MODELS ---------------------
class ShippingResponse {
  final List<Carrier> carriers;
  final String shipmentId;

  ShippingResponse({
    required this.carriers,
    required this.shipmentId,
  });

  factory ShippingResponse.fromJson(Map<String, dynamic> json) {
    return ShippingResponse(
      carriers: (json['carriers'] as List)
          .map((e) => Carrier.fromJson(e))
          .toList(),
      shipmentId: json['shipment_id'],
    );
  }
}

class Carrier {
  final String rateId;
  final double amount;
  final String currency;
  final String provider;
  final String carrierAccount;
  final String servicelevelName;
  final int estimatedDays;
  final String durationTerms;

  Carrier({
    required this.rateId,
    required this.amount,
    required this.currency,
    required this.provider,
    required this.carrierAccount,
    required this.servicelevelName,
    required this.estimatedDays,
    required this.durationTerms,
  });

  factory Carrier.fromJson(Map<String, dynamic> json) {
    return Carrier(
      rateId: json['rate_id'],
      amount: double.parse(json['amount']),
      currency: json['currency'],
      provider: json['provider'],
      carrierAccount: json['carrier_account'],
      servicelevelName: json['servicelevel_name'],
      estimatedDays: json['estimated_days'],
      durationTerms: json['duration_terms'],
    );
  }
}

// --------------------- MAIN WIDGET ---------------------
class ShippingOptionsWidget extends StatefulWidget {
  final Function(Carrier, String)? onOptionSelected;
  final Color? cardColor;
  final Color? selectedRadioColor;
  final int customerAddressId;
  final List<CartModel?> cartItems;

  const ShippingOptionsWidget({
    Key? key,
    required this.customerAddressId,
    required this.cartItems,
    this.onOptionSelected,
    this.cardColor,
    this.selectedRadioColor,
  }) : super(key: key);

  @override
  _ShippingOptionsWidgetState createState() => _ShippingOptionsWidgetState();
}

class _ShippingOptionsWidgetState extends State<ShippingOptionsWidget> {
  late SharedPreferences _sharedPreferences;
  String? _userToken;
  Carrier? _selectedCarrier;
  String? _shipmentId;
  bool _isLoading = false;
  String? _errorMessage;
  List<Carrier> _carriers = [];
  bool _hasValidAddress = false;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  @override
  void didUpdateWidget(ShippingOptionsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if address ID changed and is now valid
    if (oldWidget.customerAddressId != widget.customerAddressId) {
      _checkAndFetchShippingOptions();
    }
  }

  Future<void> _initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _userToken = _sharedPreferences.getString(AppConstants.token);
    setState(() {
      _hasInitialized = true;
    });
    _checkAndFetchShippingOptions();
  }

  void _checkAndFetchShippingOptions() {
    if (!_hasInitialized) return;

    final hasValidId = widget.customerAddressId > 0;

    if (hasValidId && !_hasValidAddress) {
      // Address ID is now valid, fetch shipping options
      setState(() {
        _hasValidAddress = true;
      });
      _fetchShippingOptions();
    } else if (!hasValidId && _hasValidAddress) {
      // Address ID is no longer valid, reset state
      setState(() {
        _hasValidAddress = false;
        _carriers = [];
        _selectedCarrier = null;
        _shipmentId = null;
        _errorMessage = null;
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchShippingOptions() async {
    if (widget.customerAddressId <= 0) {
      setState(() {
        _errorMessage = 'Please select a valid shipping address';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = {
        'customer_address_id': widget.customerAddressId,
        'items': widget.cartItems,
      };

      print('Shipping request payload: ${json.encode(request)}');
      print(request.toString());

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.getShippmentOptions}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_userToken',
        },
        body: json.encode(request),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = ShippingResponse.fromJson(json.decode(response.body));
        setState(() {
          _carriers = data.carriers;
          _shipmentId = data.shipmentId;
          if (data.carriers.isNotEmpty) {
            _selectedCarrier = data.carriers[0];
            widget.onOptionSelected?.call(_selectedCarrier!, _shipmentId!);
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load shipping options (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.cardColor ?? Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    // Show loading while initializing
    if (!_hasInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show message if no valid address selected
    if (!_hasValidAddress || widget.customerAddressId <= 0) {
      return const Column(
        children: [
          Icon(
            Icons.location_off,
            size: 48,
            color: Colors.grey,
          ),
          SizedBox(height: 8),
          Text(
            'Please select a shipping address first',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // Show loading while fetching shipping options
    if (_isLoading) {
      return const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading shipping options...'),
        ],
      );
    }

    // Show error with retry button
    if (_errorMessage != null) {
      return Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          SizedBox(height: 8),
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchShippingOptions,
            child: const Text('Retry'),
          ),
        ],
      );
    }

    // Show no options available
    if (_carriers.isEmpty) {
      return const Column(
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 48,
            color: Colors.grey,
          ),
          SizedBox(height: 8),
          Text(
            'No shipping options available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }

    // Show shipping options
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ..._carriers.map((carrier) => _buildCarrierOption(carrier)).toList(),
        const Divider(height: 24, thickness: 1),
        _buildTotal(),
      ],
    );
  }

  Widget _buildCarrierOption(Carrier carrier) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Radio<Carrier>(
                    value: carrier,
                    groupValue: _selectedCarrier,
                    onChanged: (Carrier? value) {
                      if (value != null && _shipmentId != null) {
                        setState(() {
                          _selectedCarrier = value;
                        });
                        widget.onOptionSelected?.call(value, _shipmentId!);
                      }
                    },
                    activeColor: widget.selectedRadioColor ?? Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          carrier.servicelevelName,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Est. ${carrier.estimatedDays} day${carrier.estimatedDays > 1 ? 's' : ''} • ${carrier.durationTerms}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '\$${carrier.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTotal() {
    final total = _selectedCarrier?.amount ?? 0.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '\$${total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// --------------------- HOW TO USE IT ---------------------
/*
// Now you can use it normally - it will automatically wait for valid address:

ShippingOptionsWidget(
  customerAddressId: address.addressList?[checkoutProvider.orderAddressIndex].id ?? 0,
  cartItems: cartProvider.cartList ?? [],
  onOptionSelected: (selectedCarrier, shipmentID) {
    print('Selected shipping: ${selectedCarrier.servicelevelName}');
    carierSelected = selectedCarrier;
    carrierShipmentID = shipmentID;
  },
);

// The widget will:
// 1. Show "Please select address" when customerAddressId is 0 or invalid
// 2. Automatically fetch shipping options when customerAddressId becomes valid
// 3. Handle all loading states and errors properly
*/