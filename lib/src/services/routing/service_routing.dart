import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../service.dart';
import 'navigation_link.dart';
import 'routing_config_stub.dart'
    if (dart.library.io) 'routing_config_stub.dart'
    if (dart.library.js_interop) 'routing_config_web.dart';

export 'deep_link.dart';
export 'navigation_link.dart';
export 'raw_link.dart';

abstract class RoutingServiceBase extends AppService {
  final rootKey = GlobalKey<NavigatorState>();
  late final GoRouter router;

  @override
  Future<void> run(ServiceContainer services) async {
    GoRouter.optionURLReflectsImperativeAPIs = true;
    initRouting();
    router = makeAppRouter(services);
  }

  GoRouter call() => router;

  GoRouter makeAppRouter(ServiceContainer services);

  void popIf(bool condition) {
    if (condition) {
      pop();
    }
  }

  bool canPop() {
    return router.canPop();
  }

  void pop<T>([T? result]) {
    router.pop<T>(result);
  }

  Future<T?> push<T>(NavigationLink link) {
    return router.push<T>(link.navigationLink, extra: link.navigationPayload);
  }

  void replace(NavigationLink link) {
    router.replace(link.navigationLink, extra: link.navigationPayload);
  }

  Future<T?>? show<T>({
    NavigatorState? navigator,
    required Route<T> route,
  }) {
    return (navigator ?? rootKey.currentState)?.push(route);
  }

  void go(NavigationLink link) {
    router.go(
      link.navigationLink,
      extra: link.navigationPayload,
    );
  }

  void popAll() {
    router.routerDelegate.navigatorKey.currentState?.popUntil((route) {
      return route.settings.name == '/';
    });
  }

  String get currentRoute {
    final route = router.routerDelegate.currentConfiguration.last.route.path;
    return route;
  }
}
