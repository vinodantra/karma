// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

import 'EscalationTheme.dart';
import 'EscalationWidgets.dart';
import 'EscalationTicketForm.dart';
import 'EscalationChooseType.dart';

/// Internal Escalation form — workflow / process / team issues.
class EscalationInternalForm extends StatefulWidget {
  const EscalationInternalForm({super.key});

  @override
  State<EscalationInternalForm> createState() => _EscalationInternalFormState();
}

class _EscalationInternalFormState extends State<EscalationInternalForm> {
  final _esc = Get.put(EscalationController());

  final _observationCtrl = TextEditingController();
  final _recommendationCtrl = TextEditingController();

  String? _observationError;

  @override
  void dispose() {
    _observationCtrl.dispose();
    _recommendationCtrl.dispose();
    super.dispose();
  }

  /// Picker for ID/NAME maps (Category from `Table1`, Improvement Area from
  /// `Table2` of the ESCALATIONMST response).
  Future<void> _pickMap(
    BuildContext context,
    String title,
    List<dynamic> options,
    String currentId,
    String key,
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
                        title: Text((o[key] ?? '').toString().trim(),
                            style: const TextStyle(fontSize: 13.5)),
                        trailing:
                            currentId == (o['ID'] ?? o['id'] ?? '').toString()
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

  /// Like [_pickMap] but with a search box — used by the User Name dropdown.
  Future<void> _pickSearchableMap(
    BuildContext context,
    String title,
    List<dynamic> options,
    String currentId,
    String key,
    ValueChanged<dynamic> onPicked,
  ) async {
    final picked = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _SearchableMapSheet(
        title: title,
        options: options,
        currentId: currentId,
        displayKey: key,
      ),
    );
    if (picked != null) onPicked(picked);
  }

  void _onSwitchType(String t) {
    if (t == 'Ticket') {
      Get.off(() => const EscalationTicketForm());
    }
  }

  void _save() async {
    final missing = <String>[];
    if (_esc.selectedCategoryId.value.isEmpty) missing.add('Category');
    if (_esc.selectedImprovementAreaId.value.isEmpty) {
      missing.add('Improvement Area');
    }
    if (_esc.selectedUserId.value.isEmpty) missing.add('User Name');

    setState(() {
      _observationError = _observationCtrl.text.trim().isEmpty
          ? 'User Observation is mandatory'
          : null;
    });
    if (_observationError != null) missing.add('User Observation');

    if (missing.isNotEmpty) {
      CustomWidgets.snackBar(
          title: 'Please fill required fields: ${missing.join(', ')}');
      return;
    }

    final ok = await _esc.saveInternalEscalation(
      background: '',
      observation: _observationCtrl.text,
      recommendation: _recommendationCtrl.text,
    );
    if (!ok) return;

    Get.off(() => const EscalationChooseType());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const EscHeader(title: 'Internal Escalation'),
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
                    EscTypePill(active: 'Internal', onChanged: _onSwitchType),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: EscColors.gradientSoft,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: EscColors.purple.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: EscColors.gradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.info_outline,
                                size: 16, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: EscColors.textSoft,
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Internal escalations',
                                    style: TextStyle(
                                      color: EscColors.text,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' stay within your organization. Use this for process, tooling, or team-level concerns.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    // const EscFieldDropdown(
                    //   label: 'Escalation Type',
                    //   value: 'Internal',
                    //   locked: true,
                    // ),
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
                            'NAME',
                            (v) => _esc.selectImprovementArea(v),
                          ),
                        )),
                    Obx(() => EscFieldDropdown(
                          label: 'Category',
                          value: _esc.selectedCategoryName.value,
                          placeholder: 'Select category',
                          required: true,
                          onTap: () => _pickMap(
                            context,
                            'Select Category',
                            _esc.internalCategoryList,
                            _esc.selectedCategoryId.value,
                            'internal_category',
                            (v) => _esc.selectCategory(v),
                          ),
                        )),
                    Obx(() {
                      // Subcategory is not applicable when Category is Account.
                      final cat =
                          _esc.selectedCategoryName.value.trim().toLowerCase();
                      if (cat != 'accounts') {
                        return const SizedBox.shrink();
                      }
                      return EscFieldDropdown(
                        label: 'Subcategory',
                        value: _esc.selectedSubcategoryName.value,
                        placeholder: _esc.selectedCategoryId.value.isEmpty
                            ? 'Select a category first'
                            : 'Select subcategory',
                        required: true,
                        onTap: () => _pickMap(
                          context,
                          'Select Subcategory',
                          _esc.subcategoryList,
                          _esc.selectedSubcategoryId.value,
                          'internal_SubCategory',
                          (v) => _esc.selectSubcategory(v),
                        ),
                      );
                    }),
                    Obx(() => EscFieldDropdown(
                          label: 'User Name',
                          value: _esc.selectedUserName.value,
                          placeholder: _esc.selectedCategoryId.value.isEmpty
                              ? 'Select a category'
                              : 'Select user',
                          required: true,
                          onTap: () => _pickSearchableMap(
                            context,
                            'Select User',
                            _esc.usersForSelectedCategory(),
                            _esc.selectedUserId.value,
                            'internal_username',
                            (v) => _esc.selectUser(v),
                          ),
                        )),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Divider(height: 1, color: EscColors.line),
                    ),
                    const SizedBox(height: 12),
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
                          onPressed: _esc.isSaving.value ? null : _save,
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

/// Searchable ID/NAME picker shown as a modal bottom sheet. Owns its own search
/// controller and returns the tapped row via `Navigator.pop(context, row)`.
class _SearchableMapSheet extends StatefulWidget {
  final String title;
  final List<dynamic> options;
  final String currentId;
  final String displayKey;

  const _SearchableMapSheet({
    required this.title,
    required this.options,
    required this.currentId,
    required this.displayKey,
  });

  @override
  State<_SearchableMapSheet> createState() => _SearchableMapSheetState();
}

class _SearchableMapSheetState extends State<_SearchableMapSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _name(dynamic o) => (o[widget.displayKey] ?? '').toString().trim();

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final list = q.isEmpty
        ? widget.options
        : widget.options
            .where((o) => _name(o).toLowerCase().contains(q))
            .toList();

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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: EscColors.text,
                    ),
                  ),
                ),
              ),
              SearchWidget(
                controller: _searchCtrl,
                hintText: 'Search user',
                onChanged: (v) => setState(() => _query = v ?? ''),
                onClose: () {
                  _searchCtrl.clear();
                  setState(() => _query = '');
                },
              ),
              const Divider(height: 1, color: EscColors.line),
              Expanded(
                child: list.isEmpty
                    ? const Center(
                        child: Text(
                          'No users found',
                          style: TextStyle(
                              fontSize: 13, color: EscColors.textSoft),
                        ),
                      )
                    : ListView.separated(
                        itemCount: list.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: EscColors.line),
                        itemBuilder: (_, i) {
                          final o = list[i];
                          final selected = widget.currentId ==
                              (o['ID'] ?? o['id'] ?? '').toString();
                          return ListTile(
                            title: Text(_name(o),
                                style: const TextStyle(fontSize: 13.5)),
                            trailing: selected
                                ? const Icon(Icons.check,
                                    color: EscColors.pink, size: 18)
                                : null,
                            onTap: () => Navigator.of(context).pop(o),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
