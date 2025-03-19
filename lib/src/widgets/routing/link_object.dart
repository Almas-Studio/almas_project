import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';
import '../../services/routing/navigation_link.dart';

class ObjectLink<T extends NavigationLink, Payload, Res>
    extends StatelessWidget {
  final T? object;
  final FutureOr<bool> Function(BuildContext context, Payload obj)? access;
  final Widget Function(
          BuildContext context, Future<Res?> Function([Object? extra]) openLink)
      builder;

  const ObjectLink({
    super.key,
    required this.object,
    this.access,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: object != null ? Uri(path: object!.navigationLink) : null,
      builder: (context, openLink) {
        return builder(context, ([extra2]) async {
          final router = GoRouter.of(context);
          if (object != null) {
            final check = access != null
                ? await Future(() => access!(context, object!.navigationPayload as Payload))
                : true;
            if (check) {
              return await router.push(
                object!.navigationLink,
                extra: object?.navigationPayload,
              );
            }
          }
          return null;
        });
      },
    );
  }
}
