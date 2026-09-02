// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karma/Application/Utilities/Utilities.dart';
import 'package:karma/Constants/dataInfo.dart';
import 'package:karma/Services/Apis.dart';
import 'package:karma/Widgets/Loader.dart';

class AGHSession {
  final String userId;
  final String name;
  final int age;
  final String role;
  final String next;
  final String last;
  final AGHMemberStatus status;
  final DateTime? expireDate;

  const AGHSession({
    this.userId = '',
    required this.name,
    required this.age,
    this.role = 'Antrapreneur',
    required this.next,
    required this.last,
    required this.status,
    this.expireDate,
  });
}

class AGHTopic {
  final int id;
  final String name;

  const AGHTopic({required this.id, required this.name});

  String get display {
    if (name.isEmpty) return '';
    return name
        .split('_')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}

class AGHCompletedSession {
  final String name;
  final String date;
  final String duration;
  final String mode;
  final String captainRemark;
  final String memberRemark;
  final String captainRemarkAt;
  final String memberRemarkAt;
  final String notes;
  final String topicName;
  final String captainStart;
  final String captainEnd;
  final String userStart;
  final String userEnd;

  const AGHCompletedSession({
    required this.name,
    required this.date,
    required this.duration,
    required this.mode,
    this.captainRemark = '',
    this.memberRemark = '',
    this.captainRemarkAt = '',
    this.memberRemarkAt = '',
    this.notes = '',
    this.topicName = '',
    this.captainStart = '',
    this.captainEnd = '',
    this.userStart = '',
    this.userEnd = '',
  });
}

class AGHScheduledSession {
  final String userId;
  final String meetingId;
  final String topicName;
  final String name;
  final String captainName;
  final String date;
  final String time;
  final String mode;
  final String startsIn;
  final bool joinable;
  final DateTime? scheduledAt;
  final String captainRemark;
  final String memberRemark;
  final String captainRemarkAt;
  final String memberRemarkAt;
  final String notes;
  final String captainStart;
  final String captainEnd;
  final String userStart;
  final String userEnd;
  final DateTime? expireDate;

  const AGHScheduledSession({
    this.userId = '',
    this.meetingId = '',
    this.topicName = '',
    required this.name,
    this.captainName = '',
    required this.date,
    required this.time,
    required this.mode,
    required this.startsIn,
    this.joinable = false,
    this.scheduledAt,
    this.captainRemark = '',
    this.memberRemark = '',
    this.captainRemarkAt = '',
    this.memberRemarkAt = '',
    this.notes = '',
    this.captainStart = '',
    this.captainEnd = '',
    this.userStart = '',
    this.userEnd = '',
    this.expireDate,
  });
}

class AGHNotification {
  final String title;
  final String message;
  final String time;
  final AGHNotificationKind kind;
  final bool read;

  const AGHNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.kind,
    required this.read,
  });
}

enum AGHMemberStatus { due, missed, upcoming, pending }

enum AGHNotificationKind { pink, warn, success, purple }

/// Controller for the AGH module — keeps tab state, filters, and mock data
/// so screens stay stateless.
class AGHController extends GetxController {
  final RxString activeTab = 'Upcoming'.obs;
  final RxString upcomingFilter = 'All'.obs;
  final RxString upcomingUser = ''.obs;
  final Rxn<DateTimeRange> upcomingDateRange = Rxn<DateTimeRange>();
  final RxString upcomingDatePreset = ''.obs;
  final RxString completedFilter = 'By member'.obs;
  final RxString completedUser = ''.obs;
  final Rxn<DateTimeRange> completedDateRange = Rxn<DateTimeRange>();
  final RxString completedDatePreset = ''.obs;
  final RxString notificationFilter = 'All'.obs;

  final RxList<AGHTopic> topics = <AGHTopic>[].obs;
  final RxList<AGHTopic> selectedTopicList = <AGHTopic>[].obs;
  final RxString otherTopicRemark = ''.obs;
  final RxBool isLoadingTopics = false.obs;
  final RxBool isSchedulingSession = false.obs;

  /// Display labels of currently selected topics (in selection order).
  List<String> get selectedTopics =>
      selectedTopicList.map((t) => t.display).toList();

  bool isTopicSelected(AGHTopic t) =>
      selectedTopicList.any((x) => x.id == t.id);

  bool get isOtherTopicSelected => selectedTopicList.any((t) => t.id == 0);

  void toggleTopic(AGHTopic t) {
    final i = selectedTopicList.indexWhere((x) => x.id == t.id);
    if (i >= 0) {
      selectedTopicList.removeAt(i);
      if (t.id == 0) otherTopicRemark.value = '';
    } else {
      selectedTopicList.add(t);
    }
  }

