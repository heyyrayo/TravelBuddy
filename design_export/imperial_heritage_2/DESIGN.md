---
name: Imperial Heritage
colors:
  surface: '#fcf9f6'
  surface-dim: '#dcdad7'
  surface-bright: '#fcf9f6'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3f0'
  surface-container: '#f0edea'
  surface-container-high: '#eae8e5'
  surface-container-highest: '#e5e2df'
  on-surface: '#1b1c1a'
  on-surface-variant: '#43474e'
  inverse-surface: '#31302f'
  inverse-on-surface: '#f3f0ed'
  outline: '#74777f'
  outline-variant: '#c4c6cf'
  surface-tint: '#455f88'
  primary: '#002045'
  on-primary: '#ffffff'
  primary-container: '#1a365d'
  on-primary-container: '#86a0cd'
  inverse-primary: '#adc7f7'
  secondary: '#8e4e14'
  on-secondary: '#ffffff'
  secondary-container: '#ffab69'
  on-secondary-container: '#783d01'
  tertiary: '#450a00'
  on-tertiary: '#ffffff'
  tertiary-container: '#6b1500'
  on-tertiary-container: '#f67b5c'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d6e3ff'
  primary-fixed-dim: '#adc7f7'
  on-primary-fixed: '#001b3c'
  on-primary-fixed-variant: '#2d476f'
  secondary-fixed: '#ffdcc4'
  secondary-fixed-dim: '#ffb780'
  on-secondary-fixed: '#2f1400'
  on-secondary-fixed-variant: '#6f3800'
  tertiary-fixed: '#ffdad2'
  tertiary-fixed-dim: '#ffb4a2'
  on-tertiary-fixed: '#3c0700'
  on-tertiary-fixed-variant: '#83260e'
  background: '#fcf9f6'
  on-background: '#1b1c1a'
  surface-variant: '#e5e2df'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 57px
    fontWeight: '700'
    lineHeight: 64px
    letterSpacing: -0.25px
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  title-lg:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  space-xs: 4px
  space-sm: 8px
  space-md: 16px
  space-lg: 24px
  space-xl: 32px
  margin-mobile: 16px
  margin-desktop: 64px
  gutter: 16px
---

## Brand & Style
The design system for this premium travel application centers on "Imperial Heritage"—a visual narrative that balances the grandeur of Indian tradition with the precision of modern luxury travel. The aesthetic is **Modern Corporate** with a **Minimalist** foundation, ensuring that high-quality photography and destination content remain the focus.

The experience should evoke a sense of reliability, cultural richness, and effortless exploration. We utilize a high-contrast palette to highlight actionable elements against a warm, paper-like surface, moving away from sterile whites toward a more sophisticated, "eggshell" professional tone.

## Colors
The palette is rooted in **Deep Teal** (#1A365D), representing stability and the vast Indian sky and sea. **Saffron** (#F4A261) is used sparingly as a premium accent for calls-to-action and highlights, nodding to cultural heritage without overwhelming the UI.

The surface palette uses **Imperial Pearl** (#FCF9F6), providing a soft, warm background that reduces eye strain compared to pure white. 

### Semantic Mappings
- **Primary:** Deep Teal. Used for key branding, active states, and primary buttons.
- **Secondary:** Saffron. Used for ratings, badges, and high-priority visual accents.
- **Neutral:** A range of warm grays derived from the teal hue to maintain color harmony.
- **Error:** Deep Madder (#B00020) for critical alerts.

## Typography
The system uses **Inter** exclusively to ensure a systematic, utilitarian, and highly legible experience across all device sizes. 

- **Headlines:** Use Bold or SemiBold weights to create clear information architecture.
- **Body Text:** Standardizes on Regular weight (400) for long-form content like destination descriptions.
- **Labels:** Use Medium weight (500) and increased letter spacing for navigation and small utility text to ensure readability on mobile screens.
- **Scale:** All type follows a strict 4px/8px baseline alignment to the global grid.

## Layout & Spacing
The system operates on a **strict 8px grid**. All dimensions, padding, and margins must be multiples of 8. In constrained spaces, a 4px "half-step" is permitted.

### Layout Model
- **Mobile:** 4-column fluid grid. 16px side margins. 16px gutters.
- **Tablet:** 8-column fluid grid. 32px side margins.
- **Desktop:** 12-column fixed grid (max width 1200px). Centered alignment.

Vertical rhythm is maintained by ensuring all component heights (buttons, inputs) fall on the 8px increment (e.g., 48px or 56px height).

## Elevation & Depth
In line with Material Design 3, we use **Tonal Layers** to define depth. Elevation is communicated through varying intensities of surface color and subtle, ambient shadows.

- **Level 0 (Flat):** The base surface (#FCF9F6).
- **Level 1 (Card):** Minimal elevation. A subtle 1px border (#E0E0E0) or a very soft, diffused shadow (Blur: 4px, Y: 2, Opacity: 0.05).
- **Level 2 (Dropdowns/Modals):** Medium elevation. Deep Teal-tinted shadows to maintain color harmony (Blur: 12px, Y: 4, Opacity: 0.08).
- **Level 3 (Dialogs):** High elevation. Focused shadows with a backdrop dim of 40% black.

## Shapes
The shape language is defined as **Rounded**. We use an 8px (0.5rem) base radius to strike a balance between professional rigor and modern approachability.

- **Small Components (Buttons, Chips):** 8px radius.
- **Medium Components (Cards, Text Fields):** 12px (0.75rem) radius.
- **Large Components (Modals, Bottom Sheets):** 24px (1.5rem) top-only radius for sheets.

## Components

### Buttons
- **Filled:** Deep Teal background, White text. Elevation 0 by default, Elevation 1 on hover.
- **Outlined:** 1.5px border in Deep Teal. Transparent background.
- **Text:** No border/background. Uses Saffron for high-importance "ghost" actions (e.g., "See All").

### Cards
- **Destination:** Large image container with a "Premium Shimmer" placeholder. Bottom-aligned title with a slight gradient overlay. 12px corner radius.
- **Stat:** Simple border-based cards (#E0E0E0) for travel metrics (e.g., "Days Left", "Budget Spent").

### Input Fields
- **Outlined:** Default border is 1px Gray-300. Focus state uses a 2px Deep Teal border with the label floating in the top border line.
- **Error:** Border shifts to Deep Madder (#B00020) with supporting helper text below the field.

### Navigation
- **Bottom Navigation:** Fixed at bottom. Icons use Deep Teal for active states and Gray-500 for inactive. Active state includes a small pill-shaped background indicator (Material 3 style).
- **Top App Bar:** Centered title. Deep Teal icons on the Pearl surface. Elevation 0 until the user scrolls, then transitions to a slight elevation with a blur background.

### Feedback UI & Motion
- **Skeleton Loaders:** Use a linear gradient from #F0EBE6 to #FCF9F6.
- **Premium Shimmer:** A slow, 2.5s duration diagonal light sweep that simulates the glint on premium silk or metal.
- **Transitions:** Use "Standard Easing" (400ms) for page transitions. Components use "Accelerated Easing" (200ms) for exits and "Decelerated Easing" (300ms) for entries.

### Visuals
- **Illustrations:** Use thin-stroke (1.5px) vector illustrations of Indian landmarks (India Gate, Taj Mahal, etc.) in monochromatic Deep Teal tints.