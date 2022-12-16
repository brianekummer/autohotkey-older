/**
 *  Slack functionality
 *
 *  Features
 *    - Set my Slack status based on my location 
 *    - Get the name of the emoji for my current Slack status
 *    - Run/activates Slack app
 *    - Functions to set a specific status
 *        - Working status selects between office/remote
 *        - Eating status selects between lunch and dinner
 * 
 *  Notes
 *    - Borrowed heavily from my Hammerspoon script for the Mac:
 *      https://github.com/brianekummer/hammerspoon/blob/master/my-slack.lua
 * 
 *  Dependencies
 *    - Utilities.AmConnectedToInternet()
 *    - Utilities.AmAtOffice()
 *    - Environment variables          ; See "Configure.bat" for details
 *        AHK_SLACK_TOKENS             ; Assumes 1st token is always work, 2nd is home
 */


class Slack {
  /**
   *  Constructor that initializes variables
   */
   __New() {
    this.Tokens := StrSplit(EnvGet("AHK_SLACK_TOKENS"), "|")

    this.SlackExe := Configuration.WindowsLocalAppDataFolder . "\Slack\Slack.exe"

    this.PlayingExpirationTime := "030000"
    this.StatusEmojiUnkown := "???"
    this.Statuses := Map(
      "none",      this.BuildStatus("", "|", 0),
      "meeting",   this.BuildStatus("SLACK_STATUS_MEETING",          "Meeting|:spiral_calendar_pad:", 0), 
      "office",    this.BuildStatus("SLACK_STATUS_WORKING_OFFICE",   "Office|:cityscape:", 0), 
      "remote",    this.BuildStatus("SLACK_STATUS_WORKING_REMOTELY", "Working remotely|:house_with_garden:", 0),
      "vacation",  this.BuildStatus("SLACK_STATUS_VACATION",         "Vacationing|:palm_tree:", 0), 
      "lunch",     this.BuildStatus("SLACK_STATUS_LUNCH",            "Lunch|:hamburger:", 0), 
      "dinner",    this.BuildStatus("SLACK_STATUS_DINNER",           "Dinner|:poultry_leg:", 0), 
      "brb",       this.BuildStatus("SLACK_STATUS_BRB",              "Be Right Back|:brb:", 0), 
      "playing",   this.BuildStatus("SLACK_STATUS_PLAYING",          "Playing|:8bit:", 0),
    )
    this.Urls := {
      Users: {
        Profile: {
          Get: "https://slack.com/api/users.profile.get",
          Set: "https://slack.com/api/users.profile.set"
        },
        SetPresence: "https://slack.com/api/users.setPresence"
      }
    }
  }
  




  /******************************  Public Methods  ******************************/



  /**
   *  Sets my Slack status, based on my location
   * 
   *  I can be connected to a network by a wired ethernet cable in the office or at home, so looking at what wifi
   *  networks are nearby/available seems like an accurate method of determining where I'm located.
   *
   *  If I am on PTO, then don't change the status before the PTO status expires.
   */
  SetStatusBasedOnLocation() {
    ; Get current Slack status (network errors are returned as emoji this.StatusEmojiUnkown)
    currentEmoji := this.GetStatusEmoji()
    while (currentEmoji = this.StatusEmojiUnkown) {
      Sleep(30000)
      currentEmoji := this.GetStatusEmoji() 
    }

    meetingEmoji := this.Statuses["meeting"].emoji
    vacationEmoji := this.Statuses["vacation"].emoji

    if (currentEmoji = meetingEmoji) {
      ; I'm in a meeting, and I ASSUME that my Outlook addin will change my status back when the meeting ends
    } else if (currentEmoji = vacationEmoji) {
      ; I'm on PTO, and I ASSUME that my Outlook addin or JavaScript code set that status to have an expiration
    } else {
      ; I'm not in a meeting, so we need to set my Slack status
      done := False
      loop {
        if (AmConnectedToInternet()) {
          ; I'm connected to a network
          done := True
          this.SetStatusWorking()
        } else {
          ; Wait for 30 seconds and check again
          Sleep(30000)
        }
      }
      until done
    }
  }


