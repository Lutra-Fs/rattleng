/// A numerical text input field.
//
// Time-stamp: <Sunday 2024-07-21 21:01:29 +1000 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Zheyuan Xu

library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/providers/tree_algorithm.dart';

class NumberField extends ConsumerStatefulWidget {
  final String label;
  final TextEditingController controller;
  final StateProvider stateProvider;
  final String tooltip;
  final bool enabled;
  final String? Function(String?) validator;
  final TextInputFormatter inputFormatter;
  final int maxWidth;
  final num interval;
  final int decimalPlaces;

  const NumberField({
    super.key,
    this.label = '',
    required this.controller,
    required this.stateProvider,
    this.tooltip = '',
    required this.enabled,
    required this.validator,
    required this.inputFormatter,
    this.maxWidth = 5,
    this.decimalPlaces = 0,
    this.interval = 1, // Default interval is 1, can be set as double or int
  });

  @override
  NumberFieldState createState() => NumberFieldState();
}

class NumberFieldState extends ConsumerState<NumberField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.text =
        ref.read(widget.stateProvider.notifier).state.toString();
  }

  void increment() {
    // Parse the current value, increment by interval, and update the text field.
    num currentValue = num.tryParse(widget.controller.text) ?? 0;
    currentValue += widget.interval;
    widget.controller.text = currentValue.toStringAsFixed(widget.decimalPlaces);
    updateField();
  }

  void decrement() {
    // Parse the current value, decrement by interval, and update the text field.
    num currentValue = num.tryParse(widget.controller.text) ?? 0;
    if (currentValue > widget.interval) {
      currentValue -= widget.interval;
    }
    widget.controller.text = currentValue.toStringAsFixed(widget.decimalPlaces);
    updateField();
  }

  // Timer for continuous incrementing/decrementing.
  Timer? timer;

  void startIncrementing() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      increment();
    });
  }

  void stopIncrementing() {
    timer?.cancel();
  }

  void startDecrementing() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      decrement();
    });
  }

  void stopDecrementing() {
    timer?.cancel();
  }

  // update the provider and the interval in the gui.
  void updateField() {
    String updatedText = widget.controller.text;

    num? v = num.tryParse(updatedText);
    if (v == null) {
      ref.read(widget.stateProvider.notifier).state = updatedText;
    } else {
      ref.read(widget.stateProvider.notifier).state = v;
    }

    debugPrint(
      'Interval updated to ${ref.read(widget.stateProvider.notifier).state}.',
    );
  }

  void _onFocusChange() {
    // triggered after losing focus.
    if (!_focusNode.hasFocus) {
      updateField();
    }
  }

  // Define a text style for normal fields.

  TextStyle normalTextStyle = const TextStyle(fontSize: 14.0);

  // Define a text style for disabled fields.

  TextStyle disabledTextStyle = const TextStyle(
    fontSize: 14.0,
    color: Colors.grey, // Grey out the text
  );

  @override
  Widget build(BuildContext context) {
    AlgorithmType treeAlgorithm = ref.watch(treeAlgorithmProvider);

    return Expanded(
      child: Tooltip(
        message: widget.tooltip,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.label.isEmpty
                ? Container()
                : Text(widget.label, style: normalTextStyle),
            SizedBox(
              width: widget.maxWidth * 30.0,
              child: Stack(
                children: [
                  TextFormField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.only(
                        right: 40,
                        left: 10,
                      ),
                      errorText: widget.validator(widget.controller.text),
                      errorStyle: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onEditingComplete: () {
                      // triggered after user clicks enter.
                      updateField();
                    },
                    style: treeAlgorithm == AlgorithmType.traditional
                        ? normalTextStyle
                        : disabledTextStyle,
                    enabled: widget.enabled,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      widget.inputFormatter,
                    ],
                  ),
                  // Positioned Arrow Buttons.
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: widget.enabled ? increment : null,
                          onLongPressStart: widget.enabled
                              ? (details) => startIncrementing()
                              : null,
                          onLongPressEnd: widget.enabled
                              ? (details) => stopIncrementing()
                              : null,
                          child: const Icon(Icons.arrow_drop_up),
                        ),
                        GestureDetector(
                          onTap: widget.enabled ? decrement : null,
                          onLongPressStart: widget.enabled
                              ? (details) => startDecrementing()
                              : null,
                          onLongPressEnd: widget.enabled
                              ? (details) => stopDecrementing()
                              : null,
                          child: const Icon(Icons.arrow_drop_down),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Validation logic for integer fields.

String? validateInteger(String? value, {required int min}) {
  if (value == null || value.isEmpty) return 'Cannot be empty';
  int? intValue = int.tryParse(value);
  if (intValue == null || intValue < min) {
    return 'Must >= $min';
  }
  return null;
}
