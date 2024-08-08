library ai_typing;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// A widget that simulates typing text, revealing one character at a time.
class AiTypingText extends StatefulWidget {
  /// Creates an [AiTypingText] widget.
  ///
  /// The [textWidget] parameter specifies the text to be displayed.
  /// The [interval] parameter sets the duration between each character display.
  /// The [delay] parameter sets the initial delay before typing starts.
  /// The [maxFluctuation] parameter introduces a random fluctuation to the interval.
  const AiTypingText(
    this.textWidget, {
    super.key,
    this.interval = const Duration(milliseconds: 100),
    this.delay = Duration.zero,
    this.maxFluctuation = const Duration(milliseconds: 100),
    this.enabled = true,
  });

  /// The text widget to display.
  final Text textWidget;

  /// The interval between displaying each character.
  final Duration interval;

  /// The initial delay before typing starts.
  final Duration delay;

  /// The maximum fluctuation to apply to the interval.
  final Duration maxFluctuation;

  /// Whether the typing effect is enabled.
  final bool enabled;

  @override
  State<AiTypingText> createState() => _AiTypingState();
}

class _AiTypingState extends State<AiTypingText> {
  String _fullText = '';
  String _displayedText = '';
  int _currentIndex = 0;
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _fullText = widget.textWidget.data ?? '';

    if (!widget.enabled) {
      return;
    }

    Future.delayed(widget.delay).then((_) {
      _startTyping();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Starts the typing effect by periodically revealing one character at a time.
  void _startTyping() {
    final maxFluctuation = widget.maxFluctuation;

    _timer = Timer.periodic(widget.interval, (timer) async {
      // Introduce a random delay to the interval for a more natural typing effect.
      final randomDelay = _random.nextInt(maxFluctuation.inMilliseconds + 1);
      await Future.delayed(Duration(milliseconds: randomDelay));
      if (_currentIndex < _fullText.length) {
        setState(() {
          _displayedText += _fullText[_currentIndex];
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.enabled ? _displayedText : _fullText,
      style: widget.textWidget.style,
      strutStyle: widget.textWidget.strutStyle,
      textAlign: widget.textWidget.textAlign,
      textDirection: widget.textWidget.textDirection,
      locale: widget.textWidget.locale,
      softWrap: widget.textWidget.softWrap,
      overflow: widget.textWidget.overflow,
      textScaler: widget.textWidget.textScaler,
      maxLines: widget.textWidget.maxLines,
      semanticsLabel: widget.textWidget.semanticsLabel,
      textWidthBasis: widget.textWidget.textWidthBasis,
      textHeightBehavior: widget.textWidget.textHeightBehavior,
      selectionColor: widget.textWidget.selectionColor,
    );
  }
}
