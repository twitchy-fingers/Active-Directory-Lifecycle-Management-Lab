# IAM Lab Test Case Matrix

**Document Owner:** IAM AD Lab Administrator
**Last Reviewed:** 2026-08-15
**Purpose:** Validates that all provisioning, access modification, deprovisioning, and permission enforcement controls operate as designed. Referenced by SOPs and the Control Traceability Matrix.

---

## How to Use This Matrix

Each test case includes the scenario, expected result, the control it validates, and space to record actual results during execution. Negative test cases (proving access is correctly *denied*) are included deliberately — a passing positive test alone does not prove least privilege is enforced.

---

## 1. Joiner Test Cases

| Test ID | Scenario | Expected Result | Related Control | Actual Result | Pass/Fail |
|---|---|---|---|---|---|
| TC-01 | New hire provisioned via `joiner.ps1` from HR feed | User created in correct department OU, added to correct `SG-<Dept>-Users` group, forced password reset at next logon | CTRL-01, CTRL-02 | | |
| TC-02 | New hire attempts to access an unrelated department's file share | Access denied | CTRL-09 | | |

## 2. Mover Test Cases

| Test ID | Scenario | Expected Result | Related Control | Actual Result | Pass/Fail |
|---|---|---|---|---|---|
| TC-03 | User moved from Department A to Department B via `mover.ps1` | No longer a member of `SG-DeptA-Users`; AD object relocated to Department B OU | CTRL-03, CTRL-04 | | |
| TC-04 | Same user, post-move | Now a member of `SG-DeptB-Users`; `Department` attribute updated | CTRL-03 | | |

## 3. Leaver Test Cases

| Test ID | Scenario | Expected Result | Related Control | Actual Result | Pass/Fail |
|---|---|---|---|---|---|
| TC-06 | Leaver processed via `leaver.ps1` | Account disabled; all group memberships removed | CTRL-05, CTRL-06 | | |
| TC-07 | Leaver's prior credentials used to authenticate post-offboarding | Authentication fails | CTRL-05 | | |

## 4. Least Privilege / Access Control Test Cases

| Test ID | Scenario | Expected Result | Related Control | Actual Result | Pass/Fail |
|---|---|---|---|---|---|
| TC-08 | Standard user account audited for group memberships | Member of exactly one department role group; no privileged group membership | CTRL-09 | | |
| TC-09 | Orphaned account check | No enabled accounts found with zero group memberships or no logon in 90+ days | CTRL-09 | | |
| TC-10 | Segregation of duties check | No single account holds both an approval-authority group and a provisioning-authority group | CTRL-09 | | |

## 5. NTFS and Share Permission Test Cases

| Test ID | Scenario | Expected Result | Related Control | Actual Result | Pass/Fail |
|---|---|---|---|---|---|
| TC-11 | Authorized department user accesses their department's file share | Read/write succeeds per assigned role | CTRL-10 | | |
| TC-12 | Share permission set to Full Control, NTFS permission set to Read Only, authorized group user attempts write | Write denied — NTFS governs as the more restrictive permission | CTRL-12 | | |
| TC-13 | Unauthorized user (different department) attempts to access a department share | Access denied | CTRL-10 | | |
| TC-14 | Default "Everyone"/"Users" permissions checked on department folder | Confirmed absent from Security tab | CTRL-13 | | |
| TC-15 | `SG-IT-Admins` member accesses Finance department share | Full Control confirmed via Effective Access tool | CTRL-14 | | |
| TC-16 | `SG-IT-Admins` member accesses Sales department share | Full Control confirmed (overrides department's Read & Execute for this group only) | CTRL-14 | | |
| TC-17 | Non-admin Finance user's access checked after IT overlay was added | Still exactly Modify; access not unintentionally broadened | CTRL-14 | | |

## 8. Audit and Logging Test Cases

| Test ID | Scenario | Expected Result | Related Control | Actual Result | Pass/Fail |
|---|---|---|---|---|---|
| TC-18 | Joiner action executed | Event ID 4720 and 4732 present in Security Event Log with correct timestamp | CTRL-25 | | |
| TC-19 | Leaver action executed | Event ID 4725 present; Entra ID audit log shows "Update user" and "Remove member from group" entries | CTRL-25, CTRL-26 | | |

---

## 9. Test Execution Record

| Test Run Date | Executed By | Total Tests | Passed | Failed | Notes |
|---|---|---|---|---|---|
| | | 19 | | | |

---

## 10. Related Documents

- `/policies/joiner-sop.md`
- `/policies/mover-sop.md`
- `/policies/leaver-sop.md`
- `/policies/conditional-access-policy.md`
- `/compliance/control-traceability-matrix.md`
- `/compliance/nist-800-53-mapping.md`
- `/compliance/iso-27001-mapping.md`
