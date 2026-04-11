# Simulator Configuration

## Default Device
- **Device Type**: iPhone 13 mini
- **Target OS**: iOS 18.5 (Fallback to available version)

## Dynamic UDID Discovery
To find the UDID at runtime, use:
`xcrun simctl list devices "iPhone 13 mini" | grep -v "unavailable" | grep -m 1 "iPhone 13 mini" | awk -F '[()]' '{print $2}'`

## Management Commands
- **List Devices**: `xcrun simctl list devices`
- **Boot**: `xcrun simctl boot [UDID]`
- **Launch App**: `xcrun simctl launch [UDID] [BundleID]`
- **Open Simulator App**: `open -a Simulator`
