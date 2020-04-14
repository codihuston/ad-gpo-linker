# Purpose

To offer a means of adding multiple GPO's to multiple OU's at one go. 

## Use Case

Part of our OU
structure is based on roles and locations. Often times, if computers that consist
of more than one role exists in the same location, we will have to link GPO's to
each role-based OU for said location.

## Requirements

- Windows 10
- PowerShell v5
- Microsoft Windows Powershell Active Directory Module installed

## Instructions

1. Launch the app from the `/bin` directory. Note that the app currently needs to be used on a computer
with the aforementioned requirements, as well as on a machine that is joined to the domain, and you
are logged in as an AD user with permissions to manage the group policies and OU's. There are no
measures in place to handle failed authentication / authorization... yet...
1. In the first dialog, check the policies that you want to add to OU's
	- You may view the GPO report (in HTML) my clicking the "Get Report(s)" buttons
1. Select the option titled "Link / Unlink Checked GPO's To..." in the menu toolbar
1. In the new dialog, check the OU's in which you wish you link the policies that you've selected.
	- You may view the selected policies and OU's in the box on the top right
1. Once you are ready, click on any of the following buttons
	- Unlink: This will remove the selected GPO's from the OU's; OU's that do not have the
	policy linked will be ignored
	- Link (Disabled): This will link the selected GPO's to each of the selected OU's, but the
	link itself will be disabled; if a link for the GPO already exists, it will be DISABLED!
	- Link (Enabled): This will link the selected GPO's to each of the selected OU's, and the
	link itsellf will be enabled; if a link for the GPO already exists, it will be ENABLED!
1. Do something awesome with the precious time that you have saved =)

## Feature requests

If you have feature requests, please open an issue on the github repo.

Thanks!
-Codi