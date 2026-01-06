# Paymsa Questionnaire - Manual Testing Guide

**Date**: January 6, 2026
**Version**: 1.0
**Purpose**: Comprehensive testing checklist for the Paymsa perfume questionnaire

---

## Prerequisites

- Flask app running (check port - likely 5001 due to macOS AirPlay on port 5000)
- Valid user account registered or test credentials

---

## Test Suite Overview

This guide covers all critical functionality implemented in the questionnaire system:

1. **Authentication & Access**
2. **Navigation & Progress Tracking**
3. **Form Validation**
4. **Note Filtering by Olfactory Family**
5. **Note Synchronization (Desired vs. Rejected)**
6. **Form Submission & Results**

---

## Test Cases

### 1. Authentication & Access

**Test 1.1**: Unauthenticated User
- [ ] Navigate to homepage
- [ ] Verify "Comenzar" button is visible
- [ ] Click "Comenzar" button
- [ ] **Expected**: Registration modal appears
- [ ] **Screenshot location**: Homepage with modal

**Test 1.2**: Registration Flow
- [ ] Fill in all registration fields
  - Nombre: `Test User`
  - Email: `test@example.com`
  - Password: `TestPass123`
  - Confirm Password: `TestPass123`
- [ ] Click "Crear Perfil"
- [ ] **Expected**: Redirect to homepage with questionnaire visible
- [ ] **Screenshot location**: Successful registration

**Test 1.3**: Login Flow
- [ ] Navigate to `/login`
- [ ] Enter valid credentials
- [ ] **Expected**: Redirect to homepage with questionnaire visible
- [ ] **Screenshot location**: Successful login

---

### 2. Navigation & Progress Tracking

**Test 2.1**: Progress Indicators
- [ ] Start questionnaire (Step 1)
- [ ] **Expected**: First indicator orange, others gray
- [ ] **Expected**: "1 de 6" displayed
- [ ] Navigate through all 6 steps
- [ ] **Expected**: Each step updates indicators correctly
- [ ] **Screenshot location**: Each step (1-6)

**Test 2.2**: Button Visibility
- [ ] **Step 1**: Previous button hidden, Next button visible
- [ ] **Steps 2-5**: Both Previous and Next visible
- [ ] **Step 6**: Previous visible, Next hidden, Submit visible
- [ ] **Expected**: Button states match current step
- [ ] **Screenshot location**: Step 1, Step 6

**Test 2.3**: Previous Button Navigation
- [ ] Navigate to Step 4
- [ ] Click "Anterior" (Previous)
- [ ] **Expected**: Return to Step 3
- [ ] **Expected**: Progress indicator updates
- [ ] **Expected**: Previously selected values preserved
- [ ] **Screenshot location**: Navigation back

**Test 2.4**: Smooth Transitions
- [ ] Click Next/Previous repeatedly
- [ ] **Expected**: Fade transitions between steps
- [ ] **Expected**: No scroll jumps or UI glitches
- [ ] **Screenshot location**: Transition animation (if possible)

---

### 3. Form Validation

**Test 3.1**: Required Field - Género (Step 1)
- [ ] Do NOT select any gender option
- [ ] Click "Siguiente"
- [ ] **Expected**: Alert message appears
  - Message: "Por favor, selecciona una opción antes de continuar"
- [ ] **Expected**: Remain on Step 1
- [ ] **Screenshot location**: Validation alert

**Test 3.2**: Required Field - Valid Selection
- [ ] Select "Unisex"
- [ ] Click "Siguiente"
- [ ] **Expected**: Advance to Step 2 without alert
- [ ] **Screenshot location**: Successful advancement

**Test 3.3**: Optional Fields (Steps 2-6)
- [ ] Skip selections in Steps 2-6
- [ ] Click "Siguiente" on each
- [ ] **Expected**: Advance without validation errors
- [ ] **Screenshot location**: Skipped optional fields

---

### 4. Note Filtering by Olfactory Family

**Test 4.1**: Familia "Cualquiera" (Default)
- [ ] Navigate to Step 3
- [ ] Select "Cualquiera" (or leave default)
- [ ] Navigate to Step 5 (Notas Deseadas)
- [ ] **Expected**: ALL notes visible
  - Bergamota, Limón, Naranja, Jazmín, Rosa, Lirio, etc.
- [ ] Navigate to Step 6 (Notas a Evitar)
- [ ] **Expected**: ALL notes visible
- [ ] **Screenshot location**: Step 5 & 6 with all notes

