import 'dart:async';
import 'package:floater/src/service_locator.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'navigation.dart';

/// Uses [StatelessWidgetBase] instead of [StatelessWidget]. There isn't much difference.
@immutable
abstract class StatelessWidgetBase extends StatelessWidget {
  const StatelessWidgetBase({
    Key? key,
  }) : super(key: key);
}

/// Uses [StatefulWidgetBase] instead of [StatefulWidget].
@immutable
abstract class StatefulWidgetBase<T extends WidgetStateBase> extends StatefulWidget {
  final T Function() _createState;
  final List<T> _stateHolder = <T>[];

  @protected
  T get state => this._stateHolder[0];

  StatefulWidgetBase(T Function() createState, {Key? key})
      : this._createState = createState,
        super(key: key);

  @override
  @nonVirtual
  T createState() => this._createState();

  Widget build(BuildContext context);

  void _setState(T state) {
    if (this._stateHolder.isEmpty) {
      this._stateHolder.add(state);
    } else {
      this._stateHolder[0] = state;
    }
  }
}

/// The widget is separated by Design and State.
///
/// All the business logics goes in State file, the UI designs goes in Design file.

abstract class WidgetStateBase<T extends StatefulWidget> extends State<T> {
  final _watches = <Stream, StreamSubscription>{};
  final _listeners = <Listenable, void Function()>{};
  bool _isInitialized = false;

  VoidCallback? _onInitState;
  VoidCallback? _onDeactivate;
  VoidCallback? _onDispose;
  VoidCallback? _onStateChange;

  /// Access private variables from state file by setting a public getter and calling it to the design file.
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
    if (this._onInitState != null) this._onInitState!();
  }

  @protected
  @nonVirtual
  @mustCallSuper

  /// [onInitState] is a callback to [initState].
  /// If a State's build method depends on an object that can itself change state, [onInitState] is called.
  void onInitState(VoidCallback callback) {
    // given(callback, "callback").ensureHasValue();
    this._onInitState = callback;
  }

  @override
  @protected
  @nonVirtual
  @mustCallSuper

  /// Notify the framework that the internal state of this object has changed.
  /// Whenever you change the internal state of a State object, make the change in a function that you pass to [setState].
  void setState([VoidCallback? fn]) {
    if (fn != null) fn();
    if (this._onStateChange != null) this._onStateChange!();
    if (!this._isInitialized) return;
    if (this._isDisposed) return;
    super.setState(() {});
  }

  @override
  @protected
  @nonVirtual
  @mustCallSuper

  /// The framework calls this method whenever it removes this State object from the tree.
  /// In some cases, the framework will reinsert the State object into another part of the tree.
  /// If that happens, the framework will call [activate] to give the State object a chance to
  /// reacquire any resources that it released in [deactivate].
  void deactivate() {
    if (this._onDeactivate != null) this._onDeactivate!();

    super.deactivate();
  }

  @protected
  @nonVirtual
  @mustCallSuper

  /// [onDeactivate] is a callback to [deactivate].
  void onDeactivate(VoidCallback callback) {
    this._onDeactivate = callback;
  }

  @override
  @protected
  @nonVirtual
  @mustCallSuper

  /// Called when this object is removed from the tree permanently.
  /// The framework calls this method when this State object will never build again.After the framework
  /// calls [dispose], the State object is considered unmounted and the mounted property is false.
  void dispose() {
    this._isDisposed = true;
    this._watches.values.forEach((watcher) => watcher.cancel());
    this._watches.clear();

    this._listeners.entries.forEach((t) => t.key.removeListener(t.value));
    this._listeners.clear();

    if (this._onDispose != null) this._onDispose!();

    super.dispose();
  }

  @protected
  @nonVirtual
  @mustCallSuper

  /// [onDispose] is a callback to [dispose].
  void onDispose(VoidCallback callback) {
    this._onDispose = callback;
  }

  /// [setState] is replaced by [triggerStateChange] which is more convenient.
  @protected
  @nonVirtual
  @mustCallSuper
  void triggerStateChange() {
    this.setState(() {});
  }

  @protected
  @nonVirtual
  @mustCallSuper
  void onStateChange(VoidCallback callback) {
    this._onStateChange = callback;
  }

  @protected
  @nonVirtual
  @mustCallSuper

  /// [watch] is used for [Stream].
  /// When you have a [Stream], [watch] will listens to the stream and disposes after use even if you did not
  /// use [unwatch].
  void watch<U>(Stream<U> stream, [FutureOr<void> Function(U data)? onData]) {
    if (this._watches.containsKey(stream)) return;
    onData ??= (U data) {};
    this._watches[stream] = stream.listen((event) async {
      await onData!(event);
      this.triggerStateChange();
    });
  }

  @protected
  @nonVirtual
  @mustCallSuper

  /// [unwatch] is used to dispose a [Stream] after use.
  void unwatch(Stream stream) {
    if (!this._watches.containsKey(stream)) return;
    final watcher = this._watches[stream]!;
    this._watches.remove(stream);
    watcher.cancel();
  }

  @protected
  @nonVirtual
  @mustCallSuper

  /// [listen] is used for [Listenable].
  /// The idea of [listen] is same as [watch] in [Stream].
  /// When you have a [Listenable], [listen] will listens to the [Listenable] and disposes after use even if you
  /// did not use [unlisten].
  void listen<T extends Listenable>(T listenable, void Function() onChange) {
    if (this._listeners.containsKey(listenable)) {
      throw Exception("Listenable $listenable already being listened to");
    }

    this._listeners[listenable] = onChange;
    listenable.addListener(onChange);
  }

  @protected
  @nonVirtual
  @mustCallSuper

  /// [unlisten] is used to dispose a [Listenable] after use.
  void unlisten<T extends Listenable>(T listenable) {
    if (!this._listeners.containsKey(listenable)) return;

    final listener = this._listeners.remove(listenable);
    listenable.removeListener(listener!);
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

  /// When loading starts, [showLoading] is called which sets [_isLoading] to true.
  void showLoading() {
    this._isLoading = true;
    this.triggerStateChange();
  }

  @protected
  @mustCallSuper

  /// After loading finishes, [hideLoading] is called which sets [_isLoading] to false.
  void hideLoading() {
    this._isLoading = false;
    this.triggerStateChange();
  }
}

