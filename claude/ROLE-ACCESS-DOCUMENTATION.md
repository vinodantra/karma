# Karma — Who Can See What

> **Which screen is visible to which role — and what changes inside it.**
> Companion to `API-QUICK-REFERENCE.md` (what each screen calls) and
> `API-DOCUMENTATION.md` (full technical detail).

---

# 1. Read this in one minute

## The five kinds of user

There are **two base roles** (you are one or the other) and **three add-ons** (you may also
have any of these on top).

### Base roles — everyone is exactly one of these

| | Role name | Who they are | How the code knows |
|---|---|---|---|
| **A** | **L1 Executive** | Field sales person | `desCat = "L1"` |
| **C** | **Support User** | Support desk staff | `desCat` is anything **except** `"L1"` |

### Add-on roles — these stack on top of A or C

| | Role name | What it grants | How the code knows |
|---|---|---|---|
| **B** | **Manager** | Team dropdowns; approve leave and calls | `rollId = "1"` |
| **D** | **Captain** | The captain side of AGH coaching sessions | `tcId = "7"` |
| **E** | **ANS / PBL Author** | The **"+"** create button on ANS and PBL Report | `titleId = "24"`, `"25"` or `"26"` **or** `userId = "176"`, `"177"` or `"365"` |

**None of B, D or E is a rank.** Each sits *on top of* A or C, and each is a separate server
field, so any combination is possible. A Support User can be a Manager. A Support User can be
a Captain. The three do not imply one another.

