import 'package:country_code_picker/country_code_picker.dart';
import 'package:hexacom_user/common/models/address_model.dart';
import 'package:hexacom_user/features/address/providers/address_provider.dart';
import 'package:hexacom_user/features/address/providers/location_provider.dart';
import 'package:hexacom_user/features/address/widgets/address_button_widget.dart';
import 'package:hexacom_user/helper/auth_helper.dart';
import 'package:hexacom_user/helper/responsive_helper.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import 'package:hexacom_user/utill/color_resources.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:hexacom_user/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// State model for API response
class StateModel {
  final int id;
  final String name;
  final String iso2;

  StateModel({
    required this.id,
    required this.name,
    required this.iso2,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      name: json['name'],
      iso2: json['iso2'],
    );
  }
}

class AddressDetailsWidget extends StatefulWidget {
  final TextEditingController contactPersonNameController;
  final TextEditingController contactPersonNumberController;
  final FocusNode addressNode;
  final FocusNode nameNode;
  final FocusNode numberNode;
  final bool isUpdateEnable;
  final bool fromCheckout;
  final AddressModel? address;
  final TextEditingController locationTextController;
  final TextEditingController streetNumberController;
  final TextEditingController houseNumberController;
  final TextEditingController florNumberController;
  final TextEditingController stateController;
  final TextEditingController cityController;
  final TextEditingController zipController;

  final FocusNode stateNode;
  final FocusNode houseNode;
  final FocusNode florNode;

  const AddressDetailsWidget({
    super.key,
    required this.contactPersonNameController,
    required this.contactPersonNumberController,
    required this.addressNode, required this.nameNode,
    required this.numberNode,
    required this.isUpdateEnable,
    required this.fromCheckout,
    required this.address,
    required this.stateController,
    required this.cityController,
    required this.zipController,
    required this.locationTextController,
    required this.streetNumberController,
    required this.houseNumberController,
    required this.stateNode,
    required this.houseNode,
    required this.florNumberController,
    required this.florNode,
  });

  @override
  State<AddressDetailsWidget> createState() => _AddressDetailsWidgetState();
}

