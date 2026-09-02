// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

import 'EscalationTheme.dart';
import 'EscalationWidgets.dart';
import 'EscalationInternalForm.dart';
import 'EscalationChooseType.dart';

/// Ticket Escalation form — Step 2 of 3 in the design.
/// Locked fields (Escalation Type, Executive Name) come from the logged-in
/// session; the rest are picker-driven or free-text.
///
/// When opened from Ticket Details, [presetDpId], [presetCustomerName] and
/// [presetTicketNo] are supplied — the Customer Name and Ticket No fields are
/// then locked to those values instead of being pickers.
class EscalationTicketForm extends StatefulWidget {
  final String? presetDpId;
  final String? presetCustomerName;
  final String? presetTicketNo;

  /// Ticket date (dd/MM/yyyy) from the source row. When the ticket is older
  /// than 2 calendar months the Ticket No is hidden and escalation is blocked.
  final String? presetTicketDate;

  const EscalationTicketForm({
    super.key,
    this.presetDpId,
    this.presetCustomerName,
    this.presetTicketNo,
    this.presetTicketDate,
  });

  @override
  State<EscalationTicketForm> createState() => _EscalationTicketFormState();
}

class _EscalationTicketFormState extends State<EscalationTicketForm> {
  final _esc = Get.put(EscalationController());

  final _customerNameCtrl = TextEditingController();

  final _backgroundCtrl = TextEditingController();
  final _observationCtrl = TextEditingController();
  final _recommendationCtrl = TextEditingController();

  String? _backgroundError;
  String? _observationError;

  bool get _isPreset => (widget.presetDpId ?? '').isNotEmpty;

  /// True when the preset ticket is older than 2 calendar months.
  bool _isTicketOld = false;

  @override
  void initState() {
    super.initState();
    if (_isPreset) {
      _isTicketOld =
          _computeTicketOld(widget.presetTicketDate, widget.presetTicketNo);
      // Seed the customer/ticket from the Ticket Details row and lock them.
      _esc.selectedCustomerId.value = widget.presetDpId!;
      _esc.selectedCustomerName.value =
          (widget.presetCustomerName ?? '').trim();
      _esc.selectedTicketNo.value = (widget.presetTicketNo ?? '').trim();
      _customerNameCtrl.text = (widget.presetCustomerName ?? '').trim();
      // Clear any category/area carried over from a previous escalation.
      _esc.selectedCategoryId.value = '';
      _esc.selectedCategoryName.value = '';
      _esc.selectedImprovementAreaId.value = '';
      _esc.selectedImprovementAreaName.value = '';
      // Fetch UID (exeid) for this dpid without overwriting the ticket number.
      _esc.getTicketInfo(widget.presetDpId!, updateTicket: false);
    }
  }

  static const _months = {
    'JAN': 1,
    'FEB': 2,
    'MAR': 3,
    'APR': 4,
    'MAY': 5,
    'JUN': 6,
    'JUL': 7,
    'AUG': 8,
    'SEP': 9,
    'OCT': 10,
    'NOV': 11,
    'DEC': 12,
  };

  /// Returns true when the ticket is more than 2 calendar months old. The date
  /// is taken from [date] (dd/MM/yyyy) if valid, otherwise derived from the
  /// date embedded in [ticketNo] (e.g. AWT-21JUL2026-0201 → 21 Jul 2026).
  bool _computeTicketOld(String? date, String? ticketNo) {
    final ticketDate = _parseSlashDate(date) ?? _parseTicketNoDate(ticketNo);
    if (ticketDate == null) return false;
    final now = DateTime.now();
    final cutoff = DateTime(now.year, now.month - 2, now.day);
    return ticketDate.isBefore(cutoff);
  }

  DateTime? _parseSlashDate(String? date) {
    final parts = (date ?? '').trim().split('/');
    if (parts.length != 3) return null;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return null;
    return DateTime(y, m, d);
  }

  DateTime? _parseTicketNoDate(String? ticketNo) {
    final match = RegExp(r'(\d{2})([A-Za-z]{3})(\d{4})')
        .firstMatch((ticketNo ?? '').toUpperCase());
    if (match == null) return null;
    final d = int.tryParse(match.group(1)!);
    final mon = _months[match.group(2)!];
    final y = int.tryParse(match.group(3)!);
    if (d == null || mon == null || y == null) return null;
    return DateTime(y, mon, d);
  }

  @override
  void dispose() {
    _customerNameCtrl.dispose();
    _backgroundCtrl.dispose();
    _observationCtrl.dispose();
    _recommendationCtrl.dispose();
    super.dispose();
  }

