# ZMK Firmware for Dao keyboard

This is a repository for a ZMK Firmware for both Dao42 and Dao44 keyboards.

* [main](https://github.com/yumagulovrn/dao-zmk-config/tree/main) branch is for Dao42
* [dao44](https://github.com/yumagulovrn/dao-zmk-config/tree/dao44) branch is, obviously, for Dao44

## Mouse Motions

In order to get the mouse motions working I had to make use of a development branch. I followed these links

- [feature branch](https://github.com/petejohanson/zmk/tree/feat/pointers-move-scroll)
- [how to make use](https://zmk.dev/docs/features/beta-testing) of feature branches
- Original [thread](https://gist.github.com/krissen/dd27082e7ab0575619c7a31f4d2ec7ae) on how to get mouse motions

## Fine Tuning

I love this keyboard, and as I become more adept at using it, I progressively type faster. Consequently, I started running into some limitations with the home row mods. ZMK identifies a few behavior categories to customize a keyboard to a user's style. ZMK identifies the tap/hold "balanced" behavior as one that is favorable for home row mods.

### Troublesome Words:

    - fast
    - some
    - dict
    - I'm
    - split
    - status

### Testing

⏺ Great idea! Here's a systematic test guide for your home-row mods:

  Home-Row Mod Testing Guide

  1. Test for Double-Key Issue (The Main Problem)

  Type these words that use home-row mod keys. If the issue persists, you'll see doubled letters:

  add dad did sad said
  all fall call shall
  ask flask task mask
  different difficult address

  Focus especially on:
  - d words (ALT on left hand)
  - a words (CTRL on left hand)
  - s words (SHIFT on left hand)

  2. Test Fast Typing Flow

  Type these sentences at your normal typing speed:

  The quick brown fox jumps over the lazy dog.
  A fast keyboard is a delight to use all day long.
  She sells seashells down by the seashore.

  If timing is wrong, you'll get doubled letters or missed modifiers.

  3. Test Modifier Combinations

  These test that modifiers activate correctly when pressing other keys:

  Single Modifiers:
  - Hold F (GUI) + press T → Should trigger CMD+T (new tab in browser)
  - Hold D (ALT) + press TAB → Should trigger ALT+TAB (app switcher)
  - Hold S (SHIFT) + press letters → Should give CAPITAL LETTERS
  - Hold A (CTRL) + press C → Should copy

  Multiple Modifiers (your specific example):
  - Hold F (GUI) + Hold D (ALT) + press N → Should trigger CMD+OPT+N
  - Hold J (GUI) + Hold K (ALT) + press letter → Should trigger right-hand modifier combo

  4. Test the "Roll" Pattern

  This tests if the tap-unless-interrupted flavor works correctly. Type these letter combinations quickly in succession:

  df ds da
  jk jl j;
  as df fg

  These should produce the letters, NOT trigger modifiers (since you're not holding, just rolling).

  5. Test Hold Duration

  Type these slowly, intentionally holding the home-row key for >200ms:

  - Hold A for half a second, then press C → Should copy (CTRL+C)
  - Hold F for half a second, then press T → Should open new tab (CMD+T)
  - Hold J for half a second, then press K → Should give you whatever CMD+K does

  6. Real-World Usage Test

  Open a text editor and type a few paragraphs of real content. The best test is natural typing. If you notice:
  - Doubled letters → Tapping term might need adjustment
  - Missed modifiers → Quick tap or flavor might need tweaking
  - Accidental modifiers → Tapping term might be too short

  Expected Results

  ✅ Good signs:
  - Single taps produce single letters
  - Fast typing doesn't produce doubled letters
  - Holding + another key consistently triggers modifiers
  - Modifier combos (CMD+OPT+N) work reliably

  ❌ Bad signs:
  - Still getting dd instead of d
  - Modifiers don't trigger when you want them
  - Random capitals or shortcuts appearing during normal typing

  Let me know what you find! If there are still issues, we can fine-tune:
  - tapping-term-ms (increase if modifiers trigger too easily, decrease if they don't trigger fast enough)
  - quick_tap_ms (affects the repeat-key window)
  - flavor (we can try other options like hold-preferred or balanced)

## Default keymap

### Dao42

Visual representation of the default keymap in keyboard-layout-editor: [KLE](http://www.keyboard-layout-editor.com/#/gists/67a81f6b83c65abcda5e7f32989a1688)

This layout is heavily inspired by [this](https://github.com/aroum/Watchman-layouts)

### Dao44

Visual representation of the default keymap in keyboard-layout-editor: [KLE](http://www.keyboard-layout-editor.com/#/gists/c6ba0634e5b92366be9f324775394e66)

This layout is heavily inspired by [this](https://github.com/KGOH/Jian-Info)

Because of current ZMK limitations, Dao44 keymap is in the branch [dao44](https://github.com/yumagulovrn/dao-zmk-config/tree/dao44)

## FAQ

- [FAQ](#faq)
  - [How to change the keymap?](#how-to-change-the-keymap)
  - [How to flash the keyboard?](#how-to-flash-the-keyboard)
  - [How to pair halves?](#how-to-pair-halves)
  - [Problems](#problems)
    - [I'm getting File Transfer Error after copying firmware to the keyboard](#im-getting-file-transfer-error-after-copying-firmware-to-the-keyboard)

### How to change the keymap?

1. Fork the repository https://github.com/yumagulovrn/dao-zmk-config
2. Make changes to the [dao.keymap](../config/boards/arm/dao/dao.keymap) file in your repository OR use wonderful https://nickcoutsos.github.io/keymap-editor/
3. Commit changes to your repository
4. Go to `Actions` tab in your repository
5. Wait for the GitHub Action to complete
6. Grab `firmware.zip` file - it contains firmware for both of your halves

### How to flash the keyboard?

1. Obtain `firmware.zip`
2. Unzip `firmware.zip` - you should have `dao_left.uf2` and `dao_right.uf2` files
3. Turn off the power for selected halve (move slider to position `OFF`)
4. Connect selected halve to the PC via USB-C cable
5. Press `RESET` button **twice** to enter DFU mode - you should see new USB device in your file manager
6. Copy the corresponding firmware to the root directory of the new USB device
7. Disconnect selected halve from the PC
8. Repeat steps 3-7 for the other halve

### How to pair halves?

1. Turn off the power for both halves (move slider to position `OFF`)
2. Turn on the power for both halves (move slider to position `ON`)
3. Press `RESET` button **once** on both halves **simultaneously**

### Problems

#### I'm getting File Transfer Error after copying firmware to the keyboard

It's OK. Proof: https://zmk.dev/docs/troubleshooting#file-transfer-error
