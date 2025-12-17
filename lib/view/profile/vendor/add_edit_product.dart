import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendr/app/components/my_button.dart';
import 'package:vendr/app/components/my_dialog.dart';
import 'package:vendr/app/components/my_dropdown.dart';
import 'package:vendr/app/components/my_form_text_field.dart';
import 'package:vendr/app/components/my_scaffold.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/app_constants.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/flush_bar_extension.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
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
  String _imageUrl = '';
  String? selectedCategory;

  final formKey = GlobalKey<FormState>();

  final List<String> servingTypes = [
    '1 Unit',
    '2 Units',
    '5 Units',
    '10 Units',
  ];
  // final List<String> prices = ['\$100', '\$200', '\$300'];
  final List<String> prices = List.generate(
    200, // (100 / 0.5) = 200 items
    (index) {
      final value = (index + 1) * 0.5;
      return value % 1 == 0
          ? '\$${value.toInt()}'
          : '\$${value.toStringAsFixed(1)}';
    },
  );

  // Use consistent keys: 'id', 'serving', 'price'
  List<ServingModel> existingServings = [
    ServingModel(id: 1, servingQuantity: '1 Unit', servingPrice: '\$1'),
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
        break;
      default:
        setState(() {
          categories.addAll(TypeAndCategoryConstants.foodsAndDrinksCategories);
          categories.addAll(TypeAndCategoryConstants.retailGoodsCategories);
        });
    }
    categories.add('Other');
    if (categories.isNotEmpty) selectedCategory = categories.first;
  }

  @override
  void initState() {
    super.initState();
    setProductCategories();
    setExistingProductData();
  }

  void setExistingProductData() {
    if (widget.isEdit && widget.product != null) {
      //product name
      _productNameController.text = widget.product!.itemName;
      //description
      _productDescriptionController.text =
          widget.product!.itemDescription ?? '';
      //category
      selectedCategory = widget.product!.category ?? selectedCategory;
      //image
      _imageUrl = widget.product!.imageUrl ?? '';
      //servings
      if (
      // widget.product!.servings != null &&
      widget.product!.servings.isNotEmpty) {
        existingServings = [];
        int idCounter = 1;
        for (final s in widget.product!.servings) {
          existingServings.add(
            ServingModel(
              id: idCounter++,
              servingQuantity: s.servingQuantity,
              servingPrice: s.servingPrice,
            ),
          );
        }
      }
    }
  }

  int _indexOfId(int id) {
    return existingServings.indexWhere((s) => s.id == id);
  }

  @override
  Widget build(BuildContext context) {
    final vendor = _session.vendor;
    // Build a set of currently chosen serving types (for filtering)
    final Set<String> chosenTypes = existingServings
        .map((s) => s.servingQuantity)
        .where((s) => s.isNotEmpty)
        .toSet();

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
                  _imageUrl = url ?? '';
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
              // item category
              Text(
                'Category',
                style: context.typography.title.copyWith(fontSize: 18.sp),
              ),
              10.height,
              MyDropdown(
                value: selectedCategory,
                items: categories.toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              // END: item category
              16.height,
              Text(
                'Description',
                style: context.typography.title.copyWith(fontSize: 18.sp),
              ),
              10.height,
              MyFormTextField(
                borderRadius: 16.r,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
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
              // Map servings to ServingSection, computing available serving types per section
              ...existingServings.map((serving) {
                final int id = serving.id as int;
                final String currentServingValue = serving.servingQuantity;
                final String currentPriceValue = serving.servingPrice;

                // Use chosenTypes set to compute available types for this section
                // Include this section's current serving so it doesn't vanish.
                final List<String> availableServingTypes = servingTypes.where((
                  t,
                ) {
                  final bool usedByOther =
                      chosenTypes.contains(t) &&
                      t !=
                          currentServingValue; // t is used by some other section
                  return !usedByOther;
                }).toList();

                return ServingSection(
                  id: id,
                  servingTypes: availableServingTypes,
                  prices: prices,
                  servingValue: currentServingValue,
                  priceValue: currentPriceValue,
                  onRemove: () {
                    debugPrint('Removed id: $id');
                    if (existingServings.length > 1) {
                      setState(() {
                        existingServings.removeWhere((item) => item.id == id);
                      });
                      debugPrint('Removed id = $id');
                    } else {
                      context.flushBarErrorMessage(
                        message: 'At least one serving is required.',
                      );
                    }
                  },
                  // onServingUpdate: (String value) {
                  //   final idx = _indexOfId(id);
                  //   if (idx != -1) {
                  //     setState(() {
                  //       servings[idx]['serving'] = value;
                  //     });
                  //   }
                  // },
                  onServingUpdate: (String value) {
                    final idx = _indexOfId(id);
                    if (idx != -1) {
                      setState(() {
                        existingServings[idx] = existingServings[idx].copyWith(
                          servingQuantity: value,
                        );
                      });
                    }
                  },

                  onPriceUpdate: (String value) {
                    final idx = _indexOfId(id);
                    if (idx != -1) {
                      setState(() {
                        // servings[idx]['price'] = value;
                        existingServings[idx] = existingServings[idx].copyWith(
                          servingPrice: value,
                        );
                      });
                    }
                  },
                );
              }),
              10.height,
              if (existingServings.length < servingTypes.length)
                AddNewBtn(
                  // when adding new serving, pick the first unused serving type if possible
                  addServing: () {
                    final Set<String> chosen = existingServings
                        .map((s) => s.servingQuantity)
                        .where((s) => s.isNotEmpty)
                        .toSet();
                    final String newServingType = servingTypes.firstWhere(
                      (t) => !chosen.contains(t),
                      orElse: () => servingTypes.first,
                    );

                    int newId = existingServings.isNotEmpty
                        ? (existingServings.last.id as int) + 1
                        : 1;
                    debugPrint('new ID $newId');
                    setState(() {
                      existingServings.add(
                        //   {
                        //   'id': newId,
                        //   'serving': newServingType,
                        //   'price': prices.first,
                        // }
                        ServingModel(
                          id: newId,
                          servingQuantity: newServingType,
                          servingPrice: prices.first,
                        ),
                      );
                      debugPrint('Serving added; $existingServings');
                    });
                  },
                ),
              20.height,
              MyButton(
                label: 'Add',
                isLoading: isLoading,
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  //check if image is added
                  if (_imageUrl.isEmpty) {
                    context.flushBarErrorMessage(message: 'Image is required');
                    return;
                  }

                  //check if same name already exists
                  if (!widget.isEdit) {
                    if (vendor!.menu != null) {
                      if (vendor.menu!.any(
                        (item) =>
                            item.itemName.toLowerCase() ==
                            _productNameController.text,
                      )) {
                        context.flushBarErrorMessage(
                          message:
                              'Duplicate product found. Please try a different name.',
                        );
                        return;
                      }
                    }
                  }

                  if (mounted) {
                    setState(() => isLoading = true);
                  }
                  // request here...
                  await _vendorProfileService.editOrUploadProduct(
                    context,
                    productId: widget.isEdit ? widget.product!.itemId : null,
                    isEdit: widget.isEdit,
                    imageUrl: _imageUrl,
                    category: selectedCategory,
                    productName: _productNameController.text,
                    description: _productDescriptionController.text,
                    servings: existingServings,
                    onSuccess: () {
                      // context.flushBarSuccessMessage(
                      //   message: widget.isEdit
                      //       ? 'Product updated successfully!'
                      //       : 'Product added successfully!',
                      // );
                      if (widget.isEdit) {
                        context.flushBarSuccessMessage(
                          message: 'Product updated successfully!',
                        );
                      } else {
                        Navigator.pop(context);
                      }
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

class ServingSection extends StatefulWidget {
  const ServingSection({
    super.key,
    required this.servingTypes,
    required this.prices,
    required this.onRemove,
    required this.id,
    required this.onServingUpdate,
    required this.onPriceUpdate,
    required this.servingValue,
    required this.priceValue,
  });

  final int id;
  final List<String> servingTypes;
  final List<String> prices;
  final VoidCallback onRemove;
  final ValueChanged<String> onServingUpdate;
  final ValueChanged<String> onPriceUpdate;

  // controlled values
  final String servingValue;
  final String priceValue;

  @override
  State<ServingSection> createState() => _ServingSectionState();
}

class _ServingSectionState extends State<ServingSection> {
  late String selectedServing;
  late String selectedPrice;

  @override
  void initState() {
    super.initState();
    // initialize from widget values provided by parent (controlled)
    selectedServing = widget.servingValue;
    selectedPrice = widget.priceValue;
  }

  @override
  void didUpdateWidget(covariant ServingSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // keep local selected values in sync if parent updated them
    if (oldWidget.servingValue != widget.servingValue) {
      selectedServing = widget.servingValue;
    }
    if (oldWidget.priceValue != widget.priceValue) {
      selectedPrice = widget.priceValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the list passed from parent (already filtered). Don't re-add duplicates here.
    // But make sure the currently selected value is present as an option (in case parent omitted it incorrectly).
    final List<String> items = widget.servingTypes.contains(selectedServing)
        ? widget.servingTypes
        : [selectedServing, ...widget.servingTypes];

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
            // Serving column
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
                    value: selectedServing,
                    items: items,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedServing = value;
                      });
                      widget.onServingUpdate(value);
                    },
                  ),
                ),
              ],
            ),

            // Price column
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
                          widget.onRemove.call();
                          debugPrint('THE ID HERE ${widget.id}');
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
                    value: selectedPrice,
                    items: widget.prices,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedPrice = value;
                      });
                      widget.onPriceUpdate(value);
                    },
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
