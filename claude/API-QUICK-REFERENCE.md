# Karma — API Quick Reference

> **One table per screen. Every API call it makes, and exactly what it sends.**
> No theory — just what each screen asks the server for.
> Full detail: `API-DOCUMENTATION.md` · Who can see what: `ROLE-ACCESS-DOCUMENTATION.md`

---

## How to read this

**Every call in this app uses the same URL.** Only `DATA` and `ACTION` ever change:

```
https://gateway.tallyhelp.com/crm/UpdateData.aspx?DATA=<payload>&ACTION=<name>&ENCKEY=<key>&SRC=KARMA&ISNEW=YES
                                                       ▲              ▲      └─────────┬─────────────────┘
                                              what you send    what you want   identical on every call
```

So each screen below is **just a table**. Take its `ACTION` and `DATA` from the row and drop
them into the template above — that is the full call.

**Example** — the Contact List row says `ANTRAUSER` with no DATA, so the call is:

```
https://gateway.tallyhelp.com/crm/UpdateData.aspx?DATA=&ACTION=ANTRAUSER&ENCKEY=ABC123XYZ&SRC=KARMA&ISNEW=YES
```

**6 screens do not follow the template.** Those — and only those — show their URL in full,
marked ⚠️. They are: Login, Customer Tickets, Ticket Details, Ticket Status Details,
AGH Dashboard, Products.

**Demo values used throughout:**
`ENCKEY`=`ABC123XYZ` · `UID`=`1234` · `UNAME`=`vinod` · `DPID`=`56789` ·
`CALLID`=`9001` · `OPPID`=`4501` · `TICKET`=`TCK00123` · `ENROLLID`=`EMP0042` · `PID`=`7`

**Every screen block has:**

| Line | What it tells you |
|---|---|
| **Reach it:** | How to get to that screen in the running app — tap by tap |
| 🔒 | Shown **only** when a role cannot open the screen at all. No lock = everyone can open it. |
| the table | Every API call the screen makes |

> Navigation paths are taken from the **Karma User Manual (L1 Sales edition, v12.0.35)** and
> verified against the `Get.to(...)` calls in the code.
>
> Screens where a *button or field* is hidden for some roles — but the screen still opens —
> are **not** marked here. That belongs in `ROLE-ACCESS-DOCUMENTATION.md` §3.

**Legend:**

| | |
|---|---|
| `★` | Fires **the moment the screen opens**. The first ★ row is the screen's main call. |
| *(no star)* | Only fires when the user taps something |
| **submit** | Writes to the server, rather than just reading |

---

## Totals

| | Count |
|---|---|
| Screens in the app | **84** |
| Screens that call the server | **57** |
| Screens with **no** API call | **27** |
| Total API calls | **101** |
| Distinct ACTION names | **88** |

---

## All screens at a glance

**59 screens make API calls.** Every row: who can open it, how many calls it makes, and which.

> **On the role columns.** `L1` is ✅ on **every single row** — nothing in this app is hidden
> from an L1 user. The only screens anyone loses are the **7 hidden from support users**.
>
> `L2` and `L3` share one column because **the code does not tell them apart** — both are simply
> "not L1" and take the identical path. There is no L3 check anywhere in the source.
>
> `Captain` (`tcId == "7"`) is **additive**, not a rank — a Captain is still an L1 or a support
> user. It only changes what they see **inside AGH** (marked ✅*).

