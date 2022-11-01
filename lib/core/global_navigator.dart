import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@singleton
class GlobalNavigator {
  late final GlobalKey<NavigatorState> _navigatorKey;

  // cause: conflicts with no setters without getters rule and we don't want to expose get
  // interface.
  // ignore: use_setters_to_change_properties
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) => _navigatorKey = navigatorKey;

  Future<T?> popAndPushNamed<T, TO>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) =>
      _navigatorKey.currentState!.popAndPushNamed(
        routeName,
        result: result,
        arguments: arguments,
      );

  Future<T?> showGlobalDialog<T>(WidgetBuilder builder) =>
      showDialog(context: _navigatorKey.currentContext!, builder: builder);

  Future<T?> pushAndRemoveUntil<T>(
    Route<T> newRoute,
    RoutePredicate predicate,
  ) =>
      _navigatorKey.currentState!.pushAndRemoveUntil(newRoute, predicate);

  Future<T?> pushReplacement<T>(Route<T> newRoute) =>
      _navigatorKey.currentState!.pushReplacement(newRoute);

  Future<T?> pushReplacementNamed<T>(String newRoute) =>
      _navigatorKey.currentState!.pushReplacementNamed(newRoute);

  Future<T?> pushNamedAndRemoveUntil<T>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) =>
      _navigatorKey.currentState!.pushNamedAndRemoveUntil(
        newRouteName,
        (route) => false,
        arguments: arguments,
      );

  Future<T?> pushNamed<T extends Object>(
    String routeName, {
    Object? arguments,
  }) =>
      _navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);

  Future<bool> maybePop<T extends Object>([T? result]) =>
      _navigatorKey.currentState!.maybePop(result);

  void pop<T extends Object>([T? result]) => _navigatorKey.currentState!.pop(result);

  Future<T?> push<T>(Route<T> route) => _navigatorKey.currentState!.push(route);
}