> ### ⚠️ An add-on never unlocks a hidden screen
>
> Screen visibility is decided by the **base role only** (`desCat`). B, D and E change what
> you see *inside* a screen you can already open — they never put a new item in your menu.
>
> **A Support User who is a Captain still cannot open AGH.** The AGH menu item is gated on
> `desCat == "L1"` alone ([`DrawerWidget.dart:114`](../lib/Application/Drawer/DrawerWidget.dart#L114)); `tcId` is never consulted there. The same is true of
> ANS, PBL and My Customer Call. Do not read "Captain ✅" anywhere as "can reach the screen".

### Where each role is documented

| Role | Which screens they get | Every button it unlocks |
|---|---|---|
| **A** · L1 Executive | Section 2 master table — column A | — *(base role)* |
| **C** · Support User | Section 2 master table — column C | — *(base role)* |
| **B** · Manager | *(same as their base role)* | **Section 4.1** — 9 controls on 6 screens |
| **D** · Captain | *(same as their base role)* | **Section 4.2** — the AGH side switch + 3 buttons |
| **E** · ANS / PBL Author | *(same as their base role)* | **Section 4.3** — one "+" button on 2 screens |

**Sections 2 and 3 are organised by screen. Section 4 is organised by role** — go there to answer
"what does a Manager actually get?"

## ⚠️ There is no "L3"

The team says **L1 / L2 / L3 / Captain**. The code does not work that way.

| What people say | What the code actually checks | Role above |
|---|---|---|
| "L1" | `desCat == "L1"` — **exists** | A |
| "L2" | *no check exists* — it is just "not L1" | C |
| **"L3"** | **does not exist anywhere in the source** | — |
| "Captain" | `tcId == "7"` — exists, but it is a separate add-on | D |

Every non-L1 user — whatever the business calls them — takes the **same** code path.
Two people both called "L2" can see different screens if their `rollId` differs.

The business vocabulary has no word at all for **B (Manager)** or **E (ANS / PBL Author)**,
even though both change what a user can do. That gap is why this section exists.

## The three access levels used in this document

| Symbol | Meaning |
|---|---|
| ✅ | **Full access** — sees the whole screen |
| ⚠️ | **Partial** — can open it, but some buttons or fields are hidden |
| ❌ | **No access** — the screen is not even in their menu |

---

# 2. The master table — every screen, every role

**This is the answer to "which page can which role see?"**
Read across the row. `A` = L1 Executive · `B` = Manager (on the L1 track) · `C` = Support User.

> **Why D and E have no column.** Captain and ANS / PBL Author never make a hidden screen
> appear — see the warning in Section 1. A Captain reads the column for their **base** role (A or C),
> then **Section 4.2** for what they gain. An ANS / PBL Author reads their base column, then **Section 4.3**.
>
> Column **B** assumes an L1 Manager, which is the common case. A Manager on the **support**
> track reads column C for visibility, and gains the controls listed in **Section 4.1**.
>
> **This table answers "can I open it?" only.** For "which buttons do I get?", go to Section 4.

## Menu (the drawer)

| Screen | A · L1 Exec | B · L1 Mgr | C · Support | What is different |
|---|:---:|:---:|:---:|---|
| Home / Dashboard | ⚠️ | ✅ | ⚠️ | Manager gets a team dropdown. Support sees a chart; L1 sees cards instead. |
| **Antra Golden Hour** | ✅ | ✅ | ❌ | **Hidden from the menu for support users** |
| Raise Escalation | ✅ | ✅ | ✅ | — |
| Epicenter | ✅ | ✅ | ✅ | — |
| Operations (Reports) | ✅ | ✅ | ⚠️ | L1 sees 3 report groups; support sees 1 |
| Products | ✅ | ✅ | ✅ | — |
| Antra Ticket System | ✅ | ✅ | ✅ | — |
| **ANS Report** | ⚠️ | ✅ | ❌ | **Hidden for support.** "+" button needs extra rights — see Section 3.5 |
| **PBL Report** | ⚠️ | ✅ | ❌ | **Hidden for support.** Same "+" rule as ANS |
| Ticket Status | ✅ | ✅ | ⚠️ | Support cannot filter by user |
| Contact List | ✅ | ✅ | ✅ | Identical for everyone |
| Support Availability | ✅ | ✅ | ✅ | Opens an external web page |
| CertiKit ISO27001 | ✅ | ✅ | ✅ | External link |
| Product Requirement | ✅ | ✅ | ✅ | External Google Form |
| Karma Enhancement | ✅ | ✅ | ✅ | External Google Form |
| **My Customer Call** | ✅ | ✅ | ❌ | **Hidden from the menu for support users** |
| Update App | ✅ | ✅ | ✅ | Android only — a platform rule, not a role rule |
| Logout | ✅ | ✅ | ✅ | — |

> **Only 4 things are hidden from the menu:** Antra Golden Hour, ANS Report, PBL Report,
> My Customer Call. Everything else is in everyone's menu.
>
> **The drawer has no manager check at all.** An executive and a manager see an identical
> menu. The difference appears *inside* the screens.

## Customers

| Screen | A · L1 Exec | B · L1 Mgr | C · Support | What is different |
|---|:---:|:---:|:---:|---|
| Customer List | ✅ | ✅ | ✅ | — |
| Customer 360 | ✅ | ✅ | ✅ | — |
| Create Customer | ✅ | ✅ | ✅ | — |
| Contact Details | ✅ | ✅ | ✅ | — |
| Products & Services | ✅ | ✅ | ✅ | — |
| Recent Activity | ✅ | ✅ | ✅ | — |
| Tally Serial | ✅ | ✅ | ✅ | — |
| Tally Serial Number | ✅ | ✅ | ✅ | — |
| Visit History | ✅ | ✅ | ✅ | — |
| Delivery Request | ✅ | ✅ | ✅ | — |
| Customer Tickets | ✅ | ✅ | ✅ | — |
| Address Details | ✅ | ✅ | ✅ | — |
| Data Point Details | ✅ | ✅ | ✅ | — |
| Book a Call | ⚠️ | ⚠️ | ⚠️ | Payload is encoded differently for L1 — see Section 6, risk 2 |

## Call Booking

| Screen | A · L1 Exec | B · L1 Mgr | C · Support | What is different |
|---|:---:|:---:|:---:|---|
| Call Booking | ⚠️ | ✅ | ⚠️ | **7 role gates** — the most of any screen. See Section 3.2 |
| Call Booking L2 | ⚠️ | ✅ | ⚠️ | Approve icon is manager-only; visit-entry icon is L1-only |
| Call Booking Details | ✅ | ✅ | ✅ | — |
| Add Support Entry | ✅ | ✅ | ⚠️ | Observation / requirement block hidden from support |
| Support Details | ✅ | ✅ | ⚠️ | **2 fields hidden** from support — see Section 3.4 |
| Support List | ✅ | ✅ | ✅ | — |
| Conveyance Entry | ✅ | ✅ | ✅ | — |
| PIW / Workshop Form | ✅ | ✅ | ✅ | — |
| Create Lead | ✅ | ✅ | ✅ | — |
| Cold Calling | ✅ | ✅ | ✅ | — |
| Near By Customer | ✅ | ✅ | ✅ | — |

## Leads & Opportunity

| Screen | A · L1 Exec | B · L1 Mgr | C · Support | What is different |
|---|:---:|:---:|:---:|---|
| Lead | ✅ | ✅ | ✅ | Default filter differs: L1 opens on **Received**, support on **Given** |
| Lead Received | ✅ | ✅ | ✅ | Title reads "Lead Received" for L1, "Lead Given" for support |
| Create Lead 1 | ✅ | ✅ | ✅ | — |
| Update Lead | ✅ | ✅ | ✅ | Title flips the same way. Edit rights are **not** role-based — see Section 3.7 |
| Opportunity Details | ✅ | ✅ | ✅ | — |
| Opportunity Data | ✅ | ✅ | ✅ | — |
| Change Status | ✅ | ✅ | ✅ | — |
| Update Opportunity | ✅ | ✅ | ✅ | — |

## Tickets

| Screen | A · L1 Exec | B · L1 Mgr | C · Support | What is different |
|---|:---:|:---:|:---:|---|
| Antra Ticket System | ✅ | ✅ | ✅ | — |
| Create Ticket | ✅ | ✅ | ✅ | — |
| Remark List | ✅ | ✅ | ✅ | — |
| Ticket Status | ✅ | ✅ | ⚠️ | User filter dropdown hidden from support |
| Ticket Details | ✅ | ✅ | ✅ | — |
| Ticket Status Details | ✅ | ✅ | ✅ | — |

## Reports ("Operations")

| Screen | A · L1 Exec | B · L1 Mgr | C · Support | What is different |
|---|:---:|:---:|:---:|---|
| Reports (the menu) | ✅ | ✅ | ⚠️ | Support sees **1 card**, L1 sees **3** |
| Leave Report | ✅ | ✅ | ✅ | — |
| Holidays List | ✅ | ✅ | ✅ | — |
| Leave Status | ⚠️ | ✅ | ⚠️ | **Only managers** get the team picker + approve / reject |
| Conveyance Report | ✅ | ✅ | ✅ | — |
| **Target Report** | ✅ | ✅ | ❌ | **Unreachable for support.** All 4 entry points sit inside the two L1-only card groups — see below |
| Monthly Report | ✅ | ✅ | ✅ | — |

> **Target Report is not gated by its own screen** — it has no role check inside it. It is
> hidden because the only 4 `Get.to(TargetReport)` calls in the app (`Reports.dart:93, 108,
> 152, 167`) all sit inside the two `desCat == "L1"` blocks at `Reports.dart:63-121` and
> `122-179`. A support user has no route to it.

## Everything else

| Screen | A · L1 Exec | B · L1 Mgr | C · Support | What is different |
|---|:---:|:---:|:---:|---|
| Outstanding | ✅ | ✅ | ✅ | — |
| Epicenter Details | ✅ | ✅ | ✅ | — |
| Epicenters Page 2 | ✅ | ✅ | ✅ | — |
| Epicenter Screen | ✅ | ✅ | ✅ | — |
| Escalation — Choose Type | ✅ | ✅ | ✅ | — |
| Escalation — Internal | ✅ | ✅ | ✅ | — |
| Escalation — From Ticket | ✅ | ✅ | ✅ | — |
| Escalation — Success | ✅ | ✅ | ✅ | — |
| Products / Product Details | ✅ | ✅ | ✅ | — |
| Profile / Edit Profile | ✅ | ✅ | ✅ | — |
| Notifications | ✅ | ✅ | ✅ | — |
| Company / Company Details | ✅ | ✅ | ✅ | — |
| Contact List | ✅ | ✅ | ✅ | — |
| Support Availability | ✅ | ✅ | ✅ | — |
| Login / Splash / Onboarding / Sync | ✅ | ✅ | ✅ | — |
| Data Scope | ✅ | ✅ | ✅ | — |
| **My Customer Call** | ✅ | ✅ | ❌ | Hidden from the menu |
| **ANS Report / Create ANS** | ⚠️ | ✅ | ❌ | Hidden from the menu |
| **PBL Report / Create PBL** | ⚠️ | ✅ | ❌ | Hidden from the menu |
| **AGH — all 7 screens** | ✅ | ✅ | ❌ | Hidden from the menu. Captain sees different content — see Section 3.6 |

## The bottom line

| | Count |
|---|---|
| Screens in the app | **84** |
| Screens with **any** role logic | **~14** |
| Screens where **every role sees the same thing** | **~70** |
| Screens **completely hidden** from support users | **13** — see the breakdown below |
| Base roles | **2** (A, C) |
| Add-on roles | **3** (B, D, E) |

**The 13 screens support users cannot reach:**

| Source | Screens | Count |
|---|---|---|
| Antra Golden Hour menu item | AGH Dashboard, Check In, Completed, Member Learn, Notifications, Outcome, Schedule Session | 7 |
| ANS Report menu item | ANS Report, Create ANS | 2 |
| PBL Report menu item | PBL Report, Create PBL | 2 |
| My Customer Call menu item | My Customer Call | 1 |
| Operations report cards | Target Report | 1 |

Only **4 menu items** are hidden, but they take 12 screens with them; Target Report is the
13th and is hidden by a card group rather than a menu item.

Access control is concentrated in about 14 files. Most of the app is identical for everyone.

---

# 3. The screens that actually differ

Only these need reading. Everything else is the same for all roles.

> **This section is organised by screen** — open a screen, see what changes for whom.
> For the same facts organised **by role** — "I am a Manager, what do I get?" — see **Section 4**.

## 3.1 Home / Dashboard — `DashboardNew.dart`

| What | L1 Executive | L1 Manager | Support user |
|---|---|---|---|
| Team-member dropdown | ❌ | ✅ | ❌ |
| Main chart | hidden | hidden | **shown** |
| Card list instead of chart | **shown** | **shown** | hidden |
| Data Points shortcut | **shown** | **shown** | hidden |
| Tab taps | update the chart in place | same | also **jump the page** |

*Code:* `DashboardNew.dart:643, 723, 802, 880, 1027` · `Dashboard.dart:32`

> ### ⚠️ The most important behaviour in the whole app
>
> When a **manager picks a team member** from the dropdown, the app **overwrites its own
> identity** (`dashboardController.dart:110-111`):
>
> ```dart
> DataInfo.enrollId.value = selected['ENROLLID'];
> DataInfo.desCat.value   = selected['DESCAT'];   // ← the manager's own role is now gone
> ```
>
> If the manager picks a **support-track** member, `desCat` stops being `"L1"` **globally**.
> From that moment the manager's own drawer loses AGH, ANS, PBL and My Customer Call, and
> every screen renders as a support user — until they pick someone else or log out.
>
> This is a bug, not a design. See Section 6, risk 1.

## 3.2 Call Booking — `CallBooking.dart`

The most role-gated screen in the app — 7 separate checks.

| Feature | L1 Exec | L1 Mgr | Support | Rule in code |
|---|:---:|:---:|:---:|---|
| Team-member filter | ❌ | ✅ | ❌ | `rollId == "1"` |
| Edit check-in / check-out | ❌ | ✅ | ❌ | `rollId == "1"` and time is `"00"` |
| Manual check-in entry | ✅ | ✅ | ❌ | `CHKIN == "00"` and `desCat == "L1"` |
| Info dialog button | ✅ | ✅ | ❌ | `desCat == "L1"` |
| "Call approved status" row | ✅ | ✅ | ❌ | `desCat == "L1"` and `SUPCNT == "Yes"` |
| **Visit Entry tile** | Captain only | Captain only | ❌ | `(rollId=="1" or "2")` **and** `desCat=="L1"` **and** `tcId=="7"` **and** `SUPCNT=="Yes"` |
| Notes tile | ✅ | ✅ | ❌ | `desCat == "L1"` |

*Code:* `CallBooking.dart:31, 206, 331, 527, 588, 803, 908`

> The Visit Entry tile is the only place in the app that needs **three roles at once** —
> **A** (`desCat=="L1"`) **and** **B** or second-tier (`rollId` `"1"`/`"2"`) **and** **D**
> (`tcId=="7"`) — plus the call's own `SUPCNT=="Yes"` data flag. In practice almost nobody
> sees it.

## 3.3 Call Booking L2 — `CallBookingL2.dart`

| Feature | Who sees it | Rule |
|---|---|---|
| Approve-call check icon | **L1 Manager only** | `rollId == "1"` and `desCat == "L1"` |
| Visit-entry file icon | any L1 | `desCat == "L1"` |

*Code:* `CallBookingL2.dart:530, 586`

## 3.4 Support Details — `SupportDetails.dart`

| Field | L1 | Support |
|---|:---:|:---:|
| Remark | ✅ | ✅ |
| **Observation** (`RECOMMENDATION`) | ✅ | ❌ |
| **Requirement** (`REQUIREMENT`) | ✅ | ❌ |

*Code:* `SupportDetails.dart:77, 90`

> ⚠️ The server sends **all three fields to everyone**. Two are simply not drawn for support
> users. Anyone who inspects the response sees them. See Section 6, risk 3.

## 3.5 ANS Report & PBL Report — `ans_screen.dart` · `PblReport.dart`

**This is the home of role E — ANS / PBL Author.**

Both screens are **L1-only** (hidden from the support menu). Inside, two things are gated:

| Feature | Who gets it | Roles |
|---|---|---|
| **The "+" create button** | anyone matching **any one** of the 8 conditions below | **B**, **D** or **E** |
| Team-member dropdown | managers only (`rollId == "1"`) | **B** |

**The "+" button appears if ANY of these is true:**

```
rollId  == "1"                       ← B · Manager
tcId    == "7"                       ← D · Captain
titleId == "24" or "25" or "26"      ← E · ANS / PBL Author, by designation
userId  == "176" or "177" or "365"   ← E · ANS / PBL Author, THREE SPECIFIC PEOPLE
```

**So role E is defined by elimination:** an L1 Executive who is neither a Manager nor a
Captain, but still gets the create button because of their designation (`titleId`) or because
their personal `userId` is written into the source. There is no server field named "author" —
role E exists only as the bottom six lines of that expression.

| Role E is granted by | Values | Meaning |
|---|---|---|
| `titleId` | `"24"`, `"25"`, `"26"` | Three designations. **Nobody has documented which three.** |
| `userId` | `"176"`, `"177"`, `"365"` | Three named individuals, hardcoded |

*Code:* [`ans_screen.dart:37-44`](../lib/Application/ANS/ans_screen.dart#L37-L44) · [`PblReport.dart:32`](../lib/Application/PblReport/PblReport.dart#L32) *(create button)* ·
[`ans_screen.dart:55`](../lib/Application/ANS/ans_screen.dart#L55) · [`PblReport.dart:40`](../lib/Application/PblReport/PblReport.dart#L40) *(team dropdown)*

> ⚠️ **Three individual user IDs are hardcoded into the app.** If any of those three people
> change role or leave, the app must be rebuilt and re-released. See Section 6, risk 5.
>
> ⚠️ **Nobody knows what `titleId` 24, 25 and 26 mean.** The numbers appear in these two files
> and nowhere else — no constant, no comment, no enum. Ask the backend team what the `TITLEID`
> table holds and record the answer here.
>
> The identical 8-condition expression is copy-pasted into both files. See Section 6, risk 6.

## 3.6 Antra Golden Hour — `Application/AGH/*`

**This is the home of role D — Captain.**

**L1 only.** Inside, the role that matters is **Captain (D) vs Member** (`tcId == "7"`).

"Member" is not a sixth role — it is simply *not* a Captain. Any L1 user without `tcId == "7"`
is the member side of a session.

> ⚠️ Being a Captain does **not** get you into AGH. The menu item checks `desCat == "L1"` only.
> A Captain on the support track never reaches these screens — see Section 1.

AGH is the only module with a real two-sided model: every session has one Captain and one
Member, and each sees the *other* person's name and edits their *own* fields.

| What | Captain sees | Member sees |
|---|---|---|
| Name on a session card | the **member's** name | the **captain's** name |
| Check-in slot label | `CAPTAIN` | `MEMBER` |
| Timestamps used | `captain_start` / `captain_end` | `user_start` / `user_end` |
| Text field edited | `captainOutput` | `memberOutput` |
| ChatGPT "enhance" writes to | `captainOutput` | `memberOutput` |
| Their own record in the upcoming list | **hidden** | shown |
| Check-out pending message | "pending from you" / "from {member}" | "pending from {captain}" |

*Code:* `aghController.dart:289, 318, 423, 485, 513, 844, 946` · `AGHDashboard.dart:102, 562, 834, 848` ·
`AGHCheckIn.dart:89, 97, 175, 269, 282, 316` · `AGHOutcome.dart:415`

**Role in the API:**

| Call | Payload | Note |
|---|---|---|
| `GETAGH` | `{"captain_id":"1234"}` | Sends the current user as `captain_id` — **even for members** |
| `SAVEAGH` | `{..., "role":"7"}` | The **only** call in the whole app that tells the server a role |

## 3.7 Update Lead — a gate that is *not* about roles

Easy to mistake for a role check. It isn't.

Edit rights come from a `showData` value handed over by the previous screen:

```dart
"showData": lead != "Given" && (leadType == "InProcess" || leadType == "UNTOUCHED")
```

When `showData` is false, every field is read-only and the submit button disappears.
**That depends on the lead's status, not on who is logged in.**

*Code:* `UpdateLead.dart:16, 81, 132` · `LeadReceived.dart:41`

## 3.8 Other partial screens

| Screen | What is hidden from support users | Code |
|---|---|---|
| Add Support Entry | observation / requirement input block | `AddSupportEntry.dart:642` |
| Reports (Operations) | 2 of the 3 report card groups | `Reports.dart:63, 122` |
| Ticket Status | the user filter dropdown | `TicketStatus.dart:36` |
| Leave Status | team picker + approve/reject *(non-managers)* | `LeaveStatus.dart:19` |

---

# 4. The add-ons — exactly what each one unlocks

Sections 2 and 3 are organised **by screen**. This section is the same information organised
**by role**: pick an add-on, and see every button it turns on and where.

**Read this if you are asking "what does a Manager actually get?"**

Remember the rule from Section 1: **an add-on never adds a menu item.** Everything below is a
control *inside* a screen the user can already open.

## 4.1 Add-on B — Manager · `rollId == "1"`

**In one line:** *"let me see and approve for my team."*

Nine live controls across six screens. Every one is either a team picker or an approval.

| # | Screen | Button / control | What it does | Code |
|---:|---|---|---|---|
| 1 | Home Dashboard | **Team-member picker** | Taps open a bottom sheet listing your team; picking one reloads the dashboard as that person | `Dashboard.dart:32` |
| 2 | Call Booking | **Team-member filter** | Same bottom sheet — filters the booked-call list to one member | `CallBooking.dart:31` |
| 3 | Call Booking | **✏️ Edit icon** | Opens *"Update check In/Out Time"* — only shown when `CHKIN` or `CHKOUT` is `"00"` (i.e. missing) | `CallBooking.dart:206` |
| 4 | Call Booking L2 | **Team-member filter** | Support-track version of #2 | `CallBookingL2.dart:26` |
| 5 | Call Booking L2 | **✏️ Edit icon** | Support-track version of #3 | `CallBookingL2.dart:436` |
| 6 | Call Booking L2 | **✔️ Circle icon** | Opens the *"Call Status"* approve dialog. Green when `SUPCNT == "Yes"`, red otherwise. **Also needs `desCat == "L1"`** | `CallBookingL2.dart:530` |
| 7 | Leave Status | **Team-member picker** + approve / reject | The only place leave is approved | `LeaveStatus.dart:19` |
| 8 | ANS Report | **Team-member dropdown** | Filter ANS entries by person | `ans_screen.dart:55` |
| 9 | PBL Report | **Team-member dropdown** | Filter PBL entries by person | `PblReport.dart:40` |

**Manager also counts toward two shared buttons** (it is one of several ways to qualify):

| Screen | Button | See |
|---|---|---|
| ANS Report · PBL Report | the **"+"** create button | Section 4.3 |
| Call Booking | the **Visit Entry** tile | Section 4.4 |

> ⚠️ **`rollId == "2"` exists, and it is almost dead.** It appears **once** in the whole app —
> `CallBooking.dart:804` — inside `(rollId == "1" || rollId == "2")`, where it grants exactly
> the same thing as `"1"`. It looks like a second manager tier that was started and never
> finished. Today it unlocks one tile on one screen and nothing else.
>
> ⚠️ **The drawer's manager check is commented out.** `DrawerWidget.dart:165` still carries
> `// DataInfo.rollId.value == "1" &&` above the live ANS Report gate. Someone disabled it and
> left it in place, which is why a manager and a junior executive see an identical menu.

## 4.2 Add-on D — Captain · `tcId == "7"`

**In one line:** *"I run the coaching session, I don't attend it."*

Captain is different from B and E: **most of the time it is not a button at all — it is a
side switch.** Of its 21 uses, 18 are inside Antra Golden Hour, where every session has one
Captain and one Member, both using the same screens.

### Inside AGH — what the switch flips

| What | Captain gets | Member gets | Code |
|---|---|---|---|
| Name shown on a session card | the **member's** name | the **captain's** name | `aghController.dart:423, 485, 513` |
| Check-in slot label | `CAPTAIN` | `MEMBER` | `AGHCheckIn.dart:175` |
| Timestamps read & written | `captain_start` / `captain_end` | `user_start` / `user_end` | `AGHCheckIn.dart:316` · `AGHOutcome.dart:415` |
| Which text box you type into | `captainOutput` | `memberOutput` | `AGHCheckIn.dart:269` |
| Output field hint text | *"what you observed and decisions taken"* | *"what you shared and committed to"* | `AGHCheckIn.dart:269` |
| ChatGPT **Enhance** writes to | `captainOutput` | `memberOutput` | `AGHCheckIn.dart:89` |
| **Previous** button restores | `captainOutput` | `memberOutput` | `AGHCheckIn.dart:97` |
| Which output is submitted | `captainOutput` | `memberOutput` | `aghController.dart:289, 318` |
| Your own row in the upcoming list | **hidden** | shown | `aghController.dart:844` |
| Check-out pending message | *"pending from you"* / *"from {member}"* | *"pending from {captain}"* | `AGHDashboard.dart:834` |
| Total meeting time calculated from | captain timestamps | member timestamps | `AGHOutcome.dart:415` |

> Neither side is "more" than the other. They are two halves of one meeting, and the app
> reuses the same widgets for both. `aghController.dart:946` exposes this as
> `isCurrentUserCaptain`.

### Outside AGH — 3 real buttons

| Screen | Button | Note |
|---|---|---|
| ANS Report | the **"+"** create button | one of several ways to qualify — Section 4.3 |
| PBL Report | the **"+"** create button | same |
| Call Booking | the **Visit Entry** tile | Captain is **required** here, not optional — Section 4.4 |

## 4.3 Add-on E — ANS / PBL Author · `titleId` or `userId`

**In one line:** *"I'm allowed to create entries."*

The smallest add-on in the app. It unlocks **one button, on two screens** — and nothing else.

| Screen | Button | What it opens | Code |
|---|---|---|---|
| ANS Report | the **"+"** in the top bar | Create ANS screen | `ans_screen.dart:37-44` |
| PBL Report | the **"+"** in the top bar | Create PBL screen | `PblReport.dart:32-33` |

### The full "+" rule — any ONE of these is enough

```
rollId  == "1"                       ← B · Manager
tcId    == "7"                       ← D · Captain
titleId == "24" or "25" or "26"      ← E · by designation
userId  == "176" or "177" or "365"   ← E · three named people
```

So the "+" button is shared by **three different add-ons**. Role E is the part that is
*only* about this button — a user who is neither Manager nor Captain, but still allowed to
create, because of their designation or because their id is written into the source.

| Role E is granted by | Values | Meaning |
|---|---|---|
| `titleId` | `"24"`, `"25"`, `"26"` | Three designations. **Nobody has documented which three.** |
| `userId` | `"176"`, `"177"`, `"365"` | Three named individuals, hardcoded |

> ⚠️ The same 8-condition expression is copy-pasted into both files — see Section 6, risk 6.
> Three user ids are hardcoded — see Section 6, risk 5.

## 4.4 The one button that needs three add-ons at once

The **Visit Entry** tile on Call Booking (`CallBooking.dart:803-806`) is the most gated
control in the app. All four conditions must be true together:

```dart
(rollId == "1" || rollId == "2")   // B · Manager (or the near-dead tier 2)
  && desCat == "L1"                 // A · L1 Executive
  && tcId   == "7"                  // D · Captain
  && data['SUPCNT'] == "Yes"        // the call's own data, not a role
```

An L1 Manager who is also a Captain, looking at a call already marked `SUPCNT == "Yes"`.
In practice almost nobody sees this tile.

## 4.5 Add-on summary

| Add-on | Field | Screens touched | What it really gives you |
|---|---|---|---|
| **B** · Manager | `rollId == "1"` | 6 | Team pickers and approvals |
| **D** · Captain | `tcId == "7"` | 7 AGH + 3 others | The captain side of a session |
| **E** · ANS / PBL Author | `titleId` / `userId` | 2 | One "+" button |

**Verified counts** — live comparisons in `lib/`, commented-out code excluded:

| Field | Live | Commented out |
|---|---:|---:|
| `desCat` | 35 | 2 |
| `tcId` | 21 | 0 |
| `rollId` | 13 | 3 |
| `titleId` | 6 | 0 |
| `userId` | 6 | 0 |
| **Total** | **81** | **5** |

---

# 5. Developer reference

## 5.1 The five flags — where they come from

All five are set **once, at login**, from the server's `LOGIN` response, and live in
`lib/Constants/dataInfo.dart` as globals every screen reads directly.

*Set in:* `LoginController.dart:135-149` and `authController.dart:156-163`

| Flag | Server field | Values in code | Decides | Role |
|---|---|---|---|---|
| `DataInfo.desCat` | `DESCAT` | `"L1"` / anything else | Department — sales vs support | **A** / **C** |
| `DataInfo.rollId` | `ROLLID` | `"1"`, `"2"` | Seniority — `1` = manager | **B** |
| `DataInfo.tcId` | `TCID` | `"7"` | Captain | **D** |
| `DataInfo.titleId` | `TITLEID` | `"24"`, `"25"`, `"26"` | Designation | **E** |
| `DataInfo.userId` | `UID` | `"176"`, `"177"`, `"365"` | Three hardcoded people | **E** |

`desCat` is the only flag that decides **whether a screen exists** for a user. The other four
decide **what is drawn inside** a screen the user can already open.

Note that `userId` is doing double duty: it is the session's user id on every API call, *and*
— for three specific values — a permission flag. Nothing in the code marks it as the latter.

Also derived: `DataInfo.showData = (desCat == "L1")`.

## 5.2 Every role check in the codebase — 81 live comparisons

Counted by occurrence, not by line — a single line can hold several. Commented-out code is
excluded (there are 5 more in comments: `desCat` ×2, `rollId` ×3).

### `desCat == "L1"` — 35 occurrences

| File | Line | Guards |
|---|---|---|
| `Drawer/DrawerWidget.dart` | 114 | Antra Golden Hour menu item |
| `Drawer/DrawerWidget.dart` | 166 | ANS Report menu item |
| `Drawer/DrawerWidget.dart` | 175 | PBL Report menu item |
| `Drawer/DrawerWidget.dart` | 246 | My Customer Call menu item |
| `Dashboard/Dashboard.dart` | 104 | legacy dashboard section |
| `Dashboard/DashboardNew.dart` | 643, 723, 802 | tab page-jump *(inverted: `!= "L1"`)* |
| `Dashboard/DashboardNew.dart` | 880 | chart widget *(inverted)* |
| `Dashboard/DashboardNew.dart` | 1027 | Data Points shortcut |
| `Report/Reports.dart` | 63, 122 | two report card groups |
| `TicketStatus/TicketStatus.dart` | 36 | user filter dropdown |
| `CallBooking/CallBooking.dart` | 212, 331, 527, 588, 805, 908 | check-in, info, approval, visit entry, notes |
| `CallBooking/CallBookingL2.dart` | 530, 586 | approve icon, visit-entry icon |
| `CallBooking/SupportDetails.dart` | 77, 90 | Observation, Requirement fields |
| `CallBooking/AddSupportEntry.dart` | 642 | observation input block |
| `Lead/UpdateLead.dart` | 15 | screen title |
| `Lead/LeadReceived.dart` | 16 | screen title |
| `Controller/leadController.dart` | 13 | default lead filter |
| `Controller/callBookingController.dart` | 74, 451 | branch + **payload encoding** |
| `Controller/dashboardController.dart` | 138, 569 | target + opportunity sections |

### `rollId` — Manager — 13 occurrences

Twelve are `== "1"`; one is `== "2"` (`CallBooking.dart:804`). Full walkthrough in Section 4.1.

| File | Line | Guards |
|---|---|---|
| `Dashboard/Dashboard.dart` | 32 | team-member picker |
| `Report/LeaveStatus.dart` | 19 | team-member picker + approve / reject |
| `ANS/ans_screen.dart` | 37, 55 | create button, team dropdown |
| `PblReport/PblReport.dart` | 32, 40 | create button, team dropdown |
| `CallBooking/CallBooking.dart` | 31, 206, 803, **804** | filter, edit check-in, visit entry *(804 is the lone `== "2"`)* |
| `CallBooking/CallBookingL2.dart` | 26, 436, 530 | team filter, edit check-in, approve icon |

*Plus 3 commented out:* `DrawerWidget.dart:165` · `CallBooking.dart:1236, 1348`.

### `tcId == "7"` — Captain — 21 occurrences

**18 inside AGH**, 3 outside. Full walkthrough in Section 4.2.

| File | Line | Guards |
|---|---|---|
| `Controller/aghController.dart` | 289, 318, 423, 485, 513, 844, 946 | which output is saved/read, whose name shows, own-record filter, `isCurrentUserCaptain` |
| `AGH/AGHCheckIn.dart` | 89, 97, 175, 269, 282, 316 | enhance target, previous-output target, slot label, output field, output length, check-out timestamps |
| `AGH/AGHDashboard.dart` | 102, 562, 834, 848 | card layout, session card, pending-from label |
| `AGH/AGHOutcome.dart` | 415 | total meeting time |
| `ANS/ans_screen.dart` | 38 | create button |
| `PblReport/PblReport.dart` | 32 | create button |
| `CallBooking/CallBooking.dart` | 806 | Visit Entry tile |

### `titleId ∈ {24, 25, 26}` — 6 occurrences

`ans_screen.dart:39, 40, 41` · `PblReport.dart:32` ×3 — the ANS / PBL "+" button only. Section 4.3.

### `userId ∈ {176, 177, 365}` — 6 occurrences

`ans_screen.dart:42, 43, 44` · `PblReport.dart:33` ×3 — the ANS / PBL "+" button only. Section 4.3.

---

# 6. Risks — in priority order

### Risk 1 — A manager's role is overwritten, not layered

`dashboardController.dart:110-111` replaces `desCat` with the selected team member's value.
The manager's own identity is destroyed for the rest of the session.

**Fix:** hold the viewed user separately (`viewingUserId`, `viewingDesCat`) and never mutate
the logged-in user's own flags.

### Risk 2 — The same endpoint is encoded differently per role

`callBookingController.dart:451`

```dart
data: desCat == "L1" ? Uri.encodeComponent(callBookingData)   // L1 → encoded
                     : callBookingData                        // support → raw
```

A support user whose booking text contains `&`, `#` or `+` sends a corrupted payload.

**Fix:** always encode.

### Risk 3 — Hidden is not the same as protected

`RECOMMENDATION` and `REQUIREMENT` on Support Details, and the whole staff directory on
Contacts, are **returned to every user** and merely not rendered.

**Fix:** filter server-side if the data is genuinely restricted. If it isn't, drop the UI
gate so the app stops implying a protection that doesn't exist.

### Risk 4 — No role is ever sent to the server

Of ~101 API calls, exactly **one** sends a role (`SAVEAGH`). `APPROVELEAVE`, `CALLAPROVE`,
`ACTTCKUPDATE` and `OPPSTATUSUPDATE` carry only a user id.

**All role enforcement in this app is UI-only.** A modified client, or a direct URL, performs
a manager action with an executive's credentials.

**Fix:** confirm with the backend team that the server validates `UID` against its own
permission table. The app is not helping.

### Risk 5 — Permissions hardcoded to three named people

`ans_screen.dart:42-44` and `PblReport.dart:32` grant rights to `userId` `176`, `177`, `365`.
A personnel change requires an app release.

**Fix:** a server-driven permission flag on the `LOGIN` response.

### Risk 6 — The ANS / PBL permission expression is duplicated

The same 8-condition expression is copy-pasted into two files. They match today; the next
edit to one will silently diverge.

**Fix:** one shared getter.

### Risk 7 — "L3" does not exist

If the business expects three tiers, the third was never built.

**Fix:** decide whether L3 is real. If it is, it needs a check. If it isn't, stop using the
word in specs and tickets.

---

# 7. What good would look like

Replace the five scattered globals with one object:

```dart
class UserPermissions {
  final String department;   // A / C — was desCat == "L1"
  final bool   isManager;    // B     — was rollId == "1"
  final bool   isCaptain;    // D     — was tcId   == "7"
  final Set<String> grants;  // E     — from the server: {"ANS_CREATE", "PBL_CREATE", ...}

  bool can(String grant) => grants.contains(grant);
}
```

Note how the five roles collapse into **three fields plus a grant set**. Role **E** stops
being a list of magic numbers and becomes what it always was: a set of grants.

Call sites then read as intent instead of magic numbers:

```dart
// today
if (DataInfo.rollId.value == "1" || DataInfo.tcId.value == "7" ||
    DataInfo.titleId.value == "24" || DataInfo.userId.value == "176") { ... }

// instead
if (perms.can("ANS_CREATE")) { ... }
```

Because `grants` comes from the server, permission changes ship **without an app release** —
which removes Risk 5 and Risk 6 outright.

---

*What each screen calls: `API-QUICK-REFERENCE.md` · Full technical detail: `API-DOCUMENTATION.md`*
