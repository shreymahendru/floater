import 'package:example/widgets/loading_spinner/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class OverlayLoadingSpinner extends StatelessWidgetBase {
  final Widget child;
  final bool isEnabled;

  OverlayLoadingSpinner({
    @required this.child,
    @required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        if (this.isEnabled) ...[
          Opacity(
            child: new ModalBarrier(dismissible: false, color: Colors.grey),
            opacity: 0.3,
          ),
          Center(
            child: LoadingSpinner(),
          ),
        ]

        // if (this.isE)
      ],
    );
  }
}
