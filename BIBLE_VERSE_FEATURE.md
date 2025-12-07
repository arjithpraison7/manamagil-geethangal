# Daily Bible Verse Feature

## Overview
The app now includes a daily Bible verse feature that displays Tamil Bible verses at the top of the index page and sends push notifications every morning at 10:00 AM.

## Features

### 1. **Daily Bible Verse Card**
- Displays at the top of the Index page
- Beautiful gradient card design with Tamil text
- Shows verse text and reference
- Refresh button to reload the verse
- Smooth animations on load

### 2. **Smart Fetching System**
The app uses a three-tier system to ensure you always get a verse:

1. **API Fetch** (when internet is available)
   - Tries to fetch fresh verses from online Bible API
   - Caches the verse for offline use

2. **Cache** (for offline use)
   - Stores today's verse locally
   - Reuses cached verse if already fetched today

3. **Fallback Verses** (when offline)
   - 15 pre-stored Tamil Bible verses
   - Cycles through them based on day of year
   - Ensures you always see a verse even without internet

### 3. **Push Notifications**
- Daily notification at 10:00 AM
- Tamil title: "இன்றைய வேத வசனம்"
- Shows verse preview in notification
- Only sends when internet is available
- Falls back to offline verses if no connection

### 4. **Tamil Verses Included**
The app includes 15 popular Tamil Bible verses:
- சங்கீதம் 23:1 (The Lord is my shepherd)
- ஏசாயா 40:31 (Those who wait on the Lord)
- 1 யோவான் 4:16 (God is love)
- 1 பேதுரு 5:7 (Cast all your cares)
- யோவான் 14:27 (Peace I leave with you)
- And 10 more...

## How It Works

### On App Launch:
1. Initializes notification service
2. Requests notification permissions
3. Schedules daily 10 AM notification
4. Loads today's verse on Index page

### Daily at 10:00 AM:
1. Checks for internet connection
2. If online: fetches fresh verse from API
3. If offline: uses fallback verse
4. Sends notification with verse preview
5. Caches verse for offline use

### When Opening Index Page:
1. Checks if verse is cached for today
2. If yes: displays cached verse immediately
3. If no: tries API fetch
4. If API fails: shows fallback verse
5. All with smooth loading animation

## Files Created

1. **bible_verse_service.dart**
   - Manages verse fetching and caching
   - Contains 15 fallback Tamil verses
   - Handles API communication

2. **bible_verse_card.dart**
   - UI component for displaying verse
   - Animated card with gradient design
   - Refresh functionality

3. **notification_service.dart**
   - Manages push notifications
   - Schedules daily 10 AM alerts
   - Handles notification permissions

## Permissions Required

### Android (AndroidManifest.xml):
- `INTERNET` - For fetching verses online
- `POST_NOTIFICATIONS` - For sending notifications
- `SCHEDULE_EXACT_ALARM` - For precise 10 AM timing
- `RECEIVE_BOOT_COMPLETED` - To reschedule after device restart

## Dependencies Added

```yaml
http: ^1.2.0                          # API calls
flutter_local_notifications: ^18.0.1   # Push notifications
timezone: ^0.9.4                       # Time zone handling
```

## Customization Options

### Change Notification Time:
Edit `notification_service.dart`:
```dart
tz.TZDateTime scheduledDate = tz.TZDateTime(
  tz.local,
  now.year,
  now.month,
  now.day,
  10,  // Change this hour (24-hour format)
  0,   // Change this minute
);
```

### Add More Fallback Verses:
Edit `bible_verse_service.dart` - `_fallbackVerses` list:
```dart
{
  'verse': 'Your Tamil verse text',
  'reference': 'Book Chapter:Verse'
},
```

### Use Different API:
Replace the API endpoint in `bible_verse_service.dart`:
```dart
final response = await http.get(
  Uri.parse('YOUR_TAMIL_BIBLE_API_URL'),
);
```

## Testing

1. **Test Notification**:
   - App shows notification permission prompt on first launch
   - Wait until 10:00 AM or change time in code to test

2. **Test Offline Mode**:
   - Turn off internet
   - Open app
   - Should show fallback verse

3. **Test Refresh**:
   - Tap refresh icon on verse card
   - Should reload verse

## Troubleshooting

### Notifications Not Working:
1. Check app notification permissions in device settings
2. Ensure battery optimization is off for the app
3. Verify `AndroidManifest.xml` has all permissions

### Verse Not Loading:
1. Check internet connection
2. Verify API endpoint is accessible
3. Check device logs for errors

### Same Verse Every Day:
1. Clear app data
2. Check if date comparison is working
3. Verify cache is being updated

## Future Enhancements

- [ ] Add more Tamil verses to fallback library
- [ ] Integrate with dedicated Tamil Bible API
- [ ] Allow users to customize notification time
- [ ] Add option to share verse
- [ ] Support multiple languages
- [ ] Add verse history/favorites
