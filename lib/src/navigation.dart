import 'dart:collection';
import 'package:floater/floater.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:pedantic/pedantic.dart';
import "defensive.dart";
import "extensions.dart";
// import "secure_storage.dart";
import 'package:meta/meta.dart';
import 'service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Navigation
///
/// [Navigation] service is used for setting routes for pages.
///
/// Example:
///
/// ```dart
/// abstract class Routes {
/// static const home = "/home";
/// static void initializeNavigation() {
/// NavigationManager.instance
///      ..registerPage(Routes.home, (routeArgs) => HomePage());
///
///     // bootstrapping Navigation
///     NavigationManager.instance.bootstrap();
///   }
/// }
/// ```
///
/// This example shows how to set route for HomePage and the routeName
/// can be called in any page to navigate to HomePage.
///
/// You can also pass routeArguments to do specific tasks.

enum PageType { material, cupertino, custom }

class _NavTracker {
  // final String basePath;
  final GlobalKey<NavigatorState> globalKey;
  final ServiceLocator scope;

  _NavTracker(this.globalKey, this.scope);
}

abstract class _ValidTypes {
  static const string = "string";
  static const number = "number";
  static const boolean = "boolean";
  static const object = "object";

  static const all = [string, number, boolean, object];
}

class _NavigationManager {
  final _pageRegistrations = <_PageRegistration>[];
  final _navigatorKeys = <String, Queue<_NavTracker>>{};

  void registerPage<T extends Widget>(
    String route,
    T Function(dynamic args) factoryFunc, [
    PageType pageType = PageType.material,
    bool fullscreenDialog = false,
    bool persist = false,
    CustomPageRouteBuilder? customPageRouteBuilder,
  ]) {
    given(route, "route")
        .ensure((t) => t.isNotEmptyOrWhiteSpace)
        .ensure((t) => t.trim() != "/", "cannot be root")
        .ensure((t) => t.trim().startsWith("/"), "must start with '/'")
        .ensure((t) => !t.trim().replaceAll(new RegExp(r"\s"), "").contains("//"), "route contains empty path segments")
        .ensure((t) => !t.trim().replaceAll(new RegExp(r"\s"), "").contains("&&"), "route contains empty query params")
        .ensure(
            (t) => persist ? t.trim().substring(1).split("/").length == 1 : true, "only top level routes can persist");

    given(customPageRouteBuilder, "customPageRouteBuilder").ensure(
        (t) => pageType == PageType.custom ? customPageRouteBuilder != null : customPageRouteBuilder == null,
        "customPageRouteBuilder is required if page type is custom, null otherwise");
    // .ensure((t) => t.contains("?") ? t.split("?").length == 2 : true, "must have only one '?'");

    // given(factoryFunc, "factoryFunc").ensureHasValue();

    var path = route.trim().replaceAll(new RegExp(r"\s"), "").trim();
    String? query;
    if (path.contains("?")) {
      final split = path.split("?");
      path = split[0].trim();
      query = split.skip(1).join("?").trim();
    }

    final pathSegments = <String>[];
    if (path != "/") {
      pathSegments.addAll(path.substring(1).split("/").map((e) => e.trim()));
      given(route, "route").ensure((_) => pathSegments.every((t) => t.isNotEmpty));
    }

    final queryParams = <String, String>{};
    if (query != null) {
      final queries = query.contains("&") ? query.split("&") : [query];
      queries.forEach((element) {
        final split = element.trim().split(":");
        final key = split[0].trim();
        given(route, "route")
            .ensure(
                (_) =>
                    split.length == 2 &&
                    key.isNotEmpty &&
                    key.startsWith("{") &&
                    split[1].trim().isNotEmpty &&
                    split[1].trim().endsWith("}") &&
                    _ValidTypes.all.contains(split[1].trim().substring(0, split[1].trim().length - 1).toLowerCase()),
                "invalid query params")
            .ensure((_) => !queryParams.containsKey(key), "duplicate key in query params");

        queryParams[key.substring(1).trim()] = split[1].trim().substring(0, split[1].trim().length - 1).toLowerCase();
      });
    }

    given(route, "route").ensure(
        (_) => this._pageRegistrations.every((t) => t.path.toLowerCase() != path.toLowerCase()), "duplicate path");

    this._pageRegistrations.add(new _PageRegistration(route, path, pathSegments, query, queryParams, factoryFunc,
        pageType, fullscreenDialog, persist, customPageRouteBuilder));
  }