  /**
   *  Gets the name of the emoji for my current Slack status
   *
   *  Now that I have both a work and a personal Slack account, we're just getting the status of the first 
   *  (work) account.
   * 
   *  @return                    The emoji for my current Slack status
   */
  GetStatusEmoji() {
    try {
      webRequest := ComObject("WinHttp.WinHttpRequest.5.1")
      webRequest.Open("GET", this.Urls.Users.Profile.Get)
      webRequest.SetRequestHeader("Authorization", "Bearer " . this.Tokens[1])
      webRequest.Send()
      results := webRequest.ResponseText

      ; The JSON returned by Slack will look something like this: 
      ;   ..."status_emoji":":house_with_garden:",... 
      ;   or
      ;   ..."status_emoji":"",...
      statusEmoji := SubStr(results, (InStr(results, "status_emoji"))<1 ? (InStr(results, "status_emoji"))-1 : (InStr(results, "status_emoji")))
      statusEmoji := SubStr(statusEmoji, 1, InStr(statusEmoji, ","))
      statusEmoji := RegExReplace(statusEmoji, 'i)(status_emoji|\"|,)')
      statusEmoji := RegExReplace(statusEmoji, "i)::", ":")
    } catch {
      statusEmoji := this.StatusEmojiUnkown
    }

    return statusEmoji
  }
  

  /**
   *  Runs or activates Slack app
   * 
   *  @param shortcut            The shortcut key to send to the Slack app after it is run or activated
   */
  RunOrActivateSlack(shortcut := "") {
    RunOrActivateApp("ahk_exe slack.exe", this.SlackExe)
    if (shortcut != "") {
      SendInput(shortcut)
    }

    CommonReturn()
  }


  /**
   *  Simple functions to set a specific status
   */
  SetStatusPlaying()     => this.SetSlackHomeStatusAndPresence("playing", "auto", this.CalculatePlayingExpirationTime(this.PlayingExpirationTime))
  SetStatusNone()        => this.SetStatusAndPresence("none", "auto")
  SetStatusMeeting()     => this.SetStatusAndPresence("meeting", "auto")
  SetStatusBeRightBack() => this.SetStatusAndPresence("brb", "away")
  SetStatusVacation()    => this.SetStatusAndPresence("vacation", "away")


  /**
   *  Sets my status to either working in the office or working remotely
   */
  SetStatusWorking() {
    if AmAtOffice() {
      this.SetStatusAndPresence("office", "auto")
    } else {
      this.SetStatusAndPresence("remote", "auto")
    }

    CommonReturn()
  }

  
  /**
   *  Sets my status to either lunch or dinner, depending on the current time
   * 
   *  @param lunchIsBeforeHour   Any time before this hour is considered lunch
   */
  SetStatusEating(lunchIsBeforeHour) {
    if (A_Hour < lunchIsBeforeHour) {
      this.SetStatusAndPresence("lunch", "away")
    } else {
      this.SetStatusAndPresence("dinner", "away")
    }

    CommonReturn()
  }


  SetPresenceAway() {
    this.SetPresence("away")
  }

  


  /******************************  Private Methods  ******************************/



  /**
   *  Builds a slack status object
   * 
   *  Reads the environment variable envVarName
   *    - If that variable is blank or not set, use the default value provided
   *    - The text obtained from the environment variable and/or defaultValue should be a pipe-delimited string 
   *      with the name and the emoji, such as "At lunch|:hamburger:". It does not matter the order of these.
   *  @param envVarName          The name of the environment variable 
   *  @param defaultValue        Default value to use if the environment variable is empty
   *  @param statusExpiration    The expiration of this status- as an integer specifying seconds since the epoch, 
   *                             more commonly known as "UNIX time". When 0 or omitted, the status does not expire.
   *  @return                    A Slack status object with the text, emoji, and expiration 
   */
  BuildStatus(envVarName, defaultValue, statusExpiration) {
    slackStatus := EnvGet(envVarName)
    
    if (slackStatus = "") {
      slackStatus := defaultValue
    }

    parts := StrSplit(slackStatus, "|")
    slackStatus := RegExMatch(parts[1], "^:.*:$")
      ? { text: parts[2], emoji: parts[1], expiration: statusExpiration}
      : { text: parts[1], emoji: parts[2], expiration: statusExpiration}
    
    return slackStatus
  }


