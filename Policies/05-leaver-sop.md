# Standard Operating Procedure: Leaver (Offboarding)

**Document Owner:** IAM Lab Administrator
**Last Reviewed:** 2026-08-15
**Related Policy:** access-control-policy.md

---

## 1. Purpose

Defines the standard process for revoking access when an employee leaves the organization, ensuring access is removed completely and promptly to eliminate the risk of a lingering active account.

## 2. Trigger

This procedure is initiated upon:
- A termination or resignation record appearing in the HR data feed with a status change to "Inactive"/"Terminated," or
- Direct notification from HR or the employee's manager of a departure date

For involuntary terminations, this procedure must be initiated **immediately**, coordinated in advance with HR/Security where possible, rather than waiting for the standard HR feed cycle.

## 3. Pre-Requisites

- Confirmed last working day / effective termination date.
- Confirmation of whether the departure is voluntary or involuntary (affects urgency and coordination requirements).

## 4. Procedure

| Step | Action | Owner |
|---|---|---|
| 1 | Termination confirmed via HR feed or direct notification | HR/Manager |
| 2 | IAM administrator runs `leaver.ps1` against the departing user's account | IT/IAM |
| 3 | Script removes the user from **all** group memberships | Automated |
| 4 | Script disables the AD account (`Disable-ADAccount`) | Automated |
| 5 | Script resets the account password to a random, undisclosed value | Automated |
| 6 | Script relocates the AD object to `OU=Disabled Users` | Automated |
| 7 | Verify account status is disabled in ADUC | IT/IAM |
| 8 | Verify no group memberships remain | IT/IAM |
| 9 | Confirm authentication attempts using the disabled account's credentials fail | IT/IAM |
| 10 | Retain the disabled account object for the defined retention period (see Section 6) before deletion | IT/IAM |

## 5. Critical Distinction: Disablement vs. Session Revocation

Disabling an account blocks **future** sign-in attempts only. It does **not** invalidate a session or token that was already active at the time of disablement. Step 10 (session/token revocation) is a mandatory, separate action — offboarding is not considered complete until it has been performed and verified.

## 6. Retention and Deletion

- Disabled accounts are retained in `OU=Disabled Users` for a minimum of 90 days to preserve an audit trail and allow for reactivation in the case of an erroneous termination record.
- After the retention period, the account is deleted per the organization's data retention schedule. Deletion is a separate, explicitly approved action — never automatic as part of the standard leaver script.

## 7. Validation Checklist

- [ ] Account status is **Disabled** in Active Directory
- [ ] Zero group memberships remain (`Get-ADUser -Properties MemberOf` returns none beyond `Domain Users`)
- [ ] Account object resides in `OU=Disabled Users`
- [ ] Password has been reset to an undisclosed random value
- [ ] Authentication attempt with prior credentials fails
- [ ] Event ID 4725 (account disabled) is present in the Security event log
- [ ] Any physical/company assets (laptop, badge, etc.) have been recovered — coordinate with IT asset management and Facilities as applicable

## 8. Exceptions

Any request to delay deprovisioning (e.g., pending legal hold, ongoing investigation) must be documented with the requesting authority and an explicit review date, and does not override the requirement to disable sign-in access — only deletion or additional access changes may be delayed.

## 9. Related Test Cases

TC-05, TC-06, TC-07 (see `/test-cases/test-matrix.md`)
