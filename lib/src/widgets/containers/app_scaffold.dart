import 'package:flutter/material.dart';

import 'container_body.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? fab;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool showVerticalDividers;
  final FloatingActionButtonLocation? fabLocation;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.title,
    this.bottomNavigationBar,
    this.fab,
    this.fabLocation,
    this.backgroundColor,
    this.showVerticalDividers = false,
  });

  @override
  Widget build(BuildContext context) {
    return Title(
      title: title ??
          switch (appBar) {
            AppBar(title: var appBarTitle) => switch (appBarTitle) {
                Text(data: var text) => text,
                _ => ''
              },
            _ => ''
          } ??
          '',
      color: Theme.of(context).colorScheme.primary.withAlpha(0xff),
      child: Scaffold(
        appBar: appBar,
        floatingActionButton: fab,
        floatingActionButtonLocation: fabLocation,
        body: BodyContainer(
          showVerticalDividers: showVerticalDividers,
          child: body,
        ),
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
