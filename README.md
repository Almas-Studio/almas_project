# Almas Project

Handles most boilerplate tasks in new flutter projects.

## Features

- Service Management
- No codegen API Controllers
- API caching
- Pagination APIs
- Typed go_router routing without codegen
- Encrypted Storage
- Utility Widgets
  - Layout Containers
  - Pagination Widgets
  - Routing

## Getting started

add `almas_project` to your dependencies and import it:
```
flutter pub add almas_project
```

## Recommended Project Structure
```
\lib
    \area
        \home
            \widgets
                tile_list_item.dart
                ...
            page_home.dart
        \onboarding
        \splash
        \...
        page_main.dart
    \services
        \api
            \controllers
                controller_items.dart
                ...
            \models
                item.dart
                item.g.dart
            service_api.dart
        service_routing.dart
        service_file_picker.dart
        service_theme.dart
        service_audio.dart
        services.dart
    \widgets
        \buttons
        \tiles
        \dialogs
    assets.dart
    firebase_options.dart
    main.dart
```

## Usage

Bellow are how to use the features of this package:

### Services

First step in using almas_project\services is defining a service:


A service is a class that extends/implements `AppService` class.
Services may not take anything in their constructor.
a service can only be dependent on other services or external packages.
a service is initialized when its `run` method is called.
when `run` is called, it may use previously initialized services using `ServiceContainer`.

```dart
class ThemeService extends AppService with ChangeNotifier {
  late final SecureBox _store;
  AppThemeData? _theme;

  @override
  Future<void> run(ServiceContainer services) async {
    final ss = services.get<SecureStoreService>();
    _store = await ss.getBox('services.theme');
    _theme = _getThemeFromStore();
  }

  final _themes = [
    LightTheme(),
    DarkTheme(),
    FunTheme(),
  ];

  // themes

  UnmodifiableListView<AppThemeData> get themes =>
      UnmodifiableListView(_themes);

  void setTheme(AppThemeData theme) {
    final id = theme.id;
    _store.put('selected', id);
    _theme = theme;
    notifyListeners();
  }

  AppThemeData get currentTheme => _theme ?? themes.first;

  AppThemeData _getThemeFromStore() {
    try {
      final selectedId = _store.get(
        'selected',
        defaultValue: _themes.first.id,
      );
      return themes.firstWhere((t) => t.id == selectedId);
    } catch (e) {
      return _themes.first;
    }
  }
}
```

Here `extends AppService with ChangeNotifier` is the same as `extends ReactiveAppService`.

Next The Declared `AppService` needs to be registered in the service container:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ServiceContainer();
  container.addServices({
    SecureStoreService(),
    CacheService(),
    ThemeService(), // add the service after its dependencies. note that the order is important!
    RoutingService(),
    UserService(),
  });
  await container.runServices();
  runApp(
      MultiProvider(
        providers: [
          Provider.value(value: container),
          ChangeNotifierProvider.value(value: container.get<ThemeService>()),
          ChangeNotifierProvider.value(value: container.get<UserService>()),
        ],
        child: const MyApp(),
      ),
  );
}
```

Template for accessing services through BuildContext:

```dart
typedef FetchService = T Function<T>();

class AppServices {
  final FetchService _fetch;
  final FetchService? _listenFetch;

  const AppServices(this._fetch, [this._listenFetch]);

  AppServices get listen {
    if (_listenFetch == null) {
      throw 'Error(AppServices): service provider used is not listenable';
    }
    return AppServices(_listenFetch, _listenFetch);
  }

  SecureStoreService get secureStore => _fetch();

  CacheService get cache => _fetch();

  ApiService get api => _fetch();

  ThemeService get theme => _fetch();
  
  UserService get user => _fetch();

  RoutingService get routing => _fetch();
  
  ///
  /// {class_name} get {short_name} => _fetch(); 
  /// 
}

extension AppServicesAccess on BuildContext {
  AppServices get services =>
      AppServices(read<ServiceContainer>().getUnsafe, watch);
}
```

After this you can easily access services using `context`:

```dart
@override
Widget build(BuildContext context){
  final user = context.services.listen.user(); // reactive hook into UserService
  final themes = context.services.theme.themes; // accessing theme service without listening to changes 
  return ...;
}
```

## API Controllers

In Almas, models should implement the `Jsonable` interface. you can use any library to generate toJson/fromJson or not use any libraries at all:

```dart
part 'item.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Item implements Jsonable {
  final int itemId;
  final String name;
  final String description;
  
  const Item(this.itemId, this.name, this.description);

  static const fromJson = _$ItemFromJson;

  @override
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
```

Then Register their `fromJson` method in the `GenericConverter` class:

```dart
GenericConverter.setConversions({
  Item : Item.fromJson,
  // if your using pagination, add the pagination with the entity type to the registery
  SimplePagination<Item> : SimplePagination.fromJson<Item>,
});
```

Now you can make a controller from your item, without any further codegen:

```dart
class ItemController extends ApiController {

  ItemController(Dio client) : super(client, Uri(path: '/items'));


  Rs<SimplePagination<Item>> items({int? page}) => get(
        path: '/',
        query: {'page': page},
      );

  Rs addItem(int itemId) => post(
        path: '/add',
        body: {'item_id': itemId},
      );

  Rs removeItem(int itemId) => post(
        path: '/remove',
        body: {'item_id': itemId},
      );
}
```

### Cached Paginated APIs

```dart
class ItemPaginatedRepository extends AbstractPaginationRepository<
    Item, void, ItemController> {
  ItemPaginatedRepository({
    required super.controller,
    required super.cache,
  }) : super(
          keyBuilder: (itemId) => 'item_$itemId',
          onRequest: (controller, itemId, page) =>
              controller.items(page: page.toInt()),
        );
}
```

## Routing (using go_router)

The base routing service is provided as `BaseRoutingService` which you need to extend and modify before registering in the service container.


Example Router Service:

```dart
class RoutingService extends RoutingServiceBase {
  @override
  GoRouter makeAppRouter(ServiceContainer services) {
    return GoRouter(
      initialLocation: '/splash',
      navigatorKey: rootKey,
      routes: [
        SplashPage.route(rootKey),
        MainPage.route(rootKey),
      ],
    );
  }
}
```


