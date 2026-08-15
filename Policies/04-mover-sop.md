# Standard Operating Procedure: Mover (Role/Department Change)

**Document Owner:** IAM Lab Administrator
**Last Reviewed:** 2026-08-15
**Related Policy:** access-control-policy.md

---

## 1. Purpose

Defines the standard process for updating a user's access when they change department, role, or manager, with the specific objective of preventing **privilege creep** — the retention of access no longer required after a role change.

## 2. Trigger

This procedure is initiated when an existing user's department or role is updated in the HR data feed, or upon confirmed notification from HR/the employee's manager of an internal transfer.

## 3. Pre-Requisites

- Confirmed new department and effective date of transfer.
- Target department OU and role-based security group already exist.
- Manager or HR confirmation that access outside the new department (e.g., ongoing cross-functional project access) is intentional, if applicable.

## 4. Procedure

| Step | Action | Owner |
|---|---|---|
| 1 | Transfer confirmed via HR feed update or manager notification | HR/Manager |
| 2 | IAM administrator runs `mover.ps1` with old and new department parameters | IT/IAM |
| 3 | Script removes user from the **old** department's `SG-<Dept>-Users` group | Automated |
| 4 | Script adds user to the **new** department's `SG-<Dept>-Users` group | Automated |
| 5 | Script relocates the AD object to the new department OU | Automated |
| 6 | Script updates the `Department` attribute on the user object | Automated |
| 7 | Verify old group membership has been removed | IT/IAM |
| 8 | Verify new group membership has been added | IT/IAM |
| 9 | Confirm the user's file share access reflects the new department only (test via Effective Access tool) | IT/IAM |
| 10 | If the user is moving into or out of a privileged role, process any `SG-*-Admins` group change as a separate, explicitly approved step (see Section 6) | IT/IAM |

## 5. Order of Operations (Critical)

Access removal for the old role and access grant for the new role must be treated as a single atomic transfer — **old access is removed before or simultaneously with the new access being granted, never left in place "temporarily."** This ordering is the primary control this SOP exists to enforce.

## 6. Privileged Role Changes

Any transfer into or out of a privileged group (`SG-IT-Admins` or equivalent) is not automated by the standard mover script and requires:
- Written approval from the receiving department's manager (for a transfer *into* a privileged role)
- Immediate removal (for a transfer *out of* a privileged role, processed with the same urgency as a leaver event for that specific group)

## 7. Validation Checklist

- [ ] User is no longer a member of the prior department's role group
- [ ] User is a member of exactly the new department's role group
- [ ] User's AD object resides in the correct new department OU
- [ ] `Department` attribute matches the new assignment
- [ ] Effective Access check on the old department's file share returns no access
- [ ] Effective Access check on the new department's file share returns correct access level
- [ ] Event ID 4733 (member removed) and 4732 (member added) both present in Security event log
- [ ] If applicable, dynamic group membership (Entra ID) has updated automatically to reflect the new attribute

## 8. Exceptions

If a user legitimately requires continued access to their prior department's resources following a transfer (e.g., handoff period), this must be documented as a time-boxed exception with an explicit end date, not left as standing access.

## 9. Related Test Cases

TC-03, TC-04 (see `/test-cases/test-matrix.md`)