/// For clients of AutomaticKeepAlive (example: ListView).
/// This keeps the state of a widget alive, given the wantAlive is set to true.

abstract class KeepAliveClientWidgetStateBase<T extends StatefulWidget> extends WidgetStateBase<T>
    with AutomaticKeepAliveClientMixin {
  /// Marks a child as needing to remain alive.
  /// The child and keepAlive arguments must not be null.
  /// Usually used when scrolling needs.
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

/// [ScopedNavigator] is used when same data is passed across multiple pages.
class ScopedNavigator extends StatefulWidgetBase<ScopedNavigatorState> {
  final String _initialRoute;
  final Map<String, dynamic>? _initialRouteArgs;

  /// [TransitionDelegate] creates a delegate and enables subclass to create a constant class.
  final TransitionDelegate<dynamic> _transitionDelegate;

  /// [NavigatorObserver] is an interface for observing the behavior of a [Navigator].
  final List<NavigatorObserver> observers;

  ScopedNavigator(
    String basePath, {
    required String initialRoute,
    Map<String, dynamic>? initialRouteArgs,
    TransitionDelegate<dynamic> transitionDelegate = const DefaultTransitionDelegate<dynamic>(),
    ServiceLocator? scope,
    Key? key,
    this.observers = const <NavigatorObserver>[],
  })  : this._initialRoute = initialRoute,
        this._initialRouteArgs = initialRouteArgs,
        this._transitionDelegate = transitionDelegate,
        super(() => new ScopedNavigatorState(basePath, scope), key: key);

  @override
  Widget build(BuildContext context) {
    // this implementation's back button behavior should be handled manually when used in parallel contexts
    return WillPopScope(
      child: Navigator(
        key: this.state.key,
        initialRoute: this._initialRoute,
        onGenerateRoute: NavigationManager.instance.generateRouteFactory(this.state.basePath),
        onGenerateInitialRoutes: NavigationManager.instance.generateRouteListFactory(this._initialRouteArgs),
        transitionDelegate: this._transitionDelegate,
        observers: this.observers,
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
      onWillPop: () async => !await NavigationService.instance.retrieveNavigator(this.state.basePath).maybePop(),
    );
  }
}

class ScopedNavigatorState extends WidgetStateBase<ScopedNavigator> {
  final String _basePath;
  final GlobalKey<NavigatorState> _key;

  String get basePath => this._basePath;
  GlobalKey<NavigatorState> get key => this._key;

  NavigatorState? get navigator => this._key.currentState;

  ScopedNavigatorState(String basePath, ServiceLocator? scope)
      : this._basePath = basePath,
        this._key = NavigationManager.instance.generateNavigatorKey(basePath, scope) {
    this.onDispose(() => NavigationManager.instance.disposeNavigatorKey(this._basePath, this._key));
  }
}
