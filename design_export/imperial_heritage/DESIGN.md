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
  on-surface: '#1c1c1a'
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
  secondary: '#855300'
  on-secondary: '#ffffff'
  secondary-container: '#fea619'
  on-secondary-container: '#684000'
  tertiary: '#002522'
  on-tertiary: '#ffffff'
  tertiary-container: '#003d37'
  on-tertiary-container: '#3cafa2'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d6e3ff'
  primary-fixed-dim: '#adc7f7'
  on-primary-fixed: '#001b3c'
  on-primary-fixed-variant: '#2d476f'
  secondary-fixed: '#ffddb8'
  secondary-fixed-dim: '#ffb95f'
  on-secondary-fixed: '#2a1700'
  on-secondary-fixed-variant: '#653e00'
  tertiary-fixed: '#89f5e7'
  tertiary-fixed-dim: '#6bd8cb'
  on-tertiary-fixed: '#00201d'
  on-tertiary-fixed-variant: '#005049'
  background: '#fcf9f6'
  on-background: '#1c1c1a'
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
    letterSpacing: 0.5px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.25px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-md:
    fontFamily: Inter
    fontSize: 12px
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
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  xxl: 48px
  gutter: 16px
  margin-mobile: 16px
  margin-desktop: 32px
---

## Brand & Style

This design system embodies a "Premium, Clean, and Reassuring" aesthetic, specifically tailored for the Indian travel landscape. It blends the structural rigor of **Corporate/Modern** design with the warmth of **Minimalism**. The visual narrative is built on trust and effortless navigation, ensuring that complex travel itineraries feel manageable and high-end.

The core identity utilizes subtle topographic contours and minimalist Indian travel illustrations to provide a sense of place without cluttering the interface. Every interaction should feel intentional, grounded in Material Design 3 principles but elevated through a bespoke color story and refined spacing.

## Colors

The palette is inspired by the deep indigos of Indian textiles and the vibrant marigolds of celebratory garlands. 

- **Primary (Imperial Teal/Indigo):** Used for key branding, active states, and navigation bars to instill a sense of institutional trust.
- **Secondary (Saffron/Marigold):** Reserved strictly for high-priority Call to Actions (CTAs) and critical highlights.
- **Surface Strategy:** We use an "Eggshell" off-white for light mode to reduce eye strain and provide a more premium feel than pure white. 
- **Tonal Variants:** Material 3 tonal palettes are employed for containers. Use low-luminance versions of the primary color for subtle background sections to create depth without relying on heavy lines.

## Typography

The system utilizes **Inter** for its exceptional legibility and neutral, modern character. It follows a strict 8px vertical rhythm.

- **Headlines:** Use Bold or Semi-Bold weights to create a strong information hierarchy.
- **Body Text:** Standardized on a 16px base for accessibility.
- **Labels:** Used for utility text and small buttons, with slightly increased letter spacing for clarity at small sizes.
- **Scaling:** On mobile devices, large headlines automatically scale down to prevent awkward line breaks in long Indian city names.

## Layout & Spacing

This design system uses a **Fluid Grid** model based on an 8px atomic scale. 

- **Grid:** A 12-column grid for desktop/tablet and a 4-column grid for mobile.
- **Margins:** 16px margins on mobile to maximize content real estate while maintaining a clean gutter.
- **Rhythm:** All component heights and internal padding must be multiples of 8px (e.g., 48px buttons, 16px padding).
- **Reflow:** Cards should stack vertically on mobile and shift to a multi-column masonry or grid layout on larger screens.

## Elevation & Depth

Hierarchy is established through **Tonal Layers** and **Ambient Shadows**, consistent with Material 3’s "Surface" logic.

1.  **Level 0 (Standard):** The base background (Eggshell).
2.  **Level 1 (Container):** Slightly darker or tinted surfaces for grouping content, no shadow.
3.  **Level 2 (High):** Used for elevated cards and navigation bars. Features a soft, diffused shadow (0px 4px 12px, 5% opacity) with a subtle tint of the primary color to keep the shadow "warm."
4.  **Scrims:** Used for modals, employing a 40% opacity blur rather than a heavy black overlay to maintain the "Premium" feel.

## Shapes

The shape language is generous and friendly, utilizing high corner radii to evoke comfort and safety.

- **Standard Buttons & Inputs:** 16px (Medium) radius.
- **Cards & Modals:** 24px (Large) radius for a soft, modern container look.
- **Feature Banners:** 32px (Extra Large) for high-impact visual sections.
- **Icons:** Use rounded variants of the Material Icon set to match the UI's curvature.

## Components

### Buttons
- **Primary:** Tonal Indigo buttons with white text. Padding: 16px horizontal, 12px vertical.
- **CTA:** Saffron Orange with High-Emphasis. Reserved for "Book Now" or "Confirm."
- **Ghost:** Transparent background with Indigo border for secondary actions.

### Cards
- **Travel Cards:** 24px radius. Use Level 1 Tonal Surface. Image at the top with a subtle 10% Indigo overlay to ensure text legibility.
- **Selection Cards:** Use a 2px Indigo border to indicate the selected state rather than just a color fill.

### Input Fields
- **Search:** Rounded (32px), containing a subtle topographic watermark pattern on the trailing edge.
- **Form Fields:** Outlined style with 16px radius. Label floats into the border on focus.

### Motion
Follow Material 3 standard easing:
- **Standard Easing:** `cubic-bezier(0.2, 0.0, 0, 1.0)`
- **Duration:** 200ms for small transitions (icons/buttons), 400ms for large surface transitions (modals/page entries).

### Additional Components
- **Step Indicator:** A vertical "train-track" style line for itinerary progress, using Primary color for completed steps.
- **Price Chips:** Semi-transparent Marigold containers to highlight deals within travel listings.