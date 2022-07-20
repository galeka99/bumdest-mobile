import 'package:bumdest/components/custom_appbar.dart';
import 'package:bumdest/models/withdraw_history.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class WithdrawHistoryPage extends StatefulWidget {
  const WithdrawHistoryPage({Key? key}) : super(key: key);

  @override
  State<WithdrawHistoryPage> createState() => _WithdrawHistoryPageState();
}

class _WithdrawHistoryPageState extends State<WithdrawHistoryPage> {
  final int _pageSize = 25;
  final PagingController<int, WithdrawHistoryModel> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> _getData(int page) async {
    try {
      dynamic data =
          await Api.get('/v1/withdraw/history?limit=$_pageSize&page=$page');
      List<WithdrawHistoryModel> deposits = (data['data'] as List)
          .map((e) => WithdrawHistoryModel.parse(e))
          .toList();

      if (deposits.length < _pageSize) {
        _pagingController.appendLastPage(deposits);
      } else {
        _pagingController.appendPage(deposits, page + 1);
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
      appBar: CustomAppBar(context, 'Withdraw History'),
      body: PagedListView<int, WithdrawHistoryModel>.separated(
        padding: EdgeInsets.all(20),
        pagingController: _pagingController,
        separatorBuilder: (_, __) => Divider(),
        builderDelegate: PagedChildBuilderDelegate<WithdrawHistoryModel>(
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
            Color statusColor = Colors.amber.shade600;

            switch (item.status.id) {
              case 2:
                statusColor = Colors.green.shade600;
                break;
              case 3:
                statusColor = Colors.red.shade600;
                break;
              default:
                statusColor = Colors.amber.shade600;
            }

            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                item.method.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                Helper.formatDate(
                  item.createdAt,
                  format: 'MMM d, yyyy HH:mm:ss',
                  locale: 'en',
                ),
              ),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Helper.toRupiah(item.amount),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    item.status.label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