  /// Picker for ID/NAME maps (e.g. the Category master from `Table1`).
  Future<void> _pickMap(
    BuildContext context,
    String title,
    List<dynamic> options,
    String currentId,
    ValueChanged<dynamic> onPicked,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: EscColors.text,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, color: EscColors.line),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: options.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: EscColors.line),
                    itemBuilder: (_, i) {
                      final o = options[i];
                      return ListTile(
                        title: Text((o['NAME'] ?? '').toString().trim(),
                            style: const TextStyle(fontSize: 13.5)),
                        trailing: currentId == (o['ID'] ?? '').toString()
                            ? const Icon(Icons.check,
                                color: EscColors.pink, size: 18)
                            : null,
                        onTap: () {
                          Navigator.of(ctx).pop();
                          onPicked(o);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Ticket picker shown when the selected customer has multiple open tickets.
  Future<void> _pickTicket(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select Ticket',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: EscColors.text,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, color: EscColors.line),
                Flexible(
                  child: Obx(() {
                    final list = _esc.ticketList;
                    return ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 8),
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: EscColors.line),
                      itemBuilder: (_, i) {
                        final o = list[i];
                        final ticket = (o['TICKET'] ?? '').toString().trim();
                        return ListTile(
                          title: Text(ticket,
                              style: const TextStyle(fontSize: 13.5)),
                          trailing: _esc.selectedTicketNo.value == ticket
                              ? const Icon(Icons.check,
                                  color: EscColors.pink, size: 18)
                              : null,
                          onTap: () {
                            Navigator.of(ctx).pop();
                            _esc.selectTicket(o);
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickCustomer(BuildContext context) async {
    final picked = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _CustomerPickerSheet(controller: _esc),
    );
    if (picked != null) {
      _esc.selectCustomer(picked);
      setState(() =>
          _customerNameCtrl.text = (picked['NAME'] ?? '').toString().trim());
    }
  }

  void _onSwitchType(String t) {
    if (t == 'Internal') {
      Get.off(() => const EscalationInternalForm());
    }
  }

  void _save() async {
    if (_isTicketOld) {
      CustomWidgets.snackBar(
          title: 'This ticket is older than 2 months and cannot be escalated.');
      return;
    }

    final missing = <String>[];
    if (_esc.selectedCustomerId.value.isEmpty) missing.add('Customer Name');
    if (_esc.selectedTicketNo.value.isEmpty) missing.add('Customer Ticket No');
    if (_esc.selectedCategoryId.value.isEmpty) missing.add('Category');
    if (_esc.selectedImprovementAreaId.value.isEmpty) {
      missing.add('Improvement Area');
    }

    setState(() {
      _backgroundError = _backgroundCtrl.text.trim().isEmpty
          ? 'Customer Background is mandatory'
          : null;
      _observationError = _observationCtrl.text.trim().isEmpty
          ? 'User Observation is mandatory'
          : null;
    });
    if (_backgroundError != null) missing.add('Customer Background');
    if (_observationError != null) missing.add('User Observation');

    if (missing.isNotEmpty) {
      CustomWidgets.snackBar(
          title: 'Please fill required fields: ${missing.join(', ')}');
      return;
    }

    final ok = await _esc.saveEscalation(
      background: _backgroundCtrl.text,
      observation: _observationCtrl.text,
      recommendation: _recommendationCtrl.text,
    );
    if (!ok || !mounted) return;

    if (_isPreset) {
      // Opened from a ticket details screen (List → Details → this form).
      // Pop back to the list that's already in the stack instead of
      // recreating it (recreating a live GetView page crashes with a disposed
      // controller during the transition).
      var popped = 0;
      Navigator.of(context).popUntil((_) => popped++ >= 2);
    } else {
      Get.off(() => const EscalationChooseType());
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValidationBanner =
        _backgroundError != null || _observationError != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const EscHeader(title: 'Ticket Escalation'),
          Expanded(
            child: Obx(() {
              if (_esc.isLoading.value) {
                return const LoadingScreen();
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_isPreset) ...[
                      EscTypePill(active: 'Ticket', onChanged: _onSwitchType),
                      const SizedBox(height: 22),
                    ],
                    if (hasValidationBanner) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: EscColors.dangerSoft,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: EscColors.dangerBorder),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 20, color: EscColors.danger),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${[
                                      _backgroundError,
                                      _observationError
                                    ].whereType<String>().length} fields need attention',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: EscColors.danger,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Customer Background and User Observation are mandatory.',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: EscColors.textSoft,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                    ],
                    // const EscFieldDropdown(
                    //   label: 'Escalation Type',
                    //   value: 'Ticket',
                    //   locked: true,
                    // ),
                    EscFieldDropdown(
                      label: 'Customer Name',
                      value: _customerNameCtrl.text,
                      placeholder: 'Select customer',
                      required: true,
                      locked: _isPreset,
                      onTap: _isPreset ? null : () => _pickCustomer(context),
                    ),
                    if (_isTicketOld)
                      Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: EscColors.dangerSoft,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: EscColors.dangerBorder),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline,
                                size: 20, color: EscColors.danger),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'This ticket is older than 2 months, so it '
                                'cannot be escalated.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: EscColors.danger,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Obx(() {
                        // Multiple tickets → let the user pick (non-preset only).
                        final multiple =
                            !_isPreset && _esc.ticketList.length > 1;
                        return EscFieldDropdown(
                          label: 'Customer Ticket No',
                          value: _esc.isTicketLoading.value
                              ? 'Loading…'
                              : _esc.selectedTicketNo.value,
                          placeholder: multiple
                              ? 'Select ticket'
                              : 'Select a customer first',
                          required: true,
                          locked: !multiple,
                          onTap: multiple ? () => _pickTicket(context) : null,
                        );
                      }),
                    Obx(() => EscFieldDropdown(
                          label: 'Category',
                          value: _esc.selectedCategoryName.value,
                          placeholder: 'Select category',
                          required: true,
                          onTap: () => _pickMap(
                            context,
                            'Select Category',
                            _esc.categoryList,
                            _esc.selectedCategoryId.value,
                            (v) => _esc.selectCategory(v),
                          ),
                        )),
                    Obx(() => EscFieldDropdown(
                          label: 'Improvement Area',
                          value: _esc.selectedImprovementAreaName.value,
                          placeholder: 'Select area',
                          required: true,
                          onTap: () => _pickMap(
                            context,
                            'Select Improvement Area',
                            _esc.improvementAreaList,
                            _esc.selectedImprovementAreaId.value,
                            (v) => _esc.selectImprovementArea(v),
                          ),
                        )),
                    // const EscFieldDropdown(
                    //   label: 'Executive Name',
                    //   value: 'Neha Sharma',
                    //   locked: true,
                    // ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Divider(height: 1, color: EscColors.line),
                    ),
                    const SizedBox(height: 12),
                    EscEnhanceableTextArea(
                      label: 'Customer Background',
                      controller: _backgroundCtrl,
                      required: true,
                      placeholder: 'What is the customer context?',
                      error: _backgroundError,
                      onChanged: (_) {
                        if (_backgroundError != null) {
                          setState(() => _backgroundError = null);
                        }
                      },
                    ),
                    EscEnhanceableTextArea(
                      label: 'User Observation',
                      controller: _observationCtrl,
                      required: true,
                      placeholder: 'What have you observed?',
                      error: _observationError,
                      onChanged: (_) {
                        if (_observationError != null) {
                          setState(() => _observationError = null);
                        }
                      },
                    ),
                    EscEnhanceableTextArea(
                      label: 'Recommendation',
                      controller: _recommendationCtrl,
                      placeholder: 'Optional — what should we do next?',
                    ),
                    const SizedBox(height: 8),
                    Obx(() => CustomButton(
                          width: double.infinity,
                          text: _esc.isSaving.value ? 'Saving…' : 'Save',
                          onPressed: (_esc.isSaving.value || _isTicketOld)
                              ? null
                              : _save,
                        )),

                    // const SizedBox(height: 10),
                    // const EscOutlineButton(label: 'Save as Draft'),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Searchable customer picker shown as a modal bottom sheet.
///
/// Owns its own search controller lifecycle and returns the tapped customer
/// map via `Navigator.pop(context, customer)` — the caller applies the
/// selection only after the sheet has fully closed.
class _CustomerPickerSheet extends StatefulWidget {
  final EscalationController controller;
  const _CustomerPickerSheet({required this.controller});

  @override
  State<_CustomerPickerSheet> createState() => _CustomerPickerSheetState();
}

class _CustomerPickerSheetState extends State<_CustomerPickerSheet> {
  final _searchCtrl = TextEditingController();

  EscalationController get _esc => widget.controller;

  @override
  void initState() {
    super.initState();
    _esc.searchCustomer('');
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Customer',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: EscColors.text,
                    ),
                  ),
                ),
              ),
              SearchWidget(
                controller: _searchCtrl,
                hintText: 'Search customer',
                onChanged: (v) => _esc.searchCustomer(v ?? ''),
                onClose: () {
                  _searchCtrl.clear();
                  _esc.searchCustomer('');
                },
              ),
              const Divider(height: 1, color: EscColors.line),
              Expanded(
                child: Obx(() {
                  if (_esc.isLoading.value && _esc.customerList.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: EscColors.pink),
                    );
                  }
                  final list = _esc.filteredCustomers;
                  if (list.isEmpty) {
                    return const Center(
                      child: Text(
                        'No customers found',
                        style:
                            TextStyle(fontSize: 13, color: EscColors.textSoft),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: EscColors.line),
                    itemBuilder: (_, i) {
                      final c = list[i];
                      final name = (c['NAME'] ?? '').toString().trim();
                      final selected = _esc.selectedCustomerId.value ==
                          (c['ID'] ?? '').toString();
                      return ListTile(
                        title:
                            Text(name, style: const TextStyle(fontSize: 13.5)),
                        trailing: selected
                            ? const Icon(Icons.check,
                                color: EscColors.pink, size: 18)
                            : null,
                        onTap: () => Navigator.of(context).pop(c),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
