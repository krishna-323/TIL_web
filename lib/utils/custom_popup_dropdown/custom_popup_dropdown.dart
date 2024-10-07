

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import '../static_data/motows_colors.dart';

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const double _kMenuHorizontalPadding = 16.0;
const double _kMenuVerticalPadding = 8.0;
const double _kMenuScreenPadding = 8.0;
const double _kDefaultIconSize = 24.0;

enum CustomPopupMenuPosition {
  over,
  under,
}


abstract class CustomPopupMenuEntry<T> extends StatefulWidget {
  const CustomPopupMenuEntry({ Key? key }) : super(key: key);

  double get height;
  bool represents(T? value);
}

class _CustomMenuItem extends SingleChildRenderObjectWidget {
  const _CustomMenuItem({
    Key? key,
    required this.onLayout,
    required Widget? child,
  }) : super(key: key, child: child);

  final ValueChanged<Size> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _CustomRenderMenuItem(onLayout);
  }

  @override
  void updateRenderObject(BuildContext context, covariant _CustomRenderMenuItem renderObject) {
    renderObject.onLayout = onLayout;
  }
}

class _CustomRenderMenuItem extends RenderShiftedBox {
  _CustomRenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child == null) {
      return Size.zero;
    }
    return child!.getDryLayout(constraints);
  }

  @override
  void performLayout() {
    if (child == null) {
      size = Size.zero;
    } else {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Offset.zero;
    }
    onLayout(size);
  }
}

class CustomPopupMenuItem<T> extends CustomPopupMenuEntry<T> {

  const CustomPopupMenuItem({
    Key? key,
    this.value,
    this.onTap,
    this.onHover,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.mouseCursor,
    required this.child,
    this.text,
    this.textAlign
  }) : super(key: key);

  final T? value;

  final VoidCallback? onTap;
  final  ValueChanged<bool>? onHover;

  final bool enabled;

  @override
  final double height;

  final EdgeInsets? padding;


  final TextStyle? textStyle;
  final MainAxisAlignment? textAlign;
  final MouseCursor? mouseCursor;
  final Widget? child;
  final String? text;

  @override
  bool represents(T? value) => value == this.value;

  @override
  CustomPopupMenuItemState<T, CustomPopupMenuItem<T>> createState() => CustomPopupMenuItemState<T, CustomPopupMenuItem<T>>();
}

class CustomPopupMenuItemState<T, W extends CustomPopupMenuItem<T>> extends State<W> {

  @protected
  Widget? buildChild() => widget.child;
  @protected
  void handleTap() {
    widget.onTap?.call();
    Navigator.pop<T>(context, widget.value);
  }

  bool hoverValue=false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    TextStyle style = widget.textStyle ?? popupMenuTheme.textStyle ?? theme.textTheme.titleMedium!;

    if (!widget.enabled) {
      style = style.copyWith(color: theme.disabledColor);
    }


    return InkWell(
      onHover: (val){
        if(val){
          setState(() {
            hoverValue=true;
          });
        }
        else{
          setState(() {
            hoverValue=false;
          });
        }

      },
      hoverColor: mHoverColor,
      onTap: widget.enabled ? handleTap : null,
      canRequestFocus: widget.enabled,
      child:  Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
        child:widget.text == null ?widget.child : Row(mainAxisAlignment: widget.textAlign ?? MainAxisAlignment.start,
          children: [
            Text(widget.text??"",style: TextStyle(color: hoverValue? mSaveButton:Colors.black)),
          ],
        ),
      ),
    );
  }
}


class _CustomPopupMenu<T> extends StatelessWidget {
  const _CustomPopupMenu({
    Key? key,
    required this.route,
    required this.semanticLabel,
    this.constraints,
    required this.childWidth,
    required this.childHeight,
  }) : super(key: key);