  /**
   *  Sets my Slack status
   *
   *  Now I have a work and a personal Slack account, so I have two Slack tokens. So we'll loop through them
   *  and send the status update to both.
   * 
   *  @param newStatusKey        The status key of the new status (the key from this.Statuses)
   *  @param newPresence         The new presence (auto|away)
   *  @param expiration          The expiration for this status, as a unix timestamp
   */
  SetStatusAndPresence(newStatusKey, newPresence := "", expiration := this.Statuses[newStatusKey].expiration) {
    this.SetStatus(this.Statuses[newStatusKey])
    this.SetPresence(newPresence)

    CommonReturn()
  }


  /**
   *  Set Slack status for home and away
   * 
   *  @param newStatusKey        The status key of the new status (the key from this.Statuses)
   *  @param newPresence         The new presence (auto|away)
   *  @param expiration          The expiration for this status, as a unix timestamp
   */
  SetSlackHomeStatusAndPresence(newStatusKey, newPresence := "", expiration := this.Statuses[newStatusKey].expiration) {
    this.SetStatus(this.Statuses[newStatusKey], [this.Tokens[2]], expiration)
    this.SetPresence(newPresence, [this.Tokens[2]])

    CommonReturn()
  }
  SetSlackWorkStatusAndPresence(newStatusKey, newPresence := "", expiration := this.Statuses[newStatusKey].expiration) {
    this.SetStatus(this.Statuses[newStatusKey], [this.Tokens[1]], expiration)
    this.SetPresence(newPresence, [this.Tokens[1]])

    CommonReturn()
  }
  

  /**
   *  Sets my Slack status for one or more accounts
   * 
   *  @param newStatus           The status object of the new status, contains properties text, emoji, expiration
   *  @param tokens              The array of tokens for my Slack accounts. Defaults to all my accounts.
   *  @param expiration          The expiration for this status, as a unix timestamp
   */
  SetStatus(newStatus, tokens := this.Tokens, expiration := newStatus.expiration) {
    webRequest := ComObject("WinHttp.WinHttpRequest.5.1")
    data := "profile={'status_text': '" . newStatus.text . "', 'status_emoji': '" . newStatus.emoji . "', 'status_expiration': " . expiration "}"

    for i, thisToken in tokens {
      webRequest.Open("POST", this.Urls.Users.Profile.Set)
      webRequest.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
      webRequest.SetRequestHeader("Authorization", "Bearer " . thisToken)
      webRequest.Send(data)
    }
  }


  /**
   *  Set presence for for one or more accounts
   * 
   *  @param newPresence         The new presence (auto|away)
   *  @param tokens              The array of tokens for my Slack accounts. Defaults to all my accounts.
   */
  SetPresence(newPresence, tokens := this.Tokens) {
    if (StrLen(newPresence) > 0) {
      webRequest := ComObject("WinHttp.WinHttpRequest.5.1")

      for i, thisToken in tokens {
        webRequest.Open("POST", this.Urls.Users.SetPresence . "?presence=" . newPresence)
        webRequest.SetRequestHeader("Content-Type", "application/application/json")
        webRequest.SetRequestHeader("Authorization", "Bearer " . thisToken)
        webRequest.Send("")
      }
    }
  }


  /**
   *  Calculate when I want my playing status to automatically expire
   *
   *  @param expirationTime        Expiration time, such as "030000" for 3:00 am
   *  @return                      Returns expiration time as Unix timestamp
   */
  CalculatePlayingExpirationTime(expirationTime) {
    expirationDateTimeLocal := FormatTime(, "yyyyMMdd") expirationTime

    if ((A_Hour "0000") >= expirationTime) {
      ; We're already past the expiration time, so will expire tomorrow
      expirationDateTimeLocal := DateAdd(expirationDateTimeLocal, 1, "day") 
    }

    ; Convert to UTC, assumes negative UTC offset (US/Canada/etc)
    utcOffsetInHours := DateDiff(A_NowUTC, A_Now, "hours")
    expirationDateTimeUtc := DateAdd(expirationDateTimeLocal, utcOffsetInHours, "hours")

    ; Return unix timestamp
    return ConvertDateTimeToUnixTimestamp(expirationDateTimeUtc) 
  }
}