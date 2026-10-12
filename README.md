# Tracebrain over MCP

[Tracebrain](https://tracebrain.app) builds a memory from the conversations
you already have. It reads your Telegram and WhatsApp through your own login
and writes what it learns into a private vault of plain Markdown you own: a
page per person, a note per day, the promises you made and the projects they
run through.

This repository is how you reach that vault from the assistant you already
work in.

**Server:** `https://api.tracebrain.app/mcp` — OAuth, no API key anywhere.
**What it can and cannot do:** [tracebrain.app/mcp](https://tracebrain.app/mcp).

---

## Claude Code, Claude Desktop, claude.ai

Install the plugin. It brings the connector and six skills with it.

```
claude plugin marketplace add tracebrain/mcp
claude plugin install tracebrain@tracebrain
```

Then `/mcp` in a session to sign in.

On **claude.ai and Cowork**, install from **Customize → Plugins** and connect
the server on the plugin's **Connectors** tab. That second step is real: a
plugin cannot connect a remote server on your behalf there.

### What the skills do

| Skill | When it runs |
| :- | :- |
| `brief` | before a call: who they are, what is open with them, what was last said |
| `promises` | what you owe and what is owed to you, and ticking things off |
| `catch-up` | what happened over a stretch of days |
| `project-status` | one project, its people and its open work |
| `capture` | "I told Olena I'd send the deck" becomes a task on her page |
| `remember` | one durable line about you, onto your own page |

### The one hook, and why it is off

Your vault is built from messages, so anything settled while working with an
assistant never reaches it. Turn **"Offer to remember what a session settled"**
on in the plugin's configuration and, once per session, Claude is asked
whether anything durable about you or your work belongs on your own page.

It is off by default because it costs a model turn per session and most
sessions settle nothing worth keeping.

The hook never writes anything. It cannot: a `Stop` hook is a command with no
model behind it, so it can copy but not judge, and a coding session is full of
`.env` contents and keys. It prints one constant question, reads nothing else,
runs nothing else, and makes no network call — [see the whole
script](scripts/remember.sh), which is the only thing the hook runs. The model
decides, and the server refuses a line that looks like a password, a key or a
card number.

A hook is Claude Code's alone. In Cowork it loads; on claude.ai it is ignored.
Everywhere else the `remember` skill does the same thing when you ask for it.

---

## Every other client

The address is the same everywhere: `https://api.tracebrain.app/mcp`, as a
remote **HTTP** MCP server. You sign in once at a consent screen; there is no
key to copy or store.

| Client | Where it goes |
| :- | :- |
| **Cursor** | Settings → MCP → add an HTTP server with the URL |
| **VS Code (Copilot)** | `mcp.json` — note the key is `servers`, not `mcpServers` |
| **ChatGPT** | developer mode → add a remote MCP server. Paid plans only |
| **Windsurf** | MCP settings → HTTP server |
| **Gemini CLI** | an `httpUrl` server; OAuth is discovered |
| **Zed, Codex CLI, Cline, Continue, Goose, Raycast** | wherever that client takes a remote MCP server |

These rows are checked against each client's own documentation and dated on
the page that covers it. If one has gone stale, that is a bug — please open an
issue.

---

## What it can do, in one place

Ten tools read and seven write, and they are the same ones the Tracebrain app
itself uses. The full list, with what each one cannot do, is on
[tracebrain.app/mcp](https://tracebrain.app/mcp) — deliberately in one place,
so a second copy cannot drift from the server.

The short version: it reads your people, days, tasks and projects; it writes a
task, a project, somebody into a project, and a correction to a line
Tracebrain itself wrote. It cannot write into your message history, which is
append-only. It cannot add a person. It cannot change a line you typed
yourself. It deletes nothing at all — those tools do not exist, rather than
being discouraged.

## Known limits

- The hook script is `sh`. On Windows, Claude Code runs hooks through
  `cmd.exe`, so it needs git-bash on `PATH`. Everything else works.
- Each person reaches their own vault. A shared team vault is reached only by
  a token you granted for that organisation on the consent screen.

## Licence

MIT. See [LICENSE](LICENSE).
