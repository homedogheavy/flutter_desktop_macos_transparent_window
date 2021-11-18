import 'dart:async';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeStylePage extends StatefulWidget {
  const ChangeStylePage({Key? key}) : super(key: key);

  @override
  _ChangeStylePageState createState() => _ChangeStylePageState();
}

class _ChangeStylePageState extends State<ChangeStylePage> {
  Color _dialogPickerColor = Colors.red;
  bool _isClear = false;
  bool _hasShadow = true;
  bool _blur = false;

  String _selected = 'basic';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _resetWindowStyle() async {
    _isClear = false;
    _hasShadow = true;
    _blur = false;
    _dialogPickerColor = Colors.red;
    await _reset();
  }

  static const platform = MethodChannel('samples.flutter.dev/windowController');

  Future<void> _invokeMethod(String method, Map<String, dynamic> arg) async {
    await platform.invokeMethod<void>(method, arg);
  }

  Future<void> _setClear() async {
    await _invokeMethod('transparent', <String, dynamic>{
      'isClear': _isClear,
    });
  }

  Future<void> _setShadow() async {
    await _invokeMethod('hasShadow', <String, dynamic>{
      'hasShadow': _hasShadow,
    });
  }

  Future<void> _setBlur() async {
    await _invokeMethod('blur', <String, dynamic>{
      'blur': _blur,
    });
  }

  Future<void> _setBackground() async {
    await _invokeMethod('background', <String, dynamic>{
      'background': null,
      'red': 256 - _dialogPickerColor.red,
      'blue': 256 - _dialogPickerColor.blue,
      'green': 256 - _dialogPickerColor.green,
      'alpha': 256 - _dialogPickerColor.alpha,
    });
  }

  Future<void> _reset() async {
    await _invokeMethod('reset', <String, dynamic>{
      'reset': true,
    });
  }

  Widget switchContainer(
      {required String label,
      required bool value,
      required void Function(bool) fn}) {
    return SwitchListTile.adaptive(
      title: Text(label),
      value: value,
      onChanged: (bool e) => fn(e),
    );
  }

  void _onSelected(String? value) {
    setState(() {
      _selected = value ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,
        child: Scrollbar(
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 25),
              RadioListTile(
                title: const Text('Basic'),
                value: 'basic',
                groupValue: _selected,
                onChanged: _onSelected,
              ),
              _selected != 'basic'
                  ? const SizedBox()
                  : ElevatedButton(
                      child: const Text('reset window style'),
                      onPressed: () {
                        setState(() => {_resetWindowStyle()});
                      },
                    ),
              RadioListTile(
                title: const Text('hasShadow'),
                value: 'hasshadow',
                groupValue: _selected,
                onChanged: _onSelected,
              ),
              _selected != 'hasshadow'
                  ? const SizedBox()
                  : switchContainer(
                      label: 'hasShadow',
                      value: _hasShadow,
                      fn: (bool e) {
                        setState(() => {_hasShadow = e, _setShadow()});
                      }),
              RadioListTile(
                title: const Text('transparent'),
                value: 'transparent',
                groupValue: _selected,
                onChanged: _onSelected,
              ),
              _selected != 'transparent'
                  ? const SizedBox()
                  : switchContainer(
                      label: 'background color clear',
                      value: _isClear,
                      fn: (bool e) {
                        setState(() => {_isClear = e, _setClear()});
                      }),
              RadioListTile(
                title: const Text('blur'),
                value: 'blur',
                groupValue: _selected,
                onChanged: _onSelected,
              ),
              _selected != 'blur'
                  ? const SizedBox()
                  : switchContainer(
                      label: 'blur',
                      value: _blur,
                      fn: (bool e) {
                        setState(() => {_blur = e, _setBlur()});
                      }),
              RadioListTile(
                title: const Text('background color'),
                value: 'background',
                groupValue: _selected,
                onChanged: _onSelected,
              ),
              _selected != 'background'
                  ? const SizedBox()
                  : ColorPicker(
                      color: _dialogPickerColor,
                      onColorChanged: (Color color) => setState(
                          () => {_dialogPickerColor = color, _setBackground()}),
                      enableOpacity: true,
                      enableShadesSelection: false,
                      pickersEnabled: const <ColorPickerType, bool>{
                        ColorPickerType.both: false,
                        ColorPickerType.primary: false,
                        ColorPickerType.accent: false,
                        ColorPickerType.bw: false,
                        ColorPickerType.custom: false,
                        ColorPickerType.wheel: true,
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
