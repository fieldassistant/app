
# Field Assistant is a paper-free, no-nonsense data collection app for researchers.

Key Features:

- Offline capable
- Record collection date-time
- Record GPS position
- Attach photos
- Data sets and custom fields
- CSV export (bundled zip)


### TODO

#### features
- about view
- prevent duplicate vouchers
- update GPS manually

#### layout/style
- restyle the header
- idk, new colours?
- move 'about' button somewhere.. logical
- move entry-block button (edit,trash) to the 'tab'
- move entry buttons (add,edit,export,trash) to the floating circle button
- short press to toggle an image, long press to preview

#### fixes
- fix editing sets (is it only 'name' ?)
- fix camera image orientation on saved files?
- I think the gps position doesn't update properly (fix needs testing)
- exporting on Android is borked

#### housework
- separate entry types into separate files
- the image preview slides side-to-side when opening
- many docs/comments
- onTextChanged in EntryField and TemplateField is kinda dodgey
    - could Qt.binding() fix it?

#### future
- more field types
    - range (from, to)
    - combobox (list of options)
- public repo of templates
- map view

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
