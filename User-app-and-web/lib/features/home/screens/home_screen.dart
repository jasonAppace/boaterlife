import 'package:hexacom_user/common/enums/footer_type_enum.dart';
import 'package:hexacom_user/common/enums/product_filter_type_enum.dart';
import 'package:hexacom_user/common/widgets/custom_app_bar_widget.dart';
import 'package:hexacom_user/common/widgets/custom_asset_image_widget.dart';
import 'package:hexacom_user/common/widgets/custom_single_child_list_widget.dart';
import 'package:hexacom_user/common/widgets/footer_web_widget.dart';
import 'package:hexacom_user/common/widgets/home_app_bar_widget.dart';
import 'package:hexacom_user/common/widgets/product_filter_popup_widget.dart';
import 'package:hexacom_user/common/widgets/title_widget.dart';
import 'package:hexacom_user/features/auth/providers/auth_provider.dart';
import 'package:hexacom_user/features/category/providers/category_provider.dart';
import 'package:hexacom_user/features/home/enums/banner_type_enum.dart';
import 'package:hexacom_user/features/home/providers/banner_provider.dart';
import 'package:hexacom_user/features/flash_sale/providers/flash_sale_provider.dart';
import 'package:hexacom_user/features/home/screens/weather_screen.dart';
import 'package:hexacom_user/features/home/widgets/banner_widget.dart';
import 'package:hexacom_user/features/home/widgets/category_widget.dart';
import 'package:hexacom_user/features/home/widgets/feature_category_widget.dart';
import 'package:hexacom_user/features/home/widgets/flash_sale_widget.dart';
import 'package:hexacom_user/features/home/widgets/main_slider_shimmer_widget.dart';
import 'package:hexacom_user/features/home/widgets/main_slider_widget.dart';
import 'package:hexacom_user/features/home/widgets/new_arrival_widget.dart';
import 'package:hexacom_user/features/home/widgets/offer_product_widget.dart';
import 'package:hexacom_user/features/home/widgets/product_list_widget.dart';
import 'package:hexacom_user/features/menu/widgets/options_widget.dart';
import 'package:hexacom_user/features/product/providers/product_provider.dart';
import 'package:hexacom_user/features/profile/providers/profile_provider.dart';
import 'package:hexacom_user/features/splash/providers/splash_provider.dart';
import 'package:hexacom_user/features/wishlist/providers/wishlist_provider.dart';
import 'package:hexacom_user/helper/responsive_helper.dart';
import 'package:hexacom_user/localization/language_constrants.dart';
import 'package:hexacom_user/utill/color_resources.dart';
import 'package:hexacom_user/utill/dimensions.dart';
import 'package:hexacom_user/utill/routes.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Community/Widgets/color_utils.dart';
import '../../Community/Widgets/font_utils.dart';
import '../../Community/Widgets/text_widget.dart';
import '../../address/providers/address_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Future<void> loadData(BuildContext context, bool reload) async {
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final BannerProvider bannerProvider =
        Provider.of<BannerProvider>(context, listen: false);
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    final WishListProvider wishListProvider =
        Provider.of<WishListProvider>(context, listen: false);
    final FlashSaleProvider flashSaleProvider =
        Provider.of<FlashSaleProvider>(context, listen: false);
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final AddressProvider locationPRovider =
        Provider.of<AddressProvider>(context, listen: false);

    if (reload) {
      await splashProvider.initConfig();
      await splashProvider.getDeliveryInfo();
    }

    splashProvider.getPolicyPage(reload: reload);

    if (authProvider.isLoggedIn() &&
        (profileProvider.userInfoModel == null || reload)) {
      await profileProvider.getUserInfo();
    }
    if (authProvider.isLoggedIn()) {
      await wishListProvider.getWishList();
    }

    categoryProvider.getFeatureCategories(reload, isUpdate: reload);
    categoryProvider.getCategoryList(reload);
    bannerProvider.getBannerList(reload);
    productProvider.getOfferProductList(reload);
    productProvider.getLatestProductList(1, isUpdate: reload);
    flashSaleProvider.getFlashSaleProducts(1, reload);
    productProvider.getNewArrivalProducts(1, reload);
    locationPRovider.initAddressList();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  ProductFilterType? filterType;
  final ScrollController scrollController = ScrollController();
  final ScrollController newArrivalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: drawerGlobalKey,
        endDrawerEnableOpenDragGesture: false,
        drawer: ResponsiveHelper.isTab(context)
            ? const Drawer(child: OptionsWidget(onTap: null))
            : const SizedBox(),
        appBar: const CustomAppBarWidget(onlyDesktop: true, space: 0),
        body: RefreshIndicator(
          color: Theme.of(context).secondaryHeaderColor,
          onRefresh: () async {
            filterType = null;
            Provider.of<ProductProvider>(context, listen: false).offset = 1;
            await HomeScreen.loadData(context, true);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              // App Bar
              ResponsiveHelper.isDesktop(context)
                  ? const SliverToBoxAdapter(child: SizedBox())
                  : HomeAppBarWidget(drawerGlobalKey: drawerGlobalKey),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 15,
                ),
              ),
              // Search Button
              ResponsiveHelper.isDesktop(context)
                  ? const SliverToBoxAdapter(child: SizedBox())
                  : SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverDelegate(
                          child: Center(
                        child: InkWell(
                          onTap: () => RouteHelper.getSearchRoute(context,
                              action: RouteAction.push),
                          child: Container(
                            height: 60,
                            width: Dimensions.webScreenWidth,
                            color: Theme.of(context).cardColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    Dimensions.paddingSizeExtraExtraLarge,
                                vertical: 2),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.04),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: ColorResources
                                          .getOnBoardingShadeColor(context))),
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeSmall),
                                  child: Icon(
                                    Icons.search,
                                    size: 25,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                        getTranslated(
                                            'search_for_products', context),
                                        style: rubikRegular.copyWith(
                                            fontSize: 12))),
                              ]),
                            ),
                          ),
                        ),
                      )),
                    ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge),
                  color: ColorResources.getHomeScreenBackgroundColor(context),
                  child: Column(
                    children: [
                      Center(
                          child: SizedBox(
                        width: Dimensions.webScreenWidth,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResponsiveHelper.isDesktop(context)
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: Dimensions.paddingSizeDefault),
                                      child: Consumer<BannerProvider>(builder:
                                          (context, bannerProvider, _) {
                                        return bannerProvider.bannerList == null
                                            ? const MainSliderShimmerWidget()
                                            : SizedBox(
                                                height: 380,
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      if (bannerProvider
                                                          .bannerList!
                                                          .isNotEmpty)
                                                        SizedBox(
                                                          width: bannerProvider
                                                                  .secondaryBannerList!
                                                                  .isNotEmpty
                                                              ? 780
                                                              : Dimensions
                                                                  .webScreenWidth,
                                                          child:
                                                              MainSliderWidget(
                                                            bannerList:
                                                                bannerProvider
                                                                    .bannerList,
                                                            bannerType:
                                                                BannerType
                                                                    .primary,
                                                            isMainOnly:
                                                                bannerProvider
                                                                    .secondaryBannerList!
                                                                    .isEmpty,
                                                          ),
                                                        ),
                                                      if (bannerProvider
                                                          .secondaryBannerList!
                                                          .isNotEmpty)
                                                        SizedBox(
                                                          width: 380,
                                                          child:
                                                              MainSliderWidget(
                                                            bannerList:
                                                                bannerProvider
                                                                    .secondaryBannerList,
                                                            bannerType:
                                                                BannerType
                                                                    .secondary,
                                                          ),
                                                        ),
                                                    ]),
                                              );
                                      }),
                                    )
                                  : const SizedBox(),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WeatherForecastScreen()));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeDefault,
                                        vertical: 20),
                                    child: Container(
                                        width: double.infinity,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: ColorUtils.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.26),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                              offset: Offset(0, 4),
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextWidget(
                                                    textValue: DateFormat(
                                                            'EEEE, MMM yyyy')
                                                        .format(DateTime.now()),
                                                    fontFamily:
                                                        FontUtils.urbanistBold,
                                                    fontSize: 12,
                                                    textAlign: TextAlign.center,
                                                    textColor: ColorUtils.grey2,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextWidget(
                                                    textValue:
                                                        "Weather Forecast >",
                                                    fontFamily:
                                                        FontUtils.urbanistBold,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    textAlign: TextAlign.center,
                                                    textColor: ColorResources
                                                        .getOnBoardingShadeColor(
                                                            context),
                                                  ),
                                                ],
                                              ),
                                              CustomAssetImageWidget(
                                                "assets/image/weatherImg.png",
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              )
                                            ],
                                          ),
                                        )),
                                  )),
                              const CategoryWidget(),

                              /// Flash Sale
                              const FlashSaleWidget(),

                              /// Banner
                              ResponsiveHelper.isDesktop(context)
                                  ? const SizedBox()
                                  : Consumer<BannerProvider>(
                                      builder: (context, banner, child) {
                                        return banner.bannerList == null
                                            ? const BannerWidget()
                                            : banner.bannerList!.isEmpty
                                                ? const SizedBox()
                                                : const BannerWidget();
                                      },
                                    ),

                              /// Offer Product
                              Consumer<ProductProvider>(
                                builder: (context, offerProduct, child) {
                                  return offerProduct.offerProductList == null
                                      ? const SizedBox()
                                      : offerProduct.offerProductList!.isEmpty
                                          ? const SizedBox()
                                          : const OfferProductWidget();
                                },
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),

                              /// Campaign
                              if (!ResponsiveHelper.isDesktop(context))
                                Consumer<BannerProvider>(
                                    builder: (context, bannerProvider, _) {
                                  return MainSliderWidget(
                                    bannerType: BannerType.secondary,
                                    bannerList:
                                        bannerProvider.secondaryBannerList,
                                  );
                                }),

                              /// New Arrival
                              const NewArrivalWidget(),

                              Consumer<CategoryProvider>(
                                  builder: (context, categoryProvider, _) {
                                return categoryProvider.featureCategoryMode !=
                                        null
                                    ? CustomSingleChildListWidget(
                                        itemCount: categoryProvider
                                                .featureCategoryMode
                                                ?.featuredData
                                                ?.length ??
                                            0,
                                        itemBuilder: (index) =>
                                            FeatureCategoryWidget(
                                          featuredCategory: categoryProvider
                                              .featureCategoryMode!
                                              .featuredData?[index],
                                        ),
                                      )
                                    : const SizedBox();
                              }),

                              Consumer<ProductProvider>(
                                  builder: (context, productProvider, _) {
                                return Padding(
                                  padding: ResponsiveHelper.isDesktop(context)
                                      ? const EdgeInsets.only(
                                          top: Dimensions.paddingSizeExtraLarge,
                                          bottom: Dimensions.paddingSizeLarge)
                                      : const EdgeInsets.fromLTRB(
                                          20, 10, 20, 10),
                                  child: TitleWidget(
                                    title: getTranslated('all_items', context),
                                    leadingButton: ProductFilterPopupWidget(
                                      isFilterActive: filterType != null,
                                      onSelected: (result) {
                                        filterType = result;
                                        productProvider.getLatestProductList(1,
                                            filterType: result);
                                      },
                                    ),
                                  ),
                                );
                              }),

                              ProductListWidget(
                                  scrollController: scrollController,
                                  filterType: filterType),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                            ]),
                      )),
                    ],
                  ),
                ),
              ),

              const FooterWebWidget(footerType: FooterType.sliver),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  _SliverDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(_SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