  void clearSelectedTopics() {
    selectedTopicList.clear();
    otherTopicRemark.value = '';
  }

  void setOtherTopicRemark(String s) => otherTopicRemark.value = s;

  final RxString scheduleMode = 'Office'.obs;
  final Rxn<DateTime> scheduleDate =
      Rxn<DateTime>(DateTime.now().add(const Duration(days: 1)));
  final Rxn<TimeOfDay> scheduleTime =
      Rxn<TimeOfDay>(const TimeOfDay(hour: 11, minute: 0));
  final RxString scheduleNotes = ''.obs;

  void setScheduleDate(DateTime d) => scheduleDate.value = d;
  void setScheduleTime(TimeOfDay t) => scheduleTime.value = t;
  void setScheduleNotes(String s) => scheduleNotes.value = s;

  /// Original notes text kept before an "Enhance Text" call so the user can
  /// restore it via "Previous Remark". Empty when no enhancement was done.
  final RxString notesPrevious = ''.obs;
  final RxBool isEnhancingNotes = false.obs;

  /// Enhances the notes text via the ChatGPT API. Returns the enhanced text
  /// (so the screen can update its TextField), or null on failure.
  Future<String?> enhanceScheduleNotes() async {
    final text = scheduleNotes.value.trim();
    if (text.isEmpty || isEnhancingNotes.value) return null;
    isEnhancingNotes.value = true;
    Loader();
    try {
      final apiResponse = await Apis.chatGptApi(message: text);
      if (apiResponse != null && apiResponse['MSG'] != null) {
        notesPrevious.value = text;
        scheduleNotes.value = apiResponse['MSG'].toString();
        return scheduleNotes.value;
      }
      return null;
    } catch (e) {
      if (kDebugMode) log('enhanceScheduleNotes error: $e');
      return null;
    } finally {
      isEnhancingNotes.value = false;
      Loader().hide();
    }
  }

  /// Restores the pre-enhancement notes text. Returns the restored text.
  String restorePreviousNotes() {
    if (notesPrevious.value.isNotEmpty) {
      scheduleNotes.value = notesPrevious.value;
    }
    return scheduleNotes.value;
  }

  /// Resets the schedule form to defaults (used when creating a fresh
  /// session so values from a previous schedule don't carry over).
  void resetScheduleForm() {
    scheduleMode.value = 'Office';
    scheduleDate.value = DateTime.now().add(const Duration(days: 1));
    scheduleTime.value = const TimeOfDay(hour: 11, minute: 0);
    scheduleNotes.value = '';
    notesPrevious.value = '';
    clearSelectedTopics();
  }

  // Active in-progress session state (PRD §18 step-based flow)
  final Rxn<AGHScheduledSession> activeSession = Rxn<AGHScheduledSession>();
  final Rxn<String> captainCheckInAt = Rxn<String>();
  final Rxn<String> memberCheckInAt = Rxn<String>();
  final Rxn<DateTime> sessionStartedAt = Rxn<DateTime>();
  final Rxn<DateTime> checkOutAt = Rxn<DateTime>();
  final RxBool memberLearningSubmitted = false.obs;
  final RxString captainOutput = ''.obs;
  final RxString memberOutput = ''.obs;

  void setCaptainOutput(String s) {
    captainOutput.value = s;
    if (activeSession.value != null && currentUserCheckedIn) {
      _persistActiveSession();
    }
  }

  void setMemberOutput(String s) {
    memberOutput.value = s;
    if (activeSession.value != null && currentUserCheckedIn) {
      _persistActiveSession();
    }
  }

  /// Original output text kept before an "Enhance Text" call so it can be
  /// restored via "Previous Remark". Empty when no enhancement was done.
  final RxString outputPrevious = ''.obs;
  final RxBool isEnhancingOutput = false.obs;

  /// Enhances the current user's output (captain/member) via the ChatGPT API.
  /// Returns the enhanced text, or null on failure.
  Future<String?> enhanceOutput() async {
    final isCaptain = DataInfo.tcId.value == '7';
    final text = (isCaptain ? captainOutput.value : memberOutput.value).trim();
    if (text.isEmpty || isEnhancingOutput.value) return null;
    isEnhancingOutput.value = true;
    Loader();
    try {
      final apiResponse = await Apis.chatGptApi(message: text);
      if (apiResponse != null && apiResponse['MSG'] != null) {
        outputPrevious.value = text;
        final enhanced = apiResponse['MSG'].toString();
        if (isCaptain) {
          setCaptainOutput(enhanced);
        } else {
          setMemberOutput(enhanced);
        }
        return enhanced;
      }
      return null;
    } catch (e) {
      if (kDebugMode) log('enhanceOutput error: $e');
      return null;
    } finally {
      isEnhancingOutput.value = false;
      Loader().hide();
    }
  }

