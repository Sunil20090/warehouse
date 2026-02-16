import 'package:flutter/material.dart';
import 'package:warehouse/components/global_components/floating_label_edit_box.dart';
import 'package:warehouse/components/loadable_button.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/components/rounded_rect_image.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';
import 'package:warehouse/utils/common_function.dart';

class EditProduct extends StatefulWidget {
  final int sku_id;
  const EditProduct({super.key, required this.sku_id});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  bool _gettingDetails = false,
      _gettingItemUsed = false,
      _updatingSettlement = false;

  var _productDetails;

  var _itemUsed;

  TextEditingController _bankSettlement = TextEditingController();

  @override
  void initState() {
    super.initState();
    initProductDetails();
  }

  initItemUsed() async {
    var body = {"product_id": _productDetails['id']};

    setState(() {
      _gettingItemUsed = true;
    });

    ApiResponse response = await postService(URL_ITEM_USED_IN_PRODUCT, body);

    setState(() {
      _gettingItemUsed = false;
    });

    if (response.isSuccess) {
      setState(() {
        _itemUsed = response.body;
      });
    }
  }

  initProductDetails() async {
    var body = {"sku_id": widget.sku_id};

    setState(() {
      _gettingDetails = true;
    });

    ApiResponse response = await postService(URL_PRODUCT_DETAILS, body);

    setState(() {
      _gettingDetails = false;
    });

    if (response.isSuccess) {
      setState(() {
        _productDetails = response.body[0];
        _bankSettlement.text = _productDetails['bank_settlement'];
        initItemUsed();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: SafeArea(
        child: (_productDetails != null)
            ? SingleChildScrollView(
                child: Container(
                  padding: CONTENT_PADDING,
                  child: Column(
                    children: [
                      RoundedRectImage(
                        width: 300,
                        height: 300,
                        thumbnail_url: _productDetails['thumbnail_url'],
                        image_url: _productDetails['image_url'],
                      ),
                      SingleChildScrollView(
                        child: Column(

                          children: [
                            addVerticalSpace(),
                            Divider(),
                            _item(
                              'Platform',
                              RoundedRectImage(
                                width: 28,
                                height: 28,
                                thumbnail_url: _productDetails['platform_url'],
                              ),
                            ),
                            addVerticalSpace(),
                            _item('Full Name', Text(_productDetails['name'])),
                            _item(
                              'SKU Id',
                              Text('${_productDetails['sku_id']}'),
                            ),
                            _item(
                              'SKU Name',
                              Text('${_productDetails['sku_name']}'),
                            ),
                            _item(
                              'Short Name',
                              Text(_productDetails['short_name']),
                            ),

                             _item(
                              'Bank Settlement',
                              Text(_productDetails['bank_settlement']),
                            ),

                            _item(
                              'Buying price',
                              Text(_productDetails['buying_price']),
                            ),

                            Divider(),

                            Row(
                              children: [
                                addHorizontalSpace(),
                                Text(
                                  'Changes',
                                  style: getTextTheme().titleSmall,
                                ),
                              ],
                            ),
                            Container(
                              padding: CONTENT_PADDING,
                              child: Column(
                                children: [
                                  FloatingLabelEditBox(
                                    labelText: 'Bank Settlement',
                                    textInputType: TextInputType.number,
                                    controller: _bankSettlement,
                                  ),
                                  addVerticalSpace(),
                                  Row(
                                    children: [
                                      LoadableButton(
                                        name: 'Update',
                                        
                                        isLoading: _updatingSettlement,
                                        onClicked: () => updateBankSettlement(
                                          _productDetails['sku_id'],
                                          double.parse(_bankSettlement.text),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Divider(),

                            Row(
                              children: [
                                addHorizontalSpace(),
                                Text(
                                  'Item Used: ',
                                  style: getTextTheme().titleSmall,
                                ),
                                if (_gettingItemUsed) ProgressCircular(),
                              ],
                            ),

                            if (_itemUsed != null)
                              ..._itemUsed.map((item) {
                                return ListTile(
                                  title: Row(
                                    children: [
                                      RoundedRectImage(
                                        thumbnail_url: item['url'],
                                      ),
                                      addHorizontalSpace(),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Name: ${item['name']}',
                                              softWrap: true,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'Quantity: ${item['quantity_used']}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),

                            addVerticalSpace(200)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ProgressCircular()],
              ),
      ),
    );
  }

  _item(String label, Widget value) {
    return Container(
      padding: CONTENT_PADDING,
      child: Row(
        children: [
          Container(
            padding: CONTENT_PADDING,
            decoration: BoxDecoration(
              color: COLOR_BASE,
              border: BoxBorder.symmetric(vertical: BorderSide(width: 1)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(label, style: getTextTheme().bodyMedium),
          ),

          addHorizontalSpace(),
          value,
        ],
      ),
    );
  }

  updateBankSettlement(int skuId, double bankSettlement) async {
    var body = {"sku_id": skuId, "new_settlement_price": bankSettlement};
    setState(() {
      _updatingSettlement = true;
    });

    ApiResponse response = await postService(URL_UPDATE_BANK_SETTLEMENT, body);

    setState(() {
      _updatingSettlement = false;
    });

    if (response.isSuccess) {
      initProductDetails();
      // showAlert(context, response.body['heading'], response.body['message']);
    }
  }
}
