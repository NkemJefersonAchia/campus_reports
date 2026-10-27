import 'package:flutter/material.dart';

class FadeInItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  const FadeInItem({super.key, required this.child, this.index = 0, this.delay = const Duration(milliseconds: 50)});
  @override
  State<FadeInItem> createState() => _FadeInItemState();
}
class _FadeInItemState extends State<FadeInItem> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  late final Animation<double> _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
  @override
  void initState() { super.initState(); Future.delayed(widget.delay * widget.index, () { if (mounted) _ctrl.forward(); }); }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _opacity, child: widget.child);
}
