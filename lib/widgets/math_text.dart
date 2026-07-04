import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../app_theme.dart';

class MathText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const MathText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final parts = _parse(text);
    if (parts.length == 1 && parts.first.isMath == false) {
      return Text(parts.first.value, style: style ?? AppTextStyles.serifStyle());
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: parts.map((p) {
        if (!p.isMath) {
          return Text(p.value, style: style ?? AppTextStyles.serifStyle());
        }
        final mathStr = p.value
            .replaceAll(r'$$', '')
            .replaceAll(r'\[', '')
            .replaceAll(r'\]', '')
            .replaceAll(r'$', '')
            .replaceAll(r'\(', '')
            .replaceAll(r'\)', '');
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Math.tex(
            mathStr,
            mathStyle: p.isDisplay ? MathStyle.display : MathStyle.text,
            textStyle: style ?? AppTextStyles.serifStyle(),
            onErrorFallback: (e) => Text(p.value, style: style ?? AppTextStyles.serifStyle()),
          ),
        );
      }).toList(),
    );
  }

  static final Map<String, List<_Part>> _parseCache = {};

  static List<_Part> _parse(String s) {
    if (_parseCache.containsKey(s)) {
      return _parseCache[s]!;
    }
    final parts = <_Part>[];
    // Regex patterns: $$...$$, \[...\], $...$, \(...\)
    final re = RegExp(
      r'(\$\$[\s\S]+?\$\$|\\\[[\s\S]+?\\\]|\$[^$\n]+?\$|\\\([^)]+?\\\))',
    );
    int last = 0;
    for (final m in re.allMatches(s)) {
      if (m.start > last) {
        parts.add(_Part(s.substring(last, m.start), false, false));
      }
      final val = m.group(0)!;
      final isDisplay = val.startsWith(r'$$') || val.startsWith(r'\[');
      parts.add(_Part(val, true, isDisplay));
      last = m.end;
    }
    if (last < s.length) {
      parts.add(_Part(s.substring(last), false, false));
    }
    final result = parts.isEmpty ? [_Part(s, false, false)] : parts;
    if (_parseCache.length > 1000) {
      _parseCache.clear();
    }
    _parseCache[s] = result;
    return result;
  }
}

class _Part {
  final String value;
  final bool isMath;
  final bool isDisplay;
  const _Part(this.value, this.isMath, this.isDisplay);
}
