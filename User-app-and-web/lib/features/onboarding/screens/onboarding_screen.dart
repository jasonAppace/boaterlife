import 'package:flutter/material.dart';
import 'package:hexacom_user/common/widgets/custom_button_widget2.dart';
import 'package:hexacom_user/common/widgets/custom_pop_scope_widget.dart';
import 'package:hexacom_user/features/onboarding/providers/onboarding_provider.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/utill/color_resources.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/routes.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:hexacom_user/common/widgets/custom_button_widget.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OnBoardingProvider>(context, listen: false).initBoardingList(context);

    return CustomPopScopeWidget(
      child: Scaffold(
        body: Consumer<OnBoardingProvider>(
          builder: (context, onBoardingList, child) => onBoardingList.onBoardingList.isNotEmpty
              ? SafeArea(
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: onBoardingList.onBoardingList.length,
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Image.asset(
                      onBoardingList.onBoardingList[index].imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    );
                  },
                  onPageChanged: (index) {
                    onBoardingList.changeSelectIndex(index);
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 30, bottom: 10),
                        child: Text(
                          onBoardingList.selectedIndex == 0
                              ? onBoardingList.onBoardingList[0].title
                              : onBoardingList.selectedIndex == 1
                              ? onBoardingList.onBoardingList[1].title
                              : onBoardingList.onBoardingList[2].title,
                          style: rubikBold.copyWith(
                              fontSize: 30.0, color: Theme.of(context).canvasColor),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: Text(
                          onBoardingList.selectedIndex == 0
                              ? onBoardingList.onBoardingList[0].description
                              : onBoardingList.selectedIndex == 1
                              ? onBoardingList.onBoardingList[1].description
                              : onBoardingList.onBoardingList[2].description,
                          style: rubikMedium.copyWith(
                            fontSize: 16,
                            color: Theme.of(context).shadowColor,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _getIndexList(onBoardingList.onBoardingList.length).map((i) {
                          return Container(
                            width: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? 16 : 7,
                            height: 7,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              color: i == Provider.of<OnBoardingProvider>(context).selectedIndex
                                  ? Theme.of(context).primaryColor
                                  : ColorResources.getGrayColor(context),
                              borderRadius: i == Provider.of<OnBoardingProvider>(context).selectedIndex
                                  ? BorderRadius.circular(50)
                                  : BorderRadius.circular(25),
                            ),
                          );
                        }).toList(),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(onBoardingList.selectedIndex == 2 ? 0 : 22),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                onBoardingList.selectedIndex == 2
                                    ? const SizedBox.shrink()
                                    : onBoardingList.selectedIndex != onBoardingList.onBoardingList.length - 1
                                    ? Align(
                                  alignment: Alignment.topRight,
                                  child: TextButton(
                                    onPressed: () {
                                      onBoardingList.toggleShowOnBoardingStatus();
                                      RouteHelper.getWelcomeRoute(context,
                                          action: RouteAction.pushReplacement);
                                    },
                                    child: Text(
                                      getTranslated('skip', context),
                                      style: rubikRegular.copyWith(
                                          color: Theme.of(context).textTheme.bodyLarge!.color),
                                    ),
                                  ),
                                )
                                    : const SizedBox(),
                                onBoardingList.selectedIndex == 2
                                    ? const SizedBox.shrink()
                                    : CustomButtonWidget2(
                                  height: 60,
                                  width: double.infinity,
                                  btnTxt: "       Next       ",
                                  onTap: () {
                                    _pageController.nextPage(
                                        duration: const Duration(seconds: 1), curve: Curves.ease);
                                  },
                                ),
                              ],
                            ),
                          ),
                          onBoardingList.selectedIndex == 2
                              ? Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                              child: CustomButtonWidget(
                                btnTxt: getTranslated('lets_start', context),
                                onTap: () {
                                  RouteHelper.getWelcomeRoute(context, action: RouteAction.pushReplacement);
                                },
                              ))
                              : const SizedBox.shrink(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              : const SizedBox(),
        ),
      ),
    );
  }

  List<int> _getIndexList(int length) {
    List<int> list = [];

    for (int i = 0; i < length; i++) {
      list.add(i);
    }

    return list;
  }
}
