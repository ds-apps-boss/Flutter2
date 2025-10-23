import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsSheet extends StatefulWidget {
  final Duration initial;
  final ValueChanged<Duration> onSave;

  const SettingsSheet({super.key, required this.initial, required this.onSave});
  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  int _m = 0, _s = 0, _c = 0;

  @override
  void initState() {
    super.initState();

    final d = widget.initial;
    _m = d.inMinutes.remainder(100);
    _s = d.inSeconds.remainder(60);
    _c = (d.inMilliseconds.remainder(1000) ~/ 10);
  }

  void _onChanged(int m, int s, int c) {
    setState(() {
      _m = m;
      _s = s;
      _c = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    final initM = widget.initial.inMinutes.remainder(100);
    final initS = widget.initial.inSeconds.remainder(60);
    final initC = (widget.initial.inMilliseconds.remainder(1000) ~/ 10);
    final d = Duration(minutes: _m, seconds: _s, milliseconds: _c * 10);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(
              'Timer settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            TimerInputsRow(
              initialMinutes: initM,
              initialSeconds: initS,
              initialCentis: initC,
              onChanged: _onChanged,
            ),

            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 125, 130, 104),
              ),
              onPressed: () {
                widget.onSave(d);
                Navigator.pop(context);
              },

              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                child: const Text('Save'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

//-----------
//-----------
//-----------
//-----------

class TimerInputsRow extends StatefulWidget {
  const TimerInputsRow({
    super.key,
    required this.onChanged,
    this.initialMinutes = 0,
    this.initialSeconds = 0,
    this.initialCentis = 0,
  });

  final void Function(int minutes, int seconds, int centis) onChanged;
  final int initialMinutes;
  final int initialSeconds;
  final int initialCentis;

  @override
  State<TimerInputsRow> createState() => _TimerInputsRowState();
}

class _TimerInputsRowState extends State<TimerInputsRow> {
  late final TextEditingController _mCtl;
  late final TextEditingController _sCtl;
  late final TextEditingController _cCtl;

  @override
  void initState() {
    super.initState();
    _mCtl = TextEditingController(
      text: widget.initialMinutes.toString().padLeft(2, '0'),
    );
    _sCtl = TextEditingController(
      text: widget.initialSeconds.toString().padLeft(2, '0'),
    );
    _cCtl = TextEditingController(
      text: widget.initialCentis.toString().padLeft(2, '0'),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _emit());
  }

  @override
  void dispose() {
    _mCtl.dispose();
    _sCtl.dispose();
    _cCtl.dispose();
    super.dispose();
  }

  int _parse(String v, int max) {
    final n = int.tryParse(v) ?? 0;
    return n.clamp(0, max);
  }

  void _emit() {
    widget.onChanged(
      _parse(_mCtl.text, 99),
      _parse(_sCtl.text, 59),
      _parse(_cCtl.text, 99),
    );
  }

  Widget _numBox(TextEditingController ctl, String label, int max) {
    return SizedBox(
      width: 70,
      child: TextField(
        controller: ctl,
        maxLength: 2,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: label,
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 125, 130, 104),
            ),
          ),
          isDense: true,
        ),
        onChanged: (_) => _emit(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _numBox(_mCtl, 'MM', 99),
        const SizedBox(width: 12),
        _numBox(_sCtl, 'SS', 59),
        const SizedBox(width: 12),
        _numBox(_cCtl, 'CC', 99),
      ],
    );
  }
}
