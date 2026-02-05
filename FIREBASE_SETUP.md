# Firebase Setup Guide - One Stop Editor

## Step 1: Enable Authentication

1. Go to **Firebase Console**: https://console.firebase.google.com/
2. Select your project
3. Click **Authentication** in the left menu
4. Click **Get started** (if not already done)
5. Go to **Sign-in method** tab
6. Click **Email/Password**
7. **Toggle ON** the first option (Email/Password)
8. Click **Save**

## Step 2: Create Firestore Database

1. In Firebase Console, click **Firestore Database** in the left menu
2. Click **Create database**
3. Choose **Start in test mode** (for development)
4. Select your preferred location (choose closest to you)
5. Click **Enable**

## Step 3: Set Firestore Security Rules

1. In Firestore Database, go to **Rules** tab
2. Replace the rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      // Allow users to read their own data
      allow read: if request.auth != null && request.auth.uid == userId;

      // Allow users to create their own document during signup
      allow create: if request.auth != null && request.auth.uid == userId;

      // Allow users to update their own data
      allow update: if request.auth != null && request.auth.uid == userId;

      // Prevent deletion from client
      allow delete: if false;
    }
  }
}
```

3. Click **Publish**

## Step 4: Run the App

```bash
# Make sure dependencies are installed
flutter pub get

# Run on connected device/emulator
flutter run
```

## Step 5: Test Signup & View Users in Firebase

### Sign Up:

1. Open the app
2. Fill in the signup form:
   - Name: Your Name
   - Email: your-email@gmail.com (use a real email!)
   - Password: At least 6 characters
3. Click **Sign up**
4. **Check your email** for the verification link
5. Click the verification link to verify your account

### View Users in Firebase Console:

**Authentication Users:**

1. Go to Firebase Console → **Authentication** → **Users** tab
2. You'll see your registered user with email and UID
3. Status shows if email is verified

**Firestore Data:**

1. Go to Firebase Console → **Firestore Database** → **Data** tab
2. Click on the **users** collection
3. You'll see a document with your user's UID
4. Data includes:
   - `uid`: User ID
   - `name`: User's name
   - `email`: User's email
   - `emailVerified`: true/false
   - `createdAt`: Timestamp
   - `updatedAt`: Timestamp

## Troubleshooting

### "Cannot click Sign up button"

- Make sure Firebase is initialized (check console for errors)
- Ensure google-services.json is in android/app/
- Run `flutter clean && flutter pub get`

### "No users appearing in Firestore"

- Check Firestore rules are set correctly
- Verify Authentication is enabled
- Check app logs for errors: `flutter logs`

### "Email verification not working"

- Make sure you use a real email address
- Check spam/junk folder
- Try resending verification email from the app

## Success Indicators

✅ User appears in **Authentication** → **Users**
✅ User document created in **Firestore** → **users** collection
✅ Email verification email received
✅ Can login after verifying email
✅ Cannot login before verifying email
