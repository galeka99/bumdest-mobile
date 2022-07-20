import 'package:bumdest/components/custom_appbar.dart';
import 'package:bumdest/models/investment.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:bumdest/views/investment/investment_detail.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nav/nav.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final int _pageSize = 25;
  final PagingController<int, InvestmentModel> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> _getData(int page) async {
    try {
      dynamic data =
          await Api.get('/v1/investment?limit=$_pageSize&page=$page');
      List<InvestmentModel> items =
          (data['data'] as List).map((e) => InvestmentModel.parse(e)).toList();

      if (items.length < _pageSize) {
        _pagingController.appendLastPage(items);
      } else {
        _pagingController.appendPage(items, page + 1);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, 'Invest History'),
      body: PagedListView<int, InvestmentModel>.separated(
        padding: EdgeInsets.symmetric(horizontal: 20),
        pagingController: _pagingController,
        separatorBuilder: (_, __) => Divider(),
        builderDelegate: PagedChildBuilderDelegate<InvestmentModel>(
          noItemsFoundIndicatorBuilder: (_) => Container(
            child: Center(
              child: Text(
                'There Is No Data'.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          itemBuilder: (_, item, i) {
            Color statusColor = Colors.blue.shade600;

            if (item.status.id == 2) statusColor = Colors.green.shade600;
            if (item.status.id == 3) statusColor = Colors.red.shade600;

            return InkWell(
              onTap: () => Nav.push(InvestmentDetailPage(item)),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  item.product.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  item.product.bumdes.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Helper.toRupiah(item.amount),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      item.status.label.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
