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
    Provider.of<OnBoardingProvider>(context, listen: false)
        .initBoardingList(context);

    return CustomPopScopeWidget(
      child: Scaffold(
        body: Consumer<OnBoardingProvider>(
          builder: (context, onBoardingList, child) => onBoardingList
                  .onBoardingList.isNotEmpty
              ? Stack(
                  children: [
                    PageView.builder(
                      itemCount: onBoardingList.onBoardingList.length,
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Image.asset(
                                onBoardingList.onBoardingList[index].imageUrl,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        );
                      },
                      onPageChanged: (index) {
                        onBoardingList.changeSelectIndex(index);
                      },
                    ),
                    Positioned(
                      right: 30,
                      top: 60,
                      child: onBoardingList.selectedIndex == 2
                          ? const SizedBox.shrink()
                          : onBoardingList.selectedIndex !=
                                  onBoardingList.onBoardingList.length - 1
                              ? SizedBox(
                                  width: 37,
                                  height: 37,
                                  child: TextButton(
                                    onPressed: () {
                                      onBoardingList
                                          .toggleShowOnBoardingStatus();
                                      RouteHelper.getLoginRoute(context,
                                          action: RouteAction.pushReplacement);
                                    },
                                    style: TextButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: ColorResources
                                            .getOnBoardingShadeColor(context)),
                                    child: Text(
                                      'SKIP',
                                      style: rubikSemiBold.copyWith(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent, // hide top edge
                              Colors.white, // fully visible
                            ],
                            stops: [0.0, 0.3],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          decoration: BoxDecoration(
                            color: ColorResources.colorDarkBlue,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: AlignmentGeometry.bottomCenter,
                              colors: [
                                ColorResources.getOnBoardingShadeColor(context)
                                    .withValues(alpha: 0.98),
                                ColorResources.getOnBoardingShadeColor(
                                    context), // solid body
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 30, bottom: 10),
                            child: Text(
                              onBoardingList.selectedIndex == 0
                                  ? onBoardingList.onBoardingList[0].title
                                  : onBoardingList.selectedIndex == 1
                                      ? onBoardingList.onBoardingList[1].title
                                      : onBoardingList.onBoardingList[2].title,
                              style: rubikBold.copyWith(
                                  fontSize: 39.0,
                                  color: Theme.of(context).canvasColor),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeLarge),
                            child: Text(
                              onBoardingList.selectedIndex == 0
                                  ? onBoardingList.onBoardingList[0].description
                                  : onBoardingList.selectedIndex == 1
                                      ? onBoardingList
                                          .onBoardingList[1].description
                                      : onBoardingList
                                          .onBoardingList[2].description,
                              style: rubikMedium.copyWith(
                                fontSize: 16,
                                color: Theme.of(context).shadowColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(height: 35),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _getIndexList(
                                    onBoardingList.onBoardingList.length)
                                .map((i) {
                              return Container(
                                width: i ==
                                        Provider.of<OnBoardingProvider>(context)
                                            .selectedIndex
                                    ? 8
                                    : 6,
                                height: i ==
                                        Provider.of<OnBoardingProvider>(context)
                                            .selectedIndex
                                    ? 8
                                    : 6,
                                margin: const EdgeInsets.only(right: 7),
                                decoration: BoxDecoration(
                                  color: i ==
                                          Provider.of<OnBoardingProvider>(
                                                  context)
                                              .selectedIndex
                                      ? Theme.of(context).primaryColor
                                      : ColorResources.getGrayColor(context),
                                  borderRadius: i ==
                                          Provider.of<OnBoardingProvider>(
                                                  context)
                                              .selectedIndex
                                      ? BorderRadius.circular(50)
                                      : BorderRadius.circular(50),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              // Container(
                              //   padding: EdgeInsets.all(onBoardingList.selectedIndex == 2 ? 0 : 22),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       // onBoardingList.selectedIndex == 2
                              //       //     ? const SizedBox.shrink()
                              //       //     : onBoardingList.selectedIndex != onBoardingList.onBoardingList.length - 1
                              //       //     ? Align(
                              //       //   alignment: Alignment.topRight,
                              //       //   child: TextButton(
                              //       //     onPressed: () {
                              //       //       onBoardingList.toggleShowOnBoardingStatus();
                              //       //       RouteHelper.getWelcomeRoute(context,
                              //       //           action: RouteAction.pushReplacement);
                              //       //     },
                              //       //     child: Text(
                              //       //       getTranslated('skip', context),
                              //       //       style: rubikRegular.copyWith(
                              //       //           color: Theme.of(context).textTheme.bodyLarge!.color),
                              //       //     ),
                              //       //   ),
                              //       // )
                              //       //     : const SizedBox(),
                              //       onBoardingList.selectedIndex == 2
                              //           ? const SizedBox.shrink()
                              //           : CustomButtonWidget2(
                              //         height: 60,
                              //         width: double.infinity,
                              //         btnTxt: "       Next       ",
                              //         onTap: () {
                              // _pageController.nextPage(
                              //     duration: const Duration(seconds: 1), curve: Curves.ease);
                              //         },
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              onBoardingList.selectedIndex == 2
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeLarge),
                                      child: CustomButtonWidget(
                                        height: 60,
                                        style: rubikSemiBold.copyWith(
                                            color: ColorResources
                                                .getOnBoardingShadeColor(
                                                    context),
                                            fontSize: 18),
                                        btnTxt: "       Next       ",
                                        onTap: () {
                                          _pageController.nextPage(
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.ease);
                                        },
                                      )),
                              onBoardingList.selectedIndex == 2
                                  ? Padding(
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeLarge),
                                      child: CustomButtonWidget(
                                        height: 60,
                                        style: rubikSemiBold.copyWith(
                                            color: ColorResources.colorDarkBlue,
                                            fontSize: 18),
                                        btnTxt: getTranslated(
                                            'lets_start', context),
                                        onTap: () {
                                          RouteHelper.getLoginRoute(context,
                                              action:
                                                  RouteAction.pushReplacement);
                                          // RouteHelper.getWelcomeRoute(context,
                                          //     action:
                                          //         RouteAction.pushReplacement);
                                        },
                                      ))
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 65),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