  void buildTree() {
    given(this, "this").ensure((t) => t._pageRegistrations.every((element) => !element.isRoot), "tree already built");

    final root = new _PageRegistration(
        "/", "/", <String>[], null, {}, ([args]) => this._createRootWidget(), PageType.material, false, false, null);
    this._pageRegistrations.add(root);

    for (final pr in this._pageRegistrations) {
      if (pr.isRoot) continue;

      final parentPath = "/" + pr.pathSegments.sublist(0, pr.pathSegments.length - 1).join("/");
      final parent = this._pageRegistrations.find((element) => element.path == parentPath);
      if (parent == null) throw new StateError("Route '${pr.route}' has no parent");

      parent.children.add(pr);
    }
  }

  GlobalKey<NavigatorState> generateNavigatorKey(String basePath, [ServiceLocator? scope]) {
    given(basePath, "basePath")
        .ensure((t) => t.isNotEmptyOrWhiteSpace)
        .ensure((t) => this._pageRegistrations.any((element) => element.path == basePath));

    if (!this._navigatorKeys.containsKey(basePath)) {
      this._navigatorKeys[basePath] = new Queue<_NavTracker>();
    }

    final queue = this._navigatorKeys[basePath]!;
    final navTracker = new _NavTracker(
        new GlobalKey<NavigatorState>(debugLabel: basePath), scope ?? ServiceManager.instance.createScope());
    queue.add(navTracker);

    return navTracker.globalKey;
  }

  void disposeNavigatorKey(String basePath, GlobalKey<NavigatorState> key) {
    given(basePath, "basePath")
        .ensure((t) => t.isNotEmptyOrWhiteSpace)
        .ensure((t) => this._pageRegistrations.any((element) => element.path == basePath));

    // given(key, "key").ensureHasValue();

    if (!this._navigatorKeys.containsKey(basePath)) return;

    final queue = this._navigatorKeys[basePath]!;
    final tracker = queue.last;

    // given(key, "key")
    //     .ensure((t) => tracker.globalKey == t, "disposing key that is not at the top of the stack is invalid");
    // TODO: This is meant to be an assertion, But actually fails for popUntil and pushNamedAndRemoveUntil.

    queue.removeLast();
    if (queue.isEmpty) this._navigatorKeys.remove(basePath);

    // final tracker = this._navigatorKeys.remove(basePath);
    (tracker.scope as Disposable).dispose();
  }

  Map<String, _PageRegistration> generateMappedRoutes(String basePath) {
    given(basePath, "basePath")
        .ensure((t) => t.isNotEmptyOrWhiteSpace)
        .ensure((t) => this._pageRegistrations.any((element) => element.path == basePath), "Unknown path $basePath");

    final base = this._pageRegistrations.firstWhere((element) => element.path == basePath);
    final result = <String, _PageRegistration>{};
    final list = <_PageRegistration>[...base.children];
    if (!base.isRoot) list.add(base);

    list.forEach((element) => result[element.path] = element);

    return result;
  }

  List<Route<dynamic>> generateInitialRoutes(String path, String? query, [Map<String, dynamic>? initialRouteArgs]) {
    final result = <Route<dynamic>>[];
    // FIXME: this is incorrect and should be implemented properly to facilitate deep linking
    // Ref: https://api.flutter.dev/flutter/widgets/Navigator/defaultGenerateInitialRoutes.html
    // Find the child and then traverse to find all ancestors and add to list.
    // Return list in order of ancestor to child

    initialRouteArgs ??= <String, dynamic>{};

    final pageRegistration = this._pageRegistrations.firstWhere((element) => element.path == path);

    result.add(pageRegistration.generateRoute(new RouteSettings(name: path, arguments: initialRouteArgs), query));

    return result;
  }

  NavigatorState retrieveNavigator(String path) {
    given(path, "path")
        .ensure((t) => t.isNotEmptyOrWhiteSpace)
        .ensure((t) => this._navigatorKeys.containsKey(path.trim()), "key is unavailable");

    // return this._navigatorKeys[path.trim()].globalKey.currentState;

    return this._navigatorKeys[path.trim()]!.last.globalKey.currentState!;
  }

  ServiceLocator retrieveScope(String path) {
    given(path, "path")
        .ensure((t) => t.isNotEmptyOrWhiteSpace)
        .ensure((t) => this._navigatorKeys.containsKey(path.trim()), "key is unavailable");

    // return this._navigatorKeys[path.trim()].scope;

    return this._navigatorKeys[path.trim()]!.last.scope;
  }