| # | Page | L1 | L2 / L3 | Captain | Calls | Actions it uses |
|---:|---|:---:|:---:|:---:|:---:|---|
| 1 | Splash Screen | ✅ | ✅ | ✅ | 3 | `APPVERSION` `LOGIN` `REGISTERID` |
| 2 | Login Page | ✅ | ✅ | ✅ | 3 | `LOGIN` `REGISTERID` + *1 legacy* |
| 3 | Home / Dashboard | ✅ | ✅ | ✅ | 11 | `ACHIVEDTARGET` ×2 `SUPDASHBOARD` `LEADDASHBOARD` ×3 `GETOPP` `GETTOPCUSTOMER` `TEAMMEMBER` `GETSUPRANK` `CALLBOOK` |
| 4 | Top Customers ⚠️ | ✅ | ✅ | ✅ | 1 | `GETTOPCUSTOMERDETAILS` |
| 5 | Contact List | ✅ | ✅ | ✅ | 1 | `ANTRAUSER` |
| 6 | Customer List | ✅ | ✅ | ✅ | 1 | `GETDATAPOINT` |
| 7 | Customer 360 | ✅ | ✅ | ✅ | 5 | `GETDPINF` `GETCALLENTRYDATA` `BROCHUREMASTER` `GETUSER` `BROCHEREMAIL` |
| 8 | Create Customer | ✅ | ✅ | ✅ | 3 | `LEADSRC` `EPICMAST` `NEWDATAPOINT` |
| 9 | Contact Details | ✅ | ✅ | ✅ | 2 | `GETUSER` `ADDCONTACT` |
| 10 | Products & Services | ✅ | ✅ | ✅ | 1 | `GETDPPRODUCTINFO` |
| 11 | Recent Activity | ✅ | ✅ | ✅ | 1 | `OPPRECENTACTIVITY` |
| 12 | Tally Serial | ✅ | ✅ | ✅ | 1 | `GETCALLENTRYDATA` |
| 13 | Visit History | ✅ | ✅ | ✅ | 1 | `CALLENTRYDETAILS` |
| 14 | Delivery Request ⚠️ | ✅ | ✅ | ✅ | 1 | `DELIVERYREQDATA` |
| 15 | Customer Tickets | ✅ | ✅ | ✅ | 1 | `GETSUPPALLTICKET` |
| 16 | Book a Call | ✅ | ✅ | ✅ | 3 | `GETCALLENTRYDATA` `L1USER` `CALLENTRY` |
| 17 | Call Booking | ✅ | ✅ | ✅ | 7 | `CALLBOOK` `TEAMMEMBER` `ISWORKSHOP` `DELETECALLBOOK` `CALLAPROVE` `GETCALLEDESC` `CHKINOUTDATA` |
| 18 | Call Booking L2 | ✅ | ✅ | ✅ | 5 | `CALLBOOK` `TEAMMEMBER` `CALLAPROVE` `GETCALLEDESC` `CHKINOUTDATA` |
| 19 | Call Booking Details | ✅ | ✅ | ✅ | 3 | `CALLBOOK` `CHKINOUTDATA` `ISWORKSHOP` |
| 20 | Add Support Entry | ✅ | ✅ | ✅ | 5 | `CATEGORYTYPE` `UPDATECALL` + *3 ChatGPT (external)* |
| 21 | Conveyance Entry (travel expense) | ✅ | ✅ | ✅ | 7 | `GETSOURCE` `CALLBOOK` `GETCONVAYANCE` `DELETECONVAYANCE` `PASSCONV` `PETROLRATE` `SETCONVAYANCE` |
| 22 | PIW / Workshop Form | ✅ | ✅ | ✅ | 2 | `WORKSHOPMST` `SAVEWORKSHOPREF` |
| 23 | Support List | ✅ | ✅ | ✅ | 1 | `EXISTSUPENTRY` |
| 24 | Support Details | ✅ | ✅ | ✅ | 1 | `SUPENTRY` |
| 25 | Create Lead | ✅ | ✅ | ✅ | 4 | `LEADSRC` ×2 `GETTALLYSRLOC` `NEWLEAD` |
| 26 | Lead | ✅ | ✅ | ✅ | 1 | `LEADDASHBOARD` |
| 27 | Lead Received | ✅ | ✅ | ✅ | 3 | `LEADLIST` `TCKLEADSTYPE` `LEADTICKET` |
| 28 | Create Lead 1 | ✅ | ✅ | ✅ | 2 | `LEADSRC` `NEWLEAD` |
| 29 | Update Lead | ✅ | ✅ | ✅ | 2 | `GIVENLEAD` `UPDATELEAD` |
| 30 | Opportunity Details | ✅ | ✅ | ✅ | 1 | `GETOPP` |
| 31 | Opportunity Data | ✅ | ✅ | ✅ | 3 | `OPPRECENTACTIVITY` `PROPOSALLIST` `PREFORMAINVOIC` |
| 32 | Change Status | ✅ | ✅ | ✅ | 2 | `CLOSEREASONMAST` `OPPSTATUSUPDATE` |
| 33 | Update Opportunity | ✅ | ✅ | ✅ | 2 | `PROPOSALSOURCE` `GETCALLENTRYDATA` |
| 34 | Antra Ticket System | ✅ | ✅ | ✅ | 1 | `GETANTRATICKET` |
| 35 | Create Ticket | ✅ | ✅ | ✅ | 2 | `GETTCKMAST` `ANTRATICKET` |
| 36 | Remark List | ✅ | ✅ | ✅ | 1 | `ANTRATICKETREMARK` |
| 37 | Ticket Status | ✅ | ✅ | ✅ | 2 | `GETSUPPALLPENDTICKET` `ACTTCKUPDATE` |
| 38 | Ticket Details | ✅ | ✅ | ✅ | 1 | `TICKETDETAILS` |
| 39 | Ticket Status Details | ✅ | ✅ | ✅ | 1 | `TICKETDETAILS` |
| 40 | Support Availability ⚠️ | ✅ | ✅ | ✅ | 1 | `AVAILABLEUSER` |
| 41 | **My Customer Call** | ✅ | ❌ | ✅ | 2 | `MYCALLDTLS` `SUPCALLCANCEL` |
| 42 | Leave Report | ✅ | ✅ | ✅ | 3 | `ATTENDANCE` `ANTRAHOLIDAY` `CREATELEAVE` |
| 43 | Holidays List | ✅ | ✅ | ✅ | 1 | `ANTRAHOLIDAY` |
| 44 | Leave Status | ✅ | ✅ | ✅ | 5 | `TEAMMEMBER` `GETLEAVEDATA` `DELETELEAVE` `UPDATELEAVE` `APPROVELEAVE` |
| 45 | Conveyance Report | ✅ | ✅ | ✅ | 2 | `GETUSERDITAILS` `CONVREPORT` |
| 46 | **Target Report** | ✅ | ❌ | ✅ | 2 | `TEAMMEMBER` + *1 action passed in at runtime* |
| 47 | Outstanding | ✅ | ✅ | ✅ | 1 | `USEROUTSTANDING` |
| 48 | Epicenter Details | ✅ | ✅ | ✅ | 1 | `GETEPCDATA` |
| 49 | Epicenters Page 2 | ✅ | ✅ | ✅ | — | *none* |
| 50 | Escalation — Internal | ✅ | ✅ | ✅ | 2 | `ESCALATIONMST` `SAVEESCALATION` |
| 51 | Escalation — From Ticket | ✅ | ✅ | ✅ | 3 | `ESCALATIONMST` `DPTICKETINFO` `SAVEESCALATION` |
| 52 | **AGH Dashboard** | ✅ | ❌ | ✅* | 4 | `GETAGH` `GETTOPIC` `AGHSCHEDULE` `SAVEAGH` |
| 53 | **ANS Report** | ✅ | ❌ | ✅ | 2 | `GETANS` `ANSUSER` |
| 54 | **Create ANS** | ✅ | ❌ | ✅ | 2 | `ANSUSER` `ANS` |
| 55 | **PBL Report** | ✅ | ❌ | ✅ | 2 | `GETPBL` `ANSUSER` |
| 56 | **Create PBL** | ✅ | ❌ | ✅ | 2 | `ANSUSER` `ANS` |
| 57 | Products | ✅ | ✅ | ✅ | 4 | `GETMODULELIST` `GETAPPLIST` `GETBOOSTERCAT` `GETBOOSTERLIST` |
| 58 | Edit Profile | ✅ | ✅ | ✅ | 2 | `UPDATEUSERDETAILS` + *1 legacy (image)* |
| 59 | Notifications | ✅ | ✅ | ✅ | — | `AGH` `JSON` `URL` `UID` `UNAME` `DPID` `PID` `ENROLLID` `ENCKEY` |

