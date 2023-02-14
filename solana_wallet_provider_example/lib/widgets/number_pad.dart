/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../widgets/secondary_button.dart';


/// Number Pad
/// ------------------------------------------------------------------------------------------------

class NumberPad extends StatefulWidget {
  
  /// Basic number pad.
  const NumberPad({
    super.key,
    this.onChanged,
    this.enabled = true,
  });

  final bool enabled;

  final void Function(String value)? onChanged;

  @override
  State<NumberPad> createState() => _NumberPadState();
}


/// Number Pad State
/// ------------------------------------------------------------------------------------------------

class _NumberPadState extends State<NumberPad> {
  
  String _value = '0';

  final double _spacing = 24.0;

  void _setValue(final String value) {
    _value = value;
    widget.onChanged?.call(value);
  }

  Widget _key(final VoidCallback onPressed, final Object label) {
    return Expanded(
      child: SecondaryButton(
        enabled: widget.enabled,
        onPressed: onPressed, 
        child: Text('$label'),
      ),
    );
  }

  Widget _numberKey(final int number) {
    return _key(
      () {
        if (number == 0 && _value == "0") return;
        _setValue((_value == "0" ? "" : _value) + number.toString());
      },
      number,
    );
  }

  Widget _periodKey() {
    return _key(
      () {
        if (!_value.contains('.')) {
          _setValue('$_value.');
        }
      }, 
      '.',
    );
  }

  Widget _deleteKey() {
    return _key(
      () {
        if (_value.isNotEmpty) {
          _setValue(_value.length == 1 ? '0' : _value.substring(0, _value.length - 1));
        }
      }, 
      '<',
    );
  }

  Widget _buttonRow(final Widget button0, final Widget button1, final Widget button2) {
    return Row(
      children: [
        button0,
        SizedBox(width: _spacing,),
        button1,
        SizedBox(width: _spacing,),
        button2,
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        _buttonRow(_numberKey(1), _numberKey(2), _numberKey(3)),
        SizedBox(height: _spacing,),
        _buttonRow(_numberKey(4), _numberKey(5), _numberKey(6)),
        SizedBox(height: _spacing,),
        _buttonRow(_numberKey(7), _numberKey(8), _numberKey(9)),
        SizedBox(height: _spacing,),
        _buttonRow(_periodKey(), _numberKey(0), _deleteKey()),
      ],
    );
  }
}