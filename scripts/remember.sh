#!/bin/sh
# Ask, once per session, whether anything this session settled belongs on the
# person's own page in Tracebrain.
#
# This script never writes to the vault and never touches the network. It
# cannot: a Stop hook is a shell command with no model behind it, so it can
# copy but it cannot judge, and a coding session's text is full of .env
# contents, tokens and keys. Deciding what is worth remembering is the whole
# job, so the thing that decides has to be the model - which already has
# `remember_about_me`, and whose line the server checks for secrets before it
# is written (profile_store.typed_line).
#
# So all this does is ask. It reads two fields of the hook's JSON input and
# prints one constant question.

set -eu

input=$(cat)

# Off unless the person turned it on in the plugin's configuration.
case "${CLAUDE_PLUGIN_OPTION_REMEMBER_SESSIONS:-}" in
  true|1|yes) ;;
  *) exit 0 ;;
esac

# Already answering a previous block of ours. Letting this through is how a
# Stop hook loops until the session's quota is gone.
case "$input" in
  *'"stop_hook_active"'*'true'*) exit 0 ;;
esac

# Once per session, not once per turn. A Stop hook fires at the end of every
# turn, and being asked this after every answer would be unbearable - so the
# first time wins and the rest are silent. The marker also backstops
# stop_hook_active, which has been reported to stay false when other system
# messages interleave with a stop.
session=$(printf '%s' "$input" |
  sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
if [ -n "${CLAUDE_PLUGIN_DATA:-}" ] && [ -n "$session" ]; then
  marker="$CLAUDE_PLUGIN_DATA/asked"
  mkdir -p "$marker" 2>/dev/null || exit 0
  [ -e "$marker/$session" ] && exit 0
  : > "$marker/$session" 2>/dev/null || exit 0
fi

cat <<'JSON'
{"decision":"block","reason":"Before you finish: if this session settled something durable about the person themselves or the way they work - a tool or approach they have decided on, something they have committed to, a preference worth keeping - add one line with the Tracebrain tool remember_about_me, choosing the section about, preferences, goals or ideas. Write it about the person, not about the session: 'prefers Clerk for auth in side projects', never 'we fixed the title bug today'. Read my_memory first so you do not repeat a line that is already there. Most sessions settle nothing of the kind; when this one did not, say nothing at all and stop."}
JSON
