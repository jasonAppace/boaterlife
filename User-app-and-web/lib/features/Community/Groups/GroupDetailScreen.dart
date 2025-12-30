import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../../App/locator.dart';
import '../../chat/screens/chat_screen.dart';
import '../../splash/providers/splash_provider.dart';
import '../ViewModels/main_view_model.dart';
import '../Widgets/color_utils.dart';
import '../Widgets/custom_button_border.dart';
import '../Widgets/expandable_text_widget.dart';
import '../Widgets/font_utils.dart';
import '../Widgets/page_horizontal_margin.dart';
import '../Widgets/text_widget.dart';
import 'ChatScreen.dart';

class GroupDetailScreen extends StatefulWidget {
  final int? groupID;
  GroupDetailScreen({super.key, required this.groupID});
  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onViewModelReady: (model) async {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await model.doGroupDetail(context, model.userToken ?? "", widget.groupID ?? 0);
          await model.doGroupMember(context, model.userToken ?? "", widget.groupID ?? 0);
        });
      },
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: const Color(0xFFF9FCFE),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: TextWidget(
                textValue: 'Group Detail',
                textColor: ColorUtils.black,
                fontFamily: FontUtils.urbanistBold,
                fontSize: 20,
              ),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF87CDEA).withOpacity(0.1),
                      Colors.white,
                    ],
                  ),
                ),
              ),
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: PageHorizontalMargin(
                    horizontal: 16,
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    imageUrl: model.allGroupDetailData?.data?.image ?? "",
                                    placeholder: (context, url) => Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: ColorUtils.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: ColorUtils.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Icon(Icons.group, color: ColorUtils.grey),
                                    ),
                                    fit: BoxFit.cover,
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextWidget(
                                textValue: model.allGroupDetailData?.data?.name ?? "",
                                textColor: ColorUtils.black,
                                fontFamily: FontUtils.urbanistBold,
                                fontSize: 18,
                              ),
                              const SizedBox(height: 12),
                              if ((model.allGroupDetailData?.data?.userId.toString() ?? "0") != model.userID)
                                ElevatedButton(
                                  onPressed: model.loadingWidget == true
                                      ? null
                                      : () {
                                          model.doGroupLeave(
                                            context,
                                            model.userToken ?? "",
                                            widget.groupID ?? 0,
                                          );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.withOpacity(0.1),
                                    foregroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                  child: TextWidget(
                                    textValue: "Leave Group",
                                    textColor: Colors.red,
                                    fontFamily: FontUtils.urbanistSemiBold,
                                    fontSize: 14,
                                  ),
                                ),
                              if ((model.allGroupDetailData?.data?.userId.toString() ?? "0") == model.userID)
                                ElevatedButton(
                                  onPressed: model.loadingWidget == true
                                      ? null
                                      : () {
                                          model.doGroupStatusChange(
                                            context,
                                            model.userToken ?? "",
                                            widget.groupID ?? 0,
                                          );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                  child: TextWidget(
                                    textValue: (model.allGroupDetailData?.data?.active ?? 0) == 1 ? "Activate Group" : "Deactivate Group",
                                    textColor: Colors.white,
                                    fontFamily: FontUtils.urbanistSemiBold,
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                textValue: "Description",
                                textColor: ColorUtils.black,
                                fontFamily: FontUtils.urbanistBold,
                                fontSize: 18,
                              ),
                              const SizedBox(height: 12),
                              ExpandableTextWidget(
                                textValue: model.allGroupDetailData?.data?.description ?? "",
                                textColor: ColorUtils.black,
                                fontFamily: FontUtils.urbanistRegular,
                                fontSize: 15,
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidget(
                                    textValue: "${model.allGroupMemberData?.data?.length ?? 0} Members",
                                    textColor: ColorUtils.black,
                                    fontFamily: FontUtils.urbanistBold,
                                    fontSize: 18,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final member = model.allGroupMemberData?.data?[index];
                        final isSelf = member?.id.toString() == model.userID;
                        final isAdmin = member?.pivot?.isAdmin == 1;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: CachedNetworkImage(
                                        imageUrl: '${splashProvider.baseUrls!.customerImageUrl}/${member?.image ?? ""}',
                                        placeholder: (context, url) => Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: ColorUtils.grey.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: ColorUtils.grey.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                          child: Icon(Icons.person, color: ColorUtils.grey),
                                        ),
                                        fit: BoxFit.cover,
                                        width: 44,
                                        height: 44,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          textValue: member?.name ?? "",
                                          textColor: ColorUtils.black,
                                          fontFamily: FontUtils.urbanistSemiBold,
                                          fontSize: 14,
                                        ),
                                        if (isAdmin)
                                          TextWidget(
                                            textValue: "Admin",
                                            textColor: ColorUtils.grey3,
                                            fontFamily: FontUtils.urbanistMedium,
                                            fontSize: 12,
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (!isSelf) // Only show actions for others
                                    Row(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type: PageTransitionType.bottomToTop,
                                                    child: FeedChatScreen(
                                                      userID: member?.id.toString() ?? "",
                                                      chatType: 'Individual',
                                                    ),
                                                  ),
                                                );
                                              },
                                              borderRadius: BorderRadius.circular(14),
                                              child: Center(
                                                child: TextWidget(
                                                  textValue: "Chat",
                                                  textColor: Colors.white,
                                                  fontFamily: FontUtils.urbanistSemiBold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 80,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                if (model.loadingWidget == true) return;
                                                model.doGroupMemberBlockUnblock(
                                                  context,
                                                  model.userToken ?? "",
                                                  widget.groupID ?? 0,
                                                  member?.id ?? 0,
                                                );
                                              },
                                              borderRadius: BorderRadius.circular(14),
                                              child: Center(
                                                child: TextWidget(
                                                  textValue: (member?.pivot?.blocked ?? 0) == 0 ? "Block" : "Unblock",
                                                  textColor: Colors.red,
                                                  fontFamily: FontUtils.urbanistSemiBold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (isSelf)
                                    Container(
                                      width: 80,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {},
                                          borderRadius: BorderRadius.circular(14),
                                          child: Center(
                                            child: TextWidget(
                                              textValue: "You",
                                              textColor: Colors.white,
                                              fontFamily: FontUtils.urbanistSemiBold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: model.allGroupMemberData?.data?.length ?? 0,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