**⚠️ = unreachable** — the screen makes API calls but nothing in the app navigates to it:
Top Customers, Delivery Request, Support Availability *(its `Get.to` is commented out)*.

**❌ = hidden from support users** — Antra Golden Hour, ANS Report, Create ANS, PBL Report,
Create PBL, My Customer Call, Target Report.

*Counts are per screen. Screens that share a controller (Call Booking / Call Booking L2,
the AGH screens) repeat the same underlying call, so these add up to more than the
**101 call sites** that exist in the code.*

---

# Login & startup

### Splash Screen · `SplashScreen.dart` · 3 calls

**Reach it:** App launch — shows while Karma checks the version and signs you in

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `APPVERSION` | `10.0.0` | Checks if an update exists |
| ★ `LOGIN` | `{"USER":"vinod","PWD":"pass@123","VERSION":"536","DEVICETYPE":"ANDROID"}` | Auto-login with saved details |
| `REGISTERID` | `{"TOKEN":"fcm_abc...","DEVICEID":"...","MODEL":"..."}` | Registers phone for notifications |

### Login Page · `LoginPage.dart` · 3 calls

**Reach it:** App launch, first time or after Logout

```
⚠️ THIS SCREEN'S URL IS DIFFERENT — ENCKEY is empty (no session yet):
https://gateway.tallyhelp.com/crm/UpdateData.aspx?DATA=%7B%22USER%22%3A%22vinod%22%2C%22PWD%22%3A%22pass%40123%22%2C%22VERSION%22%3A%22536%22%2C%22DEVICETYPE%22%3A%22ANDROID%22%7D&ACTION=LOGIN&ENCKEY=&SRC=KARMA&ISNEW=YES

DATA before URL-encoding:
{"USER":"vinod","PWD":"pass@123","VERSION":"536","DEVICETYPE":"ANDROID"}
```| ACTION | DATA sent | What it does |
|---|---|---|
| `LOGIN` | the JSON above, URL-encoded | **submit** — signs in |
| `REGISTERID` | `{"TOKEN":"fcm_abc...","DEVICEID":"..."}` | Registers the device |
| *(legacy)* | device info | Registration follow-up |

> **Yes — the app has a real login.** Username and password are issued by your reporting
> manager. There is **no sign-up screen and no forgot-password link**. With *Remember Me*
> ticked the credentials are stored in the phone's secure keychain and Karma signs in
> automatically on every launch. A login is tied to one handset — a second device gives
> "Cannot login in this device" until a manager releases it. *(User Manual §2)*
>
> `LOGIN` fills every global used afterwards — `UID`, `ENCKEY`, `DESCAT`, `ROLLID`, `TCID`, `TITLEID`.
> `ENCKEY` is empty on this one call, because you don't have a session yet.

---

# Home

### Home / Dashboard · `DashboardNew.dart` · 11 calls ← heaviest screen

**Reach it:** Where you land after signing in

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `ACHIVEDTARGET` | `{"UID":"1234","PID":"7","UNAME":"vinod"}` | Target achieved |
| ★ `ACHIVEDTARGET` | *(same again)* | Second target widget |
| ★ `SUPDASHBOARD` | `{"UID":"1234","PID":"7","UNAME":"vinod","ENROLLID":"EMP0042","REQTYPE":"MONTH"}` | Support counts |
| ★ `LEADDASHBOARD` | `{"UID":"1234","LEADTYPE":"GIVEN"}` | Leads given |
| ★ `GETOPP` | `{"UID":"1234","DPID":""}` | Open opportunities |
| ★ `GETTOPCUSTOMER` | `{"UID":"1234"}` | Top customers |
| ★ `LEADDASHBOARD` | `{"UID":"1234"}` | Lead counts |
| ★ `TEAMMEMBER` | `1234` | Team dropdown (managers) |
| ★ `GETSUPRANK` | `{"UNAME":"vinod","REQTYPE":"MONTH"}` | Support ranking |
| ★ `CALLBOOK` | `vinod` | Today's booked calls |
| `LEADDASHBOARD` | `{"UID":"1234","LEADTYPE":"GIVEN"}` | Refresh after an action |

