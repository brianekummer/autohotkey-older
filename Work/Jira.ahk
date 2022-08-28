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
   *  Constructor that initializes variables
   */
   __New() {
    this.BaseUrl := EnvGet("AHK_JIRA_URL")
    this.MyProjectKeys := EnvGet("AHK_JIRA_MY_PROJECT_KEYS")
    this.DefaultProjectKey := EnvGet("AHK_JIRA_DEFAULT_PROJECT_KEY")
    this.DefaultRapidKey := EnvGet("AHK_JIRA_DEFAULT_RAPID_KEY")
    this.DefaultSprint := EnvGet("AHK_JIRA_DEFAULT_SPRINT")

    this.RegexStoryNumberWithProject := "i)\b(" this.MyProjectKeys ")([-_ ]|( - ))?\d{1,5}\b"
    this.RegexStoryNumberWithoutProject := "\b\d{1,5}\b"
  }
  




  /******************************  Public Methods  ******************************/
  


  /**
   *  Opens Jira in a browser
   *    - If Ctrl is pressed, try to find a specific story number to open
   *        - Searches the selected text
   *        - Searches for a ConEmu/Cmder window with a window title with a story number
   *        - Searches for a Mintty (comes w/Git Bash) window title with a story number
   *    - If Ctrl is not pressed, or cannot find a speciifc story, then open the current sprint board
   */
  OpenJira() {
    if (GetKeyState("Ctrl")) {
      storyNumber := this.SearchSelectedTextForJiraStoryNumber() 
                     || this.SearchWindowsForJiraStoryNumber("ahk_exe i)\\conemu64\.exe$ ahk_class VirtualConsoleClass") 
                     || this.SearchWindowsForJiraStoryNumber("ahk_exe i)\\mintty\.exe$ ahk_class mintty") 
                     || ""

      if (StrLen(storyNumber) > 0) {
        ; Ensure there is a hyphen between the project name and story number
        storyNumber := RegExReplace(storyNumber, "[\s_]", "")
        if (InStr(storyNumber, "-") = 0) {
          storyNumber := RegExReplace(storyNumber, "(\d+)", "-$1")
        }

        ; Open the story
        RunOrActivateApp("\[" storyNumber "\].*Jira", this.BuildStoryUrl(storyNumber))
        return
      }
    }

    ; Either did not try to find a Jira story number, or did not, so open the default Jira board
    RunOrActivateApp("Agile Board - Jira", this.BuildSprintBoardUrl())
  }





  /******************************  Private Methods  ******************************/
  


  /**
   *  Builds the url for a specific story
   * 
   *  @param storyNumber        The Jira story number
   *  @return                   The url for that story
   */
  BuildStoryUrl(storyNumber) {
    return this.BaseUrl "/browse/" storyNumber
  }


  /**
   *  Builds the url for the current sprint board
   * 
   *  @return    The url for thecurrent sprint board
   */
  BuildSprintBoardUrl() {
    return this.BaseUrl "/secure/RapidBoard.jspa?rapidView=" this.DefaultRapidKey "&projectKey=" this.DefaultProjectKey "&sprint=" this.DefaultSprint
  }


  /**
   *  Searches the selected text for a Jira story number
   * 
   *  @return        The Jira story number, or else "" if not found
   */
  SearchSelectedTextForJiraStoryNumber() {
    selectedText := GetSelectedTextUsingClipboard()
    storyNumber := ""

    if (StrLen(selectedText) > 0) {
      ; Search the selected text for something like PROJECT-1234
      if (RegExMatch(selectedText, this.RegexStoryNumberWithProject, &matches) != 0) {
        storyNumber := matches[]
      } else { 
        ; Search for just a 1-5 digit number, and if found, add the default project name
        if (RegExMatch(selectedText, this.RegexStoryNumberWithoutProject, &matches) > 0) {
          storyNumber := this.DefaultProjectKey "-" matches[]
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