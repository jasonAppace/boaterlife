import 'package:country_code_picker/country_code_picker.dart';
import 'package:hexacom_user/common/enums/footer_type_enum.dart';
import 'package:hexacom_user/features/auth/domain/enums/from_page_enum.dart';
import 'package:hexacom_user/features/auth/domain/enums/verification_type_enum.dart';
import 'package:hexacom_user/features/auth/domain/models/user_log_data.dart';
import 'package:hexacom_user/features/auth/screens/only_social_login_widget.dart';
import 'package:hexacom_user/features/auth/screens/send_otp_screen.dart';
import 'package:hexacom_user/features/auth/widgets/social_login_widget.dart';
import 'package:hexacom_user/helper/auth_helper.dart';
import 'package:hexacom_user/helper/phone_number_checker_helper.dart';
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
import 'package:hexacom_user/common/widgets/custom_shadow_widget.dart';
import 'package:hexacom_user/helper/custom_snackbar_helper.dart';
import 'package:hexacom_user/common/widgets/custom_text_field_widget.dart';
import 'package:hexacom_user/common/widgets/custom_pop_scope_widget.dart';
import 'package:hexacom_user/common/widgets/footer_web_widget.dart';
import 'package:hexacom_user/common/widgets/web_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailOrPhoneController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();

    final AuthProvider authProvider = context.read<AuthProvider>();
    final SplashProvider splashProvider = context.read<SplashProvider>();

    authProvider.setCountSocialLoginOptions(isReload: true);
    int count = AuthHelper.countSocialLoginOptions(splashProvider.configModel);
    authProvider.setCountSocialLoginOptions(count: count, isReload: false);

    _formKeyLogin = GlobalKey<FormState>();
    _emailOrPhoneController = TextEditingController();
    _passwordController = TextEditingController();

    authProvider.toggleIsNumberLogin(value: false, isUpdate: false);

    UserLogData? userData = authProvider.getUserData();
    print("------------USER DATA---------------${userData?.toJson()}");

    _emailNumberFocus.addListener(() {
      setState(() {});
    });

    if (userData != null && userData.loginType == FromPage.login.name) {
      if (userData.phoneNumber != null) {
        _emailOrPhoneController!.text = PhoneNumberCheckerHelper.getPhoneNumber(
                userData.phoneNumber ?? '', userData.countryCode ?? '') ??
            '';
        authProvider.toggleIsNumberLogin(value: true, isUpdate: false);
        print(
            "--------------------IS Number Login-----------------${authProvider.isNumberLogin}");
        _countryDialCode ??= userData.countryCode;
        print(
            "--------------------Country CODE---------------- ${userData.countryCode}");
      } else if (userData.email != null) {
        _emailOrPhoneController!.text = userData.email ?? '';
      }
      _passwordController?.text = userData.password ?? '';
    } else {
      _countryDialCode = CountryCode.fromCountryCode(
              Provider.of<SplashProvider>(context, listen: false)
                  .configModel!
                  .countryCode!)
          .dialCode;
    }

    _passwordFocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailOrPhoneController!.dispose();
    _passwordController!.dispose();
    _emailNumberFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    final Size size = MediaQuery.of(context).size;

    if (!AuthHelper.isManualLoginEnable(configModel) &&
        !AuthHelper.isOtpLoginEnable(configModel)) {
      return const OnlySocialLoginWidget();
    } else if (!AuthHelper.isManualLoginEnable(configModel)) {
      return const SendOtpScreen();
    } else {
      return CustomPopScopeWidget(
        child: Scaffold(
          // backgroundColor: Colors.red,
          backgroundColor: ResponsiveHelper.isDesktop(context)
              ? null
              : Theme.of(context).cardColor,
          appBar: ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(90), child: WebAppBarWidget())
              : null,
          body: CustomScrollView(slivers: [
            SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: SizedBox(
                    width: ResponsiveHelper.isDesktop(context) ? 450 : null,
                    height: ResponsiveHelper.isDesktop(context)
                        ? null
                        : MediaQuery.sizeOf(context).height,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (ResponsiveHelper.isDesktop(context)) ...[
                            SizedBox(height: size.height * 0.04)
                          ],
                          Center(
                              child: CustomShadowWidget(
                            boxShadow: ResponsiveHelper.isDesktop(context)
                                ? BoxShadow(
                                    offset: const Offset(0, 10),
                                    blurRadius: 30,
                                    spreadRadius: 0,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color!
                                        .withOpacity(0.07))
                                : null,
                            shadowColor: !ResponsiveHelper.isDesktop(context)
                                ? Theme.of(context).cardColor
                                : null,
                            padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.isDesktop(context)
                                    ? 50
                                    : Dimensions.paddingSizeExtraLarge,
                                vertical: Dimensions.paddingSizeLarge),
                            child: Consumer<AuthProvider>(
                              builder: (context, authProvider, child) => Form(
                                key: _formKeyLogin,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // SizedBox(height: 30),
                                    !ResponsiveHelper.isDesktop(context)
                                        ? Center(
                                            child: Image.asset(
                                              Images.logo,
                                              height:
                                                  ResponsiveHelper.isDesktop(
                                                          context)
                                                      ? 150.0
                                                      : 130,
                                              fit: BoxFit.scaleDown,
                                              matchTextDirection: true,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    SizedBox(
                                        height:
                                            ResponsiveHelper.isDesktop(context)
                                                ? size.height * 0.03
                                                : Dimensions
                                                    .paddingSizeExtraLarge),
                                    Center(
                                        child: Text(
                                            getTranslated('login', context),
                                            style: rubikBold.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeThirty,
                                            ))),
                                    SizedBox(
                                      height: Dimensions.paddingSizeSmall,
                                    ),
                                    Center(
                                        child: SizedBox(
                                      width: 300,
                                      child: Text(
                                          getTranslated(
                                              'login_description', context),
                                          textAlign: TextAlign.center,
                                          style: rubikRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault)),
                                    )),
                                    SizedBox(
                                        height:
                                            ResponsiveHelper.isDesktop(context)
                                                ? size.height * 0.04
                                                : Dimensions.paddingSizeLarge),

                                    Selector<AuthProvider, bool>(
                                      selector: (context, authProvider) =>
                                          authProvider.isNumberLogin,
                                      builder: (context, isNumberLogin, child) {
                                        return CustomTextFieldWidget(
                                          countryDialCode: isNumberLogin
                                              ? _countryDialCode
                                              : null,
                                          onCountryChanged:
                                              (CountryCode value) =>
                                                  _countryDialCode =
                                                      value.dialCode,
                                          onChanged: (String text) =>
                                              AuthHelper.identifyEmailOrNumber(
                                                  text, context),
                                          hintText: getTranslated(
                                              'enter_email_phone', context),
                                          // title:
                                          //     getTranslated('email_phone', context),
                                          isShowBorder: true,
                                          focusNode: _emailNumberFocus,
                                          nextFocus: _passwordFocus,
                                          controller: _emailOrPhoneController,
                                          inputType: TextInputType.emailAddress,
                                          isShowPrefixIcon: !isNumberLogin,
                                          prefixAssetUrl: Images.emailPhoneIcon,
                                          prefixAssetImageColor:
                                              Theme.of(context).hintColor,
                                          borderColor: ColorResources
                                              .getOnBoardingShadeColor(context),
                                          fillColor: Colors.white,
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeLarge),

                                    CustomTextFieldWidget(
                                      hintText:
                                          getTranslated('password', context),
                                      // title: getTranslated('password', context),
                                      isShowBorder: true,
                                      isPassword: true,
                                      isShowSuffixIcon: true,
                                      isShowPrefixIcon: true,
                                      prefixAssetUrl: Images.password,
                                      focusNode: _passwordFocus,
                                      controller: _passwordController,
                                      inputAction: TextInputAction.done,
                                      prefixAssetImageColor:
                                          Theme.of(context).hintColor,
                                      borderColor: ColorResources
                                          .getOnBoardingShadeColor(context),
                                      fillColor: Colors.white,
                                    ),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeLarge),

                                    // for remember me section
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // Consumer<AuthProvider>(
                                          //   builder: (context, authProvider,
                                          //           child) =>
                                          //       InkWell(
                                          //     onTap: () => authProvider
                                          //         .toggleRememberMe(),
                                          //     child: Row(
                                          //       children: [
                                          //         Container(
                                          //           width: 18,
                                          //           height: 18,
                                          //           decoration: BoxDecoration(
                                          //               color: authProvider
                                          //                       .isActiveRememberMe
                                          //                   ? Theme.of(context)
                                          //                       .primaryColor
                                          //                   : Theme.of(context)
                                          //                       .cardColor,
                                          //               border: Border.all(
                                          //                   color: authProvider
                                          //                           .isActiveRememberMe
                                          //                       ? Colors
                                          //                           .transparent
                                          //                       : Theme.of(
                                          //                               context)
                                          //                           .primaryColor),
                                          //               borderRadius:
                                          //                   BorderRadius
                                          //                       .circular(3)),
                                          //           child: authProvider
                                          //                   .isActiveRememberMe
                                          //               ? const Icon(Icons.done,
                                          //                   color: Colors.white,
                                          //                   size: 17)
                                          //               : const SizedBox
                                          //                   .shrink(),
                                          //         ),
                                          //         const SizedBox(
                                          //             width: Dimensions
                                          //                 .paddingSizeSmall),
                                          //         Text(
                                          //           getTranslated(
                                          //               'remember_me', context),
                                          //           style:
                                          //               rubikRegular.copyWith(
                                          //                   fontSize: Dimensions
                                          //                       .fontSizeSmall),
                                          //         )
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          InkWell(
                                              onTap: () => RouteHelper
                                                  .getForgetPassRoute(context,
                                                      action: RouteAction.push),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '${getTranslated('forgot_password', context)} ?',
                                                  style: rubikSemiBold.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                  ),
                                                ),
                                              ))
                                        ]),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),

                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        authProvider
                                                .loginErrorMessage!.isNotEmpty
                                            ? const CircleAvatar(
                                                backgroundColor: Colors.red,
                                                radius: 5)
                                            : const SizedBox.shrink(),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            authProvider.loginErrorMessage ??
                                                "",
                                            style: rubikMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),

                                    // for login button
                                    CustomButtonWidget(
                                      height: 60,
                                      isLoading: authProvider.isLoading,
                                      btnTxt: getTranslated(
                                          'login_button', context),
                                      onTap: () async {
                                        final AuthProvider authProvider =
                                            Provider.of<AuthProvider>(context,
                                                listen: false);

                                        String userInput =
                                            _emailOrPhoneController?.text
                                                    .trim() ??
                                                '';
                                        String password =
                                            _passwordController?.text.trim() ??
                                                '';

                                        if (userInput.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'enter_email_or_phone',
                                                  context),
                                              context);
                                        } else if (password.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'enter_password', context),
                                              context);
                                        } else if (password.length < 6) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'password_should_be',
                                                  context),
                                              context);
                                        } else {
                                          bool isNumber =
                                              PhoneNumberCheckerHelper
                                                  .isValidPhone(userInput);
                                          if (isNumber) {
                                            userInput =
                                                _countryDialCode! + userInput;
                                          }

                                          String type = isNumber
                                              ? VerificationType.phone.name
                                              : VerificationType.email.name;

                                          await authProvider
                                              .login(context, userInput,
                                                  password, type,
                                                  fromPage: FromPage.login.name)
                                              .then((status) async {
                                            if (status.isSuccess) {
                                              if (authProvider
                                                  .isActiveRememberMe) {
                                                authProvider
                                                    .saveUserData(UserLogData(
                                                  countryCode: _countryDialCode,
                                                  phoneNumber: isNumber
                                                      ? userInput
                                                      : null,
                                                  email: isNumber
                                                      ? null
                                                      : userInput,
                                                  password: password,
                                                  loginType:
                                                      FromPage.login.name,
                                                ));
                                              } else {
                                                authProvider.clearUserData();
                                              }
                                              RouteHelper.getMainRoute(context,
                                                  action: RouteAction
                                                      .pushNamedAndRemoveUntil);
                                            }
                                          });
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraLarge),

                                    if (AuthHelper.isOtpOrSocialLoginEnable(
                                        configModel)) ...[
                                      Center(
                                          child: Text(
                                        getTranslated('or', context),
                                        style: rubikRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                        ),
                                      )),
                                      const SizedBox(
                                          height:
                                              Dimensions.paddingSizeDefault),
                                      if (AuthHelper.isOtpLoginEnable(
                                          configModel)) ...[
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                getTranslated(
                                                    'login_with', context),
                                                style: rubikRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeExtraSmall),
                                              InkWell(
                                                onTap: () => RouteHelper
                                                    .getSendOtpScreen(context,
                                                        action:
                                                            RouteAction.push),
                                                child: Text(
                                                  getTranslated('otp', context),
                                                  style: rubikRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeDefault),
                                      ],
                                      if (AuthHelper.isSocialMediaLoginEnable(
                                              configModel) &&
                                          ((AuthHelper.isFacebookLoginEnable(configModel) ||
                                              AuthHelper.isGoogleLoginEnable(
                                                  configModel) ||
                                              AuthHelper.isAppleLoginEnable(
                                                  configModel)))) ...[
                                        const Center(
                                            child: SocialLoginWidget()),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeLarge),
                                      ],
                                    ],

                                    // for create an account

                                    Center(
                                        child: InkWell(
                                      onTap: () =>
                                          RouteHelper.getCreateAccountRoute(
                                              context,
                                              action: RouteAction.push),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: getTranslated(
                                                'do_not_have_an_account',
                                                context),
                                            style: rubikMedium.copyWith(
                                              color: Colors.black,
                                            )),
                                        TextSpan(
                                            text:
                                                ' ${getTranslated('sign_up', context)}',
                                            style: rubikBold.copyWith(
                                              color: ColorResources
                                                  .getOnBoardingShadeColor(
                                                      context),
                                              fontSize: 15,
                                            )),
                                      ])),
                                    )),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraLarge),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
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

                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraLarge),

                                    if (!ResponsiveHelper.isDesktop(
                                        context)) ...[
                                      Center(
                                          child: InkWell(
                                        onTap: () =>
                                            RouteHelper.getDashboardRoute(
                                                context, 'home',
                                                action: RouteAction
                                                    .pushReplacement),
                                        child: RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text:
                                                  '${getTranslated('continue_as_a', context)} ',
                                              style: rubikMedium.copyWith(
                                                color: Colors.black,
                                              )),
                                          TextSpan(
                                              text: getTranslated(
                                                  'guest', context),
                                              style: rubikBold.copyWith(
                                                color: ColorResources
                                                    .getOnBoardingShadeColor(
                                                        context),
                                                fontSize: 15,
                                              )),
                                        ])),
                                      )),
                                    ],

                                    if (ResponsiveHelper.isDesktop(
                                        context)) ...[
                                      SizedBox(height: size.height * 0.02),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          )),
                          if (ResponsiveHelper.isDesktop(context)) ...[
                            SizedBox(height: size.height * 0.02),
                          ],
                        ]),
                  ),
                )),
            if (ResponsiveHelper.isDesktop(context))
              const SliverFillRemaining(
                hasScrollBody: false,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  SizedBox(height: Dimensions.paddingSizeLarge),
                  FooterWebWidget(footerType: FooterType.nonSliver),
                ]),
              ),
          ]),
        ),
      );
    }
  }
}
