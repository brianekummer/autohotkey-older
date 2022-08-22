;--------------------------------------------------------------------------------------------------
; Add auto-correct to EVERY application
; includes my customizations
; 
; https://www.autohotkey.com/download/AutoCorrect.ahk, based on http://www.biancolo.com/articles/autocorrect/
;--------------------------------------------------------------------------------------------------
#Include "%A_ScriptDir%\Lib\AutoCorrect_v2.ahk"

;----- Things I intentionally do NOT want to fix -----
;::brian::Brian      ; Doing this always capitalizes Brian-kummer@company.com
;::kummer::Kummer    ; Otherwise, it changes brian-kummer to brian-Kummer, and some apps REQUIRE a username to be all lowercase
;::i::I              ; Don't want to always capitalize i (e.g. "-i")
;::iqtc::IQTC
;::pto::PTO
::~~::≈              ; Approximation. I use ~~ in markdown in Typora

::nancy::Nancy
::manoj::Manoj
::prabhu::Prabhu
::shane::Shane
::vanita::Vanita
::rakesh::Rakesh
::oren::Oren
::mason::Mason
::raja::Raja
::teja::Teja
::henry::Henry
::krishna::Krishna
::foster::Foster
::kiran::Kiran
::kyle::Kyle
::jesse::Jesse
::cms::CMS
::wfh::WFH
;::i'll::I'll
;::i'd::I'd
;::i've::I've
;::i'm::I'm

; Things that I mistype that aren't in AutoCorrect.ahk
::havent::haven't
::dicsuss::discuss
::disucss::discuss
::abd::and
::enetered::entered
::erro::error
::betwene::between
::aything::anything
::sugest::suggest
::wheer::where

::Slakc::Slack
::slakc::slack
