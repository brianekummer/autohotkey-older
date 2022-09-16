@ECHO OFF
REM --------------------------------------------------------------------------
REM - My Automations is configured using Windows environment variables. This 
REM - batch file will set the necessary environment variables for the current 
REM - Windows USER.
REM - 
REM - Instructions
REM -   1. Modify this batch file to have the proper values
REM -   2. Run this batch file
REM -   3. Logout and log back into Windows, or reboot
REM -   4. Make sure your changes are there (e.g. run the command "SET")
REM -   5. Undo your changes to this file or or delete it- you don't need
REM -      them anymore. Do NOT check this file into GitHub!
REM -
REM - To clear a setting, you can SETX ENV_VAR_NAME ""
REM --------------------------------------------------------------------------

REM --------------------------------------------------------------------------
REM - These are assumed to be set by Windows- you only need to set them if
REM - they're not already set
REM --------------------------------------------------------------------------
REM SETX APPDATA "C:\Users\my-user-name\AppData\Roaming"
REM SETX COMPUTERNAME "my-laptop"
REM SETX LOCALAPPDATA "C:\Users\my-user-name\AppData\Local"
REM SETX PROGRAMFILES "C:\Program Files"
REM SETX USERDOMAIN "my-company"
REM SETX USERNAME "my-user-name"
REM SETX USERPROFILE "C:\Users\my-user-name"

REM --------------------------------------------------------------------------
REM - These are assumed to be set by your employer- you only need to set them
REM - if they're not already set
REM --------------------------------------------------------------------------
REM SETX USERDNSDOMAIN "my-company.com"

REM --------------------------------------------------------------------------
REM - The stuff you definitely need to set
REM --------------------------------------------------------------------------
REM SETX AHK_PERSONAL_FILES "D:\Personal"
REM SETX AHK_PARSEC_PEER_ID "xxxxxxxxxxxxxxxxxxxxxxxxx"
REM SETX AHK_OFFICE_WIFI_NETWORKS "(my-company-wifi|wi-company-wifi-byod)"
REM SETX AHK_HOME_WIFI_NETWORKS "(my-home-wifi|my-home-guest-wifi)"
    
REM SETX AHK_JIRA_URL "https://xxxxxxxxxx.xxx"
REM SETX AHK_JIRA_MY_PROJECT_KEYS "PROJA|PROJB|PROJC"
REM SETX AHK_JIRA_DEFAULT_PROJECT_KEY "PROJB"
REM SETX AHK_JIRA_DEFAULT_RAPID_KEY "378"
REM SETX AHK_JIRA_DEFAULT_SPRINT "1903"

REM SETX AHK_SOURCE_CODE_SCHEMA_URL "https://xxxxxxxxxxxx.xxx/eventschema/xxxxx/"
REM SETX AHK_SOURCE_CODE_SEARCH_CODE_PREFIX "NOT project:PROJECT-A NOT project:PROJECT-B"
REM SETX AHK_SOURCE_CODE_SEARCH_CODE_URL "https://xxxxxxxxx.xxx/search?account=xxxxxxx&q=""
REM SETX AHK_SOURCE_CODE_SEARCH_REPOSITORIES_URL "https://xxxxxxxxx.xxx/repositories?search="
REM SETX AHK_SOURCE_CODE_URL "https://xxxxxxxxx.xxx/dashboard/overview"

REM SETX AHK_WIKI_URL "https://xxxxxxxxxxx/wiki/home"
REM SETX AHK_WIKI_SEARCH_URL "https://xxxxxxxxxx/wiki/search?text="

REM SETX AHK_CONSTANTS "Customer ID - Joe's Company,1234|Customer ID - Mike Co,5678"

REM --- Slack
REM - Slack security tokens are pipe-delimited, work MUST be first
REM - OPTIONAL: If you want to override the emoji for various statuses, you can override them
REM -           using the environment variables SLACK_STATUS_xxxxxxx
REM SETX SLACK_TOKENS "xoxp-aaaaaaaaaaaaaaa|xoxp-bbbbbbbbbbbbbbb"
REM SETX SLACK_STATUS_MEETING "Meeting|:meeting:"
REM SETX SLACK_STATUS_WORKING_OFFICE "In the office|:skyscraper:"
REM SETX SLACK_STATUS_WORKING_REMOTELY "Working remotely|:beach_chair:"
REM SETX SLACK_STATUS_VACATION "Vacation|:cruise_ship:"
REM SETX SLACK_STATUS_LUNCH "Lunching|:bowl_of_soup:"
REM SETX SLACK_STATUS_DINNER "Dinner|:pizza:"
REM SETX SLACK_STATUS_BRB "Be Right Back|:brb:"
REM SETX SLACK_STATUS_PLAYING "Playing|:8bit:"

REM --- Home automation
REM - See "assumptions" section in my home_automation.py script for more details:
REM - https://github.com/brianekummer/home-automation/blob/master/home_automation.py
REM - Examples
REM -   SETX HA_DEVICE_OFFICEFAN "wyze|plug|xxxxxxxxxxxx"
REM -   SETX HA_DEVICE_OFFICELITE "wyze|bulb|xxxxxxxxxxxx"
REM SETX HA_EMAIL=xxxxxxxxxxxxxx@xxxxx.com
REM SETX HA_VESYNC_PASSWORD=xxxxxxxxxxx
REM SETX HA_WYZE_PASSWORD=xxxxxxxxxxx