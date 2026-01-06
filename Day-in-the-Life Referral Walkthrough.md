### Day-in-the-Life Referral Walkthrough

*(Admin + Operations Perspective)*

This walkthrough illustrates how a referral moves through the system and how **admins and operations teams experience the process**, even when parts of it occur automatically.

---

## Scenario Overview

A new referral is submitted to the Faculty Practice Group for processing.

Participants:

* **Operations User** (FPG staff)
* **Administrator** (Salesforce admin / analyst)
* **System Automation** (Flow + Apex)

---

## Step 1: Referral Enters the System

**What Happens**

* A referral record (`Referral__c`) is created.
* The referral is automatically assigned an initial status of **New**.

**What Ops Sees**

* A new referral appears in their list view or queue.
* The status is clear and expected.

**What Admins Should Know**

* No manual action is required.
* Entry conditions for automation are visible in the Record-Triggered Flow.

---

## Step 2: Automated Validation Runs

**What Happens (Behind the Scenes)**

* The system checks for required data (e.g., referral type, source).
* This logic runs automatically via Flow.

**What Ops Sees**

* The referral may remain in *New* briefly or move forward.
* No confusing system messages or silent failures.

**What Admins Should Know**

* Validation rules are declarative.
* Adjustments can be made safely in Flow without code changes.

---

## Step 3: Exception Detected (If Applicable)

**What Happens**

* Required information is missing.
* The system:

  * Flags the referral as an exception
  * Updates the status to **Awaiting Info**
  * Creates a `Referral_Event__c` record explaining why

**What Ops Sees**

* A clear exception indicator
* A readable explanation of what’s missing
* A predictable status change

**What Admins Should Know**

* Exceptions are never silent.
* Every exception creates an auditable event.
* The reason is visible and reportable.

---

## Step 4: Referral Corrected & Updated

**What Happens**

* Ops staff updates the referral with missing information.
* The system re-evaluates the referral automatically.

**What Ops Sees**

* Status transitions forward (e.g., *Validated*).
* Confidence that the system responded correctly.

**What Admins Should Know**

* The same Flow handles both initial intake and updates.
* No duplicate logic is required.

---

## Step 5: Referral Progresses Normally

**What Happens**

* The referral moves through defined lifecycle stages.
* Each meaningful change creates an event record.

**What Ops Sees**

* A clean timeline view (via LWC)
* Confidence in where the referral stands

**What Admins Should Know**

* Status transitions reflect real process steps.
* Reporting can rely on consistent status meaning.

---

## Step 6: Troubleshooting (If Needed)

**Admin Troubleshooting Path**

1. Review the referral’s current status
2. Check `Referral_Event__c` records for history
3. Inspect Flow logic if behavior needs adjustment

**Key Point**
Admins do not need to inspect Apex code to understand most behavior.

---

## Final Takeaway for Admins & Ops

* Ops teams always know **what state a referral is in and why**
* Admins always know **where logic lives and how to change it**
* The system explains itself through data and events

> *When issues arise, the system provides answers—not mysteries.*