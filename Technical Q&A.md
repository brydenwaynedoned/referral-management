## Technical Q&A

---

### Q1: *“Why not put more logic in Apex?”*

**Answer:**

> “Because in healthcare Salesforce orgs, admins and analysts live with the system long after developers rotate.
> Flow gives visibility, auditability, and safer evolution.
> I reserve Apex for cases where Flow becomes unsafe or misleading — like cross-record or transactional logic.”

---

### Q2: *“How does this handle bulk and performance?”*

**Answer:**

> “All entry points are bulk-safe.
> Triggers delegate immediately, service classes are bulkified, and Flow decisions are scoped to record context.
> I intentionally avoided per-record DML inside loops and designed this assuming high-volume referral loads.”

---

### Q3: *“How would this integrate with Epic?”*

**Answer:**

> “This design treats Salesforce as the **operational orchestration layer**, not the clinical system of record.
> Epic integration would sit at the boundary — likely publishing referral state changes or consuming validated referrals — without changing core orchestration logic.”

---

### Q4: *“What happens when requirements change?”*

**Answer:**

> “That’s actually the primary design goal.
> Most changes — validation rules, routing, exception thresholds — live in Flow.
> The architecture is meant to absorb change without refactoring code.”

---

### Q5: *“How would you test this?”*

**Answer:**

> “I test behavior, not implementation details.
> Apex tests validate service boundaries and bulk safety.
> Flow behavior is validated through scenario-based testing — especially exception paths and state transitions.”

---

### Q6: *“What’s the biggest risk in this design?”*

**Answer:**

> “Over time, Flow complexity can grow if not governed.
> That’s why I’m explicit about when to stop using Flow and introduce Apex — and why I document those boundaries clearly.”

---

### Q7: *“If you joined, what would you improve first?”*

**Answer:**

> “I’d start by aligning naming conventions, event semantics, and admin documentation across the org — because clarity compounds faster than features.”

---

### Q8: *“Does this solution require Salesforce Health Cloud or any specialized licensing?*“

**Answer:**

> “No. This solution is intentionally built using standard Salesforce Platform capabilities only. It does not require Health Cloud, Service Cloud, OmniStudio, MuleSoft, or additional healthcare-specific licenses. All functionality is supported by core Salesforce features such as custom objects, record-triggered flows, Apex, and Lightning Web Components. This design choice minimizes licensing risk, avoids procurement complexity, and allows the architecture to be deployed or evaluated in enterprise healthcare orgs regardless of cloud strategy. If Health Cloud or integrations are introduced later, they can be layered on without refactoring the core design.“
