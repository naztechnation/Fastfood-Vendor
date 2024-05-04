import 'package:flutter/cupertino.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwitchButtonWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool? isButtonActive;
  final Function onTap;
  const SwitchButtonWidget({super.key, required this.icon, required this.title, required this.onTap, this.isButtonActive});

  @override
  State<SwitchButtonWidget> createState() => _SwitchButtonWidgetState();
}

class _SwitchButtonWidgetState extends State<SwitchButtonWidget> {
  bool? _buttonActive;

  @override
  void initState() {
    super.initState();

    _buttonActive = widget.isButtonActive;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(_buttonActive != null) {
          setState(() {
            _buttonActive = !_buttonActive!;
          });
        }
        widget.onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: _buttonActive != null ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 850 : 200]!, spreadRadius: 1, blurRadius: 5)],
        ),
        child: Row(children: [

          Icon(widget.icon, size: 25),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Text(widget.title, style: robotoRegular)),

         _buttonActive != null ? Transform.scale(
           scale: 0.7,
           child: CupertinoSwitch(
              value: _buttonActive!,
              onChanged: (bool isActive) {
                if(_buttonActive != null) {
                  setState(() {
                    _buttonActive = !_buttonActive!;
                  });
                }
                widget.onTap();
              },
              activeColor: Theme.of(context).primaryColor,
              trackColor: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
         ) : const SizedBox(),

        ]),
      ),
    );
  }
}
