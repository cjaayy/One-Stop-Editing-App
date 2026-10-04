# One Stop Editor — Comprehensive App Redesign Specification

This document details the architectural, UI/UX, and visual redesign guidelines for the **One Stop Editor** mobile application.

---

## 1. Core Visual Principles & Constraints

### 1.1 Strict Constraints Checklist
- [x] **No Glow Effects**: Eliminate all blurred, neon-style glow shadows (`BoxShadow` with high blur radius or saturated colors). Use flat surfaces, sharp borders (1px solid), or clean subtle elevation.
- [x] **Color Palette**: Seamless blend of **Purple**, **Pink**, and **Green** across a modern dark slate foundation.
- [x] **Solid Button Backgrounds**: Every button must feature a solid, high-contrast background color (no low-contrast gradients, no transparent ghost buttons for main actions).
- [x] **No Duplicate Buttons**: Only one primary action button per card or section. Remove redundant duplicate CTAs.
- [x] **No Emojis**: Replace all Unicode emojis (e.g., 📸, ✨, 🚀, 🔒, ⚠️) with clean Material or Cupertino vector icons.
- [x] **No Duplicate Labels or Features**: Eliminate repetitive section titles, duplicate form headers, and overlapping feature entry points.

---

## 2. Color System: Purple, Pink & Green Blend

```
+-------------------------------------------------------------------------+
|                               PALETTE                                   |
+-------------------+-------------------+-------------------+-------------+
| Deep Background   | Primary Purple    | Accent Pink       | Accent Green|
| #0D0B14           | #7C3AED           | #EC4899           | #10B981     |
+-------------------+-------------------+-------------------+-------------+
```

### Color Tokens

| Token Name | Hex Code | Purpose |
| :--- | :--- | :--- |
| `backgroundDark` | `#0D0B14` | Main screen background |
| `surfaceDark` | `#161324` | Cards, bottom sheets, dialog backgrounds |
| `surfaceBorder` | `#2D2545` | Clean 1px card and input borders (no glow) |
| `primaryPurple` | `#7C3AED` | Primary brand color, main navigation, hero elements |
| `accentPink` | `#EC4899` | Secondary accent, creative/media tools, badges |
| `accentGreen` | `#10B981` | Success states, action confirmations, valid inputs, active filters |
| `textPrimary` | `#F8FAFC` | Primary headlines and high-emphasis text |
| `textSecondary` | `#94A3B8` | Subtitles, helper text, inactive labels |
| `errorRed` | `#EF4444` | Validation errors and destructive actions |

---

## 3. Standardized Component System

### 3.1 Solid Action Buttons (No Gradients, No Glows)

All buttons across the app follow a single solid background paradigm:

1. **Primary Solid Purple Button** (`#7C3AED` background, `#FFFFFF` text):
   - Used for main screen actions: *Sign In*, *Create Account*, *Export Collage*, *Create Template*.
   - Flat background, 12px border radius, no outer glow shadow.
2. **Action Solid Green Button** (`#10B981` background, `#FFFFFF` text):
   - Used for affirmative actions: *Save Changes*, *Use Template*, *Add Photo*.
3. **Accent Solid Pink Button** (`#EC4899` background, `#FFFFFF` text):
   - Used for creative studio tools, filters, or collage customization triggers.
4. **Secondary Solid Dark Button** (`#231F38` background, `#E2E8F0` text, 1px border `#3A3459`):
   - Used for cancel, dismiss, or secondary alternative options.

### 3.2 Iconography (Zero Emojis)
- Replace all status emojis with vector icons:
  - Valid requirement: `Icons.check_circle_rounded` (in `#10B981`)
  - Invalid requirement: `Icons.cancel_rounded` (in `#64748B`)
  - Password visibility: `Icons.visibility_outlined` / `Icons.visibility_off_outlined`
  - Collage: `Icons.grid_view_rounded`
  - Templates: `Icons.dashboard_customize_outlined`
  - Photo / Media: `Icons.image_outlined`, `Icons.videocam_outlined`

