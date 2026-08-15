# Standard Operating Procedure: Joiner (Onboarding)

**Document Owner:** IAM AD Lab Administrator
**Last Reviewed:** 2026-08-15
**Related Policy:** access-control-policy.md

---

## 1. Purpose

Defines the standard process for provisioning a new user account when an employee joins the organization, ensuring access is granted correctly, consistently, and only to what the role requires.

## 2. Trigger

This procedure is initiated when a new hire record appears in the HR data feed (simulated in this lab as `/data/NewHires.csv`) with a start date on or before the current processing date.

## 3. Pre-Requisites

- New hire record includes: First Name, Last Name, Username, Department, Job Title, Manager, Start Date.
- Target department OU already exists under `OU=Employees`.
- Corresponding role-based security group (`SG-<Department>-Users`) already exists.

## 4. Procedure

| Step | Action | Owner |
|---|---|---|
| 1 | HR system exports new hire record to the HR feed | HR (simulated) |
| 2 | IAM administrator (or scheduled script) imports the feed | IT/IAM |
| 3 | Run `joiner.ps1` against the new hire record(s) | IT/IAM |
| 4 | Script creates the AD user object in the correct department OU | Automated |
| 5 | Script sets account to require password change at first logon | Automated |
| 6 | Script adds the user to the corresponding `SG-<Department>-Users` group | Automated |
| 7 | Verify account creation in Active Directory Users and Computers | IT/IAM |
| 8 | Verify group membership matches the employee's department | IT/IAM |
| 9 | Provide credentials to the new hire through an approved secure channel (not email in plaintext) | IT/IAM |

## 5. Access Granted by Default

- Membership in the department's role-based Global group (`SG-<Department>-Users`)
- Standard domain authentication and baseline Conditional Access policies (MFA) once synced to Entra ID
- No privileged group membership is granted at onboarding under any circumstances; privileged access requires a separate, explicit request per `access-control-policy.md`.

## 6. Validation Checklist

- [ ] User object exists in the correct department OU
- [ ] `SamAccountName` and `UserPrincipalName` follow naming convention
- [ ] Account is enabled and requires password change at next logon
- [ ] User is a member of exactly one role-based Global group matching their department
- [ ] User is **not** a member of any privileged group (`SG-*-Admins`)
- [ ] Event ID 4720 (user account created) is present in the Security event log
- [ ] Event ID 4732 (member added to group) is present for the role-group addition

## 7. Exceptions

Any deviation from standard provisioning (e.g., a new hire requiring cross-department access on day one) must be documented as an exception with a stated business justification, approved by the hiring manager, and logged separately from the standard joiner record.

## 8. Related Test Cases

TC-01, TC-02 (see `/test-cases/test-matrix.md`)
