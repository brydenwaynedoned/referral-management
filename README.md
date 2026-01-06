### Faculty Practice Group Referral Intake & Exception Management
*(Version 2.3)*

**Salesforce Reference Implementation**

---

## 1. Pattern Consistency, Security & Compliance Statement

*(Expanded for Admin & Power User Transparency)*

This repository intentionally adheres to **Salesforce platform best practices**, **enterprise software engineering standards**, and **healthcare-aligned security and compliance principles**, including HIPAA-aware design considerations.

Although this reference implementation does not process real patient data, it was designed under the assumption that it would operate within a **regulated academic medical center environment**, such as UCLA Health.

### Why This Matters for Admins & Power Users

In healthcare Salesforce implementations, administrators and power users are often responsible for:

* Maintaining business logic over time
* Supporting operational teams
* Troubleshooting unexpected behavior
* Ensuring compliance and auditability

For that reason, this solution was intentionally designed so that:

* **Core business logic is visible and explainable**
* **System behavior is predictable**
* **Automation does not “hide” critical decisions**
* **Changes can be made safely without developer intervention whenever possible**

This README is written to provide **multiple layers of understanding**, so that:

* Admins can understand *what the system is doing and why*
* Power users can understand *how their actions affect downstream behavior*
* Developers can understand *where complexity lives and where it does not*

---

### Core Design Principles Applied

Across the entire solution, the following principles were enforced:

* **Declarative-first automation**
  Business rules and workflow decisions are implemented in Flow whenever feasible, allowing administrators to understand, adjust, and evolve logic over time.

* **Intentional Apex usage**
  Code exists only where declarative tools would become unclear, unsafe, or difficult to maintain.

* **Separation of concerns**
  Each layer of the system has a clearly defined role, preventing overlap and confusion.

* **Explicit error handling and traceability**
  The system always records *what happened* and *why*, rather than failing silently.

* **Least privilege security model**
  Access and execution are constrained intentionally to reduce risk.

> **Key takeaway for Admins:**
> You do not need to understand Apex to understand how this system behaves.

---

## 2. Institutional Context & Alignment (UCLA Health)

*(Expanded for Operational Understanding)*

This reference implementation was designed with the operational realities of a large **academic medical center** in mind, including organizations such as UCLA Health.

### How This Context Shapes the Design

In environments like UCLA Health:

* Faculty Practice Group (FPG) workflows are **high-impact and physician-facing**
* Referral delays directly affect **patient access and provider trust**
* Operational teams require **clarity, not complexity**
* Systems must support **frequent policy and process change**
* Salesforce often operates alongside **Epic and other clinical platforms**

Because of this, the system was designed so that:

* **Admins can modify workflows without fear of unintended side effects**
* **Operational users can see what is happening, even if they cannot change it**
* **Technical complexity is isolated away from daily operations**

This README explicitly calls out:

* What admins and power users *can change*
* What happens automatically *outside their direct control*
* Where to look when something behaves unexpectedly

> *The goal is to make system behavior understandable even when it cannot be directly edited.*

---

## 3. Problem Statement

*(Rewritten with Process Flow Transparency)*

Faculty Practice Group operations teams rely on timely and accurate referral intake to coordinate care, support physicians, and maintain operational efficiency.

In many real-world environments, referral workflows suffer from:

* Incomplete or inconsistent data at intake
* Unclear ownership during processing
* Limited visibility into referral status
* Manual exception handling and follow-up

### Why These Problems Persist

These issues often persist because:

* Business rules are scattered across multiple automations
* Exceptions are handled informally or outside the system
* Status fields lack consistent meaning
* Admins cannot easily see *why* a referral ended up in a given state

### How This Solution Addresses the Problem

This reference implementation introduces a **clear, layered process flow**:

1. **A referral enters the system**
   Admins and power users can see the initial state immediately.

2. **Validation and decision-making occur automatically**
   Most logic is visible in Flow, not hidden in code.

3. **Exceptions are explicitly flagged and explained**
   No silent failures; every exception creates an event record.

4. **State transitions are intentional and traceable**
   Status changes always reflect a meaningful process step.

5. **Operational visibility is preserved**
   Power users can understand *what happened* even if they did not initiate it.

### What This Means for Admins & Power Users

* You can confidently answer:
  *“Why is this referral in this state?”*

* You can identify whether an issue is:

  * A configuration decision
  * A data quality issue
  * A true exception requiring escalation

* You can evolve the process without rewriting the system.

> **Key takeaway:**
> The system is designed so that *behavior is explainable, not mysterious*.

---

### 4.0 Architecture Layers & Rationale

