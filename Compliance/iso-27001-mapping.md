# ISO 27001:2022 Annex A Control Mapping

**Document Owner:** IAM AD Lab Administrator
**Last Reviewed:** 2026-08-15
**Framework Reference:** ISO/IEC 27001:2022, Annex A

---

## 1. Purpose

This document maps the controls implemented in the IAM lifecycle lab to ISO/IEC 27001:2022 Annex A control objectives, demonstrating alignment with the international standard most commonly referenced by private-sector and multinational organizations for information security management.

## 2. Scope

Covers the Active Directory environment (`danotech.local`), Group Policy configuration, NTFS/Share permission model.

---

## 3. Organizational Controls (Clause A.5)

### A.5.1: Policies for Information Security
**Requirement:** Information security policy and topic-specific policies are defined, approved, and communicated.
**Implementation:** `access-control-policy.md` and associated SOPs.
**Status:** Implemented.

### A.5.15: Access Control
**Requirement:** Rules to control physical and logical access to information are established based on business and information security requirements.
**Implementation:** AGDLP role-based access model; OU structure separating standard and privileged accounts.
**Status:** Implemented.

### A.5.16: Identity Management
**Requirement:** The full lifecycle of identities is managed.
**Implementation:** Joiner/mover/leaver SOPs and corresponding automation scripts govern identity creation, modification, and removal.
**Test Case:** TC-01 through TC-07.
**Status:** Implemented.

### A.5.17: Authentication Information
**Requirement:** Allocation and management of authentication information is controlled through a managed process.
**Implementation:** Password complexity/expiration policy via GPO.
**Status:** Implemented.

### A.5.18: Access Rights
**Requirement:** Access rights are provisioned, reviewed, modified, and removed in accordance with the organization's access control policy.
**Implementation:** Role-based group assignment at provisioning; explicit removal-before-addition ordering in mover workflow; full access strip on leaver workflow; quarterly Access Reviews for recertification.
**Test Case:** TC-01, TC-03, TC-04, TC-05, TC-09.
**Status:** Implemented.

### A.5.35: Independent Review of Information Security
**Requirement:** The organization's approach to managing information security is reviewed independently at planned intervals.
**Implementation:** Test case matrix serves as a structured, repeatable validation exercise against defined controls.
**Evidence:** `/test-cases/test-matrix.md`.
**Status:** Implemented (self-assessed in lab context; would require true independence in production).

### A.5.36: Compliance with Policies, Rules, and Standards
**Requirement:** Compliance with the organization's information security policy is regularly reviewed.
**Implementation:** Control Traceability Matrix links each policy requirement to implementation evidence.
**Evidence:** `control-traceability-matrix.md`.
**Status:** Implemented.

---

## 4. People Controls (Clause A.6)

### A.6.1: Screening
**Requirement:** Background verification checks are carried out prior to joining.
**Implementation:** Out of scope for this lab (HR/pre-employment function); provisioning process assumes screening has already occurred as a precondition to the joiner trigger.
**Status:** Not implemented (out of scope — documented, not a gap).

### A.6.3: Information Security Awareness, Education, and Training
**Requirement:** Personnel receive appropriate awareness, education, and training relevant to their role.
**Implementation:** Not directly modeled in this technical lab; flagged as an adjacent administrative control that would accompany role transfers (mover-sop.md) in a production environment.
**Status:** Out of scope for this lab.

### A.6.5: Responsibilities After Termination or Change of Employment
**Requirement:** Information security responsibilities remain valid after termination, and are enforced accordingly.
**Implementation:** `leaver-sop.md` — immediate access disablement, group removal, and session revocation upon termination.
**Test Case:** TC-05, TC-06, TC-07.
**Status:** Implemented.

---

## 5. Physical Controls (Clause A.7)

Not applicable — this lab addresses logical access control only. Physical asset recovery (badges, laptops) is referenced in `leaver-sop.md` Section 7 as a coordination point with Facilities, but is out of scope for direct implementation.

---

## 6. Technological Controls (Clause A.8)

### A.8.2: Privileged Access Rights
**Requirement:** The allocation and use of privileged access rights is restricted and managed.
**Implementation:** `SG-IT-Admins` structurally separated from standard groups
**Evidence:** AD OU configuration screenshot
**Status:** Implemented.

### A.8.5: Secure Authentication
**Requirement:** Secure authentication technologies and procedures are implemented based on access restrictions and the access control policy.
**Implementation:** Password policy via GPO; session revocation on offboarding.
**Status:** Implemented.

### A.8.15: Logging
**Requirement:** Logs recording activities, exceptions, faults, and other relevant events are produced, stored, and reviewed.
**Implementation:** Windows Security Event Log (4720/4725/4726/4732/4733/4740); Entra ID Audit and Sign-in Logs.
**Status:** Implemented.

### A.8.16: Monitoring Activities
**Requirement:** Networks, systems, and applications are monitored for anomalous behavior.
**Implementation:** Manual correlation of script execution against Event Viewer after each JML action.
**Status:** Implemented (manual); automated/continuous monitoring flagged as a future enhancement.

### A.8.34: Audit Testing Considerations for Information Systems
**Requirement:** Audits and other assurance activities involving assessment of operational systems are planned and agreed to minimize disruption.
**Implementation:** Test case matrix executed in an isolated lab environment; no production systems affected.
**Evidence:** `/test-cases/test-matrix.md`.
**Status:** Implemented (lab context).

---

## 7. Known Gaps and Remediation

| Control | Gap | Remediation Plan |
|---|---|---|
| A.6.1 | Screening is out of scope for this technical lab | Documented as an assumed precondition; not a control failure |
| A.6.3 | Security awareness training not modeled | Would be layered on top of mover-sop.md in a production rollout |
| A.8.16 | Monitoring is manual rather than continuous/automated | Forward logs to a SIEM with scheduled reporting and anomaly alerting |
| A.5.35 | Review is self-assessed, not independent | Would require a separate reviewer/auditor role in a production deployment |

## 8. Related Documents

- `access-control-policy.md`
- `nist-800-53-mapping.md`
- `control-traceability-matrix.md`
- `/test-cases/test-matrix.md`