  Widget _createRootWidget() {
    return Container(
      child: Center(
        child: Text("Not what you are looking for?"),
      ),
    );
  }
}

class _PageRegistration {
  final String route;
  final String path;
  final List<String> pathSegments;
  final String? query;
  final Map<String, String> queryParams;
  final dynamic Function(dynamic args) factoryFunc;
  final PageType pageType;
  final bool fullscreenDialog;
  final bool persist;
  final CustomPageRouteBuilder? customPageRouteBuilder;
  final children = <_PageRegistration>[];

  bool get isRoot => this.route == "/";

  _PageRegistration(this.route, this.path, this.pathSegments, this.query, this.queryParams, this.factoryFunc,
      this.pageType, this.fullscreenDialog, this.persist, this.customPageRouteBuilder) {
    given(this, "this").ensure(
        (t) => t.pageType == PageType.custom ? t.customPageRouteBuilder != null : t.customPageRouteBuilder == null,
        "customPageRouteBuilder is required if page type is custom, null otherwise");
  }

  Route generateRoute(RouteSettings settings, String? query) {
    final queryArgs = this._parseQuery(query);

    final widgetBuilder = (BuildContext context) {
      // settings ??= ModalRoute.of(context)!.settings;
      final args = queryArgs;
      args.addAll(settings.arguments as Map<String, dynamic>? ?? {});
      final consolidatedArgs = <String, dynamic>{};

      this.queryParams.forEach((key, type) {
        final isOptional = key.endsWith("?");
        if (isOptional) key = key.substring(0, key.length - 1);
        if (!args.containsKey(key) || args[key] == null) {
          if (isOptional) return;
          throw new ArgumentError("Argument for param '$key' was not provided.");
        }

        var argValue = args[key];
        switch (type) {
          case _ValidTypes.string:
            given(argValue, key).ensure((t) => t is String, "must be String");
            argValue = argValue as String?;
            break;
          case _ValidTypes.number:
            given(argValue, key).ensure((t) => t is num, "must be num");
            argValue = argValue as num?;
            break;
          case _ValidTypes.boolean:
            given(argValue, key).ensure((t) => t is bool, "must be bool");
            argValue = argValue as bool?;
            break;
          case _ValidTypes.object:
            // ignore: unnecessary_type_check
            given(argValue, key).ensure((t) => t is Object, "must be Object");
            argValue = argValue as Object?;
            break;
        }

        consolidatedArgs[key] = argValue;
      });

      // print("CONSOLIDATED ARGS");
      // print(consolidatedArgs);

      // print("GENERATE ROUTE ${this.persist}");
      if (this.persist &&
          consolidatedArgs.entries.every((t) => t.value is String || t.value is num || t.value is bool)) {
        var runtimePath = this.path;
        final runtimeArgs = consolidatedArgs.entries.map((t) => "${t.key}=${t.value}").join("&").trim();
        if (runtimeArgs.isNotEmpty) runtimePath += "?" + runtimeArgs;

        // print("RUNTIME PATH $runtimePath");
        NavigationManager.instance.persistRoute(runtimePath);
      } else {
        // if (this.pathSegments.length == 1) // top level
        //   NavigationManager.instance.clearPersistedRoute();
      }

      final widget = this.factoryFunc(consolidatedArgs) as Widget;
      // final navigator = Navigator.of(context);
      // TODO: use the context to set the navigator of the widget as an ambient context
      return widget;
    };

    switch (this.pageType) {
      case PageType.material:
        return MaterialPageRoute<dynamic>(
            builder: widgetBuilder, settings: settings, fullscreenDialog: this.fullscreenDialog);
      case PageType.cupertino:
        return CupertinoPageRoute<dynamic>(
            builder: widgetBuilder, settings: settings, fullscreenDialog: this.fullscreenDialog);
      case PageType.custom:
        return PageRouteBuilder(
          pageBuilder: (context, __, ___) => widgetBuilder(context),
          settings: settings,
          fullscreenDialog: this.fullscreenDialog,
          transitionDuration: this.customPageRouteBuilder!.transitionDuration,
          reverseTransitionDuration: this.customPageRouteBuilder!.reverseTransitionDuration,
          transitionsBuilder: this.customPageRouteBuilder!.transitionsBuilder,
          opaque: this.customPageRouteBuilder!.opaque,
          barrierDismissible: this.customPageRouteBuilder!.barrierDismissible,
          barrierColor: this.customPageRouteBuilder!.barrierColor,
        );
      default:
        throw new Exception("Unsupported PageType");
    }
  }