class _AddressDetailsWidgetState extends State<AddressDetailsWidget> {
  List<StateModel> states = [];
  StateModel? selectedState;
  bool isLoadingStates = false;

  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  Future<void> fetchStates() async {
    setState(() {
      isLoadingStates = true;
    });

    try {
      // Replace with your actual API endpoint
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}${AppConstants.getStates}'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          final List<dynamic> statesData = jsonData['data'];
          setState(() {
            // Get all states without filtering - let API decide what to send
            states = statesData.map((state) => StateModel.fromJson(state)).toList();
            // Sort states alphabetically
            //states.sort((a, b) => a.name.compareTo(b.name));
          });
        }
      }
    } catch (e) {
      print('Error fetching states: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load states. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isLoadingStates = false;
      });
    }
  }

  void _showStatePicker() {
    // Add debug print to check if method is called
    print('_showStatePicker called with ${states.length} states');

    if (states.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No states available. Please wait for data to load.'),
        ),
      );
      return;
    }

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Header with Cancel and Done buttons
              Container(
                height: 44,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator,
                      width: 0.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const Text(
                      'Select State',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Done',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              // Picker
              Expanded(
                child: CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedState != null
                        ? states.indexWhere((state) => state.id == selectedState!.id)
                        : 0,
                  ),
                  onSelectedItemChanged: (int selectedItem) {
                    print('Selected item: $selectedItem, State: ${states[selectedItem].name}');
                    setState(() {
                      selectedState = states[selectedItem];
                      widget.stateController.text = selectedState!.iso2;
                    });
                  },
                  children: List<Widget>.generate(states.length, (int index) {
                    return Center(
                      child: Text(
                        states[index].name,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LocationProvider locationProvider = context.read<LocationProvider>();
    final AddressProvider addressProvider = context.read<AddressProvider>();

    return Padding(
      padding: ResponsiveHelper.isDesktop(context)
          ? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeLarge)
          : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              getTranslated('delivery_address', context),
              style: rubikRegular.copyWith(
                  color: ColorResources.getGreyBunkerColor(context),
                  fontSize: Dimensions.fontSizeLarge
              ),
            ),
          ),

          // Address Field
          Text(
            getTranslated('address_line_01', context),
            style: rubikMedium.copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Selector<LocationProvider, String?>(
            selector: (context, locationProvider) => locationProvider.address,
            builder: (context, address, child) {
              print("-------------(Address)--------------${locationProvider.address}");
              widget.locationTextController.text = locationProvider.address ?? '';
              return CustomTextFieldWidget(
                onChanged: (String? value) => locationProvider.setAddress = value,
                hintText: getTranslated('address_line_02', context),
                isShowBorder: true,
                inputType: TextInputType.streetAddress,
                inputAction: TextInputAction.next,
                focusNode: widget.addressNode,
                nextFocus: widget.nameNode,
                controller: widget.locationTextController,
              );
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          // Street Number
          Text(
            "Street Name",
           // '${getTranslated('street', context)} ${getTranslated('number', context)}',
            style: rubikRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          CustomTextFieldWidget(
            hintText: getTranslated('ex_10_th', context),
            isShowBorder: true,
            inputType: TextInputType.streetAddress,
            inputAction: TextInputAction.next,
            focusNode: widget.stateNode,
            nextFocus: widget.houseNode,
            controller: widget.streetNumberController,
            maxLength: 50,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          // House/Floor Number
          Text(
            "Apt / Unit / Suite",
            //'${getTranslated('house', context)} / ${getTranslated('floor', context)} ${getTranslated('number', context)}',
            style: rubikRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Row(
            children: [
              Expanded(
                child: CustomTextFieldWidget(
                  hintText: getTranslated('ex_2', context),
                  isShowBorder: true,
                  inputType: TextInputType.streetAddress,
                  inputAction: TextInputAction.next,
                  focusNode: widget.houseNode,
                  nextFocus: widget.florNode,
                  controller: widget.houseNumberController,
                  maxLength: 50,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeLarge),
              Expanded(
                child: CustomTextFieldWidget(
                  hintText: getTranslated('ex_2b', context),
                  isShowBorder: true,
                  inputType: TextInputType.streetAddress,
                  inputAction: TextInputAction.next,
                  focusNode: widget.florNode,
                  nextFocus: widget.nameNode,
                  controller: widget.florNumberController,
                  maxLength: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          // State Picker
          Text(
            'State',
            style: rubikRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          // Replace the GestureDetector widget with this:
          InkWell(
            onTap: () {
              print('State picker tapped. States available: ${states.length}');
              if (isLoadingStates) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Loading states, please wait...')),
                );
                return;
              }

              if (states.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No states available. Please try again later.')),
                );
                fetchStates(); // Retry loading
                return;
              }

              _showStatePicker();
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).hintColor.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isLoadingStates
                            ? 'Loading states...'
                            : (selectedState?.name ?? 'Select State'),
                        style: TextStyle(
                          color: selectedState != null
                              ? Theme.of(context).textTheme.bodyLarge?.color
                              : Theme.of(context).hintColor,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    isLoadingStates
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : Icon(
                      Icons.keyboard_arrow_down,
                      color: Theme.of(context).hintColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text(
            'City',
            style: rubikRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          CustomTextFieldWidget(
            hintText: 'Enter City',
            isShowBorder: true,
            inputType: TextInputType.streetAddress,
            inputAction: TextInputAction.next,
            controller: widget.cityController,
            maxLength: 50,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text(
            'Zip Code',
            style: rubikRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          CustomTextFieldWidget(
            hintText: 'Enter Zip Code',
            isShowBorder: true,
            inputType: TextInputType.number,
            inputAction: TextInputAction.next,
            controller: widget.zipController,
            maxLength: 50,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          // Contact Person Name
          Text(
            getTranslated('contact_person_name', context),
            style: rubikMedium.copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          CustomTextFieldWidget(
            hintText: getTranslated('enter_contact_person_name', context),
            isShowBorder: true,
            inputType: TextInputType.name,
            controller: widget.contactPersonNameController,
            focusNode: widget.nameNode,
            nextFocus: widget.numberNode,
            inputAction: TextInputAction.next,
            capitalization: TextCapitalization.words,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          // Contact Person Number
          Text(
            getTranslated('contact_person_number', context),
            style: rubikMedium.copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          CustomTextFieldWidget(
            hintText: getTranslated('enter_contact_person_number', context),
            isShowBorder: true,
            inputType: TextInputType.phone,
            inputAction: TextInputAction.done,
            focusNode: widget.numberNode,
            controller: widget.contactPersonNumberController,
             countryDialCode: addressProvider.countryCode,
             selectedCountryCode: addressProvider.selectedCountryCode ?? 'US',
            onCountryChanged: (CountryCode value) {
              addressProvider.setCountryCode(value.dialCode ?? '', isUpdate: true);
            },
            onChanged: (String text) => AuthHelper.identifyEmailOrNumber(text, context),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          if (ResponsiveHelper.isDesktop(context))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: AddressButtonWidget(
                isUpdateEnable: widget.isUpdateEnable,
                fromCheckout: widget.fromCheckout,
                contactPersonNumberController: widget.contactPersonNumberController,
                contactPersonNameController: widget.contactPersonNameController,
                address: widget.address,
                location: widget.locationTextController.text,
                streetNumberController: widget.streetNumberController,
                houseNumberController: widget.houseNumberController,
                floorNumberController: widget.florNumberController,
                countryCode: addressProvider.countryCode ?? '',
                stateController: widget.stateController,
                zipController: widget.zipController,
                cityController: widget.cityController,
              ),
            )
        ],
      ),
    );
  }
}