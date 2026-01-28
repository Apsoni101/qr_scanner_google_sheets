# iOS & Android Widget Setup Guide

## Creating a basic iOS Home Screen Widget

Adding an app extension to your Flutter iOS app is similar to adding an app extension to a SwiftUI or UIKit app:

1. Run `open ios/Runner.xcworkspace` in a terminal window from your Flutter project directory. Alternatively, right-click on the `ios` folder from VSCode and select **Open in Xcode**. This opens the default Xcode workspace in your Flutter project.

2. Select **File → New → Target** from the menu. This adds a new target to the project.

3. A list of templates appears. Select **Widget Extension**.

4. Type "QrScanWidget" into the **Product Name** box for this widget. Clear the **Include Live Activity**, **Include Control**, and **Include Configuration Intent** checkboxes.

---

## Creating a Basic Android Widget

To add a Home Screen widget in Android, open the project's build file in Android Studio. You can find this file at `android/build.gradle`. Alternatively, right-click on the `android` folder from VSCode and select **Open in Android Studio**.

After the project builds, locate the `app` directory in the top-left corner. Add your new Home Screen widget to this directory. Right-click the directory, select **New → Widget → App Widget**.

Android Studio displays a new form. Add basic information about your Home Screen widget including its class name, placement, size, and source language.

When you submit the form, Android Studio creates and updates several files. The changes relevant for this setup are listed in the table below:

| Action | Target File | Change |
|--------|-------------|--------|
| Update | `AndroidManifest.xml` | Adds a new receiver which registers the NewsWidget. |
| Create | `res/layout/news_widget.xml` | Defines Home Screen widget UI. |
| Create | `res/xml/news_widget_info.xml` | Defines your Home Screen widget configuration. You can adjust the dimensions or name of your widget in this file. |
| Create | `java/com/example/homescreen_widgets/NewsWidget.kt` | Contains your Kotlin code to add functionality to your Home Screen widget. |

---

## Setting Up QR Scanner Widget more than basic in android 

### 1. Create Widget Provider (QrScanWidget.kt)

- `onUpdate()`: Called when the widget needs to be updated (on creation, on interval, or manually)
- `HomeWidgetLaunchIntent.getActivity()`: Creates an intent to launch your Flutter app when widget is clicked
- `RemoteViews`: Creates the UI for the widget using the layout file
- `Uri.parse("qrScan://open")`: Deep link that can be handled in your Flutter app to open specific screen
- `setOnClickPendingIntent()`: Makes the entire widget clickable with the defined intent


**Location:** `android/app/src/main/kotlin/com/example/qr_scanner_practice/QrScanWidget.kt`
```kotlin
package com.example.qr_scanner_practice

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetLaunchIntent

class QrScanWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {

            val views = RemoteViews(
                context.packageName,
                R.layout.qr_scan_widget
            )

            // Make entire widget clickable
            val intent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse("qrScan://open")
            )
            views.setOnClickPendingIntent(R.id.widget_root, intent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
```

### 2. Create Widget Info XML

**Location:** `android/app/src/main/res/xml/qr_scan_widget_info.xml`
```xml
<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:description="@string/app_widget_description"
    android:initialLayout="@layout/qr_scan_widget"
    android:minWidth="110dp"
    android:minHeight="110dp"
    android:resizeMode="horizontal|vertical"
    android:targetCellWidth="2"
    android:targetCellHeight="2"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />
```

### 3. Create Widget Layout

**Location:** `android/app/src/main/res/layout/qr_scan_widget.xml`
```xml
<?xml version="1.0" encoding="utf-8"?>
<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/widget_root"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/app_widget_bg"
    android:padding="16dp">


    <!-- QR SCAN ICON -->
    <ImageView
        android:id="@+id/imgScan"
        android:layout_width="48dp"
        android:layout_height="48dp"
        android:layout_gravity="start|top"
        android:padding="10dp"
        android:background="@drawable/bg_qr_circle"
        android:src="@drawable/qr_code"
        android:tint="@android:color/white" />
    <!-- APP LOGO -->
    <ImageView
        android:id="@+id/imgAppLogo"
        android:layout_width="44dp"
        android:layout_height="44dp"
        android:layout_gravity="end|top"
        android:src="@drawable/app_logo"
        android:tint="@android:color/transparent" />


    <!-- TEXT CONTAINER -->
    <LinearLayout
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="start|bottom"
        android:orientation="vertical">

        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Scan QR Codes."
            android:textColor="#CCFFFFFF"
            android:textSize="12sp" /> <!-- half of 18sp -->

        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Store Securely."
            android:textColor="#CCFFFFFF"
            android:textSize="12sp" /> <!-- half of 18sp -->

        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Google Sheets Ready."
            android:textColor="@android:color/white"
            android:textSize="13sp"
            android:textStyle="bold" />
    </LinearLayout>

</FrameLayout>
```

### 4. Update AndroidManifest.xml

this will be added automatically if you add the qrscanwidget class using New -> Widget -> App Widget in android directory .

Add the widget receiver inside the `<application>` tag:
```xml
<receiver
    android:name=".QrScanWidget"
    android:exported="true">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
    </intent-filter>
    <meta-data
        android:name="android.appwidget.provider"
        android:resource="@xml/qr_scan_widget_info" />
</receiver>
```

### 5. Required Resources

Ensure you have the following drawable resources in `android/app/src/main/res/drawable/`:
- `app_widget_bg.xml` or `app_widget_bg.png` (widget background)
- `bg_qr_circle.xml` (circular background for QR icon)
- `qr_code.xml` or `qr_code.png` (QR code icon)
- `app_logo.xml` or `app_logo.png` (app logo)

### 6. Add String Resource

Add to `android/app/src/main/res/values/strings.xml`:
```xml
<string name="app_widget_description">Quick access to QR Scanner</string>
```
