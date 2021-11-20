@ECHO OFF
REM --------------------------------------------------------------------------
REM - My Automations is configured using Windows environment variables. This 
REM - batch file will set the necessary environment variables for the current 
REM - Windows USER.
REM - 
REM - Instructions
REM -   1. Modify this batch file as necessary 
REM -   2. Run this batch file
REM -   3. Logout and log back into Windows, or reboot
REM -   4. Make sure your changes are there (e.g. run the command "SET")
REM -   5. Undo your changes to this file or or delete it- you don't need
REM -      them anymore. Do NOT check this file into GitHub!
REM -
REM - To clear a setting, you can do this:
REM -   SETX ENV_VAR_NAME ""
REM --------------------------------------------------------------------------

REM SETX AHK_JIRA_URL "https://xxxxxxxxxx"
REM SETX AHK_JIRA_MY_PROJECT_KEYS "xxxxx|xxxxx|xxxxx|xxxxx"
REM SETX AHK_JIRA_DEFAULT_PROJECT_KEY "xxxxx"
REM SETX AHK_JIRA_DEFAULT_RAPID_KEY "xxxxx"
REM SETX AHK_JIRA_DEFAULT_SPRINT "xxxxx"

REM SETX AHK_SOURCE_CODE_URL "https://xxxxxxxxxx"
REM SETX AHK_SOURCE_CODE_SCHEMA_URL "https://xxxxxxxxxx"

REM My Slack security tokens, pipe-delimited, work is first
REM SETX SLACK_TOKENS "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

