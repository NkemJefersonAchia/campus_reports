import 'package:flutter/material.dart';

class RefreshableList extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  const RefreshableList({super.key, required this.onRefresh, required this.child});
  @override
  Widget build(BuildContext context) => RefreshIndicator.adaptive(onRefresh: onRefresh, child: child);
}
