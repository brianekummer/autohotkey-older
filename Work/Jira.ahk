/**
 *  Jira functionality
 * 
 *  Features
 *    - Open Jira page in browser, searching for a story number in the selected text, as well as
 *      window titles of Cmder/ConEmu and Mintty terminal windows.  If no story number is found, 
 *      the current sprint's board is opened.
 * 
 *  Dependencies
 *    - Utilities.RunOrActivateApp()
 *    - Environment variables:
 *        AHK_JIRA_URL
 *        AHK_JIRA_MY_PROJECT_KEYS
 *        AHK_JIRA_DEFAULT_PROJECT_KEY
 *        AHK_JIRA_DEFAULT_RAPID_KEY
 *        AHK_JIRA_DEFAULT_SPRINT
 */
class Jira
{

  /**
   *  Functions to get/build window titles and urls for Jira stories and sprint boards
   */
   GetStoryWindowTitle(storyNumber)            => "\[" . storyNumber . "\].*Jira"
   GetStoryUrl(storyNumber)                    => this.BaseUrl . "/browse/" . storyNumber

   GetDefaultBoardWindowTitle()                => "Agile Board - Jira"
   GetSprintBoardUrl(
     rapidKey := this.DefaultRapidKey, 
     projectKey := this.DefaultProjectKey, 
     sprintNumber := this.DefaultSprintNumber) => this.BaseUrl . "/secure/RapidBoard.jspa?rapidView=" . rapidKey . "&projectKey=" . projectKey . "&sprint=" . sprintNumber


   /**
   *  Constructor that initializes variables
   */
   __New() {
    this.BaseUrl := EnvGet("AHK_JIRA_URL")
    this.MyProjectKeys := EnvGet("AHK_JIRA_MY_PROJECT_KEYS")
    this.DefaultProjectKey := EnvGet("AHK_JIRA_DEFAULT_PROJECT_KEY")
    this.DefaultRapidKey := EnvGet("AHK_JIRA_DEFAULT_RAPID_KEY")
    this.DefaultSprintNumber := EnvGet("AHK_JIRA_DEFAULT_SPRINT")

    this.RegexStoryNumberWithProject := "i)\b(" . this.MyProjectKeys . ")([-_ ]|( - ))?\d{1,5}\b"
    this.RegexStoryNumberWithoutProject := "\b\d{1,5}\b"
  }



  /******************************  Public Methods  ******************************/
  


  /**
   *  Jira
   *    - If the selected text is the url to a Jira sprint board, then parse out the
   *      story number and set it to be our current sprint number
   *    - If the selected text looks like a Jira story number, then open that story
   *    - Else, open the current sprint board
   */
  OpenJira() {
    openDefaultSprintBoard := True
    selectedText := GetSelectedTextUsingClipboard()

    if (selectedText ~= (this.BaseUrl . ".*sprint=\d+")) {
      ; Parse the sprint number from the URL and save it
      this.SaveNewSprintNumber(selectedText)
      openDefaultSprintBoard := False
      
    } else if (StrLen(selectedText) > 0) {
      ; Try to find a specific story to open
      storyNumber := this.FindStoryNumber(selectedText)

      if (StrLen(storyNumber) > 0) {
        this.OpenStory(storyNumber)
        openDefaultSprintBoard := False
      }
    }

    if (openDefaultSprintBoard) {
      ; Either did not try to find a Jira story number, or did not find one, 
      ; so open the default sprint's board
      this.OpenDefaultSprintBoard()
    }
  }





  /******************************  Private Methods  ******************************/

  



