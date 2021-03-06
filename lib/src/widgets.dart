import 'dart:async';
import 'package:floater/src/service_locator.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import "defensive.dart";
import 'navigation.dart';

@immutable
abstract class StatelessWidgetBase extends StatelessWidget {}

@immutable
abstract class StatefulWidgetBase<T extends WidgetStateBase> extends StatefulWidget {
  final T Function() _createState;
  final List<T> _stateHolder = <T>[];

  @protected
  T get state => this._stateHolder[0];

  StatefulWidgetBase(T Function() createState, {Key key})
      : this._createState = createState,
        super(key: key);

  @override
  @nonVirtual
  T createState() => this._createState();

  Widget build(BuildContext context);

  void _setState(T state) {
    given(state, "state").ensureHasValue();

    if (this._stateHolder.isEmpty) {
      this._stateHolder.add(state);
    } else {
      this._stateHolder[0] = state;
    }
  }
}

abstract class WidgetStateBase<T extends StatefulWidget> extends State<T> {
  final _watches = <Stream, StreamSubscription>{};
  bool _isInitialized = false;

  void Function() _onInitState;
  void Function() _onDeactivate;
  void Function() _onDispose;
  void Function() _onStateChange;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isDisposed = false;
  @protected
  @nonVirtual
  bool get isDisposed => this._isDisposed;

  @override
  @protected
  @nonVirtual
  @mustCallSuper
  void initState() {
    super.initState();

    this._isInitialized = true;
    if (this._onInitState != null) this._onInitState();
  }

  @protected
  @nonVirtual
  @mustCallSuper
  void onInitState(void Function() callback) {
    given(callback, "callback").ensureHasValue();
    this._onInitState = callback;
  }

  @override
  @protected
  @nonVirtual
  @mustCallSuper
  void setState([void Function() fn]) {
    if (fn != null) fn();
    if (this._onStateChange != null) this._onStateChange();
    if (!this._isInitialized) return;
    if (this._isDisposed) return;
    super.setState(() {});
  }

  @override
  @protected
  @nonVirtual
  @mustCallSuper
  void deactivate() {
    if (this._onDeactivate != null) this._onDeactivate();

    super.deactivate();
  }

  @protected
  @nonVirtual
  @mustCallSuper
  void onDeactivate(void Function() callback) {
    given(callback, "callback").ensureHasValue();
    this._onDeactivate = callback;
  }

  @override
  @protected
  @nonVirtual
  @mustCallSuper
  void dispose() {
    this._isDisposed = true;
    this._watches.values.forEach((watcher) => watcher.cancel());
    this._watches.clear();

    if (this._onDispose != null) this._onDispose();

    super.dispose();
  }

  @protected
  @nonVirtual
  @mustCallSuper
  void onDispose(void Function() callback) {
    given(callback, "callback").ensureHasValue();
    this._onDispose = callback;
  }

  @protected
  @nonVirtual
  @mustCallSuper
  void triggerStateChange() {
    this.setState(() {});
  }

  @protected
  @nonVirtual
  @mustCallSuper
  void onStateChange(void Function() callback) {
    given(callback, "callback").ensureHasValue();
    this._onStateChange = callback;
  }

  @protected
  @nonVirtual
  @mustCallSuper
  void watch<U>(Stream<U> stream, [FutureOr<void> Function(U data) onData]) {
    if (this._watches.containsKey(stream)) return;
    onData ??= (U data) {};
    this._watches[stream] = stream.listen((event) async {
      await onData(event);
      this.triggerStateChange();
    });
  }

  @protected
  @nonVirtual
  @mustCallSuper
  void unwatch(Stream stream) {
    if (!this._watches.containsKey(stream)) return;
    final watcher = this._watches[stream];
    this._watches.remove(stream);
    watcher.cancel();
  }

  @override
  @protected
  @nonVirtual
  @mustCallSuper
  Widget build(BuildContext context) {
    final widget = this.widget as StatefulWidgetBase;
    widget._setState(this);
    return widget.build(context);
  }

  @protected
  @mustCallSuper
  void showLoading() {
    this._isLoading = true;
    this.triggerStateChange();
  }

  @protected
  @mustCallSuper
  void hideLoading() {
    this._isLoading = false;
    this.triggerStateChange();
  }
}

/// For clients of AutomaticKeepAlive (example: ListView). 
/// This keeps the state of a widget alive, given the wantAlive is set to true.
abstract class KeepAliveClientWidgetStateBase<T extends StatefulWidget>
    extends WidgetStateBase<T> with AutomaticKeepAliveClientMixin {
  bool _keepAlive = true;

  @override
  @protected
  @nonVirtual
  bool get wantKeepAlive => this._keepAlive;

  @protected
  @nonVirtual
  set wantKeepAlive(bool value) {
    this._keepAlive = value;
    super.updateKeepAlive();
  }

  @override
  @protected
  @nonVirtual
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    final widget = this.widget as StatefulWidgetBase;
    widget._setState(this);
    return widget.build(context);
  }
}

@sealed
class ScopedNavigator extends StatefulWidgetBase<_ScopedNavigatorState> {
  final String _initialRoute;
  final Map<String, dynamic> _initialRouteArgs;
  final TransitionDelegate<dynamic> _transitionDelegate;

  ScopedNavigator(
    String basePath, {
    @required String initialRoute,
    Map<String, dynamic> initialRouteArgs,
    TransitionDelegate<dynamic> transitionDelegate = const DefaultTransitionDelegate<dynamic>(),
    ServiceLocator scope,
  })  : this._initialRoute = initialRoute,
        this._initialRouteArgs = initialRouteArgs,
        this._transitionDelegate = transitionDelegate,
        super(() => new _ScopedNavigatorState(basePath, scope));

  @override
  Widget build(BuildContext context) {
    // this implementation's back button behavior should be handled manually when used in parallel contexts
    return WillPopScope(
      child: Navigator(
        key: this.state.key,
        initialRoute: this._initialRoute,
        onGenerateRoute: NavigationManager.instance.generateRouteFactory(this.state.basePath),
        onGenerateInitialRoutes:
            NavigationManager.instance.generateRouteListFactory(this._initialRouteArgs),
        transitionDelegate: this._transitionDelegate,
      ),
      // onWillPop: () {
      //   print("onWillPop ${this.state.basePath}");
      //   final navigator = NavigationService.instance.retrieveNavigator(this.state.basePath);
      //   if (navigator.canPop()) {
      //     navigator.pop();
      //     return Future.value(false);
      //   } else
      //     return Future.value(true);
      // },
      onWillPop: () async =>
          !await NavigationService.instance.retrieveNavigator(this.state.basePath).maybePop(),
    );
  }
}

class _ScopedNavigatorState extends WidgetStateBase<ScopedNavigator> {
  final String _basePath;
  final GlobalKey<NavigatorState> _key;

  String get basePath => this._basePath;
  GlobalKey<NavigatorState> get key => this._key;

  _ScopedNavigatorState(String basePath, ServiceLocator scope)
      : this._basePath = basePath,
        this._key = NavigationManager.instance.generateNavigatorKey(basePath, scope) {
    this.onDispose(() => NavigationManager.instance.disposeNavigatorKey(this._basePath, this._key));
  }
}
