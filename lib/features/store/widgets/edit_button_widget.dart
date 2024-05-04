import 'package:flutter/material.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class EditButtonWidget extends StatefulWidget {
  final Function onTap;
  const EditButtonWidget({super.key, required this.onTap});

  @override
  State<EditButtonWidget> createState() => _EditButtonWidgetState();
}

class _EditButtonWidgetState extends State<EditButtonWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : () async{
        setState(() {
          isLoading = true;
        });
        await widget.onTap();
        setState(() {
          isLoading = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault), border: Border.all(color: Theme.of(context).primaryColor),),
        child: isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator()) : Icon(Icons.edit, color: Theme.of(context).primaryColor, size: 20),
      ),
    );
  }
}
