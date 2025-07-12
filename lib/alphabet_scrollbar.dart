library alphabet_scrollbar;

import 'dart:math' as math;

import 'package:flutter/material.dart';

class AlphabetScrollbar extends StatefulWidget {
  const AlphabetScrollbar(
      {super.key,
      this.selectedLetterColor = Colors.red,
      required this.onLetterChange,
      this.onLetterChagneStatus,
      this.style,
      this.selectedLetterSize,
      this.padding,
      this.leftSidedOrTop = false,
      this.switchToHorizontal = false,
      this.reverse = false,
      this.factor = 30,
      this.selectedLetterAdditionalSpace = 15,
      this.duration = const Duration(milliseconds: 200),
      this.letterCollection,
      this.halfSinWaveLength = 6,
      this.selectdBGWidget,
      this.letterContainerDecoration = const BoxDecoration(shape: BoxShape.circle),
      this.letterContainerPadding = const EdgeInsets.all(0),
      this.selectedLetterContainerDecoration,
      this.selectedLettercontainerPadding});

  final Function(bool)? onLetterChagneStatus;
  final Function(String) onLetterChange;
  final TextStyle? style;
  final double? selectedLetterSize;
  final Color selectedLetterColor;
  final EdgeInsets? padding;
  final bool leftSidedOrTop;
  final bool switchToHorizontal;
  final bool reverse;
  final double factor;
  final double selectedLetterAdditionalSpace;
  final Duration duration;
  final List<String>? letterCollection;
  final int halfSinWaveLength;
  final Decoration letterContainerDecoration;
  final EdgeInsets letterContainerPadding;
  final Decoration? selectedLetterContainerDecoration;
  final EdgeInsets? selectedLettercontainerPadding;
  final Widget? selectdBGWidget;

  @override
  State<StatefulWidget> createState() => _AlphabetScrollbarState();
}

class _AlphabetScrollbarState extends State<AlphabetScrollbar> {
  _AlphabetScrollbarState();

