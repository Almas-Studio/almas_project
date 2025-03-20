
import 'package:almas_project/src/config.dart';

mixin NavigationLink {
  String get navigationLink;
  Object? get navigationPayload => this;

  Uri get resourceUri => Uri.parse(Config().deepLinkDomain).resolve(navigationLink);
}
