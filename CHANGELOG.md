## [0.1.4] - December 20, 2021
* Expose `CustomPageRouteBuilder` to build custom route transitions

## [0.1.3] - October 25, 2021
* Listen/Unlisten utility helpers for stateful widgets
* const constructor for Stateless widgets  

## [0.1.2] - April 29, 2021
* Expose navigation observers property for scoped navigator.

## [0.1.1+1] - April 18, 2021
* Fix changelog typo

## [0.1.1] - April 18, 2021
* Added Key for Scoped Navigator
* Example App now includes and example for a Bottom nav set up for an app
* formatting package files

## [0.1.0] - March 29, 2021
* Null safety
* String isEmptyOrWhiteSpace and isNotEmptyOrWhiteSpace
* BREAKING CHANGE: `given(value, "value").ensureHasValue()` is removed since it would have no values with new nullable dart types

## [0.0.5+1] - January 2, 2021
* Route gen Bug fix

## [0.0.5] - January 2, 2021
* Route persistance 

## [0.0.4] - October 27, 2020
* Event Aggregator (automatically registered as a singleton)
* BREAKING CHANGE: The StorageService renamed to SecureStorageService, and is registered as a singleton automatically if not registered by user.

## [0.0.3] - October 15, 2020
* Mutex lock
* Safe state disposal. Ignore `triggerStateChange()` when the state is disposed
* Update StorageService and added the ability to check if key exists `contains` 
* `KeepAliveClientWidgetStateBase` for clients of AutomaticKeepAlive (example: ListView). This keeps the state of a widget alive, given the wantAlive is set to true.

## [0.0.2+1] - August 6, 2020
* Documentation

## [0.0.2] - August 5, 2020
* Updated README
* Added example TODO Application
* Ability to pass a pre-crated scope to ScopedNavigator.

## [0.0.1] - July 31, 2020

* Initial Package Release.