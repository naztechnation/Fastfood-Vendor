import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/address/controllers/address_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/common/widgets/custom_dropdown_widget.dart';

class ModuleViewWidget extends StatelessWidget {
  const ModuleViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(builder: (addressController) {
      List<int> moduleIndexList = [];
      List<DropdownItem<int>> moduleList = [];
      if(addressController.moduleList != null) {
        for(int index=0; index < addressController.moduleList!.length; index++) {
          if(addressController.moduleList![index].moduleType != 'parcel') {
            moduleIndexList.add(index);
            moduleList.add(DropdownItem<int>(value: index, child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${addressController.moduleList![index].moduleName}'),
              ),
            )));
          }
        }
      }
      return addressController.moduleList != null ?  Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).cardColor,
            border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
        ),
        child: CustomDropdown<int>(
          onChange: (int? value, int index) {
            addressController.selectModuleIndex(value);
          },
          dropdownButtonStyle: DropdownButtonStyle(
            height: 45,
            padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeExtraSmall,
              horizontal: Dimensions.paddingSizeExtraSmall,
            ),
            primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          dropdownStyle: DropdownStyle(
            elevation: 10,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          ),
          items: moduleList,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text('select_module_type'.tr),
          ),
        ),
      ) : Center(child: Text('not_available_module'.tr));
    });
  }
}
