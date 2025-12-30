import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexacom_user/features/Community/Widgets/extensions.dart';
import 'package:hexacom_user/utill/app_constants.dart';
import 'package:hexacom_user/utill/styles.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../../App/locator.dart';
import '../../../utill/CustomSeperator.dart';
import '../../../utill/appbar_with_backTitle.dart';
import '../../../utill/images.dart';
import '../../splash/providers/splash_provider.dart';
import '../ChatModels/groupChatMessagesModel.dart';
import '../ChatModels/individualChatMessagesModel.dart';
import '../ViewModels/main_view_model.dart';
import '../Widgets/top_margin.dart';
import 'GroupDetailScreen.dart';
import '../Widgets/color_utils.dart';
import '../Widgets/custom_text_field.dart';
import '../Widgets/font_utils.dart';
import '../Widgets/text_widget.dart';

class FeedChatScreen extends StatefulWidget {
  final String? groupID;
  final String chatType;
  final String? userID;
  final String? userName;

  FeedChatScreen({this.groupID, required this.chatType, this.userID, this.userName});

  @override
  _FeedChatScreenState createState() => _FeedChatScreenState();
}

class _FeedChatScreenState extends State<FeedChatScreen> {
  late PusherChannelsFlutter pusher;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializePusher();
  }

  @override
  void dispose() {
    _disconnectPusher();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializePusher() async {
    pusher = PusherChannelsFlutter.getInstance();

    try {
      await pusher.init(
          apiKey: AppConstants.pusherApiKey,
          cluster: AppConstants.pusherCluster,
          onAuthorizer: _onAuthorizer,
          onError: (message, code, exception) {
            if (kDebugMode) {
              print('Pusher error: $message');
            }
          },
          onSubscriptionSucceeded: (channelName, data) {
            if (kDebugMode) {
              print('Subscribed to channel: $channelName');
            }
          },
          onSubscriptionError: (channelName, error) {
            if (kDebugMode) {
              print('Error subscribing to channel: $channelName, error: $error');
            }
          });

      await pusher.connect();

      await pusher.subscribe(
        channelName: 'private-boaterslife',
        onEvent: (event) {
          if (kDebugMode) {
            print(event);
          }
          if (event.eventName == 'messaging') {
            if (kDebugMode) {
              print('New message received: ${event.data}');
            }
            _refreshAndScroll(true);
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Pusher: $e');
      }
    }
  }

  Future<dynamic> _onAuthorizer(String channelName, String socketId, dynamic additionalData) async {
    final dio = Dio();
    final mainViewModel = locator<MainViewModel>();
    final token = mainViewModel.userToken;

    try {
      final response = await dio.post(
        AppConstants.pusherAuthApi,
        options: Options(headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: {
          'socket_id': socketId,
          'channel_name': channelName,
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Pusher Auth Check');
        }
        try {
          var jsonString = response.data["data"];
          var data = jsonDecode(jsonString);
          return data;
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing JSON response: $e');
          }
          throw Exception('Authentication failed');
        }
      } else {
        throw Exception('Authentication failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Authentication failed');
    }
  }

  void _disconnectPusher() {
    pusher.unsubscribe(channelName: 'private-boaterslife');
    pusher.disconnect();
  }

  Future<void> _refreshAndScroll(bool animated) async {
    final model = locator<MainViewModel>();

    if (widget.chatType == "Group") {
      await model.doGroupChatMessages(context, model.userToken ?? "", widget.groupID ?? "");
    } else {
      await model.doIndividualChatMessages(context, model.userToken ?? "", widget.userID ?? "");
    }
    if (mounted) {
      setState(() {
        _scrollToBottom(animated);
      });
    }
  }

  void _scrollToBottom(bool animated) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (animated) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onViewModelReady: (model) async {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _refreshAndScroll(false);
        });
      },
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            body: Column(
              children: [
                const TopMargin(),
                AppBarWithBackTitle(
                  title: 'Chat',
                  suffixIcon2: Images.kebebMenuIc,
                  onSuffixButtonPressed2: () {
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: GroupDetailScreen(groupID: int.parse(widget.groupID ?? "0"))));
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                const CustomSeparator(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    controller: _scrollController,
                    itemCount: widget.chatType == "Group" ? model.allGroupChatMessagesData?.messages?.length ?? 0 : model.allIndividualChatMessagesData?.messages?.length ?? 0,
                    itemBuilder: (context, index) {
                      GroupChatMessagesModel? groupChatMessages;
                      Message? message;
                      IndividualChatMessagesModel? individualChatMessages;
                      MessageIndi? messageIndi;

                      if (widget.chatType == "Group") {
                        groupChatMessages = model.allGroupChatMessagesData;
                        message = groupChatMessages?.messages?[index];
                      } else {
                        individualChatMessages = model.allIndividualChatMessagesData;
                        messageIndi = individualChatMessages?.messages?[index];
                      }

                      if (message == null && messageIndi == null) {
                        return const SizedBox();
                      }

                      final isSentByMe = widget.chatType == "Group" ? message?.fromId.toString() == model.userID : messageIndi?.fromId.toString() == model.userID;

                      final profileImageUrl =
                          widget.chatType == "Group" ? '${splashProvider.baseUrls!.customerImageUrl}/' '${message?.user?.image ?? ""}' : messageIndi?.user?.image ?? "";

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            if (isSentByMe)
                              Text(
                                widget.chatType == "Group" ? message?.updatedAt ?? "" : messageIndi?.updatedAt ?? "",
                                style: TextStyle(fontFamily: FontUtils.urbanistMedium, fontSize: 12, color: ColorUtils.hintGrey),
                              ),
                            if (isSentByMe)
                              SizedBox(
                                width: 18,
                              ),
                            if (!isSentByMe)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CachedNetworkImage(
                                  imageUrl: profileImageUrl,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (!isSentByMe) const SizedBox(width: 8),
                            Flexible(
                              child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: ColorUtils.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.chatType == "Group" ? message?.user?.name ?? "" : messageIndi?.user?.name ?? "",
                                        style: TextStyle(
                                          fontFamily: rubikBold.fontFamily,
                                          fontWeight: rubikBold.fontWeight,
                                          fontSize: 14,
                                          color: isSentByMe ? Theme.of(context).primaryColor : ColorUtils.black,
                                        ),
                                      ),
                                      Text(
                                        widget.chatType == "Group" ? message?.body ?? "" : messageIndi?.body ?? "",
                                        style: TextStyle(
                                          fontFamily: FontUtils.urbanistRegular,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            if (isSentByMe) const SizedBox(width: 8),
                            if (isSentByMe)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CachedNetworkImage(
                                  imageUrl: profileImageUrl,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (!isSentByMe)
                              SizedBox(
                                width: 15,
                              ),
                            if (!isSentByMe)
                              Text(
                                widget.chatType == "Group" ? message?.updatedAt ?? "" : messageIndi?.updatedAt ?? "",
                                style: TextStyle(fontFamily: FontUtils.urbanistMedium, fontSize: 12, color: ColorUtils.hintGrey),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                (widget.chatType == "Group" ? (model.allGroupChatMessagesData?.blocked == 1) : ((model.allIndividualChatMessagesData?.blockedBy?.length ?? 0) > 0))
                    ? Container(
                        width: double.infinity,
                        color:Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 42.0, vertical: 12),
                          child: TextWidget(
                            textValue: "You can't send messages to this group because you are blocked by this user.",
                            textColor: ColorUtils.white,
                            fontFamily: FontUtils.urbanistSemiBold,
                            fontSize: 14,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                hintText: 'Type something here',
                                FieldHeight: 0.8.h,
                                controller: model.groupChatMessageController,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () async {
                                if (widget.chatType == "Group") {
                                  await model.dogroupChatMessageSend(
                                    context,
                                    model.userToken ?? "",
                                    widget.groupID ?? "",
                                    model.groupChatMessageController.text,
                                  );
                                } else {
                                  await model.doindividualChatMessageSend(
                                    context,
                                    model.userToken ?? "",
                                    widget.userID ?? "",
                                    model.groupChatMessageController.text,
                                  );
                                }
                              },
                              child: SvgPicture.asset(Images.messageSend),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
