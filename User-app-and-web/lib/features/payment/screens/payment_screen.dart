import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:hexacom_user/common/widgets/custom_alert_dialog_widget.dart';
import 'package:hexacom_user/features/checkout/widgets/order_cancel_dialog_widget.dart';
import 'package:hexacom_user/features/cart/providers/cart_provider.dart';
import 'package:hexacom_user/helper/responsive_helper.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import 'package:hexacom_user/utill/routes.dart';
import 'package:hexacom_user/common/widgets/custom_loader_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hexacom_user/helper/custom_snackbar_helper.dart';
import 'package:hexacom_user/main.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final String? url;
  final int? orderId;
  const PaymentScreen({super.key, this.orderId, this.url});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String selectedUrl;
  double value = 0.0;
  final bool _isLoading = true;
  late MyInAppBrowser browser;
  bool _isRedirected = false;

  @override
  void initState() {
    super.initState();
    selectedUrl = widget.url ?? '';
    _initData();
  }

  void _initData() async {
    //browser = MyInAppBrowser(context, orderId: widget.orderId);
    browser = MyInAppBrowser(context, _initData, orderId: widget.orderId,
        onRedirect: () {
      setState(() {
        _isRedirected = true;
      });
    });

    final settings = InAppBrowserClassSettings(
      browserSettings: InAppBrowserSettings(hideUrlBar: false),
      webViewSettings: InAppWebViewSettings(
          javaScriptEnabled: true, isInspectable: kDebugMode),
    );

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri.uri(Uri.parse(selectedUrl))),
      settings: settings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (_isRedirected) return;
        // RouteHelper.getMainRoute(context,
        //     action: RouteAction.pushNamedAndRemoveUntil);
        // ResponsiveHelper.showDialogOrBottomSheet(
        //     context,
        //     CustomAlertDialogWidget(
        //       title: getTranslated('do_you_want_to_cancel_payment', context),
        //       leftButtonText: getTranslated('cancel', context),
        //       rightButtonText: getTranslated('proceed', context),
        //       icon: Icons.warning_amber,
        //       onPressLeft: () {
        //         context.pop();
        //         RouteHelper.getMainRoute(context,
        //             action: RouteAction.pushNamedAndRemoveUntil);
        //       },
        //       onPressRight: () {
        //         context.pop();
        //         _initData();
        //         // _initData();
        //       },
        //     ));
      },
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              _isLoading
                  ? Center(
                      child: CustomLoaderWidget(
                          color: Theme.of(context).primaryColor),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _exitApp(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => OrderCancelDialogWidget(
              orderID: widget.orderId,
              fromCheckout: true,
            ));
  }
}

class MyInAppBrowser extends InAppBrowser {
  final int? orderId;
  final bool? fromCheckout;
  final BuildContext context;
  final Function callBack;
  final Function? onRedirect;
  MyInAppBrowser(this.context, this.callBack,
      {required this.orderId,
      super.windowId,
      super.initialUserScripts,
      this.fromCheckout,
      this.onRedirect});

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      debugPrint("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(
    url,
  ) async {
    if (kDebugMode) {
      debugPrint("\n\nStarted: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      debugPrint("\n\nStopped: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      debugPrint("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      debugPrint("Progress: $progress");
    }
  }

  @override
  void onExit() {
    if (_canRedirect) {
      showCustomSnackBar(
          getTranslated('Order Payment is pending', context), context);
      RouteHelper.getMainRoute(context,
          action: RouteAction.pushNamedAndRemoveUntil);
      // ResponsiveHelper.showDialogOrBottomSheet(
      //     context,
      //     CustomAlertDialogWidget(
      //       title: getTranslated('do_you_want_to_cancel_payment', context),
      //       leftButtonText: getTranslated('cancel', context),
      //       rightButtonText: getTranslated('proceed', context),
      //       icon: Icons.warning_amber,
      //       onPressLeft: () {
      //         context.pop();
      //         RouteHelper.getMainRoute(context,
      //             action: RouteAction.pushNamedAndRemoveUntil);
      //       },
      //       onPressRight: () {
      //         context.pop();
      //         callBack();
      //       },
      //     ));
    }

    // if(_canRedirect) {
    //   Navigator.pushReplacementNamed(context, '${RouteHelper.orderSuccessScreen}/$orderId/payment-fail');
    // }

    if (kDebugMode) {
      debugPrint("\n\nBrowser closed!\n\n");
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    if (kDebugMode) {
      debugPrint("\n\nOverride ${navigationAction.request.url}\n\n");
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {
    // print("Started at: " + response.startTime.toString() + "ms ---> duration: " + response.duration.toString() + "ms " + (response.url ?? '').toString());
  }

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      debugPrint("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
    }
  }

  void _pageRedirect(String url) {
    if (_canRedirect) {
      bool checkedUrl = (url.contains(
          '${AppConstants.baseUrl}${RouteHelper.orderSuccessScreen}'));
      bool isSuccess = url.contains('success') && checkedUrl;
      bool isFailed = url.contains('fail') && checkedUrl;
      bool isCancel = url.contains('cancel') && checkedUrl;

      if (kDebugMode) {
        debugPrint(
            '----------------payment status -----$isCancel -- $isSuccess -- $isFailed');
        debugPrint('------------------url --- $url');
      }

      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        onRedirect?.call();
        close();
      }
      if (isSuccess) {
        if (orderId != null && orderId != -1) {
          Provider.of<CartProvider>(context, listen: false).clearCartList();
          // showCustomSnackBar(
          //     getTranslated('order_placed_successfully', Get.context!),
          //     Get.context!,
          //     isError: false);
          RouteHelper.getOrderSuccessScreen(
              context, orderId.toString(), 'success',
              action: RouteAction.pushReplacement);
        } else {
          RouteHelper.getOrderSuccessScreen(context, '', 'payment-fail',
              action: RouteAction.pushReplacement);
        }
      } else if (isFailed) {
        RouteHelper.getOrderSuccessScreen(context, '', 'payment-fail',
            action: RouteAction.pushReplacement);
      } else if (isCancel) {
        RouteHelper.getOrderSuccessScreen(context, '', 'payment-cancel',
            action: RouteAction.pushReplacement);
      }
    }
  }
}
