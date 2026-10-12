---
name: remember
description: Add one durable fact about the user themselves to their own page in Tracebrain - a preference, a goal, a decision about how they work. Use when they say to remember something about them, note it down, keep that in mind for next time, or when a conversation settles something about the way they work that is worth keeping.
---

# Remember this about me

Tracebrain's vault is built from the user's messages, so it only knows what
passed through a chat. Anything settled while working with an assistant never
reaches it unless somebody writes it down. This writes it down.

## Order

1. `my_memory` first. It is the owner's own page, and a fact already there
   should not be added again in other words.
2. `remember_about_me` with a section and one plain line. The sections are
   `about`, `preferences`, `goals` and `ideas`.
3. Say what you wrote, in the words you wrote it.

## What belongs here

A fact about the **person**, not about the session.

- Yes: "prefers Clerk over rolling auth by hand", "wants the second brain
  usable from the phone by spring", "works in Ukrainian and English".
- No: "we fixed the MCP title bug today", "the tests pass now", "asked me to
  review a pull request". That is a worklog, and it is not what this page is.

One line. The page is read whole by everything else in the product, so it
stays short or it stops being read.

## Rules

- **Write it dated and correctable, which it already is.** A line added this
  way is marked as written by an assistant: the owner can edit it on their own
  page, and a later pass may move it to Earlier when it stops being true. So
  an imperfect line is worth writing; a wrong one is not a disaster.
- **No secrets.** Passwords, API keys, tokens, card numbers, one-time codes.
  The server refuses a line that looks like one, and the refusal is a bug
  report about the line, not something to route around.
- **Nothing is ever removed.** `edit_my_memory` corrects a line; there is no
  delete. Write as if the line is permanent, because it nearly is.
