# Paymsa - Mobile & Responsive Design Testing Guide

**Date**: January 6, 2026
**Version**: 1.0
**Purpose**: Comprehensive testing checklist for mobile and responsive design

---

## 📱 Overview

Paymsa is designed with a mobile-first, responsive approach using Tailwind CSS. This guide covers testing procedures across all device sizes and orientations.

---

## 🎯 Supported Breakpoints

| Breakpoint | Width | Device Type | Grid Columns (Steps 5/6) |
|-----------|-------|-------------|-------------------------|
| **Mobile** | 375px - 767px | Phones | 2 columns |
| **Tablet** | 768px - 1023px | Tablets | 3 columns |
| **Desktop** | 1024px - 1919px | Laptops | 4 columns |
| **Large Desktop** | 1920px+ | Monitors | 4 columns |

---

## 📲 Device Testing Matrix

### iPhone Devices

| Device | Screen Size | Portrait | Landscape | Priority |
|--------|------------|----------|-----------|----------|
| **iPhone SE** | 375×667px | ✓ | ✓ | High |
| **iPhone 12/13** | 390×844px | ✓ | ✓ | High |
| **iPhone 12/13 Pro Max** | 428×926px | ✓ | ✓ | Medium |
| **iPhone 14 Pro** | 393×852px | ✓ | ✓ | High |
| **iPhone 14 Pro Max** | 430×932px | ✓ | ✓ | Medium |

### Android Devices

| Device | Screen Size | Portrait | Landscape | Priority |
|--------|------------|----------|-----------|----------|
| **Samsung Galaxy S21** | 360×800px | ✓ | ✓ | High |
| **Samsung Galaxy S21+** | 384×854px | ✓ | ✓ | Medium |
| **Google Pixel 5** | 393×851px | ✓ | ✓ | High |
| **Google Pixel 6 Pro** | 412×915px | ✓ | ✓ | Medium |

### Tablets

| Device | Screen Size | Portrait | Landscape | Priority |
|--------|------------|----------|-----------|----------|
| **iPad Mini** | 768×1024px | ✓ | ✓ | High |
| **iPad Air** | 820×1180px | ✓ | ✓ | High |
| **iPad Pro 11"** | 834×1194px | ✓ | ✓ | Medium |
| **iPad Pro 12.9"** | 1024×1366px | ✓ | ✓ | Medium |

---

## 🧪 Test Categories

### 1. Layout & Spacing

**Mobile (375px - 767px)**
- [ ] Hero section title readable (may wrap to 2-3 lines)
- [ ] "Comenzar" button full width and tappable (min 44px height)
- [ ] Navigation menu accessible (burger menu if implemented)
- [ ] Questionnaire steps centered and not cut off
- [ ] Footer columns stack vertically
- [ ] Margins/padding proportional (12px on mobile vs 16px on desktop)

**Tablet (768px - 1023px)**
- [ ] Hero section title fits on 2 lines max
- [ ] Navigation links displayed horizontally
- [ ] Questionnaire options in comfortable 3-column grid
- [ ] Footer in 3-column grid layout
- [ ] Touch targets minimum 44×44px

**Desktop (1024px+)**
- [ ] Content max-width constrained (max-w-7xl = 1280px)
- [ ] Questionnaire centered with breathing room
- [ ] Navigation spaced elegantly
- [ ] All hover states functional

### 2. Typography

**Mobile**
- [ ] Hero title: 4rem (64px) readable without zooming
- [ ] Body text: 14px-16px minimum
- [ ] Button text: 10px uppercase with proper letter-spacing
- [ ] Step headings: 3rem (48px) - may need adjustment
- [ ] No horizontal scrolling due to long words

**Tablet**
- [ ] Hero title: 5-6rem (80-96px)
- [ ] Step headings: 4rem (64px)
- [ ] Body text: 16-18px

**Desktop**
- [ ] Hero title: 7-8rem (112-128px)
- [ ] Step headings: 5-6rem (80-96px)
- [ ] All typography matches Hermès aesthetic

### 3. Questionnaire Steps (Mobile-Specific)

