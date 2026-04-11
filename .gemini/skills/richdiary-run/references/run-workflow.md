# App Run Workflow

Follow these steps when the user asks to "Run the app" (`실행해줘`):

1. **Build Check**: Ensure the project is built. If not, run `tuist generate` and `xcodebuild`.
2. **Find App Path**: Locate the `.app` bundle using `xcodebuild -showBuildSettings`.
3. **Boot Simulator**: Boot the target simulator (iPhone 13 mini) if it's not already running.
4. **Install & Launch**:
   - `xcrun simctl install [DeviceID] [AppPath]`
   - `xcrun simctl launch [DeviceID] [BundleID]`
5. **Bring to Front**: Open the Simulator app to show the running device.

## Bundle ID
- `io.tuist.RichDiary`
