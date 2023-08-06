# PS-CreateScheduleTasks

## Create user specific schedule tasks

The following PS script main.ps1 creates two schedule tasks (daily, weekly) with power optimation and settings for robustness. This can exetend to more tasks or modifcation could be made.

## Notifications

* The PowerShell script will execute (invoke by the schedule task) in the hidden mode and with RemoteSigned execution policy
  (if you don't allow the execution of PS scripts yet).
* If a laptop is used, you have no trouble if the power supply will changed to battery. The schedule task will also working.
* After a reboot or a later start of the PC (after the time in the schedule task), the PS script will start anyway.

## How to install the PS-CreateScheduleTasks tool

1. Clone this project
2. Edit the main.ps1 as following:
    - Set you windows user name in line 15
    - You can use the attached PS script, which will called by the schedule tasks, for a first try
    - Maybe you have to change in line 17 the location where your (or the attached) PS script is stored
    - In the default case the schedule tasks are active immediately. You can change this in line 30 by add the Disable option,
      if you activate manually these tasks later.
    - You can add futher schedule tasks or modify the current settings. A schedule task are create in line 45 - 50 for example
3. Save the main.ps1 after editing
4. Run the PS script with the same user that you set up in the main.ps1
