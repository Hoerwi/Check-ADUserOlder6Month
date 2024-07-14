# Active Directory Cleanup Script

## Synopsis
This PowerShell script automates the cleanup of Active Directory (AD) user accounts that are disabled and have an expiration date older than 6 months.

## Description
The script identifies AD user accounts that meet the following criteria:
- Disabled (`Enabled -eq $false`)
- Expiration date older than 6 months (`AccountExpirationDate -lt $sixMonthsAgo`)

### Accounts that do not have an expiry date or are not deactivated will not be deleted to avoid accidental deletion of service accounts! Only accounts with the conditions Deactivated and Expiry date will be deleted! If one of the conditions is not met, the account will be skipped.

It logs details of identified accounts and optionally deletes them after user confirmation. Features include:
- Logging with timestamp and error handling
- Email notification (commented out by default, needs configuration)

## Installation
1. **Download Script**: Download the `Check-ADUserOlder6Month.ps1` script from this repository.
2. **Edit Configuration**:
   - Update `$logPath` variable with the desired path for the log file.
   - Uncomment and configure the email settings (`$smtpServer`, `$smtpFrom`, etc.) if email notification is desired.
3. **Permissions**:
   - Ensure the account running the script has sufficient permissions to query and potentially delete AD user accounts.

## Usage
1. Open PowerShell with administrative privileges.
2. Navigate to the directory containing `Check-ADUserOlder6Month.ps1`.
3. Execute the script by typing `.\Check-ADUserOlder6Month.ps1` and pressing Enter.
4. Follow on-screen prompts:
   - Confirm deletion of listed user accounts when prompted (`yes` or `no`).
   - Review the log file (`ADCleanUP_<date>.log`) for details.

## Configuration
- **Log Path**: Update `$logPath` with the desired log file path (`"\\path\to\logfile\ADCleanUP_<date>.log"`).
- **Email Notification**: Uncomment and configure the email settings (`$smtpServer`, `$smtpFrom`, etc.) for automated notification.

## Notes
- **Version**: 2 / 31.05.2024
- **Email Notification**: Email functionality is commented out (`<# ... #>`) by default. Uncomment and configure for automated email notification.
- **Safety**: Ensure to test in a non-production environment before deploying in a production environment. Review deletion actions carefully.
- **Error Handling**: Errors encountered during execution are logged to the specified log file for troubleshooting.

---

For more information, refer to the script comments and adjust parameters based on organizational policies and environment specifics.