  Map<String, dynamic> _parseQuery(String? query) {
    final result = <String, dynamic>{};
    if (query == null || query.isEmptyOrWhiteSpace) return result;

    if (query.contains(new RegExp(r'[{:}]'))) throw new Exception("Invalid query: $query");

    query.split("&").forEach((element) {
      final split = element.split("=");
      final key = split[0];
      final value = split[1];

      final requiredKey = key;
      final optionalKey = key + "?";
      final hasRequiredKey = this.queryParams.containsKey(requiredKey);
      final hasOptionalKey = this.queryParams.containsKey(optionalKey);

      if (!hasRequiredKey && !hasOptionalKey) return;

      final type = this.queryParams[hasRequiredKey ? requiredKey : optionalKey];
      var typedValue;
      if (value == "null")
        typedValue = null;
      else
        switch (type) {
          case _ValidTypes.string:
            typedValue = value;
            break;
          case _ValidTypes.number:
            typedValue = num.parse(value);
            break;
          case _ValidTypes.boolean:
            typedValue = this._parseBool(value);
            break;
          case _ValidTypes.object:
            throw new Exception("Unsupported Type");
        }

      result[key] = typedValue;
    });

    return result;
  }

  bool? _parseBool(String value) {
    if (value.trim().isEmpty) return null;
    value = value.trim().toLowerCase();
    switch (value) {
      case "true":
        return true;
      case "false":
        return false;
      default:
        return null;
    }
  }
}

@sealed
class NavigationManager {
  static final _manager = new _NavigationManager();
  static final _instance = new NavigationManager._private();
  // static final _storageService = new FloaterSecureStorageService();
  static final _persistKey = "floater-navigation-persisted-path";
  static var _isBootstrapped = false;

  static NavigationManager get instance => _instance;

  NavigationManager._private();

  void registerPage<T extends Widget>(
    String route,
    T Function(dynamic routeArgs) factoryFunc, {
    PageType pageType = PageType.material,
    bool fullscreenDialog = false,
    bool persist = false,
    CustomPageRouteBuilder? customPageRouteBuilder,
  }) {
    if (_isBootstrapped) throw new StateError("Already bootstrapped");

    _manager.registerPage(route, factoryFunc, pageType, fullscreenDialog, persist, customPageRouteBuilder);
  }

  void bootstrap() {
    if (_isBootstrapped) throw new StateError("Already bootstrapped");

    _manager.buildTree();
    _isBootstrapped = true;
  }

  RouteFactory generateRouteFactory(String route) {
    if (!_isBootstrapped) throw new StateError("Not bootstrapped");
    final path = this._getJustPath(route);
    final mappedRoutes = _manager.generateMappedRoutes(path);

    final routeFactory = (RouteSettings settings) {
      final route = settings.name!.trim();
      final path = this._getJustPath(route);
      final query = this._getJustQuery(route);
      if (!mappedRoutes.containsKey(path)) throw Exception('Invalid route: ${settings.name}');
      return mappedRoutes[path]!.generateRoute(settings, query);
    };

    return routeFactory;
  }

  // InitialRouteListFactory generateInitialRouteListFactory() {
  //   if (!_isBootstrapped) throw new StateError("Not bootstrapped");

  //   final result = (String route) {
  //     return _manager.generateInitialRoutes(route);
  //   };

  //   return result;
  // }

  RouteListFactory generateRouteListFactory([Map<String, dynamic>? initialRouteArgs]) {
    if (!_isBootstrapped) throw new StateError("Not bootstrapped");

    final result = (NavigatorState navigator, String route) {
      return _manager.generateInitialRoutes(this._getJustPath(route), this._getJustQuery(route), initialRouteArgs);
    };

    return result;
  }

  GlobalKey<NavigatorState> generateNavigatorKey(String basePath, [ServiceLocator? scope]) {
    if (!_isBootstrapped) throw new StateError("Not bootstrapped");
    basePath = this._getJustPath(basePath);

    return _manager.generateNavigatorKey(basePath, scope);
  }

  void disposeNavigatorKey(String basePath, GlobalKey<NavigatorState> key) {
    if (!_isBootstrapped) throw new StateError("Not bootstrapped");
    basePath = this._getJustPath(basePath);

    _manager.disposeNavigatorKey(basePath, key);
  }

