# NIST 800-53 Rev 5 Control Mapping

**Document Owner:** IAM AD Lab Administrator
**Last Reviewed:** 2026-08-15
**Framework Reference:** NIST Special Publication 800-53, Revision 5

---

## 1. Purpose

This document maps the technical and administrative controls implemented in the IAM lifecycle lab to their corresponding NIST 800-53 Rev 5 controls. It is intended to demonstrate how a joiner-mover-leaver (JML) implementation satisfies recognized federal security control requirements, and to serve as supporting evidence during a control assessment.

## 2. Scope

Covers the Active Directory environment (`danotech.local`), associated Group Policy configuration, NTFS/Share permission model.

---

## 3. Access Control (AC) Family

### AC-1: Policy and Procedures
**Control requirement:** The organization develops, documents, and disseminates access control policy and procedures.
**Implementation:** `access-control-policy.md`, `joiner-sop.md`, `mover-sop.md`, `leaver-sop.md`.
**Evidence:** Policy documents in `/policies`.
**Status:** Implemented.

### AC-2: Account Management
**Control requirement:** The organization manages information system accounts, including establishment, activation, modification, and removal.
**Implementation:** `joiner.ps1`, `mover.ps1`, `leaver.ps1` automate account lifecycle actions tied to HR-triggered events.
**Evidence:** Script execution logs, Event ID 4720/4725/4726.
**Test Case:** TC-01, TC-05.
**Status:** Implemented.

### AC-2(1): Automated System Account Management
**Control requirement:** The system supports automated account management.
**Implementation:** PowerShell-based provisioning driven by a structured HR data feed (CSV), rather than manual account creation.
**Evidence:** `joiner.ps1`.
**Status:** Implemented.

### AC-2(3): Disable Accounts
**Control requirement:** The system automatically disables accounts after a defined period of inactivity or upon termination.
**Implementation:** `leaver.ps1` disables the account immediately upon offboarding trigger.
**Evidence:** Event ID 4725.
**Test Case:** TC-05, TC-06.
**Status:** Implemented.

### AC-2(4): Automated Audit Actions
**Control requirement:** The system automatically audits account creation, modification, disabling, and removal actions.
**Implementation:** Native Windows Security Event Log captures 4720/4725/4726/4732/4733/4740; PowerShell transcript logging supplements script-level audit trail.
**Evidence:** Event Viewer exports.
**Status:** Implemented.

### AC-2(7): Role-Based Schemes
**Control requirement:** The organization employs role-based access schemes.
**Implementation:** AGDLP model — users assigned to Global role groups (`SG-<Dept>-Users`), nested into Domain Local resource groups.
**Evidence:** ADUC group membership screenshots.
**Status:** Implemented.

### AC-3: Access Enforcement
**Control requirement:** The system enforces approved authorizations for logical access.
**Implementation:** NTFS and Share permissions applied at the resource-group level; validated using the Effective Access tool.
**Evidence:** Security tab permission screenshots; Effective Access tool output.
**Test Case:** TC-15, TC-16.
**Status:** Implemented.

### AC-6: Least Privilege
**Control requirement:** The organization employs the principle of least privilege, allowing only authorized access necessary to accomplish assigned tasks.
**Implementation:** Role-based group assignment scoped to department; no default access beyond the assigned role group.
**Evidence:** Group membership audit; test case results.
**Test Case:** TC-08.
**Status:** Implemented.

### AC-6(2): Non-Privileged Access for Nonsecurity Functions
**Control requirement:** Users of privileged accounts use non-privileged accounts when accessing nonsecurity functions.
**Implementation:** `SG-IT-Admins` is structurally separate from standard user accounts (`SG-IT-Users`); admin accounts reside in a dedicated OU.
**Evidence:** OU structure screenshot.
**Status:** Implemented.

### AC-6(5): Privileged Accounts
**Control requirement:** The organization restricts privileged accounts to specifically defined personnel.
**Implementation:** Dedicated `OU=Admin Accounts`; `SG-IT-Admins` membership reviewed and kept minimal.
**Evidence:** `Get-ADGroupMember -Identity SG-IT-Admins` output.
**Status:** Implemented.

### AC-7: Unsuccessful Logon Attempts
**Control requirement:** The system enforces a limit of consecutive invalid logon attempts.
**Implementation:** Default Domain Policy GPO — lockout threshold configured (5 attempts).
**Evidence:** GPO settings screenshot.
**Status:** Implemented.

