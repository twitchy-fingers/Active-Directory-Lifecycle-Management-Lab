
| Test ID  | Scenario | Expected Result | Pass/Fail |
| ---- | --- | --- | --- |
| TC-01  | New hire provisioned via script | User created in correct OU, added to correct SG, forced password reset |  |
| TC-02  | New hire attempts to access unrelated dept file share | Access denied |  |
| TC-03  | User moved from Engineering to IT | No longer member of SG-Engineering-Users |  | 
| TC-04	 | Same user | Now member of SG-IT-Admins/Users, correct OU |   |
| TC-05  | Leaver processed | Account disabled, all group memberships removed |   |
| TC-06  |	Leaver's old credentials | Cannot authenticate to domain or VPN |   |
| TC-07  |	Orphaned account check |	Run script to find enabled accounts with no group memberships or no logon in 90 days |   |
| TC-08  |	Segregation of duties |	No single account holds both HR-approval group and IT-provisioning group |   |	

