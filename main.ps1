# -----------------------------------------------------------------------------------
# Header
# -----------------------------------------------------------------------------------
# Programname: PS-CreateScheduleTasks 
# Current version: v0.1
# Owner: C. Huebner
# Creation date: 2023-08-06
# -----------------------------------------------------------------------------------
# Changes
#
# -----------------------------------------------------------------------------------
# Parameters
# -----------------------------------------------------------------------------------
# Set you windows user name, its needed to login with this account
[string]$user = "Testuser";
# Default installation path for PowerShell
[string]$PSscript = "C:\PS-CreateScheduleTasks\PSScript.ps1";
# Stored location of the script that should be started with the schedule task
[string]$PSPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe";
# -----------------------------------------------------------------------------------
# createScheduleTask function
# -----------------------------------------------------------------------------------
function createScheduleTask ([string]$scriptPath, [string]$option, $trigger, [string]$scheduleTaskName) {

    # Set the script which was called in the task scheduler with the arguments for the special case
    $arguments = "-WindowStyle Hidden -ExecutionPolicy RemoteSigned -Command &'" + $scriptPath + "' '" + $option + "'";
    $action = New-ScheduledTaskAction -Execute $PSPath -Argument $arguments;

    # Get no trouble if the power supply is on battery, the computer restarts, not depend on idle state or other issues
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd; #-Disable;
    # Assemble all information the create the schedule task with contains the user name
    Register-ScheduledTask -TaskName $scheduleTaskName -Trigger $trigger -Action $action -User $env:USERNAME -Settings $settings -Force;
}
# -----------------------------------------------------------------------------------
# Main function
# -----------------------------------------------------------------------------------
function main() {


    Write-Host "Start to configure the schedule tasks." -ForegroundColor Magenta;
    
    # Create the schedule task for a specific windows user
    if ($env:USERNAME -eq $user) {

        # Create a weekly (Thursday at 06:00 PM) schedule task 
        [string]$scheduleTaskName = "Start PS script every week"
        Write-Host "Start to create a task schedule '$($scheduleTaskName)'..." -ForegroundColor White;
        $trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Thursday -At '06:00PM';
        createScheduleTask -scriptPath $PSscript -option "optionA" -trigger $trigger -scheduleTaskName $scheduleTaskName;
        Write-Host "Finish with creating the schedule task '$($scheduleTaskName)'..." -ForegroundColor DarkGreen;

        # Create a daily (at 07:00 PM) schedule task 
        [string]$scheduleTaskName = "Start PS script every day"
        Write-Host "Start to create a task schedule '$($scheduleTaskName)'..." -ForegroundColor White;
        $trigger = New-ScheduledTaskTrigger -Daily -At '07:00PM';
        createScheduleTask -scriptPath $PSscript -option "optionB" -trigger $trigger -scheduleTaskName $scheduleTaskName;
        Write-Host "Finish with creating the schedule task '$($scheduleTaskName)'..." -ForegroundColor DarkGreen;
    }
    Write-Host "`nFinish the configuration of the schedule tasks.`n" -ForegroundColor DarkGray;
}
# Entry point for the main function
try {

    main;
}
catch {

    $e = $_.Exception;
    $line = $_.InvocationInfo.ScriptLineNumber;
    $msg = $e.Message;

    Write-Error "In script main.ps $($msg) see line $($line)" -Category InvalidOperation -TargetObject $e;
}
finally {

    #    Write-Host "Done";
}
