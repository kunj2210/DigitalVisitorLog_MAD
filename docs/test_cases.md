# Test Case Document - Digital Visitor Log App

| TC ID | Scenario | Steps | Expected Result | Actual Result | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **TC01** | User Login | 1. Open App<br>2. Enter Email & Password<br>3. Click "Login" | Navigate to Dashboard showing the guard's welcome message. | User logged in successfully and saw the Dashboard. | Pass |
| **TC02** | Add Visitor Entry | 1. Click "Add Visitor"<br>2. Fill name, phone, flat, and purpose<br>3. Click "ADD VISITOR" | New visitor should appear in the "Recent Visitors" list immediately. | Visitor added to Firestore and visible on Dashboard. | Pass |
| **TC03** | API Fetching | 1. Tap "Quick Actions" menu<br>2. Select "API Data"<br>3. Wait for data to load | Show external API data (e.g., placeholder posts or user list). | Data fetched from external API and displayed in list. | Pass |
| **TC04** | Image Upload | 1. Open "Add Visitor" screen<br>2. Tap "Visitor Photo" box<br>3. Select "Camera" or "Gallery"<br>4. Capture/Pick an image | Selected image should show in the preview box on the form. | Image preview visible; URL saved to database. | Pass |
| **TC05** | QR Scan | 1. Click "Scan QR" on Dashboard<br>2. Point camera at a QR code<br>3. Wait for detection | Scanned result should be displayed in a dialog box. | "Result: XYZ" dialog showed successfully. | Pass |
| **TC06** | Data Visualization | 1. Open Dashboard<br>2. Look at "Visitor Statistics" section | A Pie Chart should display the distribution of visit purposes. | Pie Chart correctly reflects the database stats. | Pass |
| **TC07** | Permissions Check | 1. Tap "Scan QR" for the first time<br>2. Observe system behavior | System should show a "Allow Camera access?" dialog. | Camera permission dialog appeared as expected. | Pass |
| **TC08** | Real-time Update | 1. Open Dashboard on two devices<br>2. Add a visitor on Device A | Device B should update the totals and chart automatically. | Dashboard updated live via Provider/Firestore stream. | Pass |
