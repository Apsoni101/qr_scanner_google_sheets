# 📱 QR Scanner Google sheets

A Flutter QR Scanner application that allows users to scan QR codes, view results, handle errors, and store scanned data in google sheets with scan data , device id , timestamp , userid .  
The app follows **Clean Architecture**, uses **BLoC** for state management, and supports **offline storage**. 

Note 1 :- when app has no internet it saves data locally and when connection restores it automatically syncs with remote google sheet in home screen also the list of google sheets is cached for offline access. 

Note 2 :- The app can only list the sheets that are created in app by user (done intentionally) .

---

## 📸 App Screenshots

| Signin Screen |
|------------|
|<img src="https://github.com/user-attachments/assets/433308c7-6a27-4a59-abef-326e988e51f5" width="360" height="720"/>|

| Home Screen | Scanner Screen | Scan Result Screen |
|------------|---------------|---------------|
| ![](https://github.com/user-attachments/assets/ae3a04fa-ceca-4524-956b-65210aff1ba0)  | ![](https://github.com/user-attachments/assets/aa4691bc-d8ae-4903-b885-aa4d3ee5fc1d) | ![](https://github.com/user-attachments/assets/13654c40-ffea-4afa-bd6c-282c2c9448e4)|

| Confirmation and sheet selection for save screen | Create new Sheets | QR History |
|-------------|-------------|---------|
| ![](https://github.com/user-attachments/assets/f7c8a066-57e7-4309-9f7f-8c1ac773e1fc) | ![](https://github.com/user-attachments/assets/6bb2be65-8e71-436c-b7f3-0c716a6075da) | ![](https://github.com/user-attachments/assets/00504736-081c-4b86-95a1-a86772301064)  |

---


## 🚀 App Flow for saving and local sync when no internet 


https://github.com/user-attachments/assets/9d032b9c-1b97-478d-9bc1-c0a85caff0bc

## 🚀 App Screens 

### 🏠 1. Home Screen
This is the **first screen** when the app opens.
It consist of two buttons one to go to scan qr code and one to view history button .
Home screen is responsible for syncing when network connectivity changes for syncing with remote when saved locally due to no connectivity . 

---

### 📷 2. QR Scanner Screen
This screen opens the **camera**.
It Toggles flash .
Can Scan Qr And Analyze .
Can open camera and gallery for capturing QR .

---

### ✅ 3. Scan Result Screen
After scanning, the app shows the result.
In this screen we can add comments or notes to be saved in sheet . 

---

### 📄 4. Review and Sheets Selection for saving 

Can review the comment and scanned data before saving . 
This screen shows all saved sheets for selecting sheet to save .
Can Also create new sheets . 

---

###  5. Signin Screen 
Google signin for authentication 

---
