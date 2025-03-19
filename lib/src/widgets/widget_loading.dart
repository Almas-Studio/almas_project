import 'dart:async';

import 'package:almas_project/src/services/routing/service_routing.dart';
import 'package:flutter/material.dart';

import 'containers/container_body.dart';

Future<void>? showLoading<T>({
  required RoutingServiceBase routing,
  required Future<T> future,
  required String title,
  Function(T result)? onResult,
  Function? onError,
}) {
  return routing.show(
    route: PageRouteBuilder(
      pageBuilder: (context, _, __) {
        return LoadingPage<T>(
          future: future,
          title: title,
          onResult: onResult ?? (_) {},
          onError: onError ?? (_) {},
        );
      },
      opaque: false,
    ),
  );
}

class LoadingPage<T> extends StatefulWidget {
  final String title;
  final Future<T> future;
  final Function(T result) onResult;
  final Function onError;

  const LoadingPage({
    super.key,
    required this.future,
    required this.title,
    required this.onResult,
    required this.onError,
  });

  @override
  State<LoadingPage<T>> createState() => _LoadingPageState<T>();
}

class _LoadingPageState<T> extends State<LoadingPage<T>> {
  @override
  void initState() {
    super.initState();
    widget.future
        .then(widget.onResult)
        .catchError(widget.onError)
        .whenComplete(() {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: IgnorePointer(
        ignoring: true,
        child: Scaffold(
          backgroundColor: Colors.black26,
          body: SafeArea(
            child: BodyContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(strokeWidth: 4),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.title),
                                ],
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
          ),
        ),
      ),
    );
  }
}