  final _CustomPopupMenuRoute<T> route;
  final String? semanticLabel;
  final BoxConstraints? constraints;
  final double childWidth;
  final double ? childHeight;
  @override
  Widget build(BuildContext context) {
    final double unit = 1.0 / (route.items.length + 1.5); // 1.0 for the width and 0.5 for the last item's fade.
    final List<Widget> children = <Widget>[];
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);

    for (int i = 0; i < route.items.length; i += 1) {
      final double start = (i + 1) * unit;
      final double end = (start + 1.5 * unit).clamp(0.0, 1.0);
      final CurvedAnimation opacity = CurvedAnimation(
        parent: route.animation!,
        curve: Interval(start, end),
      );
      Widget item = route.items[i];
      if (route.initialValue != null && route.items[i].represents(route.initialValue)) {
        item = Container(
          color: Theme.of(context).highlightColor,
          child: item,
        );
      }
      children.add(
        _CustomMenuItem(
          onLayout: (Size size) {
            route.itemSizes[i] = size;
          },
          child: FadeTransition(
            opacity: opacity,
            child: item,
          ),
        ),
      );
    }

    final CurveTween opacity = CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
    final CurveTween width = CurveTween(curve: Interval(0.0, unit));
    final CurveTween height = CurveTween(curve: Interval(0.0, unit * route.items.length));

