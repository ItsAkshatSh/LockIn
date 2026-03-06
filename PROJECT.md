# **ArvyaX Flutter Developer Interview Assignment**

## **Title**

**Immersive Session \+ Reflection (Mini App)**

## **Role**

Flutter Developer

## **Timebox**

**6–8 hours maximum**

Please prioritize **clean architecture, correctness, and usability** over building extra features.

## **Submission Deadline**

**72 hours after receiving the assignment**

## **Deliverables**

Submit the following:

* GitHub repository (public or shared zip)

* Android APK

* README

* 30–60 second screen recording

---

# **1\. Objective**

Build a **mini ArvyaX experience** with the following flow:

**Explore Ambiences → Start Session → Control Player → Journaling → History**

The experience should feel **calm, minimal, and premium**. Think **Apple-like simplicity**, not a generic demo.

The focus is on:

* clean architecture

* thoughtful UX

* correct state management

* persistence

* stable audio playback

---

# **2\. Core Features**

## **A. Ambience Library (Home Screen)**

Display a list or grid of **6 ambiences loaded from a local JSON file**.

Each ambience item should show:

* Title (example: *Forest Focus*)

* Tag (Focus / Calm / Sleep / Reset)

* Duration (example: 2-3 minutes)

* Thumbnail image (placeholder is fine)


### **Home Screen Requirements**

Include:

* Search bar (client-side filtering)

* Tag filter chips (Focus / Calm / Sleep / Reset)

* Scrollable list or grid

### **Empty State**

If no ambiences match search/filter:

Display a friendly message such as:

“No ambiences found”

Include a **Clear Filters** button.

### **Interaction**

Tapping an ambience opens the **Ambience Details screen**.

---

# **B. Ambience Details Screen**

Display:

* Hero image

* Title

* Tag

* Duration

* Short description

* Sensory recipe chips (example: Breeze, Warm Light, Mist, Binaural)

Example chips:

* Breeze

* Warm Light

* Mist

* Binaural

* Soft Rain

Include a clear **Start Session** button.

Pressing **Start Session** opens the **Session Player**.

---

# **C. Session Player**

The player should include:

* Play / Pause button

* Seek bar

* Elapsed time

* Total duration

* Calm background visual (image or gradient)

### **Audio**

Play a **local audio asset** (mp3 or wav).

The audio should **loop continuously** during the session.

### **Session Timing**

Session duration comes from the JSON file.

The session ends when the **timer reaches the duration**, regardless of audio loop.

### **Animation (Choose ONE)**

Add **one subtle animation**, such as:

* breathing gradient

* soft light pulse

* wave shimmer

* particle drift

Keep it calm and minimal.

### **End Session**

Include an **End Session button**.

Tapping it should show a confirmation dialog:

**End Session?**

* Cancel

* End

Ending the session navigates to **Reflection / Journal screen**.

---

# **D. Mini Player**

If the user exits the player while a session is active:

Show a **mini-player at the bottom** of the screen.

Mini-player should show:

* ambience title

* play / pause button

* thin progress indicator

Tapping the mini-player returns to the **Session Player**.

The mini-player should appear on:

* Home screen

* Details screen

---

# **E. Post-Session Reflection (Journal)**

When the session completes **or the user ends the session**, show a reflection screen.

Display the prompt:

**“What is gently present with you right now?”**

Include:

* Multiline text input for journal entry

* Mood selector

Mood options:

* Calm

* Grounded

* Energized

* Sleepy

Include **Save** button.

Saving the reflection should add it to **Journal History**.

---

# **F. Journal History**

Display a list of saved reflections.

Each item should show:

* date/time

* ambience title

* mood

* preview of first line of journal text

### **Interaction**

Tapping a reflection opens a **detail view** showing the full entry.

Editing is not required.

### **Empty State**

If no reflections exist:

Show message such as:

“No reflections yet. Start a session to begin.”

---

# **3\. Persistence Requirements**

Persist the following locally:

* journal entries

* last active session state (to restore mini-player)

Allowed storage options:

* Hive

* SQLite

* SharedPreferences

Preferred: **Hive or SQLite**

---

# **4\. Engineering Requirements**

We evaluate **engineering quality heavily**.

## **Architecture**

Use one state management approach:

* Riverpod

* Provider

* Bloc

Separate concerns clearly:

data/

 models

 repositories

features/

 ambience

 player

 journal

shared/

 widgets

 theme

## **Code Quality**

Requirements:

* No giant `main.dart`

* Small reusable widgets

* Meaningful naming

* Loading and error states where needed

## **Responsiveness**

UI must work on:

* small phones

* large phones

No layout breakage.

---

# **5\. Bonus (Optional – Choose ONE)**

Implement **one** of the following to demonstrate seniority:

### **Option 1**

App lifecycle handling

Pause session timer when app goes to background and resume correctly.

### **Option 2**

Dark mode support with theme tokens.

### **Option 3**

Basic analytics logging (local):

* session\_start

* session\_end

* journal\_saved

### **Option 4**

Haptic feedback on:

* play/pause

* save reflection

### **Option 5**

Accessibility support (larger text sizes without UI breakage).

---

# **6\. Assets**

You may use **placeholder assets**.

Example sources:

* Unsplash images

* Any royalty-free audio loop

Quality of assets does not affect evaluation.

---

# **7\. README Requirements**

Include:

### **How to run the project**

### **Architecture explanation**

Explain:

* folder structure

* state management approach

* how data flows from repository → controller → UI

### **Packages used**

Explain briefly **why each package was chosen**.

### **Tradeoffs**

Explain:

What would you improve if you had **two more days**.

---

# **8\. Evaluation Criteria**

| Category | Weight |
| ----- | ----- |
| UI polish & UX feel | 15% |
| Architecture & code quality | 35% |
| Player correctness | 20% |
| Persistence & history | 20% |
| Product thinking | 10% |

---

# **Fast Reject Signals**

Applications may be rejected early if:

* audio does not work

* code is in a single file

* no persistence implemented

* UI is broken or extremely janky

---

# **Final Note**

Focus on:

* **clean architecture**

* **stable functionality**

* **thoughtful UX**

Pixel-perfect design is **not required**.