> 10 of these fire on a single screen open. `LEADDASHBOARD` runs 3× and `ACHIVEDTARGET` 2×.

### Top Customers · `top_list.dart` · 1 call

**Reach it:** **UNREACHABLE** — nothing in the app navigates here

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETTOPCUSTOMERDETAILS` | `{"UID":"1234"}` | Top-customer detail list |

---

# Contacts

### Contact List · `Contacts.dart` · 1 call

**Reach it:** Menu ☰ → Contact List

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `ANTRAUSER` | *(nothing)* | Whole company staff directory |

> Search does **not** call the server — it filters the list already downloaded.

---

# Customers ("Data Point")

> `DPID` = customer id.

### Customer List · `DataPoints.dart` · 1 call

**Reach it:** Home → **Datapoint** card

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETDATAPOINT` | `vinod` | Customers assigned to this user |

### Customer 360 · `DataPointInfo.dart` · 5 calls

**Reach it:** Home → Datapoint card → tap a customer  ·  or Home → **Datapoint Search**

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETDPINF` | `{"DPID":"56789"}` | Customer master record |
| ★ `GETCALLENTRYDATA` | `56789` | Visit & call history |
| ★ `BROCHUREMASTER` | *(nothing)* | Brochure dropdown |
| ★ `GETUSER` | `56789` | Contact people there |
| `BROCHEREMAIL` | brochure id + email | **submit** — emails a brochure |

> The first four fire together in parallel on open.

### Create Customer · `CreateDataPoint.dart` · 3 calls

**Reach it:** Home → Datapoint card → **+** (top bar)

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `LEADSRC` | *(nothing)* | Lead-source dropdown |
| ★ `EPICMAST` | `{"UID":"1234"}` | Epicenter dropdown |
| `NEWDATAPOINT` | the form fields — **see below** ↓ | **submit** — creates the customer |

`NEWDATAPOINT` payload:

```json
{"MOBILE":"9876543210","EMAIL":"a@b.com","TALLYUSE":"Yes","URT":"1","WEBSITE":"",
 "TALLYSRNO":"790012345","LOCATION":"Ahmedabad","PRODUCT":"Prime","EPICID":"12","LDSRC":"3"}
```

### Contact Details · `ContactDetails.dart` · 2 calls

**Reach it:** Customer record → **Contact Details** tile

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETUSER` | `56789` | Contacts at this customer |
| `ADDCONTACT` | name, mobile, email, designation | **submit** — adds a contact |

### Products & Services · `ProductAndServices.dart` · 1 call

**Reach it:** Customer record → **Live Products** tile

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETDPPRODUCTINFO` | `{"DPID":"56789"}` | What this customer owns |

### Recent Activity · `RecentActivity.dart` · 1 call

**Reach it:** Customer record → **Recent Activity** tile

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `OPPRECENTACTIVITY` | `{"OPPID":"0","DPID":"56789"}` | Activity log |

### Tally Serial · `TallySerial.dart` · 1 call

**Reach it:** Customer record → **Tally Serial Number** tile

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETCALLENTRYDATA` | `56789` | Serial / call entry data |

### Visit History · `VisitHistory.dart` · 1 call

**Reach it:** Customer record → **FT History** tile

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `CALLENTRYDETAILS` | `vinod\|56789` | All visits to this customer |

### Delivery Request · `DeliveryRequest.dart` · 1 call

**Reach it:** **UNREACHABLE** — nothing in the app navigates here

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `DELIVERYREQDATA` | `{"UID":"1234"}` | Delivery requests |

### Customer Tickets · `Tickets.dart` · 1 call

**Reach it:** Customer record → **Tickets** tile

```
⚠️ THIS SCREEN'S URL IS DIFFERENT — other host, and no "ACTION=" at all:
https://gateway.tallyhelp.com/crm/CustomerApp.aspx?data=GETSUPPALLTICKET|30|56789&ENCKEY=ABC123XYZ&SRC=KARMA
```| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETSUPPALLTICKET` | `GETSUPPALLTICKET\|30\|56789` | Last 30 days of tickets |

### Book a Call · `CallBookingPage.dart` · 3 calls

**Reach it:** Customer record → **Call Booking** tile — *the only place a visit can be created*

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETCALLENTRYDATA` | `56789` | Existing entries |
| ★ `L1USER` | *(nothing)* | "Assign to" dropdown |
| `CALLENTRY` | `vinod\|56789\|2026-09-02\|...` | **submit** — books the call |

---

# Call Booking

### Call Booking · `CallBooking.dart` · 7 calls

**Reach it:** Home → **Call Booking** card

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `CALLBOOK` | `1234` | Booked-call list |
| ★ `TEAMMEMBER` | `1234` | Team filter (managers) |
| `ISWORKSHOP` | `{"DPID":"56789","CALLID":"9001"}` | Is it a workshop? |
| `DELETECALLBOOK` | `{"CALLID":"9001"}` | **submit** — deletes a booking |
| `CALLAPROVE` | `{"CALLID":"9001","STATUS":"Yes"}` | **submit** — approves a call |
| `GETCALLEDESC` | `{"CALLID":"9001"}` | Notes on a call |
| `CHKINOUTDATA` | `9001\|IN\|2026-09-02 10:15\|23.02,72.57` | **submit** — check in / out |

