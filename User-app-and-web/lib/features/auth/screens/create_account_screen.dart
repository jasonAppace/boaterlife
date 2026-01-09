import 'package:country_code_picker/country_code_picker.dart';
import 'package:hexacom_user/common/enums/footer_type_enum.dart';
import 'package:hexacom_user/common/models/signup_model.dart';
import 'package:hexacom_user/features/auth/providers/registration_provider.dart';
import 'package:hexacom_user/features/auth/widgets/sign_up_logo_widget.dart';
import 'package:hexacom_user/helper/email_checker_helper.dart';
import 'package:hexacom_user/helper/responsive_helper.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/features/auth/providers/auth_provider.dart';
import 'package:hexacom_user/features/splash/providers/splash_provider.dart';
import 'package:hexacom_user/utill/color_resources.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/images.dart';
import 'package:hexacom_user/utill/routes.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:hexacom_user/common/widgets/custom_button_widget.dart';
import 'package:hexacom_user/helper/custom_snackbar_helper.dart';
import 'package:hexacom_user/common/widgets/custom_text_field_widget.dart';
import 'package:hexacom_user/common/widgets/footer_web_widget.dart';
import 'package:hexacom_user/common/widgets/web_app_bar_widget.dart';
import 'package:hexacom_user/features/auth/widgets/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _countryDialCode;
  String? _selectedCountryCode;

  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  double _maxScroll = 1;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
      _maxScroll = _scrollController.position.maxScrollExtent;
    });
  }

  @override
  void initState() {
    super.initState();

    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final RegistrationProvider registrationProvider =
        Provider.of<RegistrationProvider>(context, listen: false);

    _scrollController.addListener(_scrollListener);
    _firstNameFocus.addListener(() {
      setState(() {});
    });

    _lastNameFocus.addListener(() {
      setState(() {});
    });

    _emailFocus.addListener(() {
      setState(() {});
    });

    _numberFocus.addListener(() {
      setState(() {});
    });
    _passwordFocus.addListener(() {
      setState(() {});
    });
    _confirmPasswordFocus.addListener(() {
      setState(() {});
    });

    authProvider.updateIsUpdateTernsStatus(value: false, isUpdate: false);
    registrationProvider.setErrorMessage = '';

    // Initialize country code and dial code from config
    final String configCountryCode =
        Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .countryCode ??
            'US';
    print(
        '----(CREATE ACCOUNT SCREEN)---- Config Country Code: $configCountryCode');

    // Map country code to dial code
    final Map<String, String> countryDialCodeMap = {
      'US': '+1',
      'CA': '+1',
      'GB': '+44',
      'AU': '+61',
      'IN': '+91',
      'AE': '+971',
      'SA': '+966',
    };

    // Store country code for flag display and dial code for phone input
    _selectedCountryCode = configCountryCode.toUpperCase();

    try {
      // Try to get from map first, then fall back to CountryCode parser
      if (countryDialCodeMap.containsKey(_selectedCountryCode)) {
        _countryDialCode = countryDialCodeMap[_selectedCountryCode];
        print(
            '----(CREATE ACCOUNT SCREEN)---- Using mapped dial code: $_countryDialCode');
      } else {
        _countryDialCode =
            CountryCode.fromCountryCode(_selectedCountryCode ?? "").dialCode;
        print(
            '----(CREATE ACCOUNT SCREEN)---- Using parser dial code: $_countryDialCode');
      }
    } catch (e) {
      print(
          '----(CREATE ACCOUNT SCREEN)---- Error parsing country code: $e, using default US (+1)');
      _countryDialCode = '+1';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _numberFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context)
          ? null
          : Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(90), child: WebAppBarWidget())
          : null,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                if (!ResponsiveHelper.isDesktop(context))
                  SliverToBoxAdapter(
                      child: SizedBox(height: size.height * 0.02)),
                if (!ResponsiveHelper.isDesktop(context))
                  SliverAppBar(
                    elevation: 5,
                    backgroundColor: Theme.of(context).cardColor,
                    automaticallyImplyLeading: false,
                    pinned: true,
                    expandedHeight: innerBoxIsScrolled ? 100 : 248,
                    title: AnimatedOpacity(
                      opacity:
                          (_scrollPosition / _maxScroll).floor().toDouble(),
                      duration: const Duration(milliseconds: 500),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(Images.logo, width: 40, height: 40),
                            const SizedBox(width: 10),
                            Text(
                              getTranslated('signup', context),
                              style: rubikBold.copyWith(
                                  color: Theme.of(context).primaryColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background:
                          SignUpLogoWidget(countryCode: config.countryCode),
                    ),
                  )
              ];
            },
            body: CustomScrollView(slivers: [
              if (ResponsiveHelper.isDesktop(context)) ...[
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: size.height * 0.05,
                  ),
                )
              ],
              SliverToBoxAdapter(
                  child: Center(
                      child: Container(
                width: size.width > 700 ? 500 : size.width,
                margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                padding: size.width > 700
                    ? const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: Dimensions.paddingSizeExtraLarge)
                    : const EdgeInsets.fromLTRB(
                        Dimensions.paddingSizeExtraLarge,
                        0,
                        Dimensions.paddingSizeExtraLarge,
                        Dimensions.paddingSizeDefault),
                decoration: size.width > 700
                    ? BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 5,
                              spreadRadius: 1),
                        ],
                      )
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // for first name section

                    if (ResponsiveHelper.isDesktop(context))
                      Center(
                          child: SignUpLogoWidget(
                              countryCode: config.countryCode)),

                    CustomTextFieldWidget(
                      prefixAssetUrl: Images.profile,
                      isShowPrefixIcon: true,
                      hintText: getTranslated('first_name', context),
                      isShowBorder: true,
                      controller: _firstNameController,
                      focusNode: _firstNameFocus,
                      nextFocus: _lastNameFocus,
                      inputType: TextInputType.name,
                      capitalization: TextCapitalization.words,
                      fillColor: Colors.white,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    CustomTextFieldWidget(
                      hintText: getTranslated('last_name', context),
                      prefixAssetUrl: Images.profile,
                      isShowBorder: true,
                      isShowPrefixIcon: true,
                      controller: _lastNameController,
                      focusNode: _lastNameFocus,
                      nextFocus: _emailFocus,
                      inputType: TextInputType.name,
                      capitalization: TextCapitalization.words,
                      fillColor: Colors.white,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    CustomTextFieldWidget(
                      hintText: getTranslated('email', context),
                      isShowBorder: true,
                      prefixIconUrl: Icons.email,
                      isShowPrefixIcon: true,
                      controller: _emailController,
                      focusNode: _emailFocus,
                      nextFocus: _numberFocus,
                      inputType: TextInputType.emailAddress,
                      fillColor: Colors.white,
                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // for email section

                    CustomTextFieldWidget(
                      hintText: getTranslated('enter_phone_number', context),
                      isShowBorder: true,
                      controller: _numberController,
                      focusNode: _numberFocus,
                      nextFocus: _passwordFocus,
                      inputType: TextInputType.phone,
                      countryDialCode: 'US',
                      fillColor: Colors.white,
                      onCountryChanged: (countryCode) {
                        setState(() {
                          _countryDialCode = countryCode.dialCode;
                          _selectedCountryCode = countryCode.code;
                          print(
                              '----(CREATE ACCOUNT SCREEN)---- Country changed to: ${countryCode.code}, Dial code: ${countryCode.dialCode}');
                        });
                      },
                    ),

                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius:
                    //         BorderRadius.circular(Dimensions.radiusSizeDefault),
                    //     border: Border.all(
                    //       color: _numberFocus.hasFocus
                    //           ? Theme.of(context).primaryColor.withOpacity(0.5)
                    //           : Theme.of(context).hintColor.withOpacity(0.2),
                    //       width: 1,
                    //     ),
                    //   ),
                    //   child: Row(children: [
                    //     CodePickerWidget(
                    //       onChanged: (countryCode) {
                    //         setState(() {
                    //           _countryDialCode = countryCode.dialCode;
                    //           _selectedCountryCode = countryCode.code;
                    //           print(
                    //               '----(CREATE ACCOUNT SCREEN)---- Country changed to: ${countryCode.code}, Dial code: ${countryCode.dialCode}');
                    //         });
                    //       },
                    //       initialSelection: _selectedCountryCode ?? 'US',
                    //       favorite: [_selectedCountryCode ?? 'US'],
                    //       showDropDownButton: true,
                    //       padding: EdgeInsets.zero,
                    //       showFlagMain: true,
                    //       textStyle: TextStyle(
                    //           color: Theme.of(context)
                    //               .textTheme
                    //               .displayLarge!
                    //               .color),
                    //     ),
                    //     Container(
                    //         width: 1,
                    //         height: Dimensions.paddingSizeExtraLarge,
                    //         color: Theme.of(context).dividerColor),
                    //     Expanded(
                    //         child: CustomTextFieldWidget(
                    //       borderColor: Colors.transparent,
                    //       hintText:
                    //           getTranslated('enter_phone_number', context),
                    //       isShowBorder: true,
                    //       controller: _numberController,
                    //       focusNode: _numberFocus,
                    //       nextFocus: _emailFocus,
                    //       inputType: TextInputType.phone,
                    //       countryDialCode: 'US',
                    //       onCountryChanged: (countryCode) {
                    //         setState(() {
                    //           _countryDialCode = countryCode.dialCode;
                    //           _selectedCountryCode = countryCode.code;
                    //           print(
                    //               '----(CREATE ACCOUNT SCREEN)---- Country changed to: ${countryCode.code}, Dial code: ${countryCode.dialCode}');
                    //         });
                    //       },
                    //     )),
                    //   ]),
                    // ),

                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // for password section,
                    CustomTextFieldWidget(
                      prefixIconUrl: Icons.lock,
                      hintText: getTranslated('password', context),
                      isShowBorder: true,
                      isPassword: true,
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      nextFocus: _confirmPasswordFocus,
                      isShowSuffixIcon: true,
                      isShowPrefixIcon: true,
                      fillColor: Colors.white,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // for confirm password section
                    CustomTextFieldWidget(
                      hintText: getTranslated('confirm_password', context),
                      isShowBorder: true,
                      isPassword: true,
                      prefixIconUrl: Icons.lock,
                      isShowPrefixIcon: true,
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      isShowSuffixIcon: true,
                      inputAction: TextInputAction.done,
                      fillColor: Colors.white,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Consumer<RegistrationProvider>(
                        builder: (context, registrationProvider, _) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          registrationProvider.errorMessage!.isNotEmpty
                              ? CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                  radius: 5)
                              : const SizedBox.shrink(),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              registrationProvider.errorMessage ?? "",
                              style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                    // const SizedBox(height: Dimensions.paddingSizeSmall),

                    // Row(children: [
                    //   InkWell(
                    //     onTap: () => authProvider.updateIsUpdateTernsStatus(),
                    //     child: Container(
                    //       width: Dimensions.paddingSizeLarge,
                    //       height: Dimensions.paddingSizeLarge,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(5),
                    //         border: Border.all(
                    //             color: Theme.of(context)
                    //                 .primaryColor
                    //                 .withOpacity(0.3),
                    //             width: 1),
                    //         color: Theme.of(context).primaryColor.withOpacity(
                    //             authProvider.isAgreeTerms ? 0.2 : 0.02),
                    //       ),
                    //       child: authProvider.isAgreeTerms
                    //           ? Icon(
                    //               Icons.check,
                    //               color: Theme.of(context).primaryColor,
                    //               size: Dimensions.paddingSizeDefault,
                    //             )
                    //           : const SizedBox(),
                    //     ),
                    //   ),
                    //   const SizedBox(width: Dimensions.paddingSizeSmall),
                    //   Text(getTranslated('i_agree_with_the', context)),
                    //   const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    //   InkWell(
                    //     onTap: () => RouteHelper.getTermsRoute(context,
                    //         action: RouteAction.push),
                    //     child:
                    //         Text(getTranslated('terms_and_condition', context),
                    //             style: rubikRegular.copyWith(
                    //               color: Theme.of(context).primaryColor,
                    //               decoration: TextDecoration.underline,
                    //             )),
                    //   ),
                    // ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    // for signup button

                    Consumer<RegistrationProvider>(
                        builder: (context, registrationProvider, _) {
                      return CustomButtonWidget(
                        height: 60,
                        isLoading: registrationProvider.isLoading,
                        btnTxt: getTranslated('signup_button', context),
                        onTap:
                            // !authProvider.isAgreeTerms
                            //     ? null
                            //     :
                            () {
                          String firstName = _firstNameController.text.trim();
                          String lastName = _lastNameController.text.trim();
                          String number =
                              _countryDialCode! + _numberController.text.trim();
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();
                          String confirmPassword =
                              _confirmPasswordController.text.trim();

                          if (firstName.isEmpty) {
                            showCustomSnackBar(
                                getTranslated('enter_first_name', context),
                                context);
                          } else if (lastName.isEmpty) {
                            showCustomSnackBar(
                                getTranslated('enter_last_name', context),
                                context);
                          } else if (_numberController.text.length > 10) {
                            showCustomSnackBar(
                                "Phone number should not be more than 10 characters",
                                context);
                          } else if (email.isEmpty) {
                            showCustomSnackBar(
                                getTranslated('enter_email_address', context),
                                context);
                          } else if (EmailCheckerHelper.isNotValid(email)) {
                            showCustomSnackBar(
                                getTranslated('enter_valid_email', context),
                                context);
                          } else if (password.isEmpty) {
                            showCustomSnackBar(
                                getTranslated('enter_password', context),
                                context);
                          } else if (password.length < 6) {
                            showCustomSnackBar(
                                getTranslated('password_should_be', context),
                                context);
                          } else if (confirmPassword.isEmpty) {
                            showCustomSnackBar(
                                getTranslated(
                                    'enter_confirm_password', context),
                                context);
                          } else if (password != confirmPassword) {
                            showCustomSnackBar(
                                getTranslated(
                                    'password_did_not_match', context),
                                context);
                          } else {
                            SignUpModel signUpModel = SignUpModel(
                              fName: firstName,
                              lName: lastName,
                              email: email,
                              password: password,
                              phone: number,
                            );

                            registrationProvider
                                .registration(context, signUpModel, config)
                                .then((status) async {
                              if (status.isSuccess) {
                                RouteHelper.getMainRoute(context,
                                    action:
                                        RouteAction.pushNamedAndRemoveUntil);
                              }
                            });
                          }
                        },
                      );
                    }),

                    // for already an account
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(getTranslated('already_have_account', context),
                            style: rubikMedium.copyWith(
                              color: Colors.black,
                            )),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        InkWell(
                          onTap: () => RouteHelper.getLoginRoute(context,
                              action: RouteAction.pushReplacement),
                          child: Text(getTranslated('login_button', context),
                              style: rubikBold.copyWith(
                                color: ColorResources.getOnBoardingShadeColor(
                                    context),
                                fontSize: 15,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.grey,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Text(
                          "Or",
                          style: rubikBold.copyWith(
                              color: ColorResources.colorGrey),
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.grey,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    Center(
                        child: InkWell(
                      onTap: () =>
                          RouteHelper.getDashboardRoute(context, 'home'),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text:
                                '${getTranslated('continue_as_a', context)}  ',
                            style: rubikMedium.copyWith(
                              color: Colors.black,
                            )),
                        TextSpan(
                            text: getTranslated('guest', context),
                            style: rubikBold.copyWith(
                              color: ColorResources.getOnBoardingShadeColor(
                                  context),
                              fontSize: 15,
                            )),
                      ])),
                    )),
                  ],
                ),
              ))),
              if (ResponsiveHelper.isDesktop(context)) ...[
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: size.height * 0.05,
                  ),
                )
              ],
              const FooterWebWidget(footerType: FooterType.sliver),
            ]),
          ),
        ),
      ),
    );
  }
}
