# Control Traceability Matrix (CTM)

**Document Owner:** IAM AD Lab Administrator
**Last Reviewed:** 2026-08-15
**Purpose:** Single source linking each implemented control to its NIST/ISO mapping, technical implementation, evidence artifact, and validating test case.

---

## How to Read This Matrix

Each row represents one control. The columns trace it end to end: what the control requires, how it was implemented, what proves it was implemented, and which test case validates it operates as designed. This structure mirrors what an auditor requests during a control assessment — implementation alone is not evidence; evidence and testing are what close the loop.

---

## 1. Account Lifecycle Controls

| Control ID | Control Name | NIST 800-53 | ISO 27001 | Implementation | Evidence | Test Case | Status |
|---|---|---|---|---|---|---|---|
| CTRL-01 | Account Provisioning | AC-2, AC-2(1) | A.5.16 | `joiner.ps1` | ADUC screenshot; Event ID 4720 | TC-01 | Implemented |
| CTRL-02 | Role-Based Group Assignment | AC-2(7) | A.5.15, A.5.16 | AGDLP model; joiner script group add | Group membership screenshot | TC-01, TC-02 | Implemented |
| CTRL-03 | Access Modification on Transfer | PS-5 | A.5.18 | `mover.ps1` | Before/after group membership screenshot | TC-03, TC-04 | Implemented |
| CTRL-04 | Old Access Removal Precedes New Access Grant | AC-6, AC-6(7) | A.5.18 | `mover.ps1` execution order | Script code review; test result | TC-03 | Implemented |
| CTRL-05 | Account Disablement on Termination | AC-2(3), PS-4 | A.5.18, A.6.5 | `leaver.ps1` | Event ID 4725 | TC-05, TC-06 | Implemented |
| CTRL-06 | Group Membership Removal on Termination | AC-2 | A.5.18 | `leaver.ps1` | `Get-ADUser -Properties MemberOf` output | TC-05 | Implemented |
| CTRL-07 | Session/Token Revocation on Termination | AC-12, IA-5(13) | A.8.5 | `Revoke-MgUserSignInSession` | Sign-in log entry post-revocation | TC-07 | Implemented |
| CTRL-08 | Disabled Account Retention Before Deletion | PS-4 | A.6.5 | Disabled Users OU; retention period | OU structure screenshot | N/A | Implemented |

## 2. Access Enforcement Controls

| Control ID | Control Name | NIST 800-53 | ISO 27001 | Implementation | Evidence | Test Case | Status |
|---|---|---|---|---|---|---|---|
| CTRL-09 | Least Privilege Enforcement | AC-6 | A.5.18 | Role-based groups scoped to department only | Test case result | TC-08 | Implemented |
| CTRL-10 | NTFS Access Enforcement | AC-3 | A.5.15 | Resource group ACLs on department folders | Security tab screenshot | TC-15, TC-16 | Implemented |
| CTRL-11 | Share-Level Access Enforcement | AC-3 | A.5.15 | Share permission configuration | Advanced Sharing screenshot | TC-14 | Implemented |
| CTRL-12 | Most-Restrictive-Wins Validation | AC-3 | A.5.15 | Deliberate Share/NTFS mismatch test | Access-denied screenshot | TC-14 | Implemented |
| CTRL-13 | Removal of Default Broad Permissions | AC-6 | A.5.15 | Manual removal of Everyone/Users ACEs | Before/after Security tab screenshot | TC-17 | Implemented |
| CTRL-14 | Privileged Access Structural Separation | AC-6(2), AC-6(5) | A.8.2 | Dedicated Admin Accounts OU; separate SG-IT-Admins group | OU structure screenshot | N/A | Implemented |

## 3. Authentication Controls

| Control ID | Control Name | NIST 800-53 | ISO 27001 | Implementation | Evidence | Test Case | Status |
|---|---|---|---|---|---|---|---|
| CTRL-15 | Password Complexity/Expiration | IA-5 | A.5.17 | Default Domain Policy GPO | GPO settings screenshot | N/A | Implemented |
| CTRL-16 | Account Lockout Threshold | AC-7 | A.5.17 | Default Domain Policy GPO | GPO settings screenshot | N/A | Implemented |

## 4. Governance and Recertification Controls

| Control ID | Control Name | NIST 800-53 | ISO 27001 | Implementation | Evidence | Test Case | Status |
|---|---|---|---|---|---|---|---|
| CTRL-21 | Periodic Access Review | AC-6(7), CA-7 | A.5.18, A.5.36 | Quarterly AD Access Reviews | Access Review results export | TC-09 | Implemented |

## 5. Audit and Monitoring Controls

| Control ID | Control Name | NIST 800-53 | ISO 27001 | Implementation | Evidence | Test Case | Status |
|---|---|---|---|---|---|---|---|
| CTRL-25 | Event Logging — Account Actions | AU-2 | A.8.15 | Windows Security Event Log (4720/4725/4726/4732/4733/4740) | Event Viewer export | N/A | Implemented |
| CTRL-28 | Automation-to-Log Correlation | AU-6 | A.8.16 | Manual review of script output against Event Viewer/audit logs post-execution | Comparison notes in test matrix | All | Implemented |

---

## 6. Summary Status

| Status | Count |
|---|---|
| Implemented | 28 |
| Partially Implemented | 0 |
| Not Implemented / Out of Scope | 2 (A.6.1 Screening, A.6.3 Awareness Training — documented in `iso-27001-mapping.md`) |

---

## 7. Gap Analysis Summary

See `nist-800-53-mapping.md` Section 8 and `iso-27001-mapping.md` Section 7 for full detail. Highest-priority open items:

1. Automated expiration for on-prem temporary/emergency accounts (AC-2(2))
2. Event-driven leaver triggering from a real HR system rather than manual/CSV import (PS-4)
3. Scheduled/automated log review via SIEM rather than manual correlation (AU-6, A.8.16)

## 8. Related Documents

- `nist-800-53-mapping.md`
- `iso-27001-mapping.md`
- `access-control-policy.md`
- `/test-cases/test-matrix.md`
