import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_dialog.dart';
import 'package:vendr/app/components/my_dropdown.dart';
import 'package:vendr/app/components/my_form_text_field.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/components/my_text_field.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/app_constants.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:vendr/app/utils/extensions/validations_exception.dart';
import 'package:vendr/model/vendor/vendor_model.dart';
import 'package:vendr/services/common/session_manager/session_controller.dart';
import 'package:vendr/services/vendor/vendor_profile_service.dart';
import 'package:vendr/view/profile/widgets/profile_image_picker.dart';

class AddEditProductScreen extends StatefulWidget {
  const AddEditProductScreen({super.key, required this.isEdit, this.product});
  final bool isEdit;
  final MenuItemModel? product;
  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _vendorProfileService = VendorProfileService();
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();

  bool isLoading = false;
  String? _imageUrl = '';
  String? selectedCategory;

  final formKey = GlobalKey<FormState>();

  final List<String> servingTypes = [
    'Single Serving',
    '2 Servings',
    '3 Servings',
    '4 Servings',
    '5 Servings',
  ];
  final List<String> prices = ['\$100', '\$200', '\$300'];
  int servingCount = 1;
  List<Map<String, dynamic>> servings = [
    {'id': 1, 'serving': 'Single Serving', 'price': '\$100'},
  ];

  Set<String> categories = {};

  final _session = SessionController();
  void setProductCategories() {
    final vendor = _session.vendor;
    final vendorType = vendor!.vendorType;
    switch (vendorType) {
      case "Food and Drinks":
        setState(() {
          categories = TypeAndCategoryConstants.foodsAndDrinksCategories;
        });
        break;
      case "Retail Goods":
        setState(() {
          categories = TypeAndCategoryConstants.retailGoodsCategories;
        });
      default:
        setState(() {
          categories.addAll(TypeAndCategoryConstants.foodsAndDrinksCategories);
          categories.addAll(TypeAndCategoryConstants.retailGoodsCategories);
        });
    }
    categories.add('Other');
  }

  @override
  void initState() {
    super.initState();
    setProductCategories();
    setExistingProductData();
  }

  void setExistingProductData() {
    if (widget.isEdit) {
      _productNameController.text = widget.product!.itemName;
      _productDescriptionController.text = widget.product!.itemDescription!;
      selectedCategory = widget.product!.category!;
      _imageUrl = widget.product!.imageUrl!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Menu Item' : 'Upload Menu Item',
          style: context.typography.title.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (widget.isEdit)
            IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (_) => MyDialog(
                    title: 'Delete Product?',
                    subtitle: 'This product will be deleted Permanently',
                    confirmLabel: 'Delete',
                    onConfirm: () async {
                      await _vendorProfileService.deleteProduct(
                        context,
                        productId: widget.product!.itemId!,
                        onSuccess: () {
                          if (context.mounted) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        },
                      );

                      // await deleteMenuitem();
                    },
                  ),
                );
              },
              icon: Icon(Icons.delete, color: Colors.redAccent),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              ImagePickerAvatar(
                readOnly: isLoading,
                initialUrl: _imageUrl,
                onImageChanged: (url) {
                  _imageUrl = url;
                },
              ),
              8.height,
              Text(
                'Product Name',
                style: context.typography.title.copyWith(fontSize: 18.sp),
              ),
              10.height,
              MyFormTextField(
                hint: 'Enter product name',
                controller: _productNameController,
                textCapitalization: TextCapitalization.none,
                readOnly: isLoading,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Product name is required.';
                  }
                  return null;
                },
              ),
              16.height,
              //item category
              Text(
                'Category',
                style: context.typography.title.copyWith(fontSize: 18.sp),
              ),
              10.height,
              MyDropdown(
                value: categories.first,
                items: categories.toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              //END: item category
              16.height,
              Text(
                'Description',
                style: context.typography.title.copyWith(fontSize: 18.sp),
              ),
              10.height,
              MyFormTextField(
                borderRadius: 16.r,
                maxLines: 5,
                hint: 'Add product description here...',
                textCapitalization: TextCapitalization.none,
                controller: _productDescriptionController,
                readOnly: isLoading,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Product description is required.';
                  }
                  return null;
                },
              ),
              16.height,
              ...(servings.map((serving) {
                return ServingSection(
                  servings: servingTypes,
                  prices: prices,
                  onRemove: (id) {
                    if (servings.length > 1) {
                      setState(() {
                        servings.removeWhere((item) => item['id'] == id);
                      });
                      debugPrint('Removed id = $id');
                    } else {
                      context.flushBarErrorMessage(
                        message: 'At least 1 price is required.',
                      );
                    }
                  },
                  id: serving['id'] as int,
                );
              })),
              10.height,
              AddNewBtn(
                addServing: () {
                  int newId = servings.isNotEmpty ? servings.last['id'] + 1 : 1;
                  debugPrint('new ID $newId');
                  setState(() {
                    servings.add({
                      'id': newId,
                      'servingType': 'Single Serving',
                      'price': '\$100',
                    });
                  });
                },
              ),
              20.height,
              MyButton(
                label: 'Add',
                isLoading: isLoading,
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  if (mounted) {
                    setState(() => isLoading = true);
                  }
                  //request here...
                  await _vendorProfileService.editOrUploadProduct(
                    context,
                    // productId: widget.productId, //in case of edit
                    isEdit: widget.isEdit,
                    imageUrl: _imageUrl,
                    category: selectedCategory,
                    productName: _productNameController.text,
                    description: _productDescriptionController.text,
                    servings: servings,
                    onSuccess: () {
                      context.flushBarSuccessMessage(
                        message: widget.isEdit
                            ? 'Product uploaded successfully!'
                            : 'Product added successfully!',
                      );
                    },
                  );

                  if (mounted) {
                    setState(() => isLoading = false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddNewBtn extends StatelessWidget {
  const AddNewBtn({super.key, required this.addServing});
  final VoidCallback addServing;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        addServing.call();
        debugPrint('New serving added');
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: context.colors.buttonPrimary),
            Text(
              'Add New',
              style: context.typography.title.copyWith(
                fontWeight: FontWeight.w800,
                color: context.colors.buttonPrimary,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServingSection extends StatelessWidget {
  const ServingSection({
    super.key,
    required this.servings,
    required this.prices,
    required this.onRemove,
    required this.id,
  });

  final int id;
  final List<String> servings;
  final List<String> prices;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(AppRadiuses.mediumRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Serving',
                  style: context.typography.title.copyWith(fontSize: 18.sp),
                ),
                10.height,
                SizedBox(
                  width: 160.w,
                  child: MyDropdown(
                    value: servings.first,
                    items: servings,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price',
                        style: context.typography.title.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(6.r),
                        onTap: () {
                          onRemove(id);
                          debugPrint('THE ID HERE $id');
                        },
                        child: Icon(Icons.close, size: 20.w),
                      ),
                    ],
                  ),
                ),
                10.height,
                SizedBox(
                  width: 140.w,
                  child: MyDropdown(
                    value: prices.first,
                    items: prices,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
