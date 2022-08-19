import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:bumdest/components/custom_appbar.dart';
import 'package:bumdest/components/custom_button.dart';
import 'package:bumdest/components/loading.dart';
import 'package:bumdest/models/product.dart';
import 'package:bumdest/models/product_detail.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:bumdest/services/store.dart';
import 'package:bumdest/views/bumdes/bumdes_detail.dart';
import 'package:bumdest/views/common/pdf_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nav/nav.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;
  final String productName;
  const ProductDetailPage(this.productId, this.productName, {Key? key})
      : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late ProductDetailModel _product;
  bool _loadingData = true;
  bool _loadingInvest = false;
  bool _rated = false;
  int? _rateStars;
  int _imageIndex = 0;
  PDFDocument? _proposal;
  List<ProductModel> _relatedProducts = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _investAmount = TextEditingController(text: '10000');
  TextEditingController _predictInvestAmount = TextEditingController(text: '0');
  TextEditingController _predictBumdesIncome = TextEditingController(text: '0');
  TextEditingController _predictUserIncome = TextEditingController(text: '0');
  final List<Map<String, dynamic>> _amountTemplate = [
    {
      'amount': 10000,
      'label': '10K',
    },
    {
      'amount': 20000,
      'label': '20K',
    },
    {
      'amount': 25000,
      'label': '25K',
    },
    {
      'amount': 50000,
      'label': '50K',
    },
    {
      'amount': 100000,
      'label': '100K',
    },
    {
      'amount': 200000,
      'label': '200K',
    },
    {
      'amount': 250000,
      'label': '250K',
    },
    {
      'amount': 500000,
      'label': '500K',
    },
    {
      'amount': 1000000,
      'label': '1M',
    },
  ];

  Future<void> _getData() async {
    try {
      dynamic data = await Api.get('/v1/product/detail/${widget.productId}');
      _product = ProductDetailModel.parse(data);
      if (_product.proposal != null) {
        _proposal = await PDFDocument.fromURL(_product.proposal!);
      }

      // CHECK IF PRODUCT ALREADY RATED
      dynamic ratingData = await Api.get('/v1/rating/${widget.productId}');
      _rateStars = ratingData;
      _rated = ratingData != null;
    } catch (e) {
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true);
      } else {
        print(e);
        Helper.toast(context, 'System error', isError: true);
      }
    } finally {
      if (mounted)
        setState(() {
          _loadingData = false;
        });
    }
  }

  Future<void> _getRelatedProducts() async {
    try {
      dynamic data = await Api.get('/v1/product/recommendations/${widget.productId}');

      setState(() {
        _relatedProducts =
            (data as List).map((e) => ProductModel.parse(e)).toList();
      });
    } catch (e) {
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true);
      } else {
        print(e);
        Helper.toast(context, 'System error', isError: true);
      }
    }
  }

  void _showDescription() {
    showFlexibleBottomSheet(
      context: context,
      minHeight: .6,
      maxHeight: .85,
      initHeight: .6,
      bottomSheetColor: Colors.transparent,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_, controller, ___) => ListView(
        controller: controller,
        padding: EdgeInsets.all(20),
        children: [
          Text(
            'Product Description'.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Divider(),
          SizedBox(height: 5),
          Text(
            _product.description,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Future<void> _rate() async {
    if (_rated) return;

    try {
      dynamic result = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text(
              'Are you sure to give $_rateStars star${(_rateStars ?? 0) <= 1 ? '' : 's'} to this product?'),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(false),
              child: Text(
                'Cancel'.toUpperCase(),
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(true),
              child: Text(
                'Rate Now'.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      );

      if (!result) return;

      await Api.post(
        '/v1/rating/${_product.id}/rate',
        data: {
          'value': _rateStars,
        },
      );

      Helper.toast(context, 'Successfully rated this product');
      setState(() {
        _loadingData = true;
      });
      _getData();
    } catch (e) {
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true);
      } else {
        print(e);
        Helper.toast(context, 'System error', isError: true);
      }
    }
  }

  Future<void> _invest() async {
    dynamic result = await showFlexibleBottomSheet(
      context: context,
      maxHeight: .6,
      initHeight: .6,
      isExpand: false,
      bottomSheetColor: Colors.transparent,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (ctx, controller, __) => ListView(
        controller: controller,
        padding: EdgeInsets.all(20),
        children: [
          Text(
            'Invest to Product'.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Divider(),
          SizedBox(height: 5),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _investAmount,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                prefixText: 'Rp ',
                prefixStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorLight,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              validator: (str) {
                if (str!.isEmpty) return 'Invest amount cannot be empty';
                return null;
              },
            ),
          ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.75,
            ),
            itemCount: _amountTemplate.length,
            itemBuilder: (_, i) {
              Map<String, dynamic> item = _amountTemplate[i];

              return InkWell(
                onTap: () {
                  _investAmount.text = item['amount'].toString();
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      item['label'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          CustomButton(
            label: 'Invest Now',
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              Navigator.of(ctx, rootNavigator: true).pop(true);
            },
          ),
        ],
      ),
    );

    if (result == null) return;

    int amount = int.parse(_investAmount.text.trim());

    if (amount > (store.user?.balance ?? 0)) {
      Helper.toast(
          context, 'Insufficient balance, please top up to start invest',
          isError: true);
      return;
    }

    try {
      setState(() {
        _loadingInvest = true;
      });

      await Api.post(
        '/v1/product/invest',
        data: {
          'product_id': _product.id,
          'amount': amount,
        },
      );

      Helper.toast(context,
          'Success invest to product, please wait for related BUMDes to accept your investment');
      await Helper.getUserInfo(context);
    } catch (e) {
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true);
      } else {
        print(e);
        Helper.toast(context, 'System error', isError: true);
      }
    } finally {
      setState(() {
        _loadingInvest = false;
      });
    }
  }

  void _calculateIncome() {
    int predictInvestAmount = _predictInvestAmount.text.isEmpty
        ? 0
        : int.parse(_predictInvestAmount.text);
    int bumdesIncome = _predictBumdesIncome.text.isEmpty
        ? 0
        : int.parse(_predictBumdesIncome.text);

    if (predictInvestAmount == 0 || bumdesIncome == 0) {
      _predictUserIncome.text = '0';
      return;
    }

    double percentage = predictInvestAmount / _product.investTarget;
    double userIncome = percentage * bumdesIncome;
    _predictUserIncome.text = Helper.formatNumber(userIncome);
  }

  void _showCalculator() {
    showFlexibleBottomSheet(
      context: context,
      maxHeight: .4,
      initHeight: .4,
      isExpand: false,
      bottomSheetColor: Colors.transparent,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_, controller, __) => ListView(
        controller: controller,
        padding: EdgeInsets.all(20),
        children: [
          Text(
            'Amount you want to invest',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 5),
          TextField(
            controller: _predictInvestAmount,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            decoration: InputDecoration(
              isDense: true,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade800,
                ),
              ),
              prefixText: 'Rp ',
              prefixStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onChanged: (str) => _calculateIncome(),
          ),
          SizedBox(height: 20),
          Text(
            'BUMDes income each month',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 5),
          TextField(
            controller: _predictBumdesIncome,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            decoration: InputDecoration(
              isDense: true,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.shade800,
                ),
              ),
              prefixText: 'Rp ',
              prefixStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onChanged: (str) => _calculateIncome(),
          ),
          SizedBox(height: 20),
          Text(
            'Your income each month',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 5),
          TextField(
            controller: _predictUserIncome,
            enabled: false,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              prefixText: 'Rp ',
              prefixStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _getData();
    _getRelatedProducts();
    super.initState();
  }

  @override
  void dispose() {
    _investAmount.dispose();
    _predictInvestAmount.dispose();
    _predictBumdesIncome.dispose();
    _predictUserIncome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, widget.productName),
      body: _loadingData
          ? Loading()
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Stack(
                        fit: StackFit.loose,
                        alignment: Alignment.topRight,
                        children: [
                          CarouselSlider.builder(
                            itemCount: _product.images.length,
                            options: CarouselOptions(
                              aspectRatio: 1.5,
                              autoPlay: false,
                              viewportFraction: 1,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, _) => setState(() {
                                _imageIndex = index;
                              }),
                            ),
                            itemBuilder: (_, i, __) {
                              return CachedNetworkImage(
                                imageUrl: _product.images[i].url,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Loading(),
                              );
                            },
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${_imageIndex + 1} / ${_product.images.length}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          Text(
                            _product.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Ionicons.star,
                                size: 11,
                                color: Colors.amber.shade600,
                              ),
                              SizedBox(width: 3),
                              Text(
                                _product.voteAverage.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 3),
                              Text(
                                '(${Helper.formatNumber(_product.voteCount)})',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          SizedBox(height: 5),
                          Table(
                            columnWidths: {
                              0: FractionColumnWidth(.4),
                              1: FractionColumnWidth(.6),
                            },
                            children: [
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'Product Status',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _product.status.label.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'Current Invest',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    Helper.toRupiah(_product.currentInvest),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'Target Invest',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    Helper.toRupiah(_product.investTarget),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'Offer Start',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Text(Helper.formatDate(
                                    _product.offerStartDate,
                                    format: 'MMMM dd, yyyy',
                                    locale: 'en',
                                  )),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'Offer End',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Text(Helper.formatDate(
                                    _product.offerEndDate,
                                    format: 'MMMM dd, yyyy',
                                    locale: 'en',
                                  )),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'Proposal',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  _product.proposal == null
                                      ? Text('-')
                                      : InkWell(
                                          onTap: () => Nav.push(
                                              ProposalPage(_proposal!)),
                                          child: Text(
                                            'click to view...',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () =>
                            Nav.push(BumdesDetailPage(_product.bumdes.id)),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(.25),
                              child: Icon(
                                Ionicons.business,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            title: Text(
                              _product.bumdes.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Icon(
                                  Ionicons.location_outline,
                                  size: 10,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  '${_product.bumdes.location.districtName.toUpperCase()}, ${_product.bumdes.location.cityName}, ${_product.bumdes.location.provinceName}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Ionicons.chevron_forward,
                              size: 14,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        color: Colors.grey.shade100,
                        child: Text(
                          'Description'.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _showDescription,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          color: Colors.blue.shade50.withOpacity(.5),
                          child: Text(
                            _product.description,
                            maxLines: 5,
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _showDescription,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          color: Colors.grey.shade100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Read More'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Ionicons.chevron_down_outline,
                                color: Colors.grey.shade500,
                                size: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _rated
                                  ? 'You\'ve already rated this product'
                                  : 'Like this product? Rate it',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: List.generate(5, (index) {
                                  return InkWell(
                                    onTap: () {
                                      if (_rated) return;

                                      setState(() {
                                        _rateStars = index + 1;
                                      });

                                      _rate();
                                    },
                                    child: Icon(
                                      Ionicons.star,
                                      // size: 30,
                                      color: index < (_rateStars ?? 0)
                                          ? Colors.amber.shade600
                                          : Colors.grey.shade600,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(20),
                        children: [
                          Text(
                            'Related Products',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 10),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _relatedProducts.length,
                            separatorBuilder: (_, __) => SizedBox(height: 10),
                            itemBuilder: (_, i) {
                              ProductModel item = _relatedProducts[i];

                              return InkWell(
                                onTap: () => Nav.push(
                                    ProductDetailPage(item.id, item.title)),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(.25),
                                        offset: Offset(3, 3),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(item.bumdes.name),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Ionicons.star,
                                                  size: 14,
                                                  color: Colors.amber.shade700,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  item.voteAverage.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  '(${item.voteCount})',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Ionicons.location_outline,
                                                  size: 12,
                                                  color: Colors.grey.shade800,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  item.bumdes.location.cityName,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              Helper.toRupiah(
                                                  item.currentInvest),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green.shade600,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              Helper.toRupiah(
                                                  item.investTarget),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.25),
                        offset: Offset(0, -5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: _showCalculator,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Ionicons.calculator_outline,
                                size: 16,
                                color: Colors.grey.shade800,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Calculator'.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _invest,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .6,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Center(
                            child: _loadingInvest
                                ? Container(
                                    width: 26,
                                    height: 26,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Ionicons.cash_outline,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Invest Now'.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