### Call Booking L2 · `CallBookingL2.dart` · 5 calls

**Reach it:** Home → Call Booking card *(the support-track version of the same screen)*

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `CALLBOOK` | `1234` | Booked-call list |
| ★ `TEAMMEMBER` | `1234` | Team dropdown |
| `CALLAPROVE` | `{"CALLID":"9001","STATUS":"Yes"}` | **submit** — approves |
| `GETCALLEDESC` | `{"CALLID":"9001"}` | Call notes |
| `CHKINOUTDATA` | `9001\|OUT\|2026-09-02 12:40\|...` | **submit** — check in / out |

### Call Booking Details · `CallBookingDetails.dart` · 3 calls

**Reach it:** Home → Call Booking card → tap a visit

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `CALLBOOK` | `1234` | The booking list |
| `CHKINOUTDATA` | `9001\|IN\|...` | **submit** — check in / out |
| `ISWORKSHOP` | `{"DPID":"56789","CALLID":"9001"}` | Show workshop form? |

### Add Support Entry · `AddSupportEntry.dart` · 5 calls

**Reach it:** Visit → **⌄ menu** → Support/Visit History → **+**

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `CATEGORYTYPE` | `vinod` | Category dropdown |
| `UPDATECALL` | call id, remark, observation, requirement | **submit** (POST) — saves the entry |
| *ChatGPT* ×3 | the typed text | Rewrites remark / observation / requirement |

> The 3 ChatGPT calls go to an **external AI service**, not to the CRM server.

### Conveyance Entry (travel expense) · `ConveyanceEntry.dart` · 7 calls

**Reach it:** Visit → **⌄ menu** → Conveyance Entry

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETSOURCE` | *(nothing)* | Travel-source dropdown |
| ★ `CALLBOOK` | `vinod` | Visits to attach the expense to |
| ★ `GETCONVAYANCE` | `1234` | Existing expense entries |
| `DELETECONVAYANCE` | `301` | **submit** — deletes an entry |
| `PASSCONV` | `{"CONVID":"301","STATUS":"Pass"}` | **submit** — approves |
| `PETROLRATE` | *(nothing)* | Current petrol rate |
| `SETCONVAYANCE` | date, km, source, amount | **submit** — saves the claim |

> Server spells it **`CONVAYANCE`**, not "conveyance". Copy it exactly.

### PIW / Workshop Form · `PiwForm.dart` · 2 calls

**Reach it:** Home → Call Booking card → **PIW** button *(only on calls flagged for a workshop)*

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `WORKSHOPMST` | `{"CALLID":"9001"}` | The question list |
| `SAVEWORKSHOPREF` | `{"DATA":[{"QID":"1","ANS":"Yes"}, ...]}` | **submit** (POST) — saves answers |

### Support List · `SupportList.dart` · 1 call

**Reach it:** Visit → **⌄ menu** → Support/Visit History

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `EXISTSUPENTRY` | `9001` | Support entries for a call |

### Support Details · `SupportDetails.dart` · 1 call

**Reach it:** Visit → ⌄ menu → Support/Visit History → tap an entry

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `SUPENTRY` | `9001` | One support entry |

### Create Lead · `CreateLead.dart` · 4 calls

**Reach it:** Visit → **⌄ menu** → Create Lead *(only when the booking has a Tally serial)*

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `LEADSRC` | *(nothing)* | Lead-source dropdown |
| `LEADSRC` | *(nothing)* | **The same call again** |
| `GETTALLYSRLOC` | `{"TALLYSRNO":"790012345"}` | Location from serial no. |
| `NEWLEAD` | company, contact, mobile, source | **submit** — creates the lead |

---

# Leads

### Lead · `Lead.dart` · 1 call

**Reach it:** Home → **Lead** card

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `LEADDASHBOARD` | `{"LEADTYPE":"GIVEN","UID":"1234"}` | Lead list |

> `LEADTYPE` is the on-screen filter uppercased — `GIVEN` or `RECEIVED`.

### Lead Received · `LeadReceived.dart` · 3 calls

**Reach it:** Home → Lead card → tap **Untouched / In progress / Accepted / Rejected**

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `LEADLIST` / `RCVLEADLIST` | `{"USERID":"1234","LEADTYPE":"Given"}` | Given or received leads |
| ★ `TCKLEADSTYPE` | *(nothing)* | Lead-type dropdown |
| `LEADTICKET` | `{"LEADID":"77","LEADTYPE":"2","DESCR":"Follow-up needed"}` | **submit** — lead → ticket |

### Create Lead 1 · `CreateLead1.dart` · 2 calls

**Reach it:** Home → Lead card → **+** (top bar)

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `LEADSRC` | *(nothing)* | Lead-source dropdown |
| `NEWLEAD` | company, contact, mobile, source | **submit** — creates the lead |

### Update Lead · `UpdateLead.dart` · 2 calls

**Reach it:** Home → Lead card → a tile → open a lead

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GIVENLEAD` | `77` | One lead's details |
| `UPDATELEAD` | `77~2~Followed up~1234~56789` | **submit** — updates the status |

