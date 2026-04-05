# Bug Report - Digital Visitor Log App

| Bug ID | Description | Steps | Severity | Fix Status |
| :--- | :--- | :--- | :--- | :--- |
| **BUG-01** | Missing validation on "Add Visitor" form. | 1. Open Add Visitor screen.<br>2. Leave Name field empty.<br>3. Click "ADD VISITOR". | **High** | Fixed (Added Form validation) |
| **BUG-02** | UI Overflow on Dashboard cards. | 1. Add a visitor with a very long name (e.g., >30 chars).<br>2. View Dashboard. | **Medium** | Fixed (Added Text overflow ellipsis) |
| **BUG-03** | QR Scanner black screen on first launch. | 1. Open app for the first time.<br>2. Click "Scan QR".<br>3. Deny permission (or delay). | **High** | Fixed (Added permission handling check) |
| **BUG-04** | API Fetching error toast not showing. | 1. Turn off internet.<br>2. Go to "API Data" screen.<br>3. Observe result. | **Low** | Fixed (Added SnackBar error message) |
| **BUG-05** | Image upload progress bar stuck at 100%. | 1. Select a high-res image.<br>2. Click "Save".<br>3. Observe loader after success. | **Medium** | Fixed (Reset _isUploading state properly) |
