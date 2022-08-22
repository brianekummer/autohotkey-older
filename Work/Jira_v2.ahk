/*
  Jira
    ✦ j                  Opens the current board
    ✦ ^ j                Opens the selected story number
                           * If the highlighted text looks like a Jira story number (e.g. 
                             PROJECT-1234), then open that story
                           * If the Git Bash window has text that looks like a Jira story number, 
                             then open that story
                           * Last resort is to open the current board
*/
Jira()
{
  if (GetKeyState("Ctrl"))
  {
    regexStoryNumberWithProject := "i)\b(" Configuration.Work.Jira.MyProjectKeys ")([-_ ]|( - ))?\d{1,5}\b"
    
    storyNumber := SearchSelectedTextForJiraStoryNumber(regexStoryNumberWithProject)
    storyNumber := SearchWindowsForJiraStoryNumber(storyNumber, "ahk_exe i)\\conemu64\.exe$ ahk_class VirtualConsoleClass", regexStoryNumberWithProject)
    storyNumber := SearchWindowsForJiraStoryNumber(storyNumber, "ahk_exe i)\\mintty\.exe$ ahk_class mintty", regexStoryNumberWithProject)

    if (StrLen(storyNumber) > 0)
    {
      ; Ensure there is a hyphen between the project name and story number
      storyNumber := RegExReplace(storyNumber, "[\s_]", "")
      If (InStr(storyNumber, "-") = 0)
        storyNumber := RegExReplace(storyNumber, "(\d+)", "-$1")

      ; Open the story
      title := "\[" storyNumber "\].*Jira"
      url := Configuration.Work.Jira.BaseUrl "/browse/" storyNumber
      RunOrActivateAppOrUrl(title, url,, True, False)
      return
    }
  }

  ; Either did not try to find a Jira story number, or did not, so open the default Jira board
  title := "Agile Board - Jira"
  url := Configuration.Work.Jira.BaseUrl "/secure/RapidBoard.jspa?rapidView=" Configuration.Work.Jira.DefaultRapidKey "&projectKey=" Configuration.Work.Jira.DefaultProjectKey "&sprint=" Configuration.Work.Jira.DefaultSprint
  RunOrActivateAppOrUrl(title, url,, True, False)
}


/*
  Search the selected text for a Jira story number
*/
SearchSelectedTextForJiraStoryNumber(regexStoryNumberWithProject){
  selectedText := GetSelectedTextUsingClipboard()
  storyNumber := ""

  if (StrLen(selectedText) > 0)
  {
    ; Search the selected text for something like PROJECT-1234
    pos := RegExMatch(selectedText, regexStoryNumberWithProject, &matches)
    if (pos != 0)
    {
      storyNumber := matches[]
    }
    else
    { 
      ; Search for just a 1-5 digit number, and if found, add the default project name
      regexStoryNumberWithoutProject := "\b\d{1,5}\b"
      pos := RegExMatch(selectedText, regexStoryNumberWithoutProject, &matches)
      if (pos > 0)
        storyNumber := Configuration.Work.Jira.DefaultProjectKey "-" matches[]
    }  
  }

  return storyNumber
}


/*
  Search for a Jira story number in the title of all windows matching a given criteria
*/
SearchWindowsForJiraStoryNumber(storyNumber, titleSearchCriteria, regexStoryNumberWithProject)
{
  if (StrLen(storyNumber) = 0)
  {
    try {
      pos := RegExMatch(WinGetTitle(titleSearchCriteria), regexStoryNumberWithProject, &matches)
      storyNumber = (pos > 0) ? matches[] : ""
    } catch {
      return ""
    }
  }

  return storyNumber
}