| **Layer**                                 | **Primary Responsibility**                                            | **Why This Layer Was Chosen**                                                                                                                                                                                                                                                                                           |
| ----------------------------------------- | --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Salesforce Flow**                       | Primary orchestration, validation, and referral state transitions     | Flow provides transparency and accessibility for administrators and power users while reducing technical risk. Declarative orchestration allows business rules to evolve without requiring code changes, supports rapid iteration, and aligns with auditability and governance expectations in healthcare environments. |
| **Apex Trigger Layer**                    | Event delegation and bulk-safe system entry points                    | Triggers provide a consistent, system-level interception point for data changes. By limiting triggers to delegation only, this layer enforces platform consistency, bulk safety, and prevents logic fragmentation, which is critical for long-term stability.                                                           |
| **Apex Service Layer**                    | Complex validation, cross-record logic, and transactional enforcement | Certain rules exceed the practical limits of declarative automation. The service layer centralizes this complexity, keeping it isolated, testable, and reusable, while preventing duplication and technical debt.                                                                                                       |
| **Lightning Web Component (LWC)**         | Read-only operational visibility for FPG users                        | LWC provides a modern UI layer without embedding business logic. This separation ensures operational clarity while allowing UI evolution without impacting orchestration logic, supporting long-term adaptability.                                                                                                      |
| **Data Model (Referral & Event Objects)** | Explicit state management and audit-friendly event tracking           | The data model acts as the system’s source of truth. Explicit state fields and event records provide traceability, reporting flexibility, and operational insight, supporting compliance and troubleshooting without hidden behavior.                                                                                   |

### Architectural Intent

> *Each layer exists to make change safer, understanding clearer, and long-term maintenance easier — not to increase complexity.*

---

## 4.1 Visual Architecture Diagram

```text
┌─────────────────────────────┐
│        User / System        │
│ (Referral Created/Updated)  │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│   Record-Triggered Flow     │
│  (Primary Orchestration)    │
│                             │
│ - Field validation           │
│ - Status transitions         │
│ - Exception detection        │
│ - Event creation             │
│ - Fault handling             │
└──────────────┬──────────────┘
               │
     Declarative First
               │
               ▼
┌─────────────────────────────┐
│        Apex Trigger         │
│   (Delegation Only)         │
│                             │
│ - No business logic          │
│ - Bulk-safe entry point      │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│     Apex Service Layer      │
│ (Complex / Transactional)   │
│                             │
│ - Cross-record validation    │
│ - Advanced rule evaluation   │
│ - Safe transactional logic  │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│ Lightning Web Component     │
│   (Operational Visibility)  │
│                             │
│ - Read-only display          │
│ - Timeline & status view     │
│ - No business logic          │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│     Data Model Layer        │
│ (Referral & Event Objects)  │
│                             │
│ - Explicit state tracking    │
│ - Audit & reporting          │
│ - Operational transparency  │
└─────────────────────────────┘
```

---

## 4.2 For Admins & Power Users: How to Understand and Safely Evolve This System

This section is intentionally included to support **administrators, business analysts, and power users** who may interact with or maintain this solution over time.

### What You Can Safely Change (No Code Required)

Admins and power users can confidently modify:

* Validation and routing logic within the Record-Triggered Flow
* Referral status transitions and decision criteria
* Exception detection thresholds
* Picklist values and field behavior
* Assignment logic for operational teams

These changes can be made declaratively without impacting Apex code or UI components.

---

### When Apex Is Involved (And Why)

Apex exists **only** where declarative automation becomes unclear, unsafe, or overly complex, such as:

* Cross-record or aggregate validation
* Rules requiring transactional enforcement
* Logic that must execute consistently regardless of entry point

Admins should view Apex in this solution as **supporting infrastructure**, not the primary mechanism for change.

---

### How to Reason About Issues

If unexpected behavior occurs:

1. **Review the Flow**

   * Entry criteria
   * Decision logic
   * Fault paths

2. **Inspect Referral_Event__c records**

   * These provide a chronological audit trail
   * Exceptions and status changes are intentionally visible

3. **Escalate to Apex only if**

   * Logic is not represented in Flow
   * Behavior spans multiple records or transactions

This approach reduces troubleshooting time and avoids unnecessary code changes.

---

### Why This Design Supports Long-Term Maintenance

This architecture ensures that:

* Business logic remains **visible and explainable**
* Technical complexity is **isolated and contained**
* Enhancements can be made **incrementally**
* The system remains understandable even as teams change

> *A system that can be understood by admins is a system that can survive organizational change.*

---

## 5. Data Model (Expanded for Admin & Power User Clarity)

The data model is intentionally simple, explicit, and auditable.

### 5.1 Referral__c (Primary Object)

The `Referral__c` object represents a single inbound referral entering the Faculty Practice Group workflow.

**Admin & Power User Perspective**

* This object represents the *current state* of a referral
* It is safe to report on, filter, and dashboard
* Status values are meaningful and intentionally constrained

**Key Fields**

