import 'dart:collection';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "defensive.dart";
import "extensions.dart";
import 'package:meta/meta.dart';
import 'service_locator.dart';

enum PageType { material, cupertino }

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

  void registerPage<T extends Widget>(String route, T Function(dynamic args) factoryFunc,
      [PageType pageType = PageType.material, fullscreenDialog = false]) {
    given(route, "route")
        .ensureHasValue()
        .ensure((t) => t.trim() != "/", "cannot be root")
        .ensure((t) => t.trim().startsWith("/"), "must start with '/'")
        .ensure((t) => !t.trim().replaceAll(new RegExp(r"\s"), "").contains("//"),
            "route contains empty path segments")
        .ensure((t) => !t.trim().replaceAll(new RegExp(r"\s"), "").contains("&&"),
            "route contains empty query params");
    // .ensure((t) => t.contains("?") ? t.split("?").length == 2 : true, "must have only one '?'");

    var path = route.trim().replaceAll(new RegExp(r"\s"), "").trim();
    String query;
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
                    _ValidTypes.all.contains(
                        split[1].trim().substring(0, split[1].trim().length - 1).toLowerCase()),
                "invalid query params")
            .ensure((_) => !queryParams.containsKey(key), "duplicate key in query params");

        queryParams[key.substring(1).trim()] =
            split[1].trim().substring(0, split[1].trim().length - 1).toLowerCase();
      });
    }

    given(factoryFunc, "factoryFunc").ensureHasValue();
    given(pageType, "pageType").ensureHasValue();
    given(fullscreenDialog, "fullScreenDialog").ensureHasValue();

    given(route, "route").ensure(
        (_) => this._pageRegistrations.every((t) => t.path.toLowerCase() != path.toLowerCase()),
        "duplicate path");

    this._pageRegistrations.add(new _PageRegistration(
        route, path, pathSegments, query, queryParams, factoryFunc, pageType, fullscreenDialog));
  }

  void buildTree() {
    given(this, "this").ensure(
        (t) => t._pageRegistrations.every((element) => !element.isRoot), "tree already built");

    final root = new _PageRegistration("/", "/", <String>[], null, {},
        ([args]) => this._createRootWidget(), PageType.material, false);
    this._pageRegistrations.add(root);

    for (final pr in this._pageRegistrations) {
      if (pr.isRoot) continue;

      final parentPath = "/" + pr.pathSegments.sublist(0, pr.pathSegments.length - 1).join("/");
      final parent = this._pageRegistrations.find((element) => element.path == parentPath);
      if (parent == null) throw new StateError("Route '${pr.route}' has no parent");

      parent.children.add(pr);
    }
  }

  GlobalKey<NavigatorState> generateNavigatorKey(String basePath) {
    given(basePath, "basePath")
        .ensureHasValue()
        .ensure((t) => this._pageRegistrations.any((element) => element.path == basePath));

    if (!this._navigatorKeys.containsKey(basePath)) {
      this._navigatorKeys[basePath] = new Queue<_NavTracker>();
    }

    final queue = this._navigatorKeys[basePath];
    final navTracker = new _NavTracker(
        new GlobalKey<NavigatorState>(debugLabel: basePath), ServiceManager.instance.createScope());
    queue.add(navTracker);

    return navTracker.globalKey;
  }

  void disposeNavigatorKey(String basePath, GlobalKey<NavigatorState> key) {
    given(basePath, "basePath")
        .ensureHasValue()
        .ensure((t) => this._pageRegistrations.any((element) => element.path == basePath));

    given(key, "key").ensureHasValue();

    if (!this._navigatorKeys.containsKey(basePath)) return;

    final queue = this._navigatorKeys[basePath];
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
    given(basePath, "basePath").ensureHasValue().ensure(
        (t) => this._pageRegistrations.any((element) => element.path == basePath),
        "Unknown path ${basePath}");

    final base = this._pageRegistrations.firstWhere((element) => element.path == basePath);
    final result = <String, _PageRegistration>{};
    final list = <_PageRegistration>[...base.children];
    if (!base.isRoot) list.add(base);

    list.forEach((element) => result[element.path] = element);

    return result;
  }

  List<Route<dynamic>> generateInitialRoutes(String path, String query,
      [Map<String, dynamic> initialRouteArgs]) {
    final result = <Route<dynamic>>[];
    // FIXME: this is incorrect and should be implemented properly to facilitate deep linking
    // Ref: https://api.flutter.dev/flutter/widgets/Navigator/defaultGenerateInitialRoutes.html
    // Find the child and then traverse to find all ancestors and add to list.
    // Return list in order of ancestor to child

    initialRouteArgs ??= <String, dynamic>{};

    final pageRegistration = this._pageRegistrations.firstWhere((element) => element.path == path);

    result.add(pageRegistration.generateRoute(
        new RouteSettings(name: path, arguments: initialRouteArgs), query));

    return result;
  }

  NavigatorState retrieveNavigator(String path) {
    given(path, "path")
        .ensureHasValue()
        .ensure((t) => this._navigatorKeys.containsKey(path.trim()), "key is unavailable");

    // return this._navigatorKeys[path.trim()].globalKey.currentState;

    return this._navigatorKeys[path.trim()].last.globalKey.currentState;
  }

  ServiceLocator retrieveScope(String path) {
    given(path, "path")
        .ensureHasValue()
        .ensure((t) => this._navigatorKeys.containsKey(path.trim()), "key is unavailable");

    // return this._navigatorKeys[path.trim()].scope;

    return this._navigatorKeys[path.trim()].last.scope;
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
  final String query;
  final Map<String, String> queryParams;
  final dynamic Function(dynamic args) factoryFunc;
  final PageType pageType;
  final bool fullscreenDialog;
  final children = <_PageRegistration>[];

  bool get isRoot => this.route == "/";

  _PageRegistration(this.route, this.path, this.pathSegments, this.query, this.queryParams,
      this.factoryFunc, this.pageType, this.fullscreenDialog);

  Route generateRoute(RouteSettings settings, String query) {
    final queryArgs = this._parseQuery(query);

    final widgetBuilder = (BuildContext context) {
      settings ??= ModalRoute.of(context).settings;
      final args = queryArgs;
      args.addAll(settings.arguments ?? {});
      final consolidatedArgs = <String, dynamic>{};

      this.queryParams.forEach((key, type) {
        final isOptional = key.endsWith("?");
        if (isOptional) key = key.substring(0, key.length - 1);
        if (!args.containsKey(key) || args[key] == null) {
          if (isOptional) return;
          throw new ArgumentError("Argument for param '${key}' was not provided.");
        }

        var argValue = args[key];
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
            // ignore: unnecessary_type_check
            given(argValue, key).ensure((t) => t is Object, "must be Object");
            argValue = argValue as Object;
            break;
        }

        consolidatedArgs[key] = argValue;
      });

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
      default:
        throw new Exception("Unsupported PageType");
    }
  }

  Map<String, dynamic> _parseQuery(String query) {
    final result = <String, dynamic>{};
    if (query == null || query.trim().isEmpty) return result;

    if (query.contains(new RegExp(r'[{:}]'))) throw new Exception("Invalid query: ${query}");

    query.split("&").forEach((element) {
      final split = element.split("=");
      final key = split[0];
      final value = split[1];

      if (!this.queryParams.containsKey(key)) return;
      final type = this.queryParams[key];
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
            break;
        }

      result[key] = typedValue;
    });

    return result;
  }

  bool _parseBool(String value) {
    if (value == null || value.trim().isEmpty) return null;
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
  static var _isBootstrapped = false;

  static NavigationManager get instance => _instance;

  NavigationManager._private();

  void registerPage<T extends Widget>(String route, T Function(dynamic routeArgs) factoryFunc,
      {PageType pageType = PageType.material, fullscreenDialog = false}) {
    if (_isBootstrapped) throw new StateError("Already bootstrapped");

    _manager.registerPage(route, factoryFunc, pageType, fullscreenDialog);
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
      final route = settings.name.trim();
      final path = this._getJustPath(route);
      final query = this._getJustQuery(route);
      if (!mappedRoutes.containsKey(path)) throw Exception('Invalid route: ${settings.name}');
      return mappedRoutes[path].generateRoute(settings, query);
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

  RouteListFactory generateRouteListFactory([Map<String, dynamic> initialRouteArgs]) {
    if (!_isBootstrapped) throw new StateError("Not bootstrapped");

    final result = (NavigatorState navigator, String route) {
      return _manager.generateInitialRoutes(
          this._getJustPath(route), this._getJustQuery(route), initialRouteArgs);
    };

    return result;
  }

  GlobalKey<NavigatorState> generateNavigatorKey(String basePath) {
    if (!_isBootstrapped) throw new StateError("Not bootstrapped");
    basePath = this._getJustPath(basePath);

    return _manager.generateNavigatorKey(basePath);
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

  String _generateRoute(String routeTemplate, [Map<String, dynamic> routeArgs]) {
    given(routeTemplate, "routeTemplate")
        .ensureHasValue()
        .ensure((t) => t.startsWith("/"), "invalid route template");

    final path = this._getJustPath(routeTemplate);
    final pageRegistration = _manager._pageRegistrations.find((element) => element.path == path);
    if (pageRegistration == null) throw new Exception("Unknown route: ${routeTemplate}");
    if (routeArgs == null) return path;
    final query = this._getJustQuery(routeTemplate);
    if (query == null) return routeTemplate;

    var result = "";

    routeArgs.forEach((key, value) {
      if (!pageRegistration.queryParams.containsKey(key)) return;
      final type = pageRegistration.queryParams[key];
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
          break;
      }
      if (result.isNotEmpty) result += "&";
      result += "${key}=${argValue}";
    });

    return "${path}?${result}";
  }

  String _getJustPath(String route) {
    given(route, "route")
        .ensureHasValue()
        .ensure((t) => t.trim().startsWith("/"), "Invalid route '${route}'");

    route = route.trim();
    if (route.contains("?")) {
      final split = route.split("?");
      route = split[0].trim();
    }

    return route;
  }

  String _getJustQuery(String route) {
    given(route, "route")
        .ensureHasValue()
        .ensure((t) => t.trim().startsWith("/"), "Invalid route '${route}'");
    route = route.trim();
    if (!route.contains("?")) return null;

    return route.split("?").skip(1).join("?");
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

  String generateRoute(String routeTemplate, [Map<String, dynamic> routeArgs]) {
    return NavigationManager.instance._generateRoute(routeTemplate, routeArgs);
  }
}
