import 'package:almas_project/src/services/api/api_repository_paginated.dart';
import 'package:flutter/material.dart';

import '../../services/api/model_jsonable.dart';

class PaginationBuilder<T extends Jsonable, P> extends StatefulWidget {
  final PaginatedRepository<T, P?> service;
  final P? parameter;
  final String? loadingMessage;
  final Widget Function(
    List<T> items,
    VoidCallback loadNextPage,
    bool hasMore,
  ) builder;

  const PaginationBuilder({
    super.key,
    required this.service,
    required this.builder,
    this.loadingMessage,
    this.parameter,
  });

  @override
  State<PaginationBuilder<T, P>> createState() =>
      _PaginationBuilderState<T, P>();
}

class _PaginationBuilderState<T extends Jsonable, P>
    extends State<PaginationBuilder<T, P>> {
  List<T> items = [];

  @override
  void initState() {
    super.initState();
    widget.service.addListener(onServiceChanged);
    if(widget.service.nextPage.firstPage){
      widget.service.fetchMore(widget.parameter);
    } else if(widget.service.count == 0){
      widget.service.restore(widget.parameter);
    } else if(widget.service.lastParam != widget.parameter){
      widget.service.fetchMore(widget.parameter);
    }
    items = widget.service.data; // init with in memory data
  }

  void onServiceChanged() {
    final newItems = widget.service.data;
    setState(() {
      items = newItems;
    });
  }

  @override
  void dispose() {
    widget.service.removeListener(onServiceChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      items,
      () => widget.service.fetchMore(widget.parameter),
      widget.service.hasMore,
    );
  }
}
