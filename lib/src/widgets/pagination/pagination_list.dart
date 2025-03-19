import 'package:flutter/material.dart';
import '../widget_call_once.dart';

class PaginationList<T> extends StatelessWidget {
  final List<T> items;
  final bool hasMore;
  final VoidCallback loadNextPage;
  final Widget Function(BuildContext context, T data) tileBuilder;

  const PaginationList({
    super.key,
    required this.items,
    required this.loadNextPage,
    required this.hasMore,
    required this.tileBuilder,
  });

  static Widget Function(List<T> items, VoidCallback loadNextPage, bool hasMore)
      builder<T>(Widget Function(BuildContext context, T data) tileBuilder) {
    return (List<T> items, VoidCallback loadNextPage, bool hasMore) {
      return PaginationList(
        items: items,
        loadNextPage: loadNextPage,
        hasMore: hasMore,
        tileBuilder: tileBuilder,
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    var length = items.length;
    length = hasMore ? (length + 1) : length;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          if (hasMore && i == items.length) {
            return CallOnce(
              loadNextPage,
            );
          }

          final data = items[i];
          return tileBuilder(context, data);
        },
        childCount: length,
      ),
    );
  }
}
