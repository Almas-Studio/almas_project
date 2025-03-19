import 'package:flutter/material.dart';

import '../../services/api/api_repository_paginated.dart';
import '../../services/api/model_jsonable.dart';
import 'pagination_builder.dart';

class PaginationScrollView<T extends Jsonable, P> extends StatelessWidget {
  final PaginatedRepository<T, P?> service;
  final P? parameter;
  final String? loadingMessage;
  final Widget Function(
    List<T> items,
    VoidCallback loadNextPage,
    bool hasMore,
  ) builder;
  final List<Widget> topSlivers;
  final Widget? sliverEndTile;

  const PaginationScrollView({
    super.key,
    required this.service,
    this.parameter,
    required this.builder,
    this.loadingMessage,
    this.topSlivers = const [],
    this.sliverEndTile,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () => service.refresh(parameter),
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(
          parent: ScrollConfiguration.of(context).getScrollPhysics(context),
        ),
        slivers: [
          ...topSlivers,
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 8,
              left: 12,
              right: 12,
              bottom: 8,
            ),
            sliver: PaginationBuilder<T, P>(
              service: service,
              parameter: parameter,
              builder: builder,
              loadingMessage: loadingMessage,
            ),
          ),
          if(sliverEndTile != null) sliverEndTile!,
        ],
      ),
    );
  }
}