**Step 1: Género**
- [ ] 3 gender options displayed properly (1 column on small screens, 3 columns on larger)
- [ ] Each option tappable with clear visual feedback
- [ ] Selected state visible (orange border + background tint)

**Step 2: Intensidad**
- [ ] 5 intensity options in 2 columns (mobile) or 5 columns (desktop)
- [ ] "Todas" option visible
- [ ] No overflow or clipping

**Step 3: Familia Olfativa**
- [ ] 6 family options (including "Cualquiera") in 2 columns (mobile) or 4 columns (desktop)
- [ ] Labels fully visible
- [ ] Touch targets adequate

**Step 4: Ocasiones**
- [ ] Occasion checkboxes in 2 columns (mobile) or 4 columns (desktop)
- [ ] Multi-select working
- [ ] Visual feedback for selected items

**Step 5 & 6: Notas**
- [ ] **CRITICAL**: Note cards in responsive grid
  - Mobile: 2 columns
  - Tablet: 3 columns
  - Desktop: 4 columns
- [ ] Each card height 96px (h-24) - adequate for touch
- [ ] Cards don't overlap or clip
- [ ] Selected state clear (top border orange/red)
- [ ] Disabled state visible (opacity 0.4)

### 4. Touch Interactions

**Mobile Devices**
- [ ] All buttons minimum 44×44px (Apple guidelines)
- [ ] Tap targets don't overlap
- [ ] No accidental taps on nearby elements
- [ ] Hover states disabled (or replaced with :active)
- [ ] Double-tap zoom disabled where appropriate
- [ ] Smooth scrolling (no janky animations)

**Tablets**
- [ ] Comfortable spacing between tap targets (minimum 8px gap)
- [ ] iPad touch interactions feel native
- [ ] Landscape mode comfortable to use

### 5. Navigation & Buttons

**Mobile**
- [ ] Progress indicators visible (may need smaller size)
- [ ] "Anterior" and "Siguiente" buttons accessible
- [ ] Buttons don't overlap with content
- [ ] Fixed footer buttons if scrolling required
- [ ] "Descubrir" button prominent on step 6

**Tablet/Desktop**
- [ ] Progress indicators elegant
- [ ] Button hover effects smooth
- [ ] Adequate spacing between buttons

### 6. Animations & Performance

**All Devices**
- [ ] Step transitions smooth (no lag on older devices)
- [ ] Staggered animations don't slow down UI
- [ ] `prefers-reduced-motion` respected
- [ ] Progress indicator animation performant
- [ ] Selection pulse animation doesn't cause reflow
- [ ] Loading spinner on submit works

**Performance Benchmarks**
- [ ] Time to Interactive (TTI) < 3.5s on 4G
- [ ] First Contentful Paint (FCP) < 1.8s
- [ ] No jank during animations (60fps target)

### 7. Orientation Changes

**Portrait → Landscape**
- [ ] Layout adapts without reload
- [ ] No content clipping
- [ ] Questionnaire remains usable
- [ ] Progress indicators stay visible
- [ ] Keyboard doesn't obscure inputs

**Landscape → Portrait**
- [ ] Reverse adaptation smooth
- [ ] Form state preserved
- [ ] No layout shifts

### 8. Forms & Input

**Mobile Keyboards**
- [ ] Email input triggers email keyboard
- [ ] Password input shows/hides characters
- [ ] Form doesn't submit on Enter (in questionnaire)
- [ ] Keyboard doesn't cover submit button
- [ ] Auto-correct/auto-capitalize disabled where needed

**Validation**
- [ ] Error alerts readable on small screens
- [ ] Inline validation messages visible
- [ ] "Por favor, selecciona una opción" alert formatted properly

### 9. Accessibility (Mobile)

**Touch Accessibility**
- [ ] VoiceOver (iOS) announces all options correctly
- [ ] TalkBack (Android) navigates properly
- [ ] Focus indicators visible
- [ ] Skip to content link available
- [ ] Form labels properly associated