  final GlobalKey _alphabetContainerKey = GlobalKey();
  int? _alphabetIndex;
  bool _alphabetScrollActive = false;
  List<String> _alphabet = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];
  double dy = 0.0;
  double dx = 0.0;
  double itemSize = 0.0;

  @override
  Widget build(BuildContext context) {
    _alphabet = widget.letterCollection ?? _alphabet;

    return GestureDetector(
        behavior: HitTestBehavior.opaque, // => This dissables Hit-Detection of elements behind..
        //OnTab,notDrag..
        onTapDown: widget.switchToHorizontal
            ? (details) => {
                  _alphabetScrollActive = true,
                  widget.onLetterChagneStatus?.call(_alphabetScrollActive),
                  _onDragUpdate(dx: details.localPosition.dx)
                }
            : (details) => {
                  _alphabetScrollActive = true,
                  widget.onLetterChagneStatus?.call(_alphabetScrollActive),
                  _onDragUpdate(dy: details.localPosition.dy)
                },
        onTapUp: (details) => {
              setState(() {
                _alphabetScrollActive = false;
                widget.onLetterChagneStatus?.call(_alphabetScrollActive);
                _alphabetIndex = null;
              })
            },
        onTapMove: (details) {},
        //Vertically
        onVerticalDragStart: widget.switchToHorizontal
            ? null
            : (details) => {
                  _alphabetScrollActive = true,
                  widget.onLetterChagneStatus?.call(_alphabetScrollActive),
                  _onDragUpdate(dy: details.localPosition.dy)
                },
        onVerticalDragEnd: widget.switchToHorizontal
            ? null
            : (details) => {
                  setState(() {
                    _alphabetScrollActive = false;
                    _alphabetIndex = null;
                    widget.onLetterChagneStatus?.call(_alphabetScrollActive);
                  })
                },
        onVerticalDragUpdate: widget.switchToHorizontal
            ? (DragUpdateDetails dragUpdateDetails) {
                // setState(() {
                //   dx = dragUpdateDetails.localPosition.dx;
                // });
                //
              }
            : (DragUpdateDetails dragUpdateDetails) =>
                _onDragUpdate(dy: dragUpdateDetails.localPosition.dy, dx: dragUpdateDetails.globalPosition.dx),
        //Horizontaly
        onHorizontalDragStart: !widget.switchToHorizontal
            ? (dragUpdateDetails) {
                // setState(() {
                //   dx = dragUpdateDetails.localPosition.dx;
                // });
                //
              }
            : (details) => {
                  _alphabetScrollActive = true,
                  widget.onLetterChagneStatus?.call(_alphabetScrollActive),
                  _onDragUpdate(dx: details.localPosition.dx)
                },
        onHorizontalDragEnd: !widget.switchToHorizontal
            ? (dragUpdateDetails) {
                // setState(() {
                //   dx = dragUpdateDetails.localPosition.dx;
                // });
                //
              }
            : (details) => {
                  setState(() {
                    _alphabetScrollActive = false;
                    widget.onLetterChagneStatus?.call(_alphabetScrollActive);
                    _alphabetIndex = null;
                  })
                },
        onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetails) =>
            _onDragUpdate(dy: dragUpdateDetails.localPosition.dy, dx: dragUpdateDetails.globalPosition.dx),
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.all(0),
          child: widget.switchToHorizontal
              ? Row(
                  key: _alphabetContainerKey,
                  crossAxisAlignment: widget.leftSidedOrTop ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _getAlphabetScroll())
              : Stack(
                  children: [
                    Column(
                      key: _alphabetContainerKey,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: widget.leftSidedOrTop ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                      children: _getAlphabetScroll(),
                    ),
                    _activeAlphabetWidget()
                  ],
                ),
        ));
  }

  Widget _activeAlphabetWidget() {
    final saveActiveIndex = _alphabetIndex;
    if (saveActiveIndex == null) {
      return const SizedBox.shrink();
    }
    final fontSize = (widget.selectedLetterSize ?? 10);
    return Positioned.fill(
        child: Transform.translate(
      offset: Offset(-40 - fontSize, 0),
      child: Container(
        // color: Colors.redAccent.withAlpha(100),
        child: Container(
          width: 100,
          height: 100,
          // color: Colors.amberAccent.withAlpha(100),
          margin: EdgeInsets.only(top: dy - 50, bottom: MediaQuery.of(context).size.height - dy - 50),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            Container(
              padding: EdgeInsets.only(top: fontSize/ 4),
              width: fontSize * 2, height: fontSize * 2, 
              decoration: widget.selectedLetterContainerDecoration,
              child: Text(_alphabet[saveActiveIndex],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.selectedLetterColor,
                fontSize: widget.selectedLetterSize
              ),),
            )
          ],),
        ),
      ),
    ));
  }

  List<Widget> _getAlphabetScroll() {
    List<Widget> alphabetScroll = [];

    var alphabetValues = widget.reverse ? _alphabet.reversed.toList() : _alphabet;

    final count = math.min(itemSize.toInt(), widget.halfSinWaveLength);
    var duration = widget.duration;
    for (var letter in alphabetValues) {
      var indexOfLetter = alphabetValues.indexOf(letter);
      num space = 0;
      TextStyle? currentLetterStyle = widget.style ?? Theme.of(context).textTheme.bodyMedium;
      Decoration? currentLetterContainerDecoration = widget.letterContainerDecoration;
      EdgeInsets? currentLetterContainerPadding = widget.letterContainerPadding;

      bool isActive = true;
      if (_alphabetScrollActive &&
          indexOfLetter >= _alphabetIndex! - widget.halfSinWaveLength &&
          indexOfLetter <= _alphabetIndex! + widget.halfSinWaveLength) {
        var relativeIndex = ((_alphabetIndex! - widget.halfSinWaveLength) * (-1)) + indexOfLetter;

        var deg = relativeIndex - ((dy / itemSize) - _alphabetIndex!);
        var rad = deg * (widget.halfSinWaveLength * 2 + 3) / 180 * math.pi;
        final iindex = (indexOfLetter - _alphabetIndex!).abs().toInt();
        final exponent = math.max(iindex / count, 0);

        var closerFactor = exponent;
        if (iindex >= 3) {
          closerFactor = 1;
        }
        space = math.sin(rad);

        final dxOffset = widget.leftSidedOrTop ? dx : math.max(MediaQuery.of(context).size.width - dx, 0.0);
        if (space < 0) space = 0;
        space = space * widget.factor;
        if (indexOfLetter == _alphabetIndex && false) {
          space = space + widget.selectedLetterAdditionalSpace + dxOffset;
          currentLetterStyle =
              currentLetterStyle?.copyWith(color: widget.selectedLetterColor, fontSize: widget.selectedLetterSize) ??
                  TextStyle(color: widget.selectedLetterColor, fontSize: widget.selectedLetterSize);
          currentLetterContainerPadding = widget.selectedLettercontainerPadding ?? widget.letterContainerPadding;
          currentLetterContainerDecoration =
              widget.selectedLetterContainerDecoration ?? widget.letterContainerDecoration;
          isActive = true;
        } else {
          final first = _alphabetIndex!;
          final second = alphabetValues.length - first;
          final maxD = math.max(first, second);
          final activeSpace = widget.selectedLetterAdditionalSpace + dxOffset;
          var fontSize = currentLetterStyle?.fontSize ?? Theme.of(context).textTheme.bodyMedium?.fontSize ?? 10;
          fontSize += 10;
          final letterY = indexOfLetter * fontSize;
          final iindexY = (letterY - dy).abs();
          final firstY = dy;
          final secondY = alphabetValues.length * fontSize - firstY;
          final maxY = math.max(firstY, secondY);

          final baseY = 3;
          space = (baseY * math.cos((iindexY / maxY) * math.pi) + (baseY)) / baseY * (activeSpace / 2);

          space = math.max(space, 0);
          currentLetterStyle = currentLetterStyle?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              shadows: [BoxShadow(color: Theme.of(context).colorScheme.surfaceContainerHighest, blurRadius: 8)]);
        }
      }

      final targetPadding1 = widget.switchToHorizontal && widget.leftSidedOrTop
          ? EdgeInsets.only(top: space.toDouble())
          : widget.switchToHorizontal
              ? EdgeInsets.only(bottom: space.toDouble())
              : widget.leftSidedOrTop
                  ? EdgeInsets.only(left: space.toDouble())
                  : EdgeInsets.only(right: space.toDouble());

      if (isActive && false) {
        final fontSize = currentLetterStyle?.fontSize ?? Theme.of(context).textTheme.bodyMedium?.fontSize ?? 10;
        alphabetScroll.add(Container(
          // duration: duration,
          padding: targetPadding1,
          child: ClipRRect(
            // borderRadius: BorderRadiusGeometry.circular(99),
            child: Container(
              // duration: duration,
              padding: currentLetterContainerPadding,
              decoration: currentLetterContainerDecoration,
              child: Transform.translate(
                offset: Offset(0, -fontSize / 12),
                child: Container(
                  // duration: duration,
                  // curve: Curves.easeInOut,
                  padding: EdgeInsets.only(left: fontSize / 5),
                  width: fontSize,
                  height: fontSize * 1.2,
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: indexOfLetter == _alphabetIndex && widget.selectdBGWidget != null
                              ? widget.selectdBGWidget ?? const SizedBox.shrink()
                              : const SizedBox.shrink()),
                      DefaultTextStyle(
                        // curve: Curves.easeInOut,
                        // duration: duration,
                        style: currentLetterStyle!,
                        child: Text(
                          // style: currentLetterStyle,
                          letter,
                          // textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
      } else {
        alphabetScroll.add(AnimatedContainer(
          duration: duration,
          padding: targetPadding1,
          child: AnimatedContainer(
            duration: duration,
            padding: currentLetterContainerPadding,
            // decoration: currentLetterContainerDecoration,
            child: AnimatedContainer(
              duration: duration,
              curve: Curves.easeInOut,
              width: currentLetterStyle?.fontSize ?? Theme.of(context).textTheme.bodyMedium?.fontSize ?? 10,
              child: Stack(
                children: [
                  Positioned.fill(
                      child: indexOfLetter == _alphabetIndex && widget.selectdBGWidget != null
                          ? widget.selectdBGWidget ?? const SizedBox.shrink()
                          : const SizedBox.shrink()),
                  AnimatedDefaultTextStyle(
                    curve: Curves.easeInOut,
                    duration: duration,
                    style: currentLetterStyle!,
                    child: Text(
                      // style: currentLetterStyle,
                      letter,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
      }
    }

    return alphabetScroll;
  }

  // function to get current Selected alphabet
  int _getAlphabetIndexFromDy({double? dy, double? dx}) {
    if (widget.switchToHorizontal && dx == null) {
      throw Exception("AlphabetScroll was Horizontaly but got no dx!");
    } else if (!widget.switchToHorizontal && dy == null) {
      throw Exception("AlphabetScroll was Verticaly but got no dy!");
    }

    final alphabetContainer = _alphabetContainerKey.currentContext?.findRenderObject() as RenderBox;
    final alphabetContainerSize =
        widget.switchToHorizontal ? alphabetContainer.size.width : alphabetContainer.size.height;
    final oneItemSize = alphabetContainerSize / _alphabet.length;
    itemSize = oneItemSize;
    final index = widget.switchToHorizontal ? (dx! / oneItemSize).floor() : (dy! / oneItemSize).floor();
    if (index < 0) {
      return 0;
    } else if (index > _alphabet.length - 1) {
      return _alphabet.length - 1;
    }
    return index;
  }

  String _getLetterByAlphabetID(int alphabetID) {
    var alphabetValues = widget.reverse ? _alphabet.reversed.toList() : _alphabet;

    return alphabetValues.singleWhere((element) => alphabetValues.indexOf(element) == alphabetID);
  }

  void _onDragUpdate({double? dy, double? dx}) {
    var alphabetIndex = _getAlphabetIndexFromDy(dy: dy, dx: dx);

    if (_alphabetIndex != null && alphabetIndex == _alphabetIndex && dx == this.dx) {
      return;
    }

    setState(() {
      _alphabetIndex = alphabetIndex;
      this.dy = dy ?? dx!;
      if (dx != null) {
        this.dx = dx;
      }
    });

    widget.onLetterChange(_getLetterByAlphabetID(alphabetIndex));
  }
}
