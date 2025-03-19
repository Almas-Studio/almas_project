

import 'navigation_link.dart';

class RawLink with NavigationLink {
  @override
  final String navigationLink;

  @override
  Object? get navigationPayload => null;

  const RawLink(this.navigationLink);
}