    final Widget child = Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: SizedBox(
        width: childWidth,
        height: childHeight,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: _kMenuVerticalPadding,
          ),
          child: ListBody(children: children),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: route.animation!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: opacity.animate(route.animation!),
          child: Material(
            shape: route.shape ?? popupMenuTheme.shape,
            color: route.color ?? popupMenuTheme.color,
            type: MaterialType.card,
            elevation: route.elevation ?? popupMenuTheme.elevation ?? 8.0,
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              widthFactor: width.evaluate(route.animation!),
              heightFactor: height.evaluate(route.animation!),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

// Positioning of the menu on the screen.
class _CustomPopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _CustomPopupMenuRouteLayout(
      this.position,
      this.itemSizes,
      this.selectedItemIndex,
      this.textDirection,
      this.padding,
      this.avoidBounds,
      );
  final RelativeRect position;
  List<Size?> itemSizes;

  final int? selectedItemIndex;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // The padding of unsafe area.
  EdgeInsets padding;

  // List of rectangles that we should avoid overlapping. Unusable screen area.
  final Set<Rect> avoidBounds;
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(_kMenuScreenPadding) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {

    final double buttonHeight = size.height - position.top - position.bottom;
    // Find the ideal vertical position.
    double y = position.top;
    if (selectedItemIndex != null) {
      double selectedItemOffset = _kMenuVerticalPadding;
      for (int index = 0; index < selectedItemIndex!; index += 1) {
        selectedItemOffset += itemSizes[index]!.height;
      }
      selectedItemOffset += itemSizes[selectedItemIndex!]!.height / 2;
      y = y + buttonHeight / 2.0 - selectedItemOffset;
    }

    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      switch (textDirection) {
        case TextDirection.rtl:
          x = size.width - position.right - childSize.width;
          break;
        case TextDirection.ltr:
          x = position.left;
          break;
      }
    }
    final Offset wantedPosition = Offset(x, y);
    final Offset originCenter = position.toRect(Offset.zero & size).center;
    final Iterable<Rect> subScreens = DisplayFeatureSubScreen.subScreensInBounds(Offset.zero & size, avoidBounds);
    final Rect subScreen = _closestScreen(subScreens, originCenter);
    return _fitInsideScreen(subScreen, childSize, wantedPosition);
  }

  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    Rect closest = screens.first;
    for (final Rect screen in screens) {
      if ((screen.center - point).distance < (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }

  Offset _fitInsideScreen(Rect screen, Size childSize, Offset wantedPosition){
    double x = wantedPosition.dx;
    double y = wantedPosition.dy;
    if (x < screen.left + _kMenuScreenPadding + padding.left) {
      x = screen.left + _kMenuScreenPadding + padding.left;
    } else if (x + childSize.width > screen.right - _kMenuScreenPadding - padding.right) {
      x = screen.right - childSize.width - _kMenuScreenPadding - padding.right;
    }
    if (y < screen.top + _kMenuScreenPadding + padding.top) {
      y = _kMenuScreenPadding + padding.top;
    } else if (y + childSize.height > screen.bottom - _kMenuScreenPadding - padding.bottom) {
      y = screen.bottom - childSize.height - _kMenuScreenPadding - padding.bottom;
    }

    return Offset(x,y);
  }

  @override
  bool shouldRelayout(_CustomPopupMenuRouteLayout oldDelegate) {

    assert(itemSizes.length == oldDelegate.itemSizes.length);

    return position != oldDelegate.position
        || selectedItemIndex != oldDelegate.selectedItemIndex
        || textDirection != oldDelegate.textDirection
        || !listEquals(itemSizes, oldDelegate.itemSizes)
        || padding != oldDelegate.padding
        || !setEquals(avoidBounds, oldDelegate.avoidBounds);
  }
}

class _CustomPopupMenuRoute<T> extends PopupRoute<T> {

  _CustomPopupMenuRoute({
    required this.position,
    required this.items,
    this.initialValue,
    this.elevation,
    required this.barrierLabel,
    this.semanticLabel,
    this.shape,
    this.color,
    required this.capturedThemes,
    this.constraints,
    required this.childWidth,
    required this.childHeight,
  }) : itemSizes = List<Size?>.filled(items.length, null);

  final RelativeRect position;
  final List<CustomPopupMenuEntry<T>> items;
  final List<Size?> itemSizes;
  final T? initialValue;
  final double? elevation;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final Color? color;
  final CapturedThemes capturedThemes;
  final BoxConstraints? constraints;
  double childWidth;
  double ? childHeight;
  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd),
    );
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {

    int? selectedItemIndex;
    if (initialValue != null) {
      for (int index = 0; selectedItemIndex == null && index < items.length; index += 1) {
        if (items[index].represents(initialValue)) {
          selectedItemIndex = index;
        }
      }
    }

    final Widget menu = _CustomPopupMenu<T>(
      route: this,
      semanticLabel: semanticLabel,
      constraints: constraints,
      childWidth: childWidth,
      childHeight: childHeight,
    );
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _CustomPopupMenuRouteLayout(
              position,
              itemSizes,
              selectedItemIndex,
              Directionality.of(context),
              mediaQuery.padding,
              _avoidBounds(mediaQuery),
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }

  Set<Rect> _avoidBounds(MediaQueryData mediaQuery) {
    return DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();
  }
}

Future<T?> showMenu<T>({
  required BuildContext context,
  required RelativeRect position,
  required List<CustomPopupMenuEntry<T>> items,
  T? initialValue,
  double? elevation,
  String? semanticLabel,
  ShapeBorder? shape,
  Color? color,
  bool useRootNavigator = false,
  BoxConstraints? constraints,
  required double childWidth,
  double? childHeight,
}) {
  assert(items.isNotEmpty);
  assert(debugCheckHasMaterialLocalizations(context));

  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      semanticLabel ??= MaterialLocalizations.of(context).popupMenuLabel;
  }

  final NavigatorState navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(_CustomPopupMenuRoute<T>(
    position: position,
    items: items,
    initialValue: initialValue,
    elevation: elevation,
    semanticLabel: semanticLabel,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    shape: shape,
    color: color,
    capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
    constraints: constraints,
    childWidth: childWidth,
    childHeight: childHeight,
  ));
}


typedef PopupMenuItemSelected<T> = void Function(T value);

typedef PopupMenuCanceled = void Function();


typedef PopupMenuItemBuilder<T> = List<CustomPopupMenuEntry<T>> Function(BuildContext context);


class CustomPopupMenuButton<T> extends StatefulWidget {

