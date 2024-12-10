$Domain = "domain.com"
$RemoveSMTPDomain = "smtp:*@$Domain"

$AllMailboxes = Get-Mailbox -ResultSize Unlimited| Where-Object {$_.EmailAddresses -clike $RemoveSMTPDomain}

ForEach ($Mailbox in $AllMailboxes)
{     
   $AllEmailAddress  = $Mailbox.EmailAddresses -cnotlike $RemoveSMTPDomain
   $RemovedEmailAddress = $Mailbox.EmailAddresses -clike $RemoveDomainsmtp
   $MailboxID = $Mailbox.PrimarySmtpAddress 
   $MailboxID | Set-Mailbox -EmailAddresses $AllEmailAddress #-whatif
   Write-Host "The follwoing E-mail address were removed $RemovedEmailAddress from $MailboxID Mailbox"   
}
