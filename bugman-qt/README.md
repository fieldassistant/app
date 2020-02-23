
# Field Assistant (QML)
## Aka. Bugman


### TODO

#### features
- about view
- export images zip
- prevent duplicate vouchers

#### fixes
- fix home view first swipe panel
    - current workaround is gross
- fix editing sets
- remove filter hack fix after 5.14.2 update
- images picker kinda jumps when closing
- the image preview slides side-to-side when opening
- fix camera image orientation on saved files
- I think the gps position doesn't update properly
- the "active" state for the imagebar loader doesn't really work
- remove ticks on entryblock imagebar
- new transitions for stackview

#### housework
- migrate navigation to stackview
- separate entry types into separate files
- some docs/comments
- onTextChanged in EntryField and TemplateField is kinda dodgey
    - could Qt.binding() fix it?

#### future
- swipedelegate for editing template fields
- swipedelegate for switch..?
- more field types
    - range (from, to)
    - combobox (list of options)


### Development

+ Install Qt 5.14.2+
+ Install Java 8
+ Install Android Studio

+ Use the Android Studio SDK Manager:
    + Install NDK v20+ (v29.0.3)
    + Install SDK v21+ (v29)

#### Android

+ Configure QtCreator:
    + Update to 4.11.1+
    + Set Paths: Tools -> Options -> Devices -> Android
    + https://doc.qt.io/qtcreator/creator-developing-android.html#specifying-android-device-settings

##### Notes
+ The android camera is broken in Qt 5.14, fixed in 5.14.2
+ Deploying android for release (signed & compiled) is broken in QtCreator 4.11, fixed in 4.11.1

#### iOS
+ Buy a Mac
+ Install XCode
+ Configure QtCreator, I assume?
