import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../../App/locator.dart';
import '../../splash/providers/splash_provider.dart';
import '../ViewModels/main_view_model.dart';
import '../Widgets/color_utils.dart';
import '../Widgets/font_utils.dart';
import '../Widgets/page_horizontal_margin.dart';
import '../Widgets/text_widget.dart';
import 'ChatScreen.dart';

class ChatMainScreen extends StatefulWidget {
  @override
  _ChatMainScreenState createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onViewModelReady: (model) async {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await model.doGroupChatList(context, model.userToken ?? "");
          await model.doIndividualChatList(context, model.userToken ?? "");
        });
      },
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            appBar: AppBar(
              title: Center(
                child: TextWidget(
                  textValue: 'Message          ',
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Individual'),
                  Tab(text: 'Groups'),
                ],
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                // Individual Chat View
                ListView.separated(
                  padding: EdgeInsets.only(top: 8),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: FeedChatScreen(
                                  userID: model.allIndividualChatListData?.data?[index].id.toString() ?? "",
                                  userName: model.allIndividualChatListData?.data?[index].name.toString() ?? "",
                                  chatType: 'Individual',
                                )));
                      },
                      child: PageHorizontalMargin(
                        horizontal: 10,
                        widget: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    imageUrl: model.allIndividualChatListData?.data?[index].image ?? "",
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                    width: 56,
                                    height: 56,
                                  ),
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        textValue: model.allIndividualChatListData?.data?[index].name ?? "",
                                        textColor: ColorUtils.black,
                                        fontFamily: FontUtils.urbanistSemiBold,
                                        fontSize: 14,
                                      ),
                                      TextWidget(
                                        textValue: model.allIndividualChatListData?.data?[index].latest?.body ?? "",
                                        textColor: ColorUtils.hintGrey,
                                        fontFamily: FontUtils.urbanistRegular,
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     TextWidget(
                                //       textValue: "07/21",
                                //       textColor: ColorUtils.hintGrey,
                                //       fontFamily: FontUtils.urbanistRegular,
                                //       fontSize: 14,
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: model.allIndividualChatListData?.data?.length ?? 0,
                ),
                // Group Chat View
                ListView.separated(
                  padding: EdgeInsets.only(top: 8),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: FeedChatScreen(
                                  groupID: model.allGroupChatListData?.data?[index]?.id.toString() ?? "",
                                  chatType: "Group",
                                )));
                      },
                      child: PageHorizontalMargin(
                        horizontal: 10,
                        widget: Column(
                          children: [
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    imageUrl: model.allGroupChatListData?.data?[index]?.image ?? "",
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                    width: 56,
                                    height: 56,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        textValue: model.allGroupChatListData?.data?[index]?.name ?? "",
                                        textColor: ColorUtils.black,
                                        fontFamily: FontUtils.urbanistSemiBold,
                                        fontSize: 14,
                                      ),
                                      TextWidget(
                                        textValue: model.allGroupChatListData?.data?[index]?.description ?? "",
                                        textColor: ColorUtils.hintGrey,
                                        fontFamily: FontUtils.urbanistRegular,
                                        fontSize: 14,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     TextWidget(
                                //       textValue: "07/21",
                                //       textColor: ColorUtils.hintGrey,
                                //       fontFamily: FontUtils.urbanistRegular,
                                //       fontSize: 14,
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: model.allGroupChatListData?.data?.length ?? 0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