  /**
   *  If the selected text is the url of a Jira sprint, then save the sprint number
   *  in our environment variable.
   *  
   *  @param selectedText       The selected text
   *  @return                   Was the sprint number saved? True/False
   */
  SaveNewSprintNumber(selectedText) {
    savedSprintNumber := False

    if (RegExMatch(selectedText, "(?<=sprint\=)\d+", &matches) != 0) {
      sprintNumber := matches[]

      if (sprintNumber > this.DefaultSprint) {

        if (MsgBox("Change the current sprint number from " . this.DefaultSprint . " to " . sprintNumber . "?", "Change Jira Current Sprint Number", "YesNo Icon?") = "Yes") {
          ; Temporarily update the sprint number for the current instance of this script
          EnvSet("AHK_JIRA_DEFAULT_SPRINT", sprintNumber)
          this.DefaultSprint := sprintNumber

          ; Permanently set the sprint number for the next time this script runs
          RegWrite(sprintNumber, "REG_SZ", "HKEY_CURRENT_USER\Environment", "AHK_JIRA_DEFAULT_SPRINT")

          Msgbox("Current Jira sprint number changed to " . sprintNumber . ".", "Change Current Sprint Number")
          savedSprintNumber := True
        }
      }
    }

    return savedSprintNumber
  }


  /**
   *  Tries to find a story to open
   *    - Searches the selected text
   *    - Searches for a ConEmu/Cmder window with a window title with a story number
   *    - Searches for a Mintty (comes w/Git Bash) window title with a story number
   * 
   *  @param selectedText       The selected text
   *  @return                   The found story number, else ""
   */
  FindStoryNumber(selectedText) {
    storyNumber := this.SearchSelectedTextForJiraStoryNumber(selectedText) 
                   || this.SearchWindowsForJiraStoryNumber("ahk_exe i)\\conemu64\.exe$ ahk_class VirtualConsoleClass") 
                   || this.SearchWindowsForJiraStoryNumber("ahk_exe i)\\mintty\.exe$ ahk_class mintty") 
                   || ""

    if (StrLen(storyNumber) > 0) {
      ; Ensure there is a hyphen between the project name and story number
      storyNumber := RegExReplace(storyNumber, "[\s_]", "")
      if (InStr(storyNumber, "-") = 0) {
        storyNumber := RegExReplace(storyNumber, "(\d+)", "-$1")
      }
    }

    return storyNumber
  }

  
  /**
   *  Opens a specific story
   * 
   *  @param storyNumber        The story number
   */
  OpenStory(storyNumber) {
    RunOrActivateApp(this.GetStoryWindowTitle(storyNumber), this.GetStoryUrl(storyNumber))
  }


  /**
   *  Opens the default sprint board
   */
  OpenDefaultSprintBoard() {
    RunOrActivateApp(this.GetDefaultBoardWindowTitle(), this.GetSprintBoardUrl())
  }


  /**
   *  Searches the selected text for a Jira story number
   * 
   *  @param selectedText       The selected text
   *  @return                   The Jira story number, or else "" if not found
   */
  SearchSelectedTextForJiraStoryNumber(selectedText) {
    storyNumber := ""

    if (StrLen(selectedText) > 0) {
      ; Search the selected text for something like PROJECT-1234
      if (RegExMatch(selectedText, this.RegexStoryNumberWithProject, &matches) != 0) {
        storyNumber := matches[]
      } else { 
        ; Search for just a 1-5 digit number, and if found, add the default project name
        if (RegExMatch(selectedText, this.RegexStoryNumberWithoutProject, &matches) > 0) {
          storyNumber := this.DefaultProjectKey . "-" . matches[]
        }
      }  
    }

    return storyNumber
  }


  /**
   *  Search for a Jira story number in the title of all windows matching a given criteria
   * 
   *  The current story number is passed in
   * 
   *  @param titleSearchCriteria    The search criteria
   *  @return                       The found story number, or "" if not found
   */
  SearchWindowsForJiraStoryNumber(titleSearchCriteria) {
    try {
      pos := RegExMatch(WinGetTitle(titleSearchCriteria), this.RegexStoryNumberWithProject, &matches)
      storyNumber = (pos > 0) ? matches[] : ""
    } catch {
      storyNumber := ""
    }

    return storyNumber
  }
}