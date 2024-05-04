import 'package:sixam_mart_store/features/notification/controllers/notification_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/notification/widgets/notification_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  final bool fromNotification;
  const NotificationScreen({super.key, this.fromNotification = false});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<NotificationController>().getNotificationList();

  }
  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvoked: (didPop) async {
        if(widget.fromNotification && !didPop) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        } else {
          return;
        }
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(title: 'notification'.tr, onTap: (){
          if(widget.fromNotification){
            Get.offAllNamed(RouteHelper.getInitialRoute());
          }else{
            Get.back();
          }
        }),
        body: GetBuilder<NotificationController>(builder: (notificationController) {
          if(notificationController.notificationList != null) {
            notificationController.saveSeenNotificationCount(notificationController.notificationList!.length);
          }
          List<DateTime> dateTimeList = [];
          return notificationController.notificationList != null ? notificationController.notificationList!.isNotEmpty ? RefreshIndicator(
            onRefresh: () async {
              await notificationController.getNotificationList();
            },
            child: SingleChildScrollView(child: Center(child: SizedBox(width: 1170, child: ListView.builder(
              itemCount: notificationController.notificationList!.length,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                DateTime originalDateTime = DateConverterHelper.dateTimeStringToDate(notificationController.notificationList![index].createdAt!);
                DateTime convertedDate = DateTime(originalDateTime.year, originalDateTime.month, originalDateTime.day);
                bool addTitle = false;
                if(!dateTimeList.contains(convertedDate)) {
                  addTitle = true;
                  dateTimeList.add(convertedDate);
                }
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  addTitle ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text(DateConverterHelper.dateTimeStringToDateOnly(notificationController.notificationList![index].createdAt!)),
                  ) : const SizedBox(),

                  ListTile(
                    onTap: () {
                      showDialog(context: context, builder: (BuildContext context) {
                        return NotificationDialogWidget(notificationModel: notificationController.notificationList![index]);
                      });
                    },
                    leading: ClipOval(child: CustomImageWidget(
                      isNotification: true,
                      height: 40, width: 40, fit: BoxFit.cover,
                      image: '${Get.find<SplashController>().configModel!.baseUrls!.notificationImageUrl}'
                          '/${notificationController.notificationList![index].image}',
                    )),
                    title: Text(
                      notificationController.notificationList![index].title ?? '',
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    subtitle: Text(
                      notificationController.notificationList![index].description ?? '',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Divider(color: Theme.of(context).disabledColor),
                  ),

                ]);
              },
            )))),
          ) : Center(child: Text('no_notification_found'.tr)) : const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