**Test 4.2**: Familia "Floral"
- [ ] Navigate back to Step 3
- [ ] Select "Floral"
- [ ] Navigate to Step 5
- [ ] **Expected**: ONLY floral notes visible:
  - ✓ Jazmín
  - ✓ Rosa
  - ✓ Lirio
  - ✓ Geranio
  - ✓ Bergamota
  - ✓ Vainilla
  - ✓ Ámbar
- [ ] **Expected**: Non-floral notes hidden (e.g., Limón, Cedro, Cuero)
- [ ] **Screenshot location**: Step 5 with Floral filtering

**Test 4.3**: Familia "Amaderada"
- [ ] Select "Amaderada" in Step 3
- [ ] Navigate to Step 5
- [ ] **Expected**: ONLY woody notes visible:
  - ✓ Sándalo
  - ✓ Cedro
  - ✓ Vetiver
  - ✓ Pachuli
  - ✓ Cuero
  - ✓ Bergamota
  - ✓ Pimienta
- [ ] **Screenshot location**: Step 5 with Amaderada filtering

**Test 4.4**: Familia "Oriental"
- [ ] Select "Oriental" in Step 3
- [ ] **Expected**: Oriental notes visible:
  - ✓ Vainilla, Ámbar, Almizcle, Clavo, Canela, Cardamomo, Pachuli, Rosa
- [ ] **Screenshot location**: Step 5 with Oriental filtering

**Test 4.5**: Filtering Deselects Hidden Notes
- [ ] Select "Cualquiera" in Step 3
- [ ] Navigate to Step 5
- [ ] Select "Limón" (citrus note)
- [ ] Navigate back to Step 3
- [ ] Change to "Floral"
- [ ] Navigate to Step 5
- [ ] **Expected**: "Limón" is now hidden AND deselected
- [ ] **Screenshot location**: Deselected hidden note

---

### 5. Note Synchronization (Desired vs. Rejected)

**Test 5.1**: Desired Note Disables in Rejected
- [ ] Navigate to Step 5 (Notas Deseadas)
- [ ] Select "Rosa"
- [ ] Navigate to Step 6 (Notas a Evitar)
- [ ] **Expected**: "Rosa" checkbox is:
  - ✗ Disabled (cannot click)
  - ✗ Grayed out (opacity: 0.4)
  - ✗ Cursor shows `not-allowed`
- [ ] **Screenshot location**: Rosa disabled in Step 6

**Test 5.2**: Multiple Desired Notes
- [ ] Select "Vainilla" and "Bergamota" in Step 5
- [ ] Navigate to Step 6
- [ ] **Expected**: All three notes (Rosa, Vainilla, Bergamota) disabled
- [ ] **Screenshot location**: Multiple disabled notes

**Test 5.3**: Rejected Note Disables in Desired
- [ ] Navigate to Step 6 (Notas a Evitar)
- [ ] Deselect all previously selected notes (if possible)
- [ ] Select "Jazmín"
- [ ] Navigate back to Step 5
- [ ] **Expected**: "Jazmín" is disabled and grayed out
- [ ] **Screenshot location**: Jazmín disabled in Step 5

**Test 5.4**: Bidirectional Synchronization
- [ ] In Step 5, select "Cedro"
- [ ] Go to Step 6, verify "Cedro" disabled
- [ ] Return to Step 5, deselect "Cedro"
- [ ] Go to Step 6
- [ ] **Expected**: "Cedro" is now enabled and clickable
- [ ] **Screenshot location**: Re-enabled note

---

### 6. Visual Design & UX