**Visual Accessibility**
- [ ] Text readable at default zoom level
- [ ] No pinch-zoom required
- [ ] Color contrast ratios meet WCAG AA (4.5:1 for text)
- [ ] Hermès orange (#FF8C42) on white has sufficient contrast

### 10. Cross-Browser Testing

**iOS Browsers**
| Browser | Version | Test |
|---------|---------|------|
| Safari | Latest | ✓ |
| Chrome | Latest | ✓ |
| Firefox | Latest | ✓ |
| Edge | Latest | ○ |

**Android Browsers**
| Browser | Version | Test |
|---------|---------|------|
| Chrome | Latest | ✓ |
| Samsung Internet | Latest | ✓ |
| Firefox | Latest | ✓ |
| Opera | Latest | ○ |

**Test Priority**: ✓ Required, ○ Optional

---

## 🛠️ Testing Tools

### 1. Browser DevTools

**Chrome DevTools**
```
1. F12 to open DevTools
2. Click device icon (Ctrl+Shift+M)
3. Select device from dropdown
4. Test portrait/landscape toggle
```

**Safari Responsive Design Mode**
```
1. Develop → Enter Responsive Design Mode
2. Choose device presets
3. Test touch simulations
```

### 2. Real Device Testing

**iOS (Physical Device)**
```
1. Connect iPhone via USB
2. Safari → Develop → [Your iPhone]
3. Navigate to http://localhost:5001
4. Test all interactions
```

**Android (Physical Device)**
```
1. Enable USB Debugging
2. Chrome → chrome://inspect
3. Connect device
4. Inspect and test
```

### 3. Cloud Testing Services

**BrowserStack**
- Test on real iOS/Android devices
- URL: https://www.browserstack.com

**LambdaTest**
- Cross-browser mobile testing
- URL: https://www.lambdatest.com

**Sauce Labs**
- Automated mobile testing
- URL: https://saucelabs.com

### 4. Lighthouse Mobile Audit

```bash
# Install Lighthouse
npm install -g lighthouse

# Run mobile audit
lighthouse http://localhost:5001 --preset=mobile --view
```

**Audit Criteria**:
- Performance: > 90
- Accessibility: > 95
- Best Practices: > 90
- SEO: > 85

---

## 🐛 Common Mobile Issues

### Issue 1: Text Too Small

**Symptoms**: Users need to pinch-zoom to read

**Solution**:
```css
/* Ensure minimum font size */
body {
    font-size: 16px; /* iOS minimum to prevent zoom */
}
```

### Issue 2: Tap Targets Too Small

**Symptoms**: Difficulty tapping buttons/options

**Solution**:
```css
/* Minimum touch target */
.tap-target {
    min-width: 44px;
    min-height: 44px;
}
```

### Issue 3: Horizontal Scrolling

**Symptoms**: Content wider than viewport

**Solution**:
```css
/* Prevent overflow */
* {
    max-width: 100%;
    overflow-x: hidden;
}
```

### Issue 4: Fixed Elements Cover Content

**Symptoms**: Header/footer cover questionnaire

**Solution**:
```css
/* Add padding to body */
body {
    padding-top: 80px; /* Header height */
    padding-bottom: 100px; /* Footer height */
}
```

### Issue 5: Animations Laggy on Older Devices

**Symptoms**: Choppy transitions

**Solution**:
```css
/* Use transform instead of position */
.step {
    transform: translateY(20px); /* GPU accelerated */
    /* NOT: top: 20px; (CPU) */
}
```

---

## ✅ Mobile Testing Checklist

Print this checklist and test each item:

**Device Setup**
- [ ] Clear browser cache
- [ ] Disable ad blockers
- [ ] Enable JavaScript
- [ ] Set network to "4G" (throttle if needed)

**Pre-Test**
- [ ] App running on port 5001
- [ ] Database seeded with test data
- [ ] Test user account created

**Navigation Test (2 min)**
- [ ] Open homepage on mobile
- [ ] Click "Comenzar"
- [ ] Navigate through all 6 steps
- [ ] Click "Anterior" to go back
- [ ] Submit form
- [ ] View results page

**Visual Test (5 min)**
- [ ] All text readable without zoom
- [ ] Images load (if any)
- [ ] Colors match Hermès palette
- [ ] No layout shifts during load
- [ ] Favicon visible in browser tab

**Interaction Test (5 min)**
- [ ] Select gender option (Step 1)
- [ ] Select intensity (Step 2)
- [ ] Select family (Step 3)
- [ ] Select multiple occasions (Step 4)
- [ ] Select desired notes (Step 5)
- [ ] Verify desired notes disabled in rejected notes (Step 6)
- [ ] Submit and view recommendations

**Rotation Test (2 min)**
- [ ] Rotate device to landscape
- [ ] Verify layout adapts
- [ ] Rotate back to portrait
- [ ] Verify no content lost

**Performance Test (3 min)**
- [ ] Page loads in < 3 seconds
- [ ] Animations smooth (no jank)
- [ ] No console errors (check DevTools)
- [ ] Memory usage reasonable (< 100MB)

**Total Test Time**: ~17 minutes per device

---

## 📊 Responsive Grid Verification

### Steps 5 & 6 (Notas) - Grid Layout

**Expected Layout**:
```
Mobile (< 768px):
┌─────────┬─────────┐
│ Rosa    │ Jazmín  │
├─────────┼─────────┤
│ Vainilla│ Ámbar   │
└─────────┴─────────┘
(2 columns)

Tablet (768px - 1023px):
┌──────┬──────┬──────┐
│ Rosa │Jazmín│Vaini.│
├──────┼──────┼──────┤
│ Ámbar│ Lirio│Geran.│
└──────┴──────┴──────┘
(3 columns)

Desktop (1024px+):
┌─────┬─────┬─────┬─────┐
│ Rosa│Jazmí│Vaini│Ámbar│
├─────┼─────┼─────┼─────┤
│Lirio│Geran│Berg.│Sánd.│
└─────┴─────┴─────┴─────┘
(4 columns)
```

**CSS Verification**:
```css
/* From index.html line 234 & 257 */
.grid.grid-cols-2.md:grid-cols-3.lg:grid-cols-4
```

---

## 🚀 Quick Test Commands

### Test on Specific Device

**iPhone 12 Pro**
```bash
# Chrome DevTools
1. F12
2. Ctrl+Shift+M
3. Select "iPhone 12 Pro" from dropdown
4. Navigate to http://localhost:5001
```

**iPad Air**
```bash
# Same as above, select "iPad Air"
```

### Network Throttling

**Simulate 4G**
```
Chrome DevTools → Network tab → Throttling → Fast 4G
```

**Simulate 3G**
```
Chrome DevTools → Network tab → Throttling → Slow 3G
```

---

## 📝 Bug Reporting Template (Mobile)

When reporting mobile bugs, include:

```markdown
## Mobile Bug Report

**Device**: iPhone 13 Pro
**OS**: iOS 17.2
**Browser**: Safari 17.2
**Screen Size**: 390×844px
**Orientation**: Portrait
**Network**: 4G

**Steps to Reproduce**:
1. Open app on mobile
2. Navigate to Step 5
3. Select "Rosa"
4. ...

**Expected Behavior**:
[What should happen]

**Actual Behavior**:
[What actually happened]

**Screenshot**:
[Attach mobile screenshot]

**Console Errors**:
[Any errors in Safari console]

**Severity**: High/Medium/Low
```

---

## ✨ Success Criteria

Mobile implementation is successful if:

- ✅ All devices (iPhone SE to iPad Pro) display correctly
- ✅ Touch targets minimum 44×44px
- ✅ No horizontal scrolling required
- ✅ All text readable without zoom
- ✅ Animations smooth on all devices
- ✅ Forms submittable on all devices
- ✅ Lighthouse mobile score > 85
- ✅ No console errors on any device

---

## 🔗 Related Documentation

- **TESTING_GUIDE.md** - General testing procedures
- **CLAUDE.md** - Session notes and fixes
- **LUXURY_INTERFACE.md** - Hermès design guidelines
- **app/templates/index.html** - Responsive implementation

---

**Generated**: 2026-01-06
**Author**: Claude Code Testing Session
**Version**: 1.0