> The only call in the app using `~` separators: `leadId ~ status ~ comment ~ userId ~ DPID`.

---

# Opportunity

### Opportunity Details · `OpportunityDetails.dart` · 1 call

**Reach it:** Home → **Opportunity** card  ·  or Customer record → Opportunity tile

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETOPP` | `{"UID":"1234","DPID":""}` from the drawer · `{"UID":"","DPID":"56789"}` from a customer | Opportunity list |

### Opportunity Data · `OpportunityData.dart` · 3 calls

**Reach it:** Opportunity list → open one

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `OPPRECENTACTIVITY` | `{"OPPID":"4501","DPID":"56789"}` | Activity log |
| ★ `PROPOSALLIST` | `{"OPPID":"4501","DPID":"56789"}` | Proposals sent |
| ★ `PREFORMAINVOIC` | `{"OPPID":"4501","DPID":"56789","ISMAIL":"220"}` | Proforma invoice |

> All three fire on open.

### Change Status · `Status.dart` · 2 calls

**Reach it:** Opportunity → open one → **Change Status**

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `CLOSEREASONMAST` | *(nothing)* | Close-reason dropdown |
| `OPPSTATUSUPDATE` | `{"DPID":"56789","OPPID":"4501","STATUS":"Closed","REASONID":"3","REMARK":"Budget not approved","POSDATE":""}` | **submit** — changes status |

### Update Opportunity · `UpdateOpportunity.dart` · 2 calls

**Reach it:** Opportunity → open one → **Update Opportunity**

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `PROPOSALSOURCE` | `{"DPID":"56789"}` | Proposal-source dropdown |
| ★ `GETCALLENTRYDATA` | `56789` | Call entry data |

---

# Tickets

### Antra Ticket System · `Ticket.dart` · 1 call

**Reach it:** Menu ☰ → **Antra Ticket System**

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETANTRATICKET` | `{"uid":"1234","status":"Open"}` | The user's tickets |

### Create Ticket · `CreateTicket.dart` · 2 calls

**Reach it:** Menu ☰ → Antra Ticket System → **+**

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETTCKMAST` | *(nothing)* | Category & subject dropdowns |
| `ANTRATICKET` | `{"categoryid":"12","descr":"Printer not working","uid":"1234","priority":"High","duplicate":"0"}` | **submit** (POST) — raises the ticket |

> This payload uses **lowercase** keys, unlike most of the app.

### Remark List · `RemarkList.dart` · 1 call

**Reach it:** Menu ☰ → Antra Ticket System → a ticket → **Show Remark**

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `ANTRATICKETREMARK` | `{"tckid":"TCK00123"}` | Comments on a ticket |

### Ticket Status · `TicketStatus.dart` · 2 calls

**Reach it:** Menu ☰ → **Ticket Status**

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETSUPPALLPENDTICKET` | `30\|1234` (days\|userId) | Pending tickets |
| `ACTTCKUPDATE` | `TCK00123\|1234` | **submit** — updates a ticket |

### Ticket Details · `TickerDetails.dart` · 1 call

**Reach it:** Home → **⋮** → Search Ticket  ·  or Ticket Status → open a ticket

```
⚠️ THIS SCREEN'S URL IS DIFFERENT — other host, and no "ACTION=" at all:
https://gateway.tallyhelp.com/crm/CustomerApp.aspx?data=TICKETDETAILS|TCK00123|&ENCKEY=ABC123XYZ&SRC=KARMA
```| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `TICKETDETAILS` | `TICKETDETAILS\|TCK00123\|` | One ticket + its full history |

### Ticket Status Details · `TicketStatusDetails.dart` · 1 call

**Reach it:** Menu ☰ → Ticket Status → open a ticket

```
⚠️ THIS SCREEN'S URL IS DIFFERENT — other host, and no "ACTION=" at all:
https://gateway.tallyhelp.com/crm/CustomerApp.aspx?data=TICKETDETAILS|TCK00123|&ENCKEY=ABC123XYZ&SRC=KARMA
```| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `TICKETDETAILS` | `TICKETDETAILS\|TCK00123\|` | Same call, second screen |

---

# Support

### Support Availability · `Support.dart` · 1 call

**Reach it:** **UNREACHABLE** — the drawer opens a web page instead; the `Get.to` is commented out

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `AVAILABLEUSER` | *(nothing)* | Who is free right now |

### My Customer Call · `MyCustomerCall.dart` · 2 calls

**Reach it:** Menu ☰ → My Customer Call  ·  🔒 **L1 only** — not in the support menu

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `MYCALLDTLS` | `{"UID":"1234"}` | This user's customer calls |
| `SUPCALLCANCEL` | `{"CALLID":"9001","REMARK":"Customer unavailable"}` | **submit** — cancels a call |

---

# Reports ("Operations")

### Leave Report · `LeaveReport.dart` · 3 calls

**Reach it:** Menu ☰ → **Operations** → Leave

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `ATTENDANCE` | `EMP0042\|Sep 2026` | Monthly attendance |
| ★ `ANTRAHOLIDAY` | *(nothing)* | Holiday list |
| `CREATELEAVE` | `{"ENROLLID":"EMP0042","FROMDATE":"...","TODATE":"...","REASON":"..."}` | **submit** — applies for leave |

### Holidays List · `HolidaysList.dart` · 1 call

