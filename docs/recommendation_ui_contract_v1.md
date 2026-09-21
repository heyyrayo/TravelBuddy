# TravelBuddy Recommendation UI Contract — V1

## 1. Purpose

Define the presentation-layer contract for TravelBuddy recommendations before production integration.

This contract does not modify or redefine the recommendation engine.

## 2. Current Integration Status

- V1.3 recommendation engine: LOCKED.
- V2.2 recommendation engine: EXPERIMENTAL.
- Weather expansion: PAUSED.
- Database integration: PAUSED.
- ML integration: PAUSED.
- Production recommendation integration: NOT YET APPROVED.

## 3. Recommendation Card — Allowed Fields

A recommendation card may display:

- Destination name
- State / region, when available from an authoritative destination record
- Recommendation rank, when intentionally exposed
- A validated destination image/reference, when available
- A concise recommendation explanation derived from supported recommendation evidence

## 4. Featured Recommendation — Allowed Fields

A featured recommendation may display:

- Destination name
- State / region
- Validated image/reference
- Concise recommendation explanation
- Supported travel-relevance signals

It must not invent:

- Best season
- Budget tier
- Student suitability
- Family suitability
- Solo/friends suitability
- Trip duration
- Weather claims

unless those values are supplied by an approved, validated data source.

## 5. Recommendation Explanation

The UI may explain why a destination was recommended using validated signals.

Examples of supported signal categories include:

- Temperature preference match
- Attraction-interest match
- Transport-access match
- Locality / local-evidence relevance

Internal scoring mechanics must not automatically be presented as user-facing facts.

## 6. Unsupported UI Claims

The recommendation UI must not generate or imply facts that are absent from the approved data contract.

Prohibited by default:

- "Perfect for Students"
- "Family Friendly"
- "Best for Solo Travelers"
- "Budget"
- "Luxury"
- "Best Season"
- Exact trip duration
- Exact expected travel cost
- Exact weather conditions
- Attraction ownership/membership claims based only on proximity
- Destination popularity claims without supporting evidence

## 6A. Supported Signal Presentation

Supported recommendation signals may be displayed as concise neutral labels.

Allowed examples:

- Temperature match
- Interest match
- Transport access
- Local relevance

Signal labels must describe the available evidence and must not be converted into unsupported suitability claims.

The UI must not expose internal numeric component scores unless a separately approved contract explicitly permits them.

If no supported signals are available, the signal section should be omitted.

## 7. Destination Detail Screen

A recommendation destination detail screen must receive a destination-specific data contract.

It must not use a destination-specific template containing unrelated hard-coded facts.

The screen must never display Manali-specific information for another destination.

Required destination identity fields:

- Destination ID
- Destination name
- State / region, when available
- Latitude / longitude, when approved for the feature

Optional sections may only render when validated data exists:

- About
- Attractions
- Weather
- Transport
- Gallery
- Local information
- Recommendation explanation

Missing data must be represented as unavailable/omitted, not fabricated.

## 8. Image Policy

Images must be destination-specific.

If no validated image is available:

- use a generic visual fallback, or
- omit the image-dependent content.

Never reuse a different destination's image as if it represented the requested destination.

## 9. Loading State

Loading UI may communicate that recommendations are being prepared.

It must not imply that a recommendation has already been calculated when it has not.

## 10. Empty State

If no valid recommendations are available, show an explicit empty state.

Do not populate the screen with demo destinations.

## 11. Error State

Recommendation loading failures must use the application's existing error-state conventions.

Retry must trigger the recommendation loading operation.

## 12. Data Flow

Target architecture:

Recommendation source
    ↓
Recommendation domain/presentation contract
    ↓
RecommendationState
    ↓
RecommendedForYouScreen
    ↓
Destination-detail route
    ↓
Destination-detail contract

The presentation layer must not reconstruct recommendation scores or infer missing destination facts.

## 13. Separation of Concerns

Recommendation engine fields and UI fields are separate contracts.

Engine/internal fields may include:

- recommendation score
- component scores
- evidence fields
- locality classifications
- intermediate calculation fields

These must not automatically become UI fields.

## 14. Versioning

This document is V1 of the recommendation UI contract.

Changes must be versioned and validated before production integration.

## 15. Production Integration Gate

Real recommendation data may be connected only after:

1. Weather coverage required by the approved recommendation scope is available.
2. Recommendation input coverage is validated.
3. V2.2 behavior is explicitly approved for production.
4. Destination-detail data contract is implemented.
5. Recommendation UI regression tests pass.
6. No locked artifact is overwritten.