  const CustomPopupMenuButton({
    Key? key,
    required this.itemBuilder,
    this.initialValue,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.padding = const EdgeInsets.all(8.0),
    this.child,
    this.splashRadius,
    this.icon,
    this.iconSize,
    this.offset = Offset.zero,
    this.enabled = true,
    this.shape,
    this.color,
    this.enableFeedback,
    required this.hintText,
    this.constraints,
    this.position = CustomPopupMenuPosition.over,
    required this.childWidth,
     this.childHeight,
    this.textController,
    this.validator,
    this.decoration,
    this.textAlign,
  }) : assert(
        !(child != null && icon != null),
        'You can only pass [child] or [icon], not both.',
        ),
        super(key: key);

  final PopupMenuItemBuilder<T> itemBuilder;
  final T? initialValue;

  final PopupMenuItemSelected<T>? onSelected;

  final PopupMenuCanceled? onCanceled;
  final String? tooltip;
  final double? elevation;

  final EdgeInsetsGeometry padding;
  final double? splashRadius;

  final Widget? child;

  final Widget? icon;
  final Offset offset;

  final bool enabled;

  final ShapeBorder? shape;

  final Color? color;

  final bool? enableFeedback;

  final double? iconSize;

  final InputDecoration? decoration;

  final BoxConstraints? constraints;

  final CustomPopupMenuPosition position;

  final double childWidth;
  final double ? childHeight;
  final String hintText;

  final TextAlign? textAlign;

  final TextEditingController? textController ;

  final FormFieldValidator<String>? validator ;


  @override
  CustomPopupMenuButtonState<T> createState() => CustomPopupMenuButtonState<T>();
}


class CustomPopupMenuButtonState<T> extends State<CustomPopupMenuButton<T>> {
  void showButtonMenu() {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final Offset offset;
    switch (widget.position) {
      case CustomPopupMenuPosition.over:
        offset = widget.offset;
        break;
      case CustomPopupMenuPosition.under:
        offset = Offset(0.0, button.size.height - (widget.padding.vertical / 2)) + widget.offset;
        break;
    }
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    final List<CustomPopupMenuEntry<T>> items = widget.itemBuilder(context);

    // Only show the menu if there is something to show
    if (items.isNotEmpty) {
      showMenu<T?>(
        context: context,
        elevation: widget.elevation ?? popupMenuTheme.elevation,
        items: items,
        initialValue: widget.initialValue,
        position: position,
        shape: widget.shape ?? popupMenuTheme.shape,
        color: widget.color ?? popupMenuTheme.color,
        constraints: widget.constraints,
        childWidth: widget.childWidth,
        childHeight: widget.childHeight,
      )
          .then<void>((T? newValue) {
        if (!mounted) {
          return null;
        }
        if (newValue == null) {
          widget.onCanceled?.call();
          return null;
        }
        widget.onSelected?.call(newValue);
      });
    }
  }

  bool isHovered=false;
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final bool enableFeedback = widget.enableFeedback
        ?? PopupMenuTheme.of(context).enableFeedback
        ?? true;

    assert(debugCheckHasMaterialLocalizations(context));

    if (widget.child != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
              isHovered=true;
          });
        },
        onExit: (event) {
          setState(() {
            isHovered=false;
          });
        },
        child: TextFormField(

          mouseCursor: MouseCursor.defer,cursorHeight: 0,enableInteractiveSelection: false,
          onTap: widget.enabled ? showButtonMenu : null,
          style: const TextStyle(color: Colors.black),
          textAlign: widget.textAlign ?? TextAlign.left,
          validator: widget.validator,
          controller: widget.textController,
          decoration: widget.decoration,
          readOnly: true,
        ),
      );
    }

    return IconButton(
      icon: widget.icon ?? Icon(Icons.adaptive.more),
      padding: widget.padding,
      splashRadius: widget.splashRadius,
      iconSize: widget.iconSize ?? iconTheme.size ?? _kDefaultIconSize,
      tooltip: widget.tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
      onPressed: widget.enabled ? showButtonMenu : null,
      enableFeedback: enableFeedback,
    );
  }
}

