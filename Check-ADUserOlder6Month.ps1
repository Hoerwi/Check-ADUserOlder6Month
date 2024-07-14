<#
.SYNOPSIS
   AD Cleanup Script: Deletes AD user accounts that are disabled and have an expiration date older than 6 months.

.DESCRIPTION
   This script identifies disabled AD user accounts with an expiration date older than 6 months and optionally deletes them
   after user confirmation. It logs details of identified accounts and any deletion operations performed.

.NOTES
   Version: 2 / 31.05.2024
   Added Features:
   - Logging with timestamp and error handling
   - Email notification (commented out, needs configuration)
#>

# Set log file path and date
$date = Get-Date -Format "yyyyMMdd"
$logPath = "\\path\to\logfile\ADCleanUP_$date.log" # Update log file path as per your environment

# Email configuration (uncomment and configure for automated email notification)
<#
 $smtpServer = "smtp.example.com"
 $smtpFrom = "CleanUpAD@xxxxxxxxx.com"
 $smtpTo = "xxxxxxxx@xxxxxxxxx.com"
 $emailSubject = "AD Cleanup Log $date" # Customize subject as needed
 $emailBody = "Attached is the log file of AD Cleanup Script executed on $date."
 $smtpUser = "smtp_user"
 $smtpPassword = "smtp_password"
#>

# Function to log messages to console and log file
function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Write-Host $logMessage
    Add-Content -Path $logPath -Value $logMessage
}

try {
    # Calculate date 6 months ago
    $sixMonthsAgo = (Get-Date).AddMonths(-6)

    # Query AD for disabled accounts with expiration date older than 6 months
    $olderThanSixMonths = Get-ADUser -Filter {Enabled -eq $false -and AccountExpirationDate -lt $sixMonthsAgo} -Properties AccountExpirationDate

    if ($null -ne $olderThanSixMonths -and $olderThanSixMonths.Count -gt 0) {
        Write-Log "Found disabled user accounts with expiration date older than six months:"

        foreach ($user in $olderThanSixMonths) {
            $expiryDate = $user.AccountExpirationDate
            Write-Log "User account $($user.SamAccountName), expiration date: $expiryDate"
        }

        # Confirmation prompt for manuell user account deletion
        $confirmation = Read-Host "Do you want to delete the listed user accounts? (yes/no)" # Prevent accidental confirmation with 'yes', comment for automation

        if ($confirmation -eq "yes") {                                  # comment for automation
            Write-Log ">> Deletion confirmed with YES"                  # comment for automation

            foreach ($user in $olderThanSixMonths) {
                try {
                    Remove-ADUser -Identity $user.SamAccountName -Confirm:$false 
                    Write-Log "User account $($user.SamAccountName) with expiration date $($user.AccountExpirationDate) has been deleted."
                } catch {
                    Write-Log "Error deleting user account $($user.SamAccountName): $_"
                }
            }
        } else {                                                        # comment for automation
            Write-Log "Deletion of user accounts has been cancelled."   # comment for automation
        }                                                               # comment for automation
    } else {
        Write-Log "No disabled user accounts with expiration date older than six months found."
    }
} catch {
    Write-Log "An error occurred: $_"
}

# Send log file via email (uncomment for automated email notification)
<#
 try {
    $emailMessage = New-Object system.net.mail.mailmessage
    $emailMessage.from = $smtpFrom
    $emailMessage.To.Add($smtpTo)
    $emailMessage.Subject = $emailSubject
    $emailMessage.Body = $emailBody
    $emailMessage.Attachments.Add($logPath)

    $smtpClient = New-Object system.net.mail.smtpclient
    $smtpClient.Host = $smtpServer
    $smtpClient.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPassword)
    $smtpClient.Send($emailMessage)
    Write-Host "Email with log file has been successfully sent."
 } catch {
    Write-Log "Error sending email: $_"
 }
#>

