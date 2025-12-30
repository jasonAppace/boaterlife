import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../../App/locator.dart';
import '../../../utill/appbar_with_backTitle.dart';
import '../../splash/providers/splash_provider.dart';
import '../ViewModels/main_view_model.dart';
import '../Widgets/color_utils.dart';
import '../Widgets/font_utils.dart';
import '../Widgets/page_horizontal_margin.dart';
import '../Widgets/text_widget.dart';
import '../Widgets/top_margin.dart';
import 'UserDetailScreen.dart';

class SearchUserScreen extends StatefulWidget {
  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  _searchUsers(String query, MainViewModel model) async {
    if (model.userSearchTF.text.isNotEmpty && model.userSearchTF.text.length > 2) {
      await model.doSearchUser(context, model.userToken ?? "", model.userSearchTF.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onViewModelReady: (model) async {},
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
              body: PageHorizontalMargin(
                horizontal: 15,
            widget: Column(
              children: [
                TopMargin(),
                const AppBarWithBackTitle(
                  title: "Search Users",
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: model.userSearchTF,
                  onChanged: (query) => _searchUsers(query, model),
                  decoration: InputDecoration(
                    hintText: "Search Users",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color:  Theme.of(context).primaryColor, // Border color when focused
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color:  Theme.of(context).primaryColor, // Border color when not focused
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: (model.allSearchUserData?.data?.isEmpty ?? false)
                      ? const Center(child: Text("No users found"))
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                print("Searched User Tapped");

                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: UserDetailScreen(
                                      userID: model.allSearchUserData?.data?[index].id.toString() ?? "0",
                                    ),
                                  ),
                                );
                              },
                              child: PageHorizontalMargin(
                                widget: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: CachedNetworkImage(
                                            imageUrl: '${splashProvider.baseUrls!.customerImageUrl}/' '${model.allSearchUserData?.data?[index].image ?? ""}',
                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                            fit: BoxFit.cover,
                                            width: 56,
                                            height: 56,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextWidget(
                                                textValue: model.allSearchUserData?.data?[index].name ?? "",
                                                textColor: ColorUtils.black,
                                                fontFamily: FontUtils.urbanistSemiBold,
                                                fontSize: 14,
                                              ),
                                              TextWidget(
                                                textValue: model.allSearchUserData?.data?[index].email ?? "",
                                                textColor: ColorUtils.hintGrey,
                                                fontFamily: FontUtils.urbanistRegular,
                                                fontSize: 14,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemCount: model.allSearchUserData?.data?.length ?? 0,
                        ),
                ),
              ],
            ),
          )),
        );
      },
    );
  }
}
