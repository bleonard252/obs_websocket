# Changelog

## 5.0.0+10

* commands
  * Outputs - ToggleReplayBuffer
  * Outputs - StartReplayBuffer
  * Outputs - StopReplayBuffer
  * Outputs - SaveReplayBuffer
* unit tests
  * ToggleReplayBuffer

## 5.0.0+9

* dependency bump for publish_tools again

## 5.0.0+8

* updated dependency for publish_tools

## 5.0.0+7

* using publish_tools from pub.dev

## 5.0.0+6

* additional events supported
  * Config - CurrentSceneCollectionChanging
  * Config - CurrentSceneCollectionChanged
  * Config - SceneCollectionListChanged

## 5.0.0+5

* improved build tools (using publish_tools package)
* issue #25 implemented
* cli commands
  * general - BroadcastCustomEventCommand
  * general - CallVendorRequestCommand
  * general - BrowserEventCommand (helper method)
  * general - GetHotkeyListCommand
  * general - TriggerHotkeyByNameCommand
  * general - TriggerHotkeyByKeySequenceCommand
  * general - SleepCommand
* unit tests
  * GetVersion
  * CallVendorRequest
  * obsBrowserEvent
  * GetHotkeyList

## 5.0.0+5

* improved build tools (using publish_tools package)
* issue #25 implemented
* cli commands
  * general - BroadcastCustomEventCommand
  * general - CallVendorRequestCommand
  * general - BrowserEventCommand (helper method)
  * general - GetHotkeyListCommand
  * general - TriggerHotkeyByNameCommand
  * general - TriggerHotkeyByKeySequenceCommand
  * general - SleepCommand
* unit tests
  * GetVersion
  * CallVendorRequest
  * obsBrowserEvent
  * GetHotkeyList

## 5.0.0+5

* improved build tools (using publish_tools package)
* issue #25 implemented
* cli commands
  * general - BroadcastCustomEventCommand
  * general - CallVendorRequestCommand
  * general - BrowserEventCommand (helper method)
  * general - GetHotkeyListCommand
  * general - TriggerHotkeyByNameCommand
  * general - TriggerHotkeyByKeySequenceCommand
  * general - SleepCommand
* unit tests
  * GetVersion
  * CallVendorRequest
  * obsBrowserEvent
  * GetHotkeyList

## 5.0.0+4

* build tool changes
* fix for issue #23

## 5.0.0+3

* SetPersistentData, GetSceneCollectionList, SetCurrentSceneCollection, CreateSceneCollection, GetProfileList, GetProfileParameter, SetProfileParameter now supported as high level commands
* more tests
* improved build tools

## 5.0.0+2

* resolving some release issues

## 5.0.0+1

* support for GetSceneItemIndex and SetSceneItemIndex
* improved build tools

## 5.0.0

* production release
* obs cli can run shell commands with `listen`
* improved cli README

## 5.0.0-dev.6

* ui module now supports: OpenInputPropertiesDialog, OpenInputFiltersDialog, OpenInputInteractDialog, OpenVideoMixProjector, OpenSourceProjector
* changed LICENSE

## 5.0.0-dev.5

* obs at the command prompt
* updated README
* `obs version` to confirm installed package from cli

## 5.0.0-dev.4

 - SceneListResponse fix null currentPreviewSceneName 
 - batch operations now supported
 - add batch.dart example
 - fix Flutter web `Enum` error Issue #16
 
## 5.0.0-dev.3

- typed responses, additional helper methods
  
## 5.0.0-dev.2

- bug fixes (mostly events), additional helper methods
  
## 5.0.0-dev.1

- new release for obs websocket v5.0.0 protocol

## 2.4.3

- README fix and grind improvement

## 2.4.2

- added fallbackEvent back in

## 2.4.1

- issue #11

## 2.4.0

- restructure of the cli functionality

## 2.3.1

- fix for &quot;web&quot; platform

## 2.3.0

- support for &quot;web&quot; platform

## 2.2.12

- updated package layout

## 2.2.11

- more fix for GetSourceActive and GetSourceActive

## 2.2.10

- fix for GetSourceActive and GetSourceActive

## 2.2.9

- readme typo

## 2.2.8

- added GetMediaSourcesList, GetSourcesList, GetSourceActive and GetSourceActive

## 2.2.7

- added SaveStreamSettings, TakeSourceScreenshot, SetCurrentProfile, GetCurrentProfile and RefreshBrowserSource

## 2.2.6

- disable studio mode

## 2.2.5

- adjustments to the publish workflow

## 2.2.4

- code tweaks from Sabuto merged

## 2.2.3

- improved API docs

## 2.2.2

- correction of some class names in the readme

## 2.2.1

- restructured the event model

## 2.2.0

- file name changed to match publish spec

## 2.1.2

- runtime js compatibility

## 2.1.1

- tweak readme

## 2.0.8

- added grind for a simplified workflow

## 2.0.7

- more readme improvements

## 2.0.6

- improved readme and example

## 2.0.5

- trying to remove the dart:io dependency, for greater platform support

## 2.0.4

- using pedantic for static analysis, upgrade to some dependencies

## 2.0.3

- universal_io package replaces dart:io to maybe support web

## 2.0.2

- updated API docs

## 2.0.1

- static analysis improvements

## 2.0.0

- null safety, method based commands and event handling

## 1.0.0

- included example matches the README and addition of bin/ws-obs.app command lne app for OSX

## 0.0.2

- initial simplified support for responses

## 0.0.1

- initial commit, no support for responses to commands