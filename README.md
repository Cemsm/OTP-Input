# OTP Input for Oracle APEX

A modern, customizable Oracle APEX Item Plug-in for secure OTP,
verification-code, PIN, and short-code inputs.

**Plug-in:** `COM_CEMSM_OTP_INPUT`\
**Version:** `0.1.0`

## Overview

OTP Input replaces a traditional single text field with a polished
multi-box input experience designed for one-time passwords and
verification codes.

The plug-in keeps the complete value in the underlying APEX page item
while presenting individual character boxes to the user. It integrates
with the APEX item API and supports keyboard navigation, paste, mobile
OTP autofill, masking, validation, theming, and custom events.

## Features

-   Configurable OTP length from 4 to 8 characters
-   Numeric, alphanumeric, and general non-whitespace input modes
-   Optional masking for password/PIN-style inputs
-   Automatic focus movement between boxes
-   Backspace, Delete, arrow-key, Home, and End navigation
-   Optional paste support
-   Mobile-friendly `one-time-code` autocomplete
-   Persian and Arabic-Indic digit normalization for numeric codes
-   Optional automatic page submit when the code is complete
-   Optional autofocus
-   Configurable separator spacing
-   Small, medium, and large sizes
-   Boxed, rounded, and underline presentation styles
-   Theme-aware colors using Oracle APEX / Universal Theme variables
-   Configurable Font APEX header icon with `fa-lock` fallback
-   Animated focus, shadow, glow, and hover states
-   Responsive layout
-   Reduced-motion accessibility support
-   Native APEX item API integration
-   `otp-change` and `otp-complete` custom events

## Installation

1.  Download or clone this repository.
2.  Open your Oracle APEX application in App Builder.
3.  Go to **Shared Components**.
4.  Open **Plug-ins**.
5.  Choose **Import**.
6.  Select the exported plug-in SQL file from this repository.
7.  Complete the import and installation process.
8.  Open a page in Page Designer.
9.  Create a new page item.
10. Set the item's type to **OTP Input** / `COM_CEMSM_OTP_INPUT`.
11. Configure the plug-in attributes as needed and run the page.

> The exact exported SQL filename can vary depending on how the plug-in
> was exported from APEX.

## Usage

After installation, add the OTP Input item to any APEX page and
configure its attributes in Page Designer.

Typical configurations include:

-   **Login verification:** 6-digit numeric OTP
-   **PIN entry:** 4-6 digits with masking enabled
-   **Email verification:** 6-digit code with paste enabled
-   **Alphanumeric verification:** letters and numbers
-   **Confirmation flow:** automatically submit when all characters are
    entered

The plug-in stores the final combined code in the actual APEX page item,
so server-side processes can reference it normally:

``` plsql
:P1_OTP
```

## JavaScript API

The plug-in registers itself using `apex.item.create`, so standard APEX
item operations can be used.

``` javascript
apex.item("P1_OTP").getValue();

apex.item("P1_OTP").setValue("123456");

apex.item("P1_OTP").setFocus();

apex.item("P1_OTP").disable();

apex.item("P1_OTP").enable();
```

## Custom Events

### `otp-change`

Triggered whenever the OTP value changes.

``` javascript
apex.jQuery("#P1_OTP").on("otp-change", function (event, data) {
    console.log(data.value);
});
```

### `otp-complete`

Triggered when the user completes all configured OTP positions.

``` javascript
apex.jQuery("#P1_OTP").on("otp-complete", function (event, data) {
    console.log("OTP complete:", data.value);
});
```

These events can also be used as the basis for APEX Dynamic Actions.

## Input Behavior

The plug-in keeps the entered characters as a continuous sequence with
no gaps. Typing advances naturally through the boxes, while Backspace
and Delete remove characters and update the underlying APEX item.

When numeric mode is enabled, Persian and Arabic-Indic digits are
normalized to ASCII digits before being stored.

When masking is enabled, the visual boxes display bullets while the
underlying page item retains the actual code.

## Styling

The plug-in is designed to follow the application's APEX theme. Its
primary states use Universal Theme / APEX CSS variables with fallback
values.

The component includes:

-   Theme-aware accent colors
-   Light security-pattern header
-   Font APEX icon support
-   Smooth hover and focus transitions
-   Layered focus shadows and glow
-   Responsive OTP sizing
-   Reduced-motion handling

Custom styling can be applied by overriding the plug-in CSS classes in
the application.

Main classes include:

``` text
.com-cemsm-otp-wrapper
.com-cemsm-otp-header
.com-cemsm-otp-header__icon
.com-cemsm-otp-body
.com-cemsm-otp-title
.com-cemsm-otp
.com-cemsm-otp__box
```

## Demo

A standalone visual demo is included in `index.html`.


``` text
https://cemsm.github.io/OTP-Input/
```


> The GitHub Pages demo reproduces the plug-in's front-end experience.
> The actual Oracle APEX integration requires the plug-in to be
> installed in an APEX application.

## Repository Structure

``` text
oracle-apex-otp-input/
├── README.md
├── index.html
├── plugin/
│   └── <APEX plug-in export>.sql
└── src/
    ├── otp-input.js
    └── otp-input.css
```

You can adjust the folders to match your exported repository structure.

## Compatibility

The plug-in is built for Oracle APEX and uses the APEX JavaScript item
API, APEX events, Font APEX, and theme CSS variables.

If you test the plug-in against specific Oracle APEX releases, list the
confirmed versions here before publishing.

## Version

### 0.1.0

Initial public release.

## License

Add the license you want to use for the project (for example, MIT) and
include a `LICENSE` file in the repository.

## Contributing

Issues, bug reports, suggestions, and pull requests are welcome.

------------------------------------------------------------------------

Built for the Oracle APEX community.
