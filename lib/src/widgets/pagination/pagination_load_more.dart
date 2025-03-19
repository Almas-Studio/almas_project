import 'package:flutter/material.dart';

import '../../services/api/api_repository_paginated.dart';
import '../../services/api/model_jsonable.dart';
import 'call_once_at_scroll_end.dart';

class PaginationLoadMore<T extends Jsonable, P> extends StatelessWidget {
  final PaginatedRepository<T, P> service;
  final P param;
  final Widget child;

  const PaginationLoadMore({
    super.key,
    required this.service,
    required this.param,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        return CallOnceAtScrollEnd(
          callbackId: service.hasMore ? service.nextPage.value : null,
          callback: () => service.fetchMore(param),
          child: child,
        );
      }
    );
  }
}
