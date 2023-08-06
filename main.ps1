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
# Parameter
# -----------------------------------------------------------------------------------
# Only messages will displayed if this is set to true => no actions taking place
[boolean]$DEBUG = $false;

# 
[string]$user = "Testuser";


[string]$PSscriptA = ""


# Set you computername
[string]$computerName = "MyPC";
# Get windows key
#wmic path softwarelicensingservice get OA3xOriginalProductKey;
[string]$windowsKey = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"



# -----------------------------------------------------------------------------------
function createScheduleTask ([string]$scriptPath, [string]$backupAction, $trigger, [string]$scheduleTaskName) {

    # Set the script which was called in the task scheduler with the arguments for the special case
    $arguments = "-WindowStyle Hidden -ExecutionPolicy RemoteSigned -Command &'" + $scriptPath + "' '" + $backupAction + "'";
    $action = New-ScheduledTaskAction -Execute $b.powershellPath -Argument $arguments;

    # Get no trouble if the power supply is on battery, the computer restarts, not depent on idle state or other issues
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -Disable;
    # Assemble all information the create the schedule task with contains the user name
    Register-ScheduledTask -TaskName $scheduleTaskName -Trigger $trigger -Action $action -User $env:USERNAME -Settings $settings -Force;
}
# -----------------------------------------------------------------------------------
function main() {


    Write-Host "Start to configure the backup plans." -ForegroundColor Magenta;
    
    # Create the schedule task for a specific windows user
    if ($env:USERNAME -eq $user) {

        # Create a weekly (Thursday at 06:00 PM) schedule task 
        [string]$scheduleTaskName = "Start PS script every week"
        Write-Host "Start to create a task schedule '$($scheduleTaskName)'..." -ForegroundColor White;
        $trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Thursday -At '06:00PM';
        createScheduleTask -scriptPath $destination -backupAction "EXT" -trigger $trigger -scheduleTaskName $b.scheduleTaskNameEXTPrivate;
        $b.showMessage("Finish with creating the task schedule '$($b.scheduleTaskNameEXTPrivate)'.", $b.colorFinishSingleProcess, $true);

        # Create a daily schedule task
        $b.showMessage("Start to create a task schedule '$($b.scheduleTaskNameDBPWPrivate)'...", $b.colorStartSingleProcess, $true);
        $trigger = New-ScheduledTaskTrigger -Daily -At '07:00PM';
        createScheduleTask -scriptPath $destination -backupAction "DBPWPrivate" -trigger $trigger -scheduleTaskName $b.scheduleTaskNameDBPWPrivate;
        $b.showMessage("Finish with creating the task schedule '$($b.scheduleTaskNameDBPWPrivate)'.", $b.colorFinishSingleProcess, $true);
    }
    

    Write-Host "`nFinish the configuration of the backup plans.`n" -ForegroundColor DarkGray;
}


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