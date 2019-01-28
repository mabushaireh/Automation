$rgname = "rg-Lab42"
$aaname = "aa-Lab42"
$rbname = "M4L2Runbook"
$currentStatus = $null
$jobmonitor = $true;
$runbookjob = Start-AzureRmAutomationRunbook -Name $rbname `
            -ResourceGroupName $rgname `
            -AutomationAccountName $aaname

while ($jobmonitor)
{
    if ($currentStatus -ne $runbookjob.Status)
    {
        $currentStatus = $runbookjob.Status
        Write-Output $currentStatus
        if ($currentStatus -eq "Failed") { $jobmonitor = $false }
        if ($currentStatus -eq "Completed") { $jobmonitor = $false }        
    }

    if ($jobmonitor)
    {
        sleep 1
        $runbookjob = Get-AzureRmAutomationJob -id $runbookjob.JobId `
                        -ResourceGroupName $rgname `
                        -AutomationAccountName $aaname

    }
    else {
        $runbookjoboutput = Get-AzureRmAutomationJobOutput -Id $runbookjob.JobId `
        -ResourceGroupName $rgname -AutomationAccountName $aaname

        Write-Output $runbookjoboutput | select Summary
    }
}
        