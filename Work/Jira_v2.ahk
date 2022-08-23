/*
  Jira
    ✦ j                  Opens the current sprint board
    ✦ ^ j                Search for a specific story number to open
                           * If the highlighted text looks like a Jira story number (e.g. 
                             PROJECT-1234), then open that story
                           * If the Git Bash window has text that looks like a Jira story number, 
                             then open that story
                           * Last resort is to open the current sprint board

DEPENDENCIES
-------------
Utilities.RunOrActivateApp()


*/
class Jira
{
  __New() 
  {
    this.BaseUrl := EnvGet("AHK_JIRA_URL")
    this.MyProjectKeys := EnvGet("AHK_JIRA_MY_PROJECT_KEYS")
    this.DefaultProjectKey := EnvGet("AHK_JIRA_DEFAULT_PROJECT_KEY")
    this.DefaultRapidKey := EnvGet("AHK_JIRA_DEFAULT_RAPID_KEY")
    this.DefaultSprint := EnvGet("AHK_JIRA_DEFAULT_SPRINT")

    this.RegexStoryNumberWithProject := "i)\b(" this.MyProjectKeys ")([-_ ]|( - ))?\d{1,5}\b"
    this.RegexStoryNumberWithoutProject := "\b\d{1,5}\b"
  }
  

  OpenJira()
  {
    if (GetKeyState("Ctrl"))
    {
      storyNumber := this.SearchSelectedTextForJiraStoryNumber()
      storyNumber := this.SearchWindowsForJiraStoryNumber(storyNumber, "ahk_exe i)\\conemu64\.exe$ ahk_class VirtualConsoleClass")
      storyNumber := this.SearchWindowsForJiraStoryNumber(storyNumber, "ahk_exe i)\\mintty\.exe$ ahk_class mintty")

      if (StrLen(storyNumber) > 0)
      {
        ; Ensure there is a hyphen between the project name and story number
        storyNumber := RegExReplace(storyNumber, "[\s_]", "")
        If (InStr(storyNumber, "-") = 0)
          storyNumber := RegExReplace(storyNumber, "(\d+)", "-$1")

        ; Open the story
        RunOrActivateApp("\[" storyNumber "\].*Jira", this.BuildStoryUrl(storyNumber))
        return
      }
    }

    ; Either did not try to find a Jira story number, or did not, so open the default Jira board
    RunOrActivateApp("Agile Board - Jira", this.BuildSprintBoardUrl())
  }


  BuildStoryUrl(storyNumber)
  {
    return this.BaseUrl "/browse/" storyNumber
  }


  BuildSprintBoardUrl(){
    return  url := this.BaseUrl "/secure/RapidBoard.jspa?rapidView=" this.DefaultRapidKey "&projectKey=" this.DefaultProjectKey "&sprint=" this.DefaultSprint
  }


  /*
    Search the selected text for a Jira story number
  */
  SearchSelectedTextForJiraStoryNumber(){
    selectedText := GetSelectedTextUsingClipboard()
    storyNumber := ""

    if (StrLen(selectedText) > 0)
    {
      ; Search the selected text for something like PROJECT-1234
      if (RegExMatch(selectedText, this.RegexStoryNumberWithProject, &matches) != 0)
      {
        storyNumber := matches[]
      }
      else
      { 
        ; Search for just a 1-5 digit number, and if found, add the default project name
        if (RegExMatch(selectedText, this.RegexStoryNumberWithoutProject, &matches) > 0)
          storyNumber := this.DefaultProjectKey "-" matches[]
      }  
    }

    return storyNumber
  }


  /*
    Search for a Jira story number in the title of all windows matching a given criteria
  */
  SearchWindowsForJiraStoryNumber(storyNumber, titleSearchCriteria)
  {
    if (StrLen(storyNumber) = 0)
    {
      try {
        pos := RegExMatch(WinGetTitle(titleSearchCriteria), this.RegexStoryNumberWithProject, &matches)
        storyNumber = (pos > 0) ? matches[] : ""
      } catch {
        return ""
      }
    }

    return storyNumber
  }
}