### AC-17: Remote Access
**Control requirement:** The organization authorizes, monitors, and controls remote access.
**Implementation:** `SG-VPN-Access` group; Conditional Access policies applied to all remote/cloud sign-ins.
**Evidence:** Conditional Access policy list.
**Status:** Implemented.

---

## 4. Identification and Authentication (IA) Family

### IA-2: Identification and Authentication (Organizational Users)
**Control requirement:** The system uniquely identifies and authenticates organizational users.
**Implementation:** Unique `SamAccountName`/UPN per user; domain authentication required for all resource access.
**Status:** Implemented.

### IA-2(1): MFA for Privileged Accounts
**Control requirement:** The system implements multifactor authentication for network access to privileged accounts.
**Implementation:** Conditional Access policy `CA03-Require-Compliant-Device-Admins`, applied to `SG-IT-Admins`.
**Evidence:** Conditional Access policy detail screenshot.
**Status:** Implemented.

### IA-2(2): MFA for Non-Privileged Accounts
**Control requirement:** The system implements multifactor authentication for network access to non-privileged accounts.
**Implementation:** Conditional Access policy `CA01-Require-MFA-AllUsers`.
**Evidence:** Conditional Access policy detail screenshot.
**Status:** Implemented.

### IA-5: Authenticator Management
**Control requirement:** The organization manages information system authenticators.
**Implementation:** Password complexity, minimum length, and expiration enforced via Default Domain Policy GPO; forced password change at first logon for new accounts.
**Evidence:** GPO settings screenshot.
**Status:** Implemented.

### IA-5(13): Expiration of Cached Authenticators
**Control requirement:** The system prohibits the use of cached authenticators after a defined time period.
**Implementation:** Session/token revocation on offboarding ensures cached authenticators do not remain valid past termination.
**Test Case:** TC-07.
**Status:** Implemented.

---

## 5. Audit and Accountability (AU) Family

### AU-2: Event Logging
**Control requirement:** The organization determines the types of events to be logged.
**Implementation:** Defined set of Security Event Log IDs tracked (4720, 4725, 4726, 4732, 4733, 4740); Entra ID Audit Logs and Sign-in Logs tracked for cloud events.
**Status:** Implemented.

### AU-6: Audit Review, Analysis, and Reporting
**Control requirement:** The organization reviews and analyzes system audit records.
**Implementation:** Manual review of Event Viewer Logs following each JML action, correlated against script execution.
**Evidence:** Audit log export (`/logs/audit-export-sample.csv`).
**Status:** Implemented (manual); scheduled/automated review flagged as a future enhancement (see Section 6).

---

## 6. Personnel Security (PS) Family

### PS-4: Personnel Termination
**Control requirement:** The organization disables system access, retrieves credentials, and terminates access consistent with personnel termination timelines.
**Implementation:** `leaver-sop.md` procedure and `leaver.ps1` script, triggered on the termination event.
**Test Case:** TC-05, TC-06.
**Status:** Implemented.

### PS-5: Personnel Transfer
**Control requirement:** The organization reviews and confirms access authorizations following personnel transfers.
**Implementation:** `mover-sop.md` procedure and `mover.ps1` script; access review of old vs. new entitlements performed as part of the transfer.
**Test Case:** TC-03, TC-04.
**Status:** Implemented.

---

## 8. Known Gaps and Remediation

| Control | Gap | Remediation Plan |
|---|---|---|
| AC-2(2) | No automated expiration for temporary/emergency accounts on-prem | Add scheduled task to disable accounts past a defined expiration date |
| PS-4 | Leaver process is manually triggered rather than event-driven from an HR system | Future integration via SCIM provisioning from an HRIS (e.g., Workday) |
| AU-6 | Log review is manual/ad hoc rather than scheduled | Forward logs to a SIEM (Wazuh/Splunk) with scheduled weekly reporting and alerting |
| AC-6(7) | Standard 90-day review cadence used uniformly |
| AC-6(1) | No on-prem equivalent of just-in-time privileged activation | Documented as an inherent limitation of on-prem AD |

## 9. Related Documents

- `access-control-policy.md`
- `iso-27001-mapping.md`
- `control-traceability-matrix.md`
- `/test-cases/test-matrix.md`