  NavigatorState _retrieveNavigator(String path) {
    if (!_isBootstrapped) throw new StateError("Not bootstrapped");

    return _manager.retrieveNavigator(this._getJustPath(path));
  }

  ServiceLocator _retrieveScope(String path) {
    if (!_isBootstrapped) throw new StateError("Not bootstrapped");

    return _manager.retrieveScope(this._getJustPath(path));
  }

  String _generateRoute(String routeTemplate, [Map<String, dynamic>? routeArgs]) {
    given(routeTemplate, "routeTemplate")
        .ensure((t) => t.isNotEmptyOrWhiteSpace)
        .ensure((t) => t.startsWith("/"), "invalid route template");

    final path = this._getJustPath(routeTemplate);
    final pageRegistration = _manager._pageRegistrations.find((element) => element.path == path);
    if (pageRegistration == null) throw new Exception("Unknown route: $routeTemplate");
    if (routeArgs == null) return path;
    final query = this._getJustQuery(routeTemplate);
    if (query == null) return routeTemplate;

    var result = "";

    routeArgs.forEach((key, value) {
      final requiredKey = key;
      final optionalKey = key + "?";
      final hasRequiredKey = pageRegistration.queryParams.containsKey(requiredKey);
      final hasOptionalKey = pageRegistration.queryParams.containsKey(optionalKey);

      if (!hasRequiredKey && !hasOptionalKey) return;

      final type = pageRegistration.queryParams[hasRequiredKey ? requiredKey : optionalKey];
      var argValue = value;
      switch (type) {
        case _ValidTypes.string:
          given(argValue, key).ensure((t) => t is String, "must be String");
          argValue = argValue as String;
          break;
        case _ValidTypes.number:
          given(argValue, key).ensure((t) => t is num, "must be num");
          argValue = argValue as num;
          break;
        case _ValidTypes.boolean:
          given(argValue, key).ensure((t) => t is bool, "must be bool");
          argValue = argValue as bool;
          break;
        case _ValidTypes.object:
          throw new Exception("Unsupported Type");
      }
      if (result.isNotEmpty) result += "&";
      result += "$key=$argValue";
    });

    return "$path?$result";
  }

  String _getJustPath(String route) {
    given(route, "route")
        // .ensureHasValue()
        .ensure((t) => t.trim().startsWith("/"), "Invalid route '$route'");

    route = route.trim();
    if (route.contains("?")) {
      final split = route.split("?");
      route = split[0].trim();
    }

    return route;
  }

  String? _getJustQuery(String route) {
    given(route, "route")
        .ensure((t) => t.isNotEmptyOrWhiteSpace)
        .ensure((t) => t.trim().startsWith("/"), "Invalid route '$route'");
    route = route.trim();
    if (!route.contains("?")) return null;

    return route.split("?").skip(1).join("?");
  }

  void persistRoute(String path) {
    given(path, "path")
        .ensure((t) => t.isNotEmptyOrWhiteSpace)
        .ensure((t) => t.trim().substring(1).split("/").length == 1);

    unawaited(SharedPreferences.getInstance().then((t) => t.setString(_persistKey, path))
        // .then((t) => print("Saved=$t"))
        .catchError((e) {
      print(e);
      return false;
    }));
  }

  Future<String?> retrievePersistedRoute() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_persistKey);
    } catch (e) {
      print(e);
      return null;
    }
  }

  void clearPersistedRoute() {
    unawaited(SharedPreferences.getInstance().then((t) => t.remove(_persistKey)).catchError((e) {
      print(e);
      return false;
    }));
  }
}

@sealed
class NavigationService {
  static final _instance = new NavigationService._private();

  static NavigationService get instance => _instance;

  NavigationService._private();

  NavigatorState retrieveNavigator(String path) {
    return NavigationManager.instance._retrieveNavigator(path);
  }

  ServiceLocator retrieveScope(String path) {
    return NavigationManager.instance._retrieveScope(path);
  }

  String generateRoute(String routeTemplate, [Map<String, dynamic>? routeArgs]) {
    return NavigationManager.instance._generateRoute(routeTemplate, routeArgs);
  }
}

class CustomPageRouteBuilder {
  final bool opaque;
  final RouteTransitionsBuilder transitionsBuilder;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final bool barrierDismissible;
  final Color? barrierColor;

  CustomPageRouteBuilder({
    required this.opaque,
    required this.transitionsBuilder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.barrierDismissible = false,
    this.barrierColor,
  });
}