---

## 4. Screen-by-Screen Redesign Plan

### 4.1 Authentication Screens
- **Login (`login_screen.dart`)**:
  - Remove glow shadows behind the header and input boxes.
  - Form fields use `#161324` background with a clean `#2D2545` solid border.
  - Single solid purple **Sign In** button.
  - Clean social login button with solid surface `#161324` and single Google logo.
  - Remove duplicate labels (do not show "Email Address" as both label, hint, and error prefix).

- **Sign Up (`signup_screen.dart`)**:
  - Remove neon glow on password validation box.
  - Password rules checklist: use solid `#10B981` checkmarks with vector icons (`Icons.check_circle`), no emoji bullets.
  - Single solid pink or purple **Create Account** button.
  - Single terms and conditions checkbox line.

- **Email Verification (`email_verification_screen.dart`)**:
  - Replace emoji mail icons with `Icons.mark_email_read_outlined` in `#7C3AED`.
  - Single solid purple button **Open Email App** and secondary solid button **Resend Email**.

---

### 4.2 Home Screen (`home_screen.dart`)
- **Header**:
  - Clean user greeting with solid status badge (e.g. Green `#10B981` dot for online/active).
  - Admin button only visible when user has admin role (solid purple badge).
- **Feature Cards (Zero Duplicate Shortcuts)**:
  - **Photo Collage**: Solid purple accent badge, subtitle, direct link to collage creator.
  - **Photo Templates**: Solid pink accent badge, subtitle, direct link to template picker.
  - **Video Templates**: Solid green accent badge, subtitle, direct link to video tools.
  - Remove redundant duplicate buttons inside card headers.
- **Recent Works**:
  - Clean horizontal scroll of recent projects with aspect ratio tags.

---

### 4.3 Collage Creator (`collage_editor_screen.dart`)
- **Canvas View**:
  - Clean solid border around image slots.
  - Active slot highlight: 2px solid `#10B981` (Green) without any outer glow.
- **Toolbar**:
  - Solid segmented controls for layout selection (2 photos, 3 photos, 4 photos, grid).
  - Aspect ratio chips: Solid `#161324` background when inactive, solid `#7C3AED` when selected.
  - Top Action Bar: Single solid green **Export** button in the top right. Remove duplicate floating export buttons.

---

### 4.4 Templates Screen (`templates_screen.dart`)
- **Categories Navigation**:
  - Clean horizontal pill tabs (All, Photo, Video, Custom) with solid fill when active (`#7C3AED`).
  - No duplicate subcategory buttons.
- **Template Card**:
  - Clean preview thumbnail.
  - Single solid button: **Use Template** (`#10B981` Green).
  - Clean metadata chips (aspect ratio, photo count) with solid dark background `#231F38`.

---

### 4.5 Admin Dashboard (`admin_dashboard_screen.dart`)
- **Overview Metrics**:
  - Stats cards using Purple (`#7C3AED`), Pink (`#EC4899`), and Green (`#10B981`) solid metric values.
  - No glow overlays on graph/stats boxes.
- **Template Manager**:
  - Consolidated template list item with single edit icon button and single delete icon button.
  - Single **New Template** solid purple button in the app bar.

---

## 5. Execution Roadmap

```
Step 1: Theme & Constants Consolidation
        └── Update lib/utils/constants.dart with AppColors, solid buttons, no glows.

Step 2: Unified Button Widget
        └── Create lib/widgets/app_button.dart with solid purple, pink, green variants.

Step 3: Auth Screen Refactor
        └── Remove glow shadows, replace emojis with vector icons, standardize single CTA.

Step 4: Home & Navigation Refactor
        └── Eliminate duplicate shortcuts, update cards with tri-color palette.

Step 5: Collage & Template Studios
        └── Clean up editor controls, solid active indicators, single export action.
```