  /// Restores the pre-enhancement output text. Returns the restored text.
  String restorePreviousOutput() {
    final isCaptain = DataInfo.tcId.value == '7';
    if (outputPrevious.value.isNotEmpty) {
      if (isCaptain) {
        setCaptainOutput(outputPrevious.value);
      } else {
        setMemberOutput(outputPrevious.value);
      }
    }
    return isCaptain ? captainOutput.value : memberOutput.value;
  }

  final RxList<AGHSession> upcoming = <AGHSession>[].obs;
  final RxBool isLoadingUpcoming = false.obs;
  final RxString upcomingError = ''.obs;

  final RxList<AGHScheduledSession> scheduled = <AGHScheduledSession>[].obs;

  final RxList<AGHScheduledSession> pending = <AGHScheduledSession>[].obs;

  final RxList<AGHCompletedSession> completed = <AGHCompletedSession>[].obs;

  final List<AGHNotification> notifications = const [];

  @override
  void onInit() {
    super.onInit();
    fetchUpcoming();
    fetchTopics();
  }

  Future<void> fetchUpcoming({bool force = false}) async {
    if (isLoadingUpcoming.value) {
      // A load is already running. For a normal call just skip; when forced
      // (e.g. right after scheduling) wait for it, then fetch fresh data.
      if (!force) return;
      while (isLoadingUpcoming.value) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
    final captainId = DataInfo.userId.value;
    if (captainId.isEmpty) {
      upcomingError.value = 'Missing captain id';
      return;
    }

    isLoadingUpcoming.value = true;
    upcomingError.value = '';
    try {
      final data = '{"captain_id":"$captainId"}';
      final response = await Apis.sendData4(data, 'GETAGH&ISNEW=YES');
      if (response == null) {
        upcomingError.value = 'Failed to load sessions';
        return;
      }

      final decoded = json.decode(response.body);
      final records = (decoded is Map && decoded['records'] is List)
          ? decoded['records'] as List
          : const [];

      final upcomingList = <AGHSession>[];
      final scheduledList = <AGHScheduledSession>[];
      final pendingList = <AGHScheduledSession>[];
      final completedList = <AGHCompletedSession>[];
      for (final raw in records.whereType<Map>()) {
        final r = raw.cast<String, dynamic>();
        final stage = (r['stage'] ?? '').toString().trim().toLowerCase();
        switch (stage) {
          case 'upcoming':
            upcomingList.add(_sessionFromJson(r));
            break;
          case 'scheduled':
            scheduledList.add(_scheduledFromJson(r));
            break;
          case 'pending':
            pendingList.add(_scheduledFromJson(r, roleAwareName: true));
            break;
          default:
            completedList.add(_completedFromJson(r));
        }
      }
      upcoming.assignAll(upcomingList);
      scheduled.assignAll(scheduledList);
      pending.assignAll(pendingList);
      completed.assignAll(completedList);
    } catch (e) {
      if (kDebugMode) log('fetchUpcoming error: $e');
      upcomingError.value = 'Failed to load sessions';
    } finally {
      isLoadingUpcoming.value = false;
    }
  }

  AGHCompletedSession _completedFromJson(Map<String, dynamic> r) {
    final rawDate = (r['captain_remark_at'] ??
            r['last_attended_date'] ??
            r['scheduled_date'])
        ?.toString();
    final dt = (rawDate == null || rawDate.isEmpty)
        ? null
        : DateTime.tryParse(rawDate);
    final dateStr = dt == null
        ? '—'
        : '${dt.day.toString().padLeft(2, '0')} ${_monthsShort[dt.month - 1]} ${dt.year}';
    // Captain sees the member's name; member sees the captain's name.
    final isCaptain = DataInfo.tcId.value == '7';
    return AGHCompletedSession(
      name: isCaptain
          ? (r['name'] ?? r['loginname'] ?? '').toString()
          : (r['captain_name'] ?? r['name'] ?? r['loginname'] ?? '').toString(),
      date: dateStr,
      duration: '—',
      mode: (r['meeting_mode'] == null || '${r['meeting_mode']}'.trim().isEmpty)
          ? '—'
          : r['meeting_mode'].toString(),
      captainRemark: (r['captain_remark'] ?? '').toString(),
      memberRemark: (r['member_remark'] ?? '').toString(),
      captainRemarkAt: (r['captain_remark_at'] ?? '').toString(),
      memberRemarkAt: (r['member_remark_at'] ?? '').toString(),
      notes: (r['notes'] ?? '').toString(),
      topicName: (r['topic_names'] ?? r['topic_name'] ?? '').toString(),
      captainStart: (r['captain_start'] ?? '').toString(),
      captainEnd: (r['captain_end'] ?? '').toString(),
      userStart: (r['user_start'] ?? '').toString(),
      userEnd: (r['user_end'] ?? '').toString(),
    );
  }

  AGHScheduledSession _scheduledFromJson(Map<String, dynamic> r,
      {bool roleAwareName = false}) {
    final raw = r['scheduled_date']?.toString();
    final dt = (raw == null || raw.isEmpty) ? null : DateTime.tryParse(raw);
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final dateOnly = dt == null ? null : DateTime(dt.year, dt.month, dt.day);
    final diffDays =
        (dateOnly == null) ? null : dateOnly.difference(todayOnly).inDays;

    final dateStr = dt == null
        ? '—'
        : '${dt.day.toString().padLeft(2, '0')} ${_monthsShort[dt.month - 1]} ${dt.year}';

    String timeStr = '';
    if (dt != null) {
      final h24 = dt.hour;
      final h12 = h24 % 12 == 0 ? 12 : h24 % 12;
      final period = h24 < 12 ? 'AM' : 'PM';
      timeStr =
          '${h12.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $period';
    }

    String startsIn;
    if (diffDays == null) {
      startsIn = 'Scheduled';
    } else if (diffDays == 0) {
      startsIn = 'Today · $timeStr';
    } else if (diffDays > 0) {
      startsIn = diffDays == 1 ? 'Tomorrow · $timeStr' : 'In $diffDays days';
    } else {
      startsIn = 'Was on $dateStr';
    }

    return AGHScheduledSession(
      userId: (r['id'] ?? '').toString(),
      meetingId: (r['meeting_id'] ?? '').toString(),
      topicName: (r['topic_names'] ?? r['topic_name'] ?? '').toString(),
      // Role-aware (pending): captain sees member name, member sees captain.
      name: (roleAwareName && DataInfo.tcId.value != '7')
          ? (r['captain_name'] ?? r['name'] ?? r['loginname'] ?? '').toString()
          : (r['name'] ?? r['loginname'] ?? '').toString(),
      captainName: (r['captain_name'] ?? '').toString(),
      date: dateStr,
      time: timeStr,
      mode: (r['meeting_mode'] == null || '${r['meeting_mode']}'.trim().isEmpty)
          ? '—'
          : r['meeting_mode'].toString(),
      startsIn: startsIn,
      joinable: diffDays == 0,
      scheduledAt: dt,
      captainRemark: (r['captain_remark'] ?? '').toString(),
      memberRemark: (r['member_remark'] ?? '').toString(),
      captainRemarkAt: (r['captain_remark_at'] ?? '').toString(),
      memberRemarkAt: (r['member_remark_at'] ?? '').toString(),
      notes: (r['notes'] ?? '').toString(),
      captainStart: (r['captain_start'] ?? '').toString(),
      captainEnd: (r['captain_end'] ?? '').toString(),
      userStart: (r['user_start'] ?? '').toString(),
      userEnd: (r['user_end'] ?? '').toString(),
      expireDate: _parseExpireDate(r['expire_date']?.toString()),
    );
  }

  AGHSession _sessionFromJson(Map<String, dynamic> r) {
    final expire = _parseExpireDate(r['expire_date']?.toString());
    // Captain sees the member's name; member sees the captain's name.
    final isCaptain = DataInfo.tcId.value == '7';
    return AGHSession(
      userId: (r['id'] ?? '').toString(),
      name: isCaptain
          ? (r['name'] ?? r['loginname'] ?? '').toString()
          : (r['captain_name'] ?? r['name'] ?? r['loginname'] ?? '').toString(),
      age: (r['age'] is num)
          ? (r['age'] as num).toInt()
          : int.tryParse('${r['age'] ?? ''}') ?? 0,
      role: (r['role'] == null || '${r['role']}'.trim().isEmpty)
          ? 'Not Set'
          : r['role'].toString(),
      next: _formatApiDate(r['expire_date'] ?? r['scheduled_date']),
      last: _formatApiDate(r['last_attended_date']),
      status: expire != null
          ? _statusFromExpire(expire)
          : _statusFromStage(r['stage']?.toString()),
      expireDate: expire,
    );
  }

  DateTime? _parseExpireDate(String? raw) {
    if (raw == null) return null;
    final s = raw.trim();
    if (s.isEmpty) return null;
    final iso = DateTime.tryParse(s);
    if (iso != null) return iso;
    final parts = s.split(RegExp(r'\s+'));
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = _monthMap[parts[1]];
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  AGHMemberStatus _statusFromExpire(DateTime expire) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final exp = DateTime(expire.year, expire.month, expire.day);
    final diff = exp.difference(today).inDays;
    // Expired before today → Missed; within 3 days → Due Soon; else Upcoming.
    if (diff < 0) return AGHMemberStatus.missed;
    if (diff <= 3) return AGHMemberStatus.due;
    return AGHMemberStatus.upcoming;
  }

  Future<void> fetchTopics() async {
    isLoadingTopics.value = true;
    try {
      final response = await Apis.sendData4('', 'GETTOPIC&ISNEW=YES');
      if (response == null) return;
      final decoded = json.decode(response.body);
      final records = (decoded is Map && decoded['records'] is List)
          ? decoded['records'] as List
          : const [];
      topics.assignAll(
        records.whereType<Map>().map((r) {
          final id = r['id'];
          return AGHTopic(
            id: id is num ? id.toInt() : int.tryParse('$id') ?? 0,
            name: (r['name'] ?? '').toString(),
          );
        }),
      );
      // Reconcile current multi-selection against the refreshed catalog.
      // Keep any topic whose id still exists (and always keep the synthetic
      // "Other" entry, id=0, which the catalog doesn't return).
      if (selectedTopicList.isNotEmpty) {
        selectedTopicList.assignAll(
          selectedTopicList.where(
            (t) => t.id == 0 || topics.any((x) => x.id == t.id),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) log('fetchTopics error: $e');
    } finally {
      isLoadingTopics.value = false;
    }
  }

  setButtonStatus() {
    isCheckingIn.value = false;
    update();
  }

  /// Calls GETAGHSCHEDULE. Returns null on success, error message on failure.
  /// Calls AGHSCHEDULE. Handles both create and edit:
  /// - [topicIds] is the comma-joined selection (use "0" for "Other").
  /// - [remark] is included only when the user selected "Other" and typed text.
  /// - [meetingId] is included only when editing an existing schedule.
  /// Returns null on success, error message on failure.
  Future<String?> createSchedule({
    required String memberUserId,
    required String dateTime,
    required String mode,
    required String topicIds,
    required String notes,
    String? remark,
    String? meetingId,
  }) async {
    final captainId = DataInfo.userId.value;
    if (captainId.isEmpty) return 'Missing captain id';
    if (memberUserId.isEmpty) return 'Missing member id';

    isSchedulingSession.value = true;
    try {
      final payload = <String, dynamic>{
        'captain_id': captainId,
        'userid': memberUserId,
        'dateTime': dateTime,
        'mode': mode,
        'topic_id': topicIds,
        'notes': notes,
      };
      if (remark != null && remark.trim().isNotEmpty) {
        payload['remark'] = remark.trim();
      }
      if (meetingId != null && meetingId.trim().isNotEmpty) {
        payload['meeting_id'] = meetingId.trim();
      }

      final response = await Apis.sendDataPost('AGHSCHEDULE', payload);
      if (response == null) return 'Something went wrong';
      final body = response.data?.toString().trim() ?? '';
      if (body.toLowerCase().contains('success')) return null;
      return body.isEmpty ? 'Something went wrong' : body;
    } catch (e) {
      if (kDebugMode) log('createSchedule error: $e');
      return 'Something went wrong';
    } finally {
      isSchedulingSession.value = false;
    }
  }

  AGHMemberStatus _statusFromStage(String? stage) {
    switch ((stage ?? '').trim().toLowerCase()) {
      case 'due':
      case 'due soon':
        return AGHMemberStatus.due;
      case 'missed':
        return AGHMemberStatus.missed;
      case 'pending':
        return AGHMemberStatus.pending;
      case 'upcoming':
      default:
        return AGHMemberStatus.upcoming;
    }
  }

  static const List<String> _monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _formatApiDate(dynamic raw) {
    if (raw == null) return '—';
    final s = raw.toString().trim();
    if (s.isEmpty) return '—';
    // Handle both ISO (last_attended_date) and "21 Jul 2026" (expire_date)
    // so NEXT DUE and LAST SESSION share one format: "21 Jul 2026".
    final d = DateTime.tryParse(s) ?? _parseExpireDate(s);
    if (d == null) return s;
    return '${d.day.toString().padLeft(2, '0')} ${_monthsShort[d.month - 1]} ${d.year}';
  }

  void setTab(String t) => activeTab.value = t;
  void setUpcomingFilter(String f) => upcomingFilter.value = f;
  void setUpcomingUser(String u) => upcomingUser.value = u;
  void clearUpcomingUser() => upcomingUser.value = '';
  void setUpcomingDateRange(DateTimeRange? r) => upcomingDateRange.value = r;
  void clearUpcomingDateRange() {
    upcomingDateRange.value = null;
    upcomingDatePreset.value = '';
  }

  void setUpcomingDatePreset(String preset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (preset) {
      case 'Today':
        upcomingDateRange.value = DateTimeRange(start: today, end: today);
        break;
      case 'Next 5 days':
        upcomingDateRange.value = DateTimeRange(
            start: today, end: today.add(const Duration(days: 5)));
        break;
      case 'Next 10 days':
        upcomingDateRange.value = DateTimeRange(
            start: today, end: today.add(const Duration(days: 10)));
        break;
      default:
        return;
    }
    upcomingDatePreset.value = preset;
  }

  void setUpcomingCustomRange(DateTimeRange r) {
    upcomingDateRange.value = r;
    upcomingDatePreset.value = 'Custom';
  }

  void setCompletedFilter(String f) {
    completedFilter.value = f;
    if (f != 'By member') completedUser.value = '';
    if (f != 'Date range') {
      completedDateRange.value = null;
      completedDatePreset.value = '';
    }
  }

  void setCompletedUser(String name) {
    completedUser.value = name;
    completedFilter.value = 'By member';
  }

  void setCompletedDateRange(DateTimeRange r) {
    completedDateRange.value = r;
    completedDatePreset.value = 'Custom';
    completedFilter.value = 'Date range';
  }

  void setCompletedDatePreset(String preset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (preset) {
      case 'Today':
        completedDateRange.value = DateTimeRange(start: today, end: today);
        break;
      case 'Last 5 days':
        completedDateRange.value = DateTimeRange(
            start: today.subtract(const Duration(days: 5)), end: today);
        break;
      case 'Last 10 days':
        completedDateRange.value = DateTimeRange(
            start: today.subtract(const Duration(days: 10)), end: today);
        break;
      default:
        return;
    }
    completedDatePreset.value = preset;
    completedFilter.value = 'Date range';
  }

  void clearCompletedDateRange() {
    completedDateRange.value = null;
    completedDatePreset.value = '';
    completedFilter.value = 'By member';
  }

  void clearCompletedFilters() {
    completedFilter.value = 'By member';
    completedUser.value = '';
    completedDateRange.value = null;
    completedDatePreset.value = '';
  }

  List<String> get completedUserNames =>
      completed.map((s) => s.name).toSet().toList()..sort();

  List<AGHCompletedSession> get filteredCompleted {
    final filter = completedFilter.value;
    final user = completedUser.value;
    final range = completedDateRange.value;
    return completed.where((s) {
      final d = _parseSessionDate(s.date);
      switch (filter) {
        case 'Last 10 days':
          if (d == null) return false;
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final cutoff = today.subtract(const Duration(days: 10));
          if (d.isBefore(cutoff) || d.isAfter(today)) return false;
          break;
        case 'By member':
          if (user.isEmpty) break;
          if (s.name != user) return false;
          break;
        case 'Date range':
          if (range == null) break;
          if (d == null) return false;
          final start =
              DateTime(range.start.year, range.start.month, range.start.day);
          final end = DateTime(range.end.year, range.end.month, range.end.day);
          if (d.isBefore(start) || d.isAfter(end)) return false;
          break;
      }
      return true;
    }).toList()
      // Descending by date (most recent first); undated rows go last.
      ..sort((a, b) {
        final da = _parseSessionDate(a.date);
        final db = _parseSessionDate(b.date);
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });
  }

  void setNotificationFilter(String f) => notificationFilter.value = f;

  List<String> get upcomingUserNames {
    final selfId = DataInfo.userId.value;
    // Captain names (s.name is parsed from captain_name); show both rows.
    // Exclude the logged-in user's own record (match by id).
    return upcoming
        .where((s) => s.userId != selfId)
        .map((s) => s.name)
        .where((n) => n.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  List<AGHSession> get filteredUpcoming {
    final user = upcomingUser.value;
    final range = upcomingDateRange.value;
    final status = upcomingFilter.value;
    final selfId = DataInfo.userId.value;
    final isCaptain = DataInfo.tcId.value == '7';
    return upcoming.where((s) {
      // Captain only: hide their own record (match by id). Members see all.
      if (isCaptain && s.userId == selfId) return false;
      if (user.isNotEmpty && s.name != user) return false;
      if (range != null) {
        final d = _parseSessionDate(s.next);
        if (d == null) return false;
        final start =
            DateTime(range.start.year, range.start.month, range.start.day);
        final end = DateTime(range.end.year, range.end.month, range.end.day);
        if (d.isBefore(start) || d.isAfter(end)) return false;
      }
      switch (status) {
        case 'Due Soon':
          if (s.status != AGHMemberStatus.due) return false;
          break;
        case 'Missed':
          if (s.status != AGHMemberStatus.missed) return false;
          break;
        case 'Upcoming':
          if (s.status != AGHMemberStatus.upcoming) return false;
          break;
      }
      return true;
    }).toList()
      // Ascending by Next Due date; rows without a date go last.
      ..sort((a, b) {
        final da = a.expireDate ?? _parseSessionDate(a.next);
        final db = b.expireDate ?? _parseSessionDate(b.next);
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return da.compareTo(db);
      });
  }

  static const Map<String, int> _monthMap = {
    'Jan': 1,
    'Feb': 2,
    'Mar': 3,
    'Apr': 4,
    'May': 5,
    'Jun': 6,
    'Jul': 7,
    'Aug': 8,
    'Sep': 9,
    'Oct': 10,
    'Nov': 11,
    'Dec': 12,
  };

  /*
  {"userid":"loginid","meeting_id":"1","chekin":"2026 May 15 14:05"
  ,"chekout":"2026 May 15 15:00","notes":"captain note | member note"
  ,"latitude":"10.55555","longitude":"15.00000","role":"7"
  }
  * */

  DateTime? _parseSessionDate(String s) {
    final parts = s.replaceAll(',', '').trim().split(RegExp(r'\s+'));
    if (parts.length != 3) return null;
    if (_monthMap.containsKey(parts[1])) {
      final day = int.tryParse(parts[0]);
      final month = _monthMap[parts[1]];
      final year = int.tryParse(parts[2]);
      if (day == null || month == null || year == null) return null;
      return DateTime(year, month, day);
    }
    if (_monthMap.containsKey(parts[0])) {
      final month = _monthMap[parts[0]];
      final day = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day == null || month == null || year == null) return null;
      return DateTime(year, month, day);
    }
    return null;
  }

  /// Replaces the entire selection with [topic] (or clears it if null).
  /// Kept for callers that pre-select a single topic (e.g. reschedule flow).
  void setSelectedTopic(AGHTopic? topic) {
    if (topic == null) {
      clearSelectedTopics();
      return;
    }
    selectedTopicList.assignAll([topic]);
    if (topic.id != 0) otherTopicRemark.value = '';
  }

  void setMode(String mode) => scheduleMode.value = mode;

  void addScheduled(AGHScheduledSession s) => scheduled.insert(0, s);

  // ──────────────────────────────────────────────────────────────────────
  // Active session lifecycle (PRD §18)

  final RxBool isCheckingIn = false.obs;

  bool get bothCheckedIn =>
      captainCheckInAt.value != null && memberCheckInAt.value != null;

  bool get isCurrentUserCaptain => DataInfo.tcId.value == '7';

  bool get currentUserCheckedIn => isCurrentUserCaptain
      ? captainCheckInAt.value != null
      : memberCheckInAt.value != null;

  String _formatAghTimestamp(DateTime d) {
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${d.year} ${_monthsShort[d.month - 1]} ${d.day.toString().padLeft(2, '0')} $hh:$mm';
  }

  static const String _activeSessionKey = 'agh_active_checkin';

  /// Local-only check-in: stamps time, starts the session timer and persists
  /// state so the session can be resumed after app close / back press.
  void checkInLocally() {
    if (currentUserCheckedIn) return;
    final hhmm = _nowHHmm();
    if (isCurrentUserCaptain) {
      captainCheckInAt.value = hhmm;
    } else {
      memberCheckInAt.value = hhmm;
    }
    sessionStartedAt.value = DateTime.now();
    _persistActiveSession();
  }

  /// Posts to SAVEAGH on check-out. Returns null on success, error message on
  /// failure. Uses [sessionStartedAt] for `chekin` and [checkOutAt] for
  /// `chekout` so the timestamps survive app restarts.
  Future<String?> postCheckOut() async {
    final session = activeSession.value;
    if (session == null) return 'No active session';
    if (session.meetingId.isEmpty) return 'Missing meeting id';
    if (!currentUserCheckedIn) return 'Please check in first';

    isCheckingIn.value = true;
    try {
      final loc = await Utilities.getLocation();
      final lat = loc?.latitude?.toString() ?? '';
      final lng = loc?.longitude?.toString() ?? '';

      final checkInDate = sessionStartedAt.value ?? DateTime.now();
      final checkOutDate = checkOutAt.value ?? DateTime.now();
      final captain = isCurrentUserCaptain;
      final notes = captain ? captainOutput.value : memberOutput.value;

      final response = await Apis.sendDataPost('SAVEAGH', {
        'userid': DataInfo.userId.value,
        'meeting_id': session.meetingId,
        'chekin': _formatAghTimestamp(checkInDate),
        'chekout': _formatAghTimestamp(checkOutDate),
        'notes': notes,
        'latitude': lat,
        'longitude': lng,
        'role': DataInfo.tcId.value,
        'Address': '',
      });

      if (response == null) return 'Something went wrong';

      final raw = response.data;
      final data = raw is String ? json.decode(raw) : raw;
      if (data is Map && data['status']?.toString() == 'success') {
        _clearActiveSessionStorage();
        return null;
      }
      final message = (data is Map ? data['message']?.toString() : null);
      return (message == null || message.isEmpty)
          ? 'Something went wrong'
          : message;
    } catch (e) {
      if (kDebugMode) log('postCheckOut error: $e');
      return 'Something went wrong';
    } finally {
      isCheckingIn.value = false;
    }
  }

  void _persistActiveSession() {
    final s = activeSession.value;
    if (s == null) return;
    try {
      DataInfo.box.write(_activeSessionKey, {
        'meeting_id': s.meetingId,
        'captain_check_in_hhmm': captainCheckInAt.value,
        'member_check_in_hhmm': memberCheckInAt.value,
        'session_started_iso': sessionStartedAt.value?.toIso8601String(),
        'captain_output': captainOutput.value,
        'member_output': memberOutput.value,
      });
    } catch (e) {
      if (kDebugMode) log('AGH persist error: $e');
    }
  }

  bool _restoreActiveSession(String meetingId) {
    try {
      final raw = DataInfo.box.read(_activeSessionKey);
      if (raw is! Map) return false;
      if (raw['meeting_id']?.toString() != meetingId) return false;

      captainCheckInAt.value = raw['captain_check_in_hhmm'] as String?;
      memberCheckInAt.value = raw['member_check_in_hhmm'] as String?;
      final startedIso = raw['session_started_iso'] as String?;
      sessionStartedAt.value =
          startedIso == null ? null : DateTime.tryParse(startedIso);
      captainOutput.value = (raw['captain_output'] as String?) ?? '';
      memberOutput.value = (raw['member_output'] as String?) ?? '';
      checkOutAt.value = null;
      memberLearningSubmitted.value = false;
      return true;
    } catch (e) {
      if (kDebugMode) log('AGH restore error: $e');
      return false;
    }
  }

  void _clearActiveSessionStorage() {
    try {
      DataInfo.box.remove(_activeSessionKey);
    } catch (_) {}
  }

  void startActiveSession(AGHScheduledSession s) {
    activeSession.value = s;
    if (_restoreActiveSession(s.meetingId)) return;
    // Seed check-in times from any server-side check-in already recorded
    // (captain_start / user_start) so the room shows who has checked in.
    captainCheckInAt.value = _hhmmFromIso(s.captainStart);
    memberCheckInAt.value = _hhmmFromIso(s.userStart);
    final seeded =
        s.captainStart.trim().isNotEmpty || s.userStart.trim().isNotEmpty;
    sessionStartedAt.value = seeded ? DateTime.now() : null;
    checkOutAt.value = null;
    memberLearningSubmitted.value = false;
    captainOutput.value = '';
    memberOutput.value = '';
    outputPrevious.value = '';
  }

  /// Converts an ISO timestamp (e.g. 2026-06-26T15:21:00) to "HH:mm", or null
  /// when the input is empty/unparseable.
  String? _hhmmFromIso(String raw) {
    if (raw.trim().isEmpty) return null;
    final dt = DateTime.tryParse(raw);
    if (dt == null) return null;
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _nowHHmm() {
    final n = DateTime.now();
    final h = n.hour.toString().padLeft(2, '0');
    final m = n.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void captainCheckIn() {
    if (captainCheckInAt.value != null) return;
    captainCheckInAt.value = _nowHHmm();
    _maybeStartTimer();
  }

  void memberCheckIn() {
    if (memberCheckInAt.value != null) return;
    memberCheckInAt.value = _nowHHmm();
    _maybeStartTimer();
  }

  void _maybeStartTimer() {
    if (sessionStartedAt.value != null) return;
    if (currentUserCheckedIn) sessionStartedAt.value = DateTime.now();
  }

  /// Captain ends the session (Step 2 — Check-Out).
  void endSession() {
    if (!currentUserCheckedIn) return;
    checkOutAt.value = DateTime.now();
  }

  /// Step 3 — Member submits "What I Learned".
  void submitMemberLearning() => memberLearningSubmitted.value = true;

  /// Step 5 — Captain Final Save: lock + move to Completed.
  void finalSaveSession() {
    final s = activeSession.value;
    if (s == null) return;
    final start = sessionStartedAt.value ?? DateTime.now();
    final end = checkOutAt.value ?? DateTime.now();
    final mins = end.difference(start).inMinutes.clamp(1, 999);

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final t = DateTime.now();
    final dateStr =
        '${t.day.toString().padLeft(2, '0')} ${months[t.month - 1]} ${t.year}';

    completed.insert(
      0,
      AGHCompletedSession(
        name: s.name,
        date: dateStr,
        duration: '${mins}m',
        mode: s.mode,
      ),
    );

    scheduled.removeWhere(
      (x) => x.name == s.name && x.date == s.date && x.time == s.time,
    );

    activeSession.value = null;
    setTab('Completed');
  }
}