**Test 6.1**: Hermès-Inspired Aesthetics
- [ ] Verify serif font (Playfair Display) on headings
- [ ] Verify orange (#FF8C42) accent color
- [ ] Verify cream (#FAFAF8) background on questionnaire
- [ ] Verify elegant spacing and typography
- [ ] **Screenshot location**: Overall design verification

**Test 6.2**: Hover Effects
- [ ] Hover over gender options (Step 1)
- [ ] **Expected**: Orange border appears
- [ ] Hover over note cards (Steps 5 & 6)
- [ ] **Expected**: Orange/red border + shadow-lg
- [ ] **Screenshot location**: Hover states

**Test 6.3**: Selected States
- [ ] Select options in each step
- [ ] **Expected Step 1-4**: Orange background tint + orange border
- [ ] **Expected Step 5**: Top 4px orange border + orange text
- [ ] **Expected Step 6**: Top 4px red border + red text
- [ ] **Screenshot location**: Selected states

**Test 6.4**: Responsive Design
- [ ] Test on desktop (1920px+ wide)
- [ ] Test on tablet (768px-1024px)
- [ ] Test on mobile (375px-768px)
- [ ] **Expected**: Grid layouts adapt correctly
  - Step 5/6: 2 cols mobile → 3 tablet → 4 desktop
- [ ] **Screenshot location**: Each breakpoint

---

### 7. Form Submission & Results

**Test 7.1**: Complete Questionnaire
- [ ] Fill out all 6 steps with valid selections:
  - **Step 1**: Unisex
  - **Step 2**: Eau de Parfum
  - **Step 3**: Floral
  - **Step 4**: Diario, Nocturno
  - **Step 5**: Rosa, Vainilla
  - **Step 6**: Jazmín
- [ ] Click "Descubrir" (Submit)
- [ ] **Expected**: Redirect to `/resultados`
- [ ] **Screenshot location**: Completed form before submission

**Test 7.2**: Results Page - Compatibility Index
- [ ] View results page
- [ ] **Expected**: Perfume recommendations displayed
- [ ] **Expected**: Each perfume shows compatibility percentage
  - Example: "85% Compatible"
- [ ] **Expected**: Percentages are visible and calculated
- [ ] **Screenshot location**: Results with compatibility %

**Test 7.3**: Results Match Preferences
- [ ] Verify recommended perfumes:
  - ✓ Match selected gender (Unisex)
  - ✓ Match selected family (Floral)
  - ✓ Contain desired notes (Rosa, Vainilla)
  - ✓ Exclude rejected notes (Jazmín)
- [ ] **Screenshot location**: Recommended perfume details

**Test 7.4**: Empty/Minimal Selections
- [ ] Submit with only required field (Género)
- [ ] **Expected**: Results still generated
- [ ] **Expected**: Broader recommendations shown
- [ ] **Screenshot location**: Results with minimal input

---

### 8. Edge Cases

**Test 8.1**: Conflicting Familia Changes
- [ ] Select "Floral" in Step 3
- [ ] Select floral notes in Step 5 (Rosa, Vainilla)
- [ ] Change Familia to "Amaderada" in Step 3
- [ ] Return to Step 5
- [ ] **Expected**: Rosa and Vainilla are hidden and deselected
- [ ] **Expected**: Only woody notes visible
- [ ] **Screenshot location**: Notes reset after family change

**Test 8.2**: Maximum Selections
- [ ] Select ALL available ocasiones (Step 4)
- [ ] Select ALL visible notes (Steps 5 & 6)
- [ ] **Expected**: Form handles multiple selections
- [ ] **Expected**: Submit works without errors
- [ ] **Screenshot location**: Maximum selections

**Test 8.3**: Rapid Navigation
- [ ] Click Next/Previous rapidly 10 times
- [ ] **Expected**: No UI glitches or stuck states
- [ ] **Expected**: Transitions smooth
- [ ] **Screenshot location**: After rapid navigation

---

## Automated Test Script (Playwright)

A Playwright automation script has been created but requires:
- Correct Flask app running on port 5001
- Python environment with `playwright` installed
- Test user credentials or registration capability

**Script location**: `test_questionnaire_with_auth.py`

**Run with**:
```bash
python3 test_questionnaire_with_auth.py
```

---

## Bug Reporting Template

When reporting bugs, include:

1. **Test Case**: [e.g., Test 4.2 - Familia Floral]
2. **Steps to Reproduce**:
   - Step 1...
   - Step 2...
3. **Expected Result**: [What should happen]
4. **Actual Result**: [What actually happened]
5. **Screenshot**: [Attach image]
6. **Browser**: [Chrome 120, Safari 17, etc.]
7. **Screen Size**: [Desktop 1920x1080, Mobile 375x667, etc.]

---

## Success Criteria

All tests pass if:

- ✅ Navigation works smoothly across all 6 steps
- ✅ Progress indicators update correctly
- ✅ Required field validation prevents advancement
- ✅ Note filtering shows/hides correct notes by family
- ✅ Note synchronization prevents selecting same note twice
- ✅ Form submits successfully
- ✅ Results display compatibility percentages
- ✅ Visual design matches Hermès aesthetic
- ✅ Responsive design works on all screen sizes

---

## Known Issues

1. **Port Conflict**: macOS uses port 5000 for AirPlay - Flask likely runs on 5001
2. **Favicon**: Successfully added at `static/favicon.svg`
3. **Authentication**: Required for questionnaire access

---

## Changelog

**v1.0** (2026-01-06):
- Initial testing guide created
- Covers all 6 questionnaire steps
- Includes note filtering and synchronization tests
- Automated Playwright script prepared

---

**Generated**: 2026-01-06
**Author**: Claude Code Testing Session