**Reach it:** Menu ☰ → Operations → Leave → **List of Holidays**

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `ANTRAHOLIDAY` | *(nothing)* | Company holidays |

### Leave Status · `LeaveStatus.dart` · 5 calls

**Reach it:** Menu ☰ → Operations → Leave → **Leave Status**

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `TEAMMEMBER` | `1234` | Team dropdown (managers) |
| ★ `GETLEAVEDATA` | `{"ENROLLID":"EMP0042","MONTH":"9","STATUS":"All"}` | Leave records |
| `DELETELEAVE` | `{"LEAVEID":"301"}` | **submit** — cancels a request |
| `UPDATELEAVE` | `{"LEAVEID":"301","FROMDATE":"...","TODATE":"..."}` | **submit** — edits a request |
| `APPROVELEAVE` | `{"LEAVEID":"301","UID":"1234","UNAME":"vinod","STATUS":"Approved","REASON":"OK"}` | **submit** — approves / rejects |

### Conveyance Report · `ConveyReport.dart` · 2 calls

**Reach it:** Menu ☰ → **Operations** → Conveyance

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETUSERDITAILS` | `vinod` | User details *(server-side typo)* |
| ★ `CONVREPORT` | `{"UNAME":"vinod","FROMDATE":"1 Sep 2026"}` | Travel expense report |

### Target Report · `TargetReport.dart` · 2 calls

**Reach it:** Menu ☰ → Operations → **Individual Target / Team Target** (Weekly or Monthly)  ·  🔒 **L1 only** — the target cards are hidden from support users

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ **passed in** `args['action']` | `{"UID":"1234","MONTH":9}` | The report itself |
| ★ `TEAMMEMBER` | `1234` | Team dropdown |

> One screen serves several report types. You cannot tell which endpoint it hits from this file alone.

---

# Outstanding

### Outstanding · `Outstanding.dart` · 1 call

**Reach it:** Home → **View more** → Outstanding card

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `USEROUTSTANDING` | `{"UNAME":"vinod","UID":"1234","UST":"USER"}` | Unpaid customer invoices |

---

# Epicenters

### Epicenter Details · `EpicentersDetails.dart` · 1 call

**Reach it:** Menu ☰ → **Epicenter**

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETEPCDATA` | `{"UID":"1234","UNAME":"vinod"}` | Epicenter data |

### Epicenters Page 2 · `EpicentersPage2.dart` · 0 calls

**Reach it:** Menu ☰ → Epicenter → tap an area

No main call — it filters the list the previous screen already handed it.

---

# Escalation

### Escalation — Internal · `EscalationInternalForm.dart` · 2 calls

**Reach it:** Menu ☰ → **Raise Escalation** → Internal → Continue

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `ESCALATIONMST` | `{"uid":"1234"}` | Categories, areas, users |
| `SAVEESCALATION` | the form fields — **see below** ↓ | **submit** (POST) — raises it |

`SAVEESCALATION` payload:

```json
{"userid":"1234","dpid":"0","exeid":"0","catid":"5","imprid":"2","touserid":"88",
 "subcatid":"0","background":"...","observation":"...","Recommendation":"..."}
```

### Escalation — From Ticket · `EscalationTicketForm.dart` · 3 calls

**Reach it:** Menu ☰ → Raise Escalation → Customer → Continue  ·  or Ticket Status → a ticket → **Raise Escalation**

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `ESCALATIONMST` | `{"uid":"1234"}` | Master data |
| `DPTICKETINFO` | `{"dpid":"56789"}` | That customer's tickets |
| `SAVEESCALATION` | same as above **plus** `"ticket":"TCK00123"`, a real `dpid` and `exeid` | **submit** (POST) — raises it |

---

# Antra Golden Hour (AGH)

### AGH Dashboard · `AGHDashboard.dart` · 4 calls

**Reach it:** Menu ☰ → **Antra Golden Hour**  ·  🔒 **L1 only** — not in the support menu

```
⚠️ THIS SCREEN'S URL IS DIFFERENT — "&ISNEW=YES" is glued onto the ACTION value:
https://gateway.tallyhelp.com/crm/UpdateData.aspx?DATA={"captain_id":"1234"}&ACTION=GETAGH&ISNEW=YES&ENCKEY=ABC123XYZ&SRC=KARMA
```| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETAGH` | `{"captain_id":"1234"}` | This user's AGH sessions |
| ★ `GETTOPIC` | *(nothing)* | Topic list |
| `AGHSCHEDULE` | date, topic, member id | **submit** (POST) — schedules a session |
| `SAVEAGH` | outcome text + `"role":"7"` | **submit** (POST) — saves the outcome |

> `captain_id` always carries the current user's id — even when they are not a captain.
> `SAVEAGH` is the **only** call in the whole app that tells the server the user's role.

The other 6 AGH screens (`AGHCheckIn`, `AGHCompleted`, `AGHMemberLearn`, `AGHNotifications`,
`AGHOutcome`, `AGHScheduleSession`) share this controller and add **no new calls**.

---

# ANS & PBL

### ANS Report · `ans_screen.dart` · 2 calls

**Reach it:** Menu ☰ → **ANS Report**  ·  🔒 **L1 only** — not in the support menu

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETANS` | `{"login_id":"1234"}` | ANS entries |
| `ANSUSER` | `{"login_id":"1234"}` | User dropdown |

