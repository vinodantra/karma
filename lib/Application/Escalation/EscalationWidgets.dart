// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:karma/Services/Apis.dart';
import 'package:karma/Widgets/CustomWidgets.dart';
import 'EscalationTheme.dart';

/// Gradient header used at the top of every Escalation screen.
class EscHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onBack;

  const EscHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 6,
        bottom: subtitle == null ? 18 : 22,
      ),
      decoration: const BoxDecoration(
        gradient: EscColors.gradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onBack ?? () => Navigator.of(context).maybePop(),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      showBack ? Icons.chevron_left : Icons.menu,
                      color: Colors.white,
                      size: showBack ? 24 : 22,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Dropdown-style read-only field tile used across the forms.
class EscFieldDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final String placeholder;
  final bool required;
  final bool locked;
  final String? error;
  final VoidCallback? onTap;

  const EscFieldDropdown({
    super.key,
    required this.label,
    this.value,
    this.placeholder = 'Select',
    this.required = false,
    this.locked = false,
    this.error,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = (value ?? '').isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: EscColors.textSoft,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (required)
                const Text(' *',
                    style: TextStyle(
                        fontSize: 11.5,
                        color: EscColors.pink,
                        fontWeight: FontWeight.w500)),
              if (locked) ...[
                const SizedBox(width: 4),
                const Icon(Icons.lock_outline,
                    size: 11, color: EscColors.textFaint),
              ],
            ],
          ),
          const SizedBox(height: 6),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: locked ? null : onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: locked ? EscColors.fieldLocked : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: error != null ? EscColors.danger : EscColors.line,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      hasValue ? value! : placeholder,
                      style: TextStyle(
                        fontSize: 14,
                        color: hasValue ? EscColors.text : EscColors.textFaint,
                        fontWeight:
                            hasValue ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (!locked)
                    const Icon(Icons.keyboard_arrow_down,
                        size: 18, color: EscColors.textSoft),
                ],
              ),
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.error_outline,
                    size: 12, color: EscColors.danger),
                const SizedBox(width: 5),
                Text(
                  error!,
                  style: const TextStyle(fontSize: 11, color: EscColors.danger),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Multi-line text field used for the long-form narrative inputs.
class EscFieldTextArea extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? placeholder;
  final bool required;
  final int rows;
  final int max;
  final String? error;
  final ValueChanged<String>? onChanged;

  const EscFieldTextArea({
    super.key,
    required this.label,
    required this.controller,
    this.placeholder,
    this.required = false,
    this.rows = 3,
    this.max = 500,
    this.error,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: EscColors.textSoft,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (required)
                const Text(' *',
                    style: TextStyle(
                        fontSize: 11.5,
                        color: EscColors.pink,
                        fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: error != null ? EscColors.danger : EscColors.line,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: TextField(
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              controller: controller,
              onChanged: onChanged,
              minLines: rows,
              maxLines: rows + 4,
              maxLength: max,
              style: const TextStyle(
                fontSize: 13.5,
                color: EscColors.text,
                height: 1.5,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                counterText: '',
                hintText: placeholder ?? '',
                hintStyle: const TextStyle(
                  fontSize: 13.5,
                  color: EscColors.textFaint,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                required ? 'Mandatory' : 'Optional',
                style:
                    const TextStyle(fontSize: 10.5, color: EscColors.textFaint),
              ),
              AnimatedBuilder(
                animation: controller,
                builder: (_, __) => Text(
                  '${controller.text.length} / $max',
                  style: const TextStyle(
                      fontSize: 10.5, color: EscColors.textFaint),
                ),
              ),
            ],
          ),
          if (error != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.error_outline,
                    size: 12, color: EscColors.danger),
                const SizedBox(width: 5),
                Text(
                  error!,
                  style: const TextStyle(fontSize: 11, color: EscColors.danger),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Pink→purple gradient button — primary CTA.
class EscGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const EscGradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            gradient: EscColors.gradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color(0x408B47C6),
                blurRadius: 18,
                offset: Offset(0, 8),
                spreadRadius: -6,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 16),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Outline / secondary CTA — same shape as the gradient button.
class EscOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const EscOutlineButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: EscColors.line, width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: EscColors.text,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Ticket / Internal segmented control used at the top of both forms.
class EscTypePill extends StatelessWidget {
  final String active;
  final ValueChanged<String> onChanged;
  const EscTypePill({
    super.key,
    required this.active,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EDFA),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          for (final t in const ['Ticket', 'Internal'])
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(t),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: active == t ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: active == t
                        ? const [
                            BoxShadow(
                              color: Color(0x268B47C6),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      t,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight:
                            active == t ? FontWeight.w600 : FontWeight.w500,
                        color:
                            active == t ? EscColors.pink : EscColors.textSoft,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// [EscFieldTextArea] plus an "Enhance Text" action that rewrites the field
/// contents via the ChatGPT API (`STD_ENG`). Keeps the pre-enhancement text so
/// the user can revert with "Previous Text". Owns its own busy/previous state.
class EscEnhanceableTextArea extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? placeholder;
  final bool required;
  final String? error;
  final ValueChanged<String>? onChanged;

  const EscEnhanceableTextArea({
    super.key,
    required this.label,
    required this.controller,
    this.placeholder,
    this.required = false,
    this.error,
    this.onChanged,
  });

  @override
  State<EscEnhanceableTextArea> createState() => _EscEnhanceableTextAreaState();
}

class _EscEnhanceableTextAreaState extends State<EscEnhanceableTextArea> {
  bool _busy = false;
  String _previous = '';

  Future<void> _enhance() async {
    final text = widget.controller.text.trim();
    if (text.isEmpty || _busy) return;
    setState(() => _busy = true);
    try {
      final apiResponse = await Apis.chatGptApi(message: text);
      final enhanced = apiResponse != null ? apiResponse['MSG'] : null;
      if (enhanced != null && enhanced.toString().trim().isNotEmpty) {
        _previous = text;
        widget.controller.text = enhanced.toString().trim();
        widget.onChanged?.call(widget.controller.text);
      } else {
        CustomWidgets.snackBar(title: 'Could not enhance text. Try again.');
      }
    } catch (e) {
      if (kDebugMode) print('enhance error: $e');
      CustomWidgets.snackBar(title: 'Could not enhance text. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _restorePrevious() {
    if (_previous.isEmpty) return;
    widget.controller.text = _previous;
    widget.onChanged?.call(widget.controller.text);
    setState(() => _previous = '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EscFieldTextArea(
          label: widget.label,
          controller: widget.controller,
          required: widget.required,
          placeholder: widget.placeholder,
          error: widget.error,
          onChanged: widget.onChanged,
        ),
        AnimatedBuilder(
          animation: widget.controller,
          builder: (_, __) {
            final hasText = widget.controller.text.trim().isNotEmpty;
            if (!hasText) return const SizedBox.shrink();
            final hasPrevious = _previous.isNotEmpty;
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Row(
                mainAxisAlignment: hasPrevious
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.end,
                children: [
                  if (hasPrevious)
                    _EscEnhanceButton(
                      label: 'Previous Text',
                      outlined: true,
                      onTap: _busy ? null : _restorePrevious,
                    ),
                  _EscEnhanceButton(
                    label: _busy ? 'Enhancing…' : 'Enhance Text',
                    outlined: false,
                    onTap: _busy ? null : _enhance,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Compact pill button used by [EscEnhanceableTextArea].
class _EscEnhanceButton extends StatelessWidget {
  final String label;
  final bool outlined;
  final VoidCallback? onTap;

  const _EscEnhanceButton({
    required this.label,
    required this.outlined,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            gradient: outlined ? null : EscColors.gradient,
            color: outlined ? Colors.white : null,
            borderRadius: BorderRadius.circular(24),
            border:
                outlined ? Border.all(color: EscColors.line, width: 1.5) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                outlined ? Icons.undo : Icons.auto_awesome,
                size: 14,
                color: outlined ? EscColors.textSoft : Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: outlined ? EscColors.text : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
