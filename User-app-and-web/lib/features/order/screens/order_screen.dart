import 'package:flutter/material.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/features/auth/providers/auth_provider.dart';
import 'package:hexacom_user/features/order/providers/order_provider.dart';
import 'package:hexacom_user/utill/color_resources.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:hexacom_user/common/widgets/custom_app_bar_widget.dart';
import 'package:hexacom_user/common/widgets/not_logged_in_screen.dart';
import 'package:hexacom_user/features/order/widgets/order_list_widget.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
      Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getHomeScreenBackgroundColor(context),
      appBar: CustomAppBarWidget(title: getTranslated('my_order', context)),
      body: _isLoggedIn
          ? Consumer<OrderProvider>(
              builder: (context, order, child) {
                return Column(children: [
                  Center(
                      child: Container(
                    height: 55,
                    // width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      // tabAlignment: TabAlignment.center,
                      controller: _tabController,
                      dividerHeight: 0,
                      padding: const EdgeInsets.all(4),
                      labelColor: Theme.of(context).textTheme.bodyLarge!.color,
                      indicatorColor: Theme.of(context).primaryColor,
                      // indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      unselectedLabelStyle: rubikRegular.copyWith(
                          color: Theme.of(context).hintColor,
                          fontSize: Dimensions.fontSizeDefault),
                      labelStyle: rubikBold.copyWith(
                          fontSize: Dimensions.fontSizeDefault),
                      tabs: [
                        Tab(text: getTranslated('ongoing', context)),
                        Tab(text: getTranslated('history', context)),
                      ],
                    ),
                  )),
                  Expanded(
                      child: TabBarView(
                    controller: _tabController,
                    children: const [
                      OrderListWidget(isRunning: true),
                      OrderListWidget(isRunning: false),
                    ],
                  )),
                ]);
              },
            )
          : const NotLoggedInScreen(),
    );
  }
}
