# Access Control Policy

**Document Owner:** IAM AD Lab Administrator

**Last Reviewed:** 2026-08-15

**Applies To:** Active Directory domain `danotech.local`
---

## 1. Purpose

This policy defines how access to systems and resources is granted, structured, and maintained within the lab environment, in order to enforce least privilege and prevent unauthorized or excessive access accumulation ("privilege creep").

## 2. Scope

Applies to all user accounts, security groups, organizational units, and file/resource permissions within the `danotech.local` Active Directory domain and its synchronized Entra ID tenant.

## 3. Access Control Model

Access is granted through role-based security groups, never assigned directly to individual user accounts. This follows the **AGDLP** pattern:

**User Account → Global Group (role) → Domain Local Group (resource permission) → Permission on resource**

### 3.1 Group Naming Convention

| Pattern | Purpose | Example |
|---|---|---|
| `SG-<Department>-Users` | Role-based access group (Global scope) | `SG-Finance-Users` |
| `SG-<Department>-Admins` | Privileged role-based group (Global scope) | `SG-IT-Admins` |
| `SG-<Resource>-<Department>-<Permission>` | Resource permission group (Domain Local scope) | `SG-FileShare-Finance-RW` |

All security groups are prefixed `SG-` to distinguish them from distribution groups and built-in groups.

### 3.2 Group Scope Usage

| Scope | Usage |
|---|---|
| Global | Role-based groups, membership limited to same-domain users |
| Domain Local | Resource permission groups, applied directly to NTFS/Share permissions |
| Universal | Not used in this lab; reserved for forest-wide roles if the domain structure expands |

## 4. Organizational Unit Structure
corp.local
├── OU=Employees
│ ├── OU=Sales
│ ├── OU=Engineering
│ ├── OU=Finance
│ ├── OU=HR
│ └── OU=IT
├── OU=Groups
│ ├── OU=Role-Groups
│ └── OU=Resource-Groups
├── OU=Disabled Users
├── OU=Service Accounts
└── OU=Admin Accounts

## 5. Least Privilege Principles
- Users are granted access only to the resources required for their current role.
- Privileged accounts (`SG-IT-Admins`) are kept in a separate group from standard role groups (`SG-IT-Users`) and are not used for daily non-administrative tasks.
- Access changes triggered by role transfers must remove prior access before or simultaneously with granting new access — access is never left "just in case."
- Deny permissions are used sparingly and only for deliberate exceptions, since an explicit Deny always overrides an Allow regardless of source.

## 6. NTFS and Share Permission Standards

- Share permissions are set broadly (Full Control for the applicable resource group); actual access control is enforced at the NTFS layer, per the "most restrictive wins" evaluation rule.
- Default overly-broad permissions (e.g., `Everyone`, `Authenticated Users`, local `Users` group) are removed from all resource folders during setup.
- Privileged access overlays (e.g., `SG-IT-Admins: Full Control`) are added alongside, not in place of, department-level resource group permissions.

## 7. Review and Maintenance

- Group membership and OU structure are reviewed as part of each joiner, mover, and leaver event per the associated SOPs.
- This policy is reviewed whenever the OU structure, group naming convention, or permission model changes.

## 8. Related Documents

- `joiner-sop.md`
- `mover-sop.md`
- `leaver-sop.md`
- `conditional-access-policy.md`
- `/compliance/control-traceability-matrix.md`
