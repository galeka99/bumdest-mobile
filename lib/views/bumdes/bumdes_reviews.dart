import 'package:bumdest/components/custom_appbar.dart';
import 'package:bumdest/models/review.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ionicons/ionicons.dart';

class BumdesReviewPage extends StatefulWidget {
  final int bumdesId;
  const BumdesReviewPage(this.bumdesId, {Key? key}) : super(key: key);

  @override
  State<BumdesReviewPage> createState() => _BumdesReviewPageState();
}

class _BumdesReviewPageState extends State<BumdesReviewPage> {
  final int _pageSize = 25;
  final PagingController<int, ReviewModel> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> _getData(int page) async {
    try {
      dynamic data = await Api.get(
          '/v1/bumdes/${widget.bumdesId}/reviews?limit=$_pageSize&page=$page');
      List<ReviewModel> reviews =
          (data['data'] as List).map((e) => ReviewModel.parse(e)).toList();

      if (reviews.length < _pageSize) {
        _pagingController.appendLastPage(reviews);
      } else {
        _pagingController.appendPage(reviews, page + 1);
      }
    } catch (e) {
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true);
      } else {
        print(e);
        Helper.toast(context, 'System error', isError: true);
      }
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) => _getData(pageKey));
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, "Visitor's Reviews"),
      body: PagedListView<int, ReviewModel>.separated(
        padding: EdgeInsets.all(20),
        pagingController: _pagingController,
        separatorBuilder: (_, __) => SizedBox(height: 10),
        builderDelegate: PagedChildBuilderDelegate<ReviewModel>(
          noItemsFoundIndicatorBuilder: (_) => Container(
            child: Center(
              child: Text(
                'No Reviews Found'.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          itemBuilder: (_, item, i) => Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: item.visitorImage,
                        width: 40,
                        height: 40,
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.visitorName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.5),
                              child: Icon(
                                Ionicons.star,
                                color: index < item.rating
                                    ? Colors.amber.shade800
                                    : Colors.grey.shade400,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                item.description.isNotEmpty ? Divider() : SizedBox(),
                item.description.isNotEmpty
                    ? Text(
                        item.description,
                        textAlign: TextAlign.justify,
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
