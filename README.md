# IAM-Lifecycle-Management-Lab (Active Directory)
Joiner-Mover-Leaver Automation, and Compliance-Mapped Access Control

Overview

This project simulates a full **identity and access management (IAM) lifecycle** — from new hire provisioning through role changes to offboarding — using an Active Directory environment. It was built to demonstrate practical IAM analyst skills: access control design, least-privilege enforcement, automation, audit logging, and compliance mapping against NIST 800-53 and ISO 27001.

**Why this project exists:** Joiner-Mover-Leaver (JML) is the single most common source of access-related risk in real organizations — access granted late, access never removed on role change ("privilege creep"), and access that lingers after termination. This lab builds and tests controls against each of those failure points.

---

## Architecture

**Environment:** On-premises Active Directory.

**On-prem components:**
- Windows Server 2022 Domain Controller (`corp.local`)
- OU structure by department, with dedicated OUs for Disabled Users, Admin Accounts, and Service Accounts
- Role-based security groups following the **AGDLP** pattern (Account → Global Group → Domain Local Group → Permission)
- Group Policy for password/lockout enforcement

---

## Core Workflows

### 1. Joiner (Onboarding)
New hires are provisioned from a simulated HR feed (CSV) via PowerShell. Accounts are created in the correct department OU, added to the corresponding role-based security group, and forced to reset their password on first login.

`/Scripts/joiner.ps1`

### 2. Mover (Role/Department Change)
Simulates an internal transfer. The script explicitly removes the old department's group membership before adding the new one, and relocates the AD object to the new OU. This directly targets **privilege creep** — the most common real-world audit finding in access reviews.

`/Scripts/mover.ps1`

### 3. Leaver (Offboarding)
Disables the account, strips all group memberships, resets the password to a random value, and moves the object to a Disabled Users OU for retention before eventual deletion.

`/Scripts/leaver.ps1` and `/Scripts/revoke-sessions.ps1`

---

## Repository Structure
iam-jml-lab/
├── README.md
├── /scripts
│ ├── joiner.ps1
│ ├── mover.ps1
│ ├── leaver.ps1
├── /data
│ └── sample-hr-feed.csv
├── /policies
│ ├── access-control-policy.md
│ ├── joiner-sop.md
│ ├── mover-sop.md
│ ├── leaver-sop.md
├── /compliance
│ ├── control-traceability-matrix.md
│ ├── nist-800-53-mapping.md
│ └── iso-27001-mapping.md
├── /test-cases
│ └── test-matrix.md
├── /diagrams
│ ├── ou-group-architecture.png
└── /screenshots
├── aduc-ou-structure.png
├── gpo-password-policy.png
├── event-viewer-4732.png

---

## Access Control Model

Access is granted through role-based security groups, never assigned directly to individual user accounts. This follows the AGDLP pattern:

**User Account → Global Group (role, e.g. `SG-Finance-Users`) → Domain Local Group (resource permission, e.g. `SG-FileShare-Finance-RW`) → Permission on resource**

---

## Testing

A 13-case test matrix validates that provisioning, transfer, deprovisioning, including negative test cases (e.g., a disabled leaver's credentials must fail authentication).

Full matrix: `/test-cases/test-matrix.md`

| Sample Test | Result |
|---|---|
| Leaver's old credentials used post-offboarding | Access denied |
| Mover's old department group membership | Removed within workflow execution |

---

## Logging and Audit Evidence

Provisioning, transfer, and deprovisioning actions are correlated against native Windows Security Event Log entries to prove automation matches actual directory state:

| Event ID | Meaning |
|---|---|
| 4720 | User account created |
| 4725 | User account disabled |
| 4726 | User account deleted |
| 4732 / 4733 | Member added / removed from security group |
| 4740 | Account lockout |

PowerShell transcript logging wraps every script execution, providing a timestamped record independent of Event Viewer for audit correlation.

---

## Compliance Mapping

Every control implemented in this lab is mapped to **NIST 800-53 Rev 5** and **ISO 27001:2022 Annex A**, with a full control traceability matrix linking each control to its implementation, evidence, and test case.

Full mapping: `/compliance/control-traceability-matrix.md`

| Example Control | NIST 800-53 | ISO 27001 | Implementation |
|---|---|---|---|
| Least privilege | AC-6 | A.5.18 | AGDLP group model, Admin OU separation |
| Account disablement on termination | AC-2(3), PS-4 | A.5.18, A.6.5 | `leaver.ps1` |

A documented gap analysis identifies known control deficiencies — such as manual (rather than event-driven) leaver triggering, and ad hoc rather than scheduled log review — and their remediation paths. This is intentional: demonstrating awareness of gaps is part of the deliverable, not a shortcoming of it.

---

## What This Project Demonstrates

- Design and implementation of a role-based access control model enforcing least privilege
- Automated Joiner-Mover-Leaver workflows addressing the most common real-world access risk (privilege creep, delayed deprovisioning)
- Audit-ready documentation: SOPs, test cases, and a compliance control traceability matrix
- Practical understanding of the distinction between technical controls (disabling an account) and administrative controls (the HR process that triggers it) — and where gaps between the two create real risk

---

## Future Enhancements

- Event-driven provisioning triggered by a mock HRIS webhook instead of manual CSV import (simulating SCIM-based provisioning)
- Centralized log forwarding to a SIEM (Wazuh/Splunk) with scheduled reporting and anomaly alerting
- Monthly (rather than quarterly) access review cadence for PIM-eligible privileged roles
- Extension to a second application (e.g., a SaaS app provisioned via SCIM) to demonstrate provisioning beyond AD/Entra ID alone