### Create ANS · `create_ans_screen.dart` · 2 calls

**Reach it:** Menu ☰ → ANS Report → **+**  ·  🔒 **L1 only** — not in the support menu

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `ANSUSER` | `{"login_id":"1234"}` | User dropdown |
| `ANS` | entry fields | **submit** — saves the entry |

### PBL Report · `PblReport.dart` · 2 calls

**Reach it:** Menu ☰ → **PBL Report**  ·  🔒 **L1 only** — not in the support menu

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETPBL` | `{"login_id":"1234"}` | PBL entries |
| `ANSUSER` | `{"login_id":"1234"}` | User dropdown |

### Create PBL · `create_pbl_screen.dart` · 2 calls

**Reach it:** Menu ☰ → PBL Report → **+**  ·  🔒 **L1 only** — not in the support menu

| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `ANSUSER` | `{"login_id":"1234"}` | User dropdown |
| `ANS` | entry fields | **submit** — saves the entry |

> PBL reuses the ANS endpoints — same backend feature.

---

# Products

### Products · `Products.dart` · 4 calls — all on the **other** URL

**Reach it:** Menu ☰ → **Products**

```
⚠️ THIS SCREEN'S URL IS DIFFERENT — other host, and no ISNEW:
https://gateway.tallyhelp.com/crm/CustomerApp.aspx?DATA=&ACTION=GETMODULELIST&ENCKEY=ABC123XYZ&SRC=KARMA
```| ACTION | DATA sent | What it does |
|---|---|---|
| ★ `GETMODULELIST` | *(nothing)* | Tally modules |
| ★ `GETAPPLIST` | *(nothing)* | Apps |
| ★ `GETBOOSTERCAT` | *(nothing)* | Booster categories |
| `GETBOOSTERLIST\|\|45` | *(action only, no DATA)* | Boosters in a category |

```
https://gateway.tallyhelp.com/crm/CustomerApp.aspx?ACTION=GETBOOSTERLIST||45&ENCKEY=ABC123XYZ&SRC=KARMA
```

---

# Profile

### Edit Profile · `EditProfile.dart` · 2 calls

**Reach it:** Menu ☰ → tap your photo → **pencil** (top right)

| ACTION | DATA sent | What it does |
|---|---|---|
| `UPDATEUSERDETAILS` | `Vinod Sharma\|Sr. Executive\|9876543210\|vinod@antraweb.co.in\|vinod` | **submit** — saves the profile |
| *(legacy)* | image data | Profile picture |

> This screen makes **no call on open** — it fills the form from values already in memory.

---

# Notifications

### Notifications · `NotificationScreen.dart` · 0 CRM calls

**Reach it:** **Bell** icon in the top bar

No main call. Runs on Firebase push plus one raw `http.get`. No `ACTION` is used.

---

# The 27 screens with no API call

They show data handed to them by the previous screen, or are static. **No main call.**

| Group | Screens |
|---|---|
| Customers | Address Details · Data Point Details · Tally Serial Number |
| Call Booking | Cold Calling · Near By Customer |
| Epicenters | Epicenters Page 2 · Epicenter Details 2 · Epicenter Screen |
| Escalation | Choose Type · Success · From Ticket |
| Products | Product Details |
| Reports | Reports (menu) · Monthly Report |
| Profile | Profile |
| Company | Company · Company Details |
| Startup | Onboarding · Sync Progress |
| Other | Data Scope · Drawer |
| AGH | Check In · Completed · Member Learn · Notifications · Outcome · Schedule Session *(share the AGH controller)* |

---

# Payload cheat sheet

Six formats. **Check which one a screen uses before you change it.**

| Format | Example | Screens that use it |
|---|---|---|
| **Empty** | `DATA=` | Contacts · dropdowns · Support |
| **Plain value** | `DATA=vinod` | Customer List · Call Booking · Team dropdowns |
| **Pipe `\|`** | `DATA=vinod\|56789` | Visit History · Attendance · Ticket Status · Edit Profile |
| **Tilde `~`** | `DATA=77~2~text~1234~56789` | Update Lead **only** |
| **JSON** | `DATA={"UID":"1234"}` | most screens |
| **URL-encoded JSON** | `DATA=%7B%22UID%22...` | Login · Create Customer · Update Leave |

> ⚠️ JSON is **not** consistently URL-encoded across the app. If a payload can contain
> `&`, `#` or `+`, un-encoded JSON breaks and the screen silently shows nothing.
> **Always encode when you write new code.**

---

# Where the values come from

Every payload is built from these, set once at login.

| In the payload | Global | Demo |
|---|---|---|
| `UID` · `USERID` · `uid` · `login_id` · `captain_id` | `DataInfo.userId` | `1234` |
| `UNAME` · `USER` | `DataInfo.username` | `vinod` |
| `DPID` | `DataInfo.dpId` | `56789` |
| `PID` | `DataInfo.pid` | `7` |
| `ENROLLID` | `DataInfo.enrollId` | `EMP0042` |
| `ENCKEY` *(every call)* | `DataInfo.encKey` | `ABC123XYZ` |
| `role` *(AGH only)* | `DataInfo.tcId` | `7` |

---

*Full detail, response shapes and engineering notes: `API-DOCUMENTATION.md`.*
*Who can see which screen: `ROLE-ACCESS-DOCUMENTATION.md`.*
