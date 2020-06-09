
# Field Assistant (QML)
## Aka. Bugman


### TODO

#### features
- about view
- prevent duplicate vouchers

#### fixes
- fix editing sets (is it only 'name' ?)
- opening entry edit view is slow (is it the images grid?)
- fix home view first swipe panel
    - current workaround is gross
- some bugs around selection sets in image picker
- new camera images aren't refreshed into the image picker
  - probably image lists not updating again
  - maybe just manually force a reload whenever it opens
- fix camera image orientation on saved files?
- I think the gps position doesn't update properly
  - like, first data doesn't exist at all
- remove ticks on entryblock imagebar


#### housework
- images picker kinda jumps when closing
- separate entry types into separate files
- the "active" state for the imagebar loader doesn't really work
- the image preview slides side-to-side when opening
- many docs/comments
- onTextChanged in EntryField and TemplateField is kinda dodgey
    - could Qt.binding() fix it?

#### future
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
+ Deploying android for release (signed & compiled) is broken in QtCreator 4.11, fixed in 4.11.1
+ Can't figure out how to free-self-sign iOS builds. Still, it would only last 7 days before it deletes itself.

#### iOS
+ Buy a Mac
+ Install XCode (11+, requires Catalina)
+ Configure QtCreator
+ Connect an iOS device
+ Pay for dev subscription
+ ???