* `Referral_Status__c` – A controlled state machine
* `Referral_Type__c` – Categorizes referral intent
* `Source_System__c` – Identifies origin of referral
* `Priority__c` – Operational urgency indicator
* `Is_Exception__c` – Explicit exception flag
* `Exception_Reason__c` – Human-readable explanation
* `Assigned_Team__c` – Operational ownership

> Status changes should always reflect *process movement*, not manual interpretation.

---

### 5.2 Referral_Event__c (Audit & Traceability Object)

The `Referral_Event__c` object records **what happened and why**.

**Admin & Power User Perspective**

* Think of this as the *timeline* or *audit log*
* Nothing here should be manually edited
* Used heavily for troubleshooting and reporting

**Tracked Events**

* Status changes
* Exceptions detected
* Escalations triggered

This design ensures transparency without overloading the primary record.

---

## 6. Flow Design & Orchestration (Admin-Friendly)

### 6.1 Flow Overview

The **Record-Triggered Flow** is the *primary brain* of the system.

It handles:

* Validation
* Decision-making
* Status transitions
* Exception detection
* Event creation

### 6.2 Flow Naming Conventions

Flows follow a strict naming pattern for clarity:

```
Referral__RTF__Lifecycle_Orchestration
Referral__Subflow__Validate_Core_Data
Referral__Subflow__Handle_Exception
```

**Why This Matters**

* Easy to identify purpose
* Predictable structure
* Reduces admin onboarding time

---

### 6.3 Flow Screenshot Placeholders

> 📸 *Add screenshots once Flow is created*

**Screenshot 1: Entry Criteria**

* Shows when the Flow runs
* Highlights create vs update logic

**Screenshot 2: Validation Decision**

* Demonstrates required field checks
* Shows branching logic

**Screenshot 3: Exception Path**

* Shows status change to *Awaiting Info*
* Shows event creation

**Screenshot 4: Happy Path**

* Shows transition to *Validated*
* Shows normal lifecycle progression

---

## 7. Apex Design & Role (Clarified)

### 7.1 When Apex Is Used

Apex is intentionally limited to scenarios where Flow becomes:

* Difficult to read
* Unsafe
* Transactionally unreliable

Examples include:

* Cross-record evaluation
* Complex rule enforcement
* Multi-record transactional logic

---

### 7.2 What Admins Should Know About Apex

Admins do **not** need to modify Apex to:

* Change referral rules
* Adjust status logic
* Tune exception thresholds

Apex exists as **supporting infrastructure**, not the primary control layer.

---

## 8. Lightning Web Component: referralTimeline (Operational Clarity)

### 8.1 Purpose

The `referralTimeline` component provides a **read-only operational view** of referral history.

**Admin & Power User Perspective**

* Improves situational awareness
* Reduces clicks between records
* Does not affect system behavior

### 8.2 Design Constraints

* No business logic in the UI
* Data retrieved via Apex
* UI changes do not impact process logic

---

## 9. Error Handling & Fault Transparency

### 9.1 Flow Fault Handling

All Flow fault paths:

* Are explicitly defined
* Result in visible system behavior
* Create a Referral_Event__c record

### 9.2 What Power Users See

* Clear exception flags
* Human-readable reasons
* Predictable outcomes

Silent failures are intentionally avoided.

---

## 10. Security & Access (Admin-Readable)

Security design follows **least privilege** principles.

### Key Elements

* Custom permission sets
* Field-level security awareness
* `with sharing` Apex enforcement

Admins can safely:

* Assign access
* Audit permissions
* Adjust without breaking logic

---

## 11. Testing Strategy (Transparency Focused)

Testing prioritizes:

* Behavioral correctness
* Predictable outcomes
* Bulk safety

Admins and power users should view tests as:

* Confidence mechanisms
* Guardrails against regression

---

## 12. What Is Implemented vs. Planned (Expanded)

### Implemented

* End-to-end referral lifecycle orchestration
* Exception detection and logging
* Audit-friendly event tracking
* Architectural scaffolding

### Planned Enhancements

* Additional validation depth
* Expanded operational dashboards
* Integration simulation
* Enhanced UI visualization

Incremental delivery is intentional and aligned with enterprise governance.

---

## 13. Tradeoffs & Design Decisions (Plain Language)

Key decisions explained:

* **Chose Flow first** → Easier to maintain and evolve
* **Limited Apex usage** → Reduces long-term risk
* **Explicit status tracking** → Improves reporting and trust
* **Simple UI** → Prevents accidental behavior changes

---

## 14. Intended Audience (Expanded)

This repository supports:

* Salesforce Technical Leads
* Architects
* Developers
* Administrators
* Power Users
* Healthcare IT stakeholders

Each layer was designed to be understandable by its primary audience.

---

## 15. Closing Note

This implementation is **representative, not exhaustive**.

Its purpose is to demonstrate:

* Thoughtful architecture
* Safe execution
* Clear ownership boundaries
* Long-term maintainability

> *Systems that are understandable survive. Systems that are opaque do not.*
