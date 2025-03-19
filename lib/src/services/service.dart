import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';

abstract class AppService {
  bool get isSupported => true;

  Future<void> run(ServiceContainer services) => SynchronousFuture(null);
}

abstract class ReactiveAppService extends AppService with ChangeNotifier {}

class ServiceContainer {
  final Map<Type, AppService> _services = {};
  final Map<Type, bool> _servicesRan = {};

  ServiceContainer();

  Iterable<AppService> get services => _services.values;

  void addServices(Set<AppService> services) {
    _services
        .addAll({for (var service in services) service.runtimeType: service});
  }

  Future<void> runServices() async {
    return await Future.forEach<AppService>(
      _services.entries
          .where((e) => !(_servicesRan[e.key] ?? false))
          .map((e) => e.value), // services not ran
      (service) async {
        if (service.isSupported) {
          try {
            await service.run(this);
          } catch (e) {
            log('ServiceContainer/Service(${service.runtimeType}) Error:$e');
          }
          _servicesRan[service.runtimeType] = true;
        }
      },
    ).catchError((error) {
      log('ServiceContainer: $error');
    });
  }

  T get<T extends AppService>() {
    return getUnsafe<T>();
  }

  T getUnsafe<T>() {
    final service = _services[T];
    if (service == null) {
      throw "service of type $T is not registered in this service container";
    } else {
      return service as T;
    }
  }
}
