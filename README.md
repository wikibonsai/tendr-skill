# 🪴 tendr-skill 🎍

[![A WikiBonsai Project](https://img.shields.io/badge/%F0%9F%8E%8B-A%20WikiBonsai%20Project-brightgreen)](https://github.com/wikibonsai/wikibonsai)

<p align="center">
  <img src="./static/tendr.svg" width="35%" height="35%"/>
</p>

An AI agent skill for managing long-term semantic memory as structured knowledge in plain text (markdown).

🤖 🚰 ✂️ Unlock [🎋 WikiBonsai](https://github.com/wikibonsai/wikibonsai) digital gardening for your AI agent.

## What It Does

Teaches AI agents to use [wikirefs](https://github.com/wikibonsai/wikirefs), [CAML](https://github.com/wikibonsai/caml-mkdn), and [semtree](https://github.com/wikibonsai/semtree) to build and maintain a structured knowledge graph as persistent memory. Agents learn to capture concepts, verbalize definitions, connect ideas with typed links, and organize knowledge in a semantic hierarchy. All in plain markdown.

Requires [tendr-cli](https://github.com/wikibonsai/tendr-cli):

```bash
npm install -g tendr-cli
```

## Supported Agents

- [Claude Code](#claude-code) by [Anthropic](https://claude.ai/code)
- [gptme](#gptme) by [gptmeorg](https://github.com/gptme/gptme)
- [OpenClaw](#openclaw) by [Open Claw](https://github.com/openclaw/openclaw)
- [pi](#pi) by [badlogic](https://github.com/badlogic/pi-mono/) (badlogic)

## Install

### Cross-Agent (shared directory)

All supported agents also discover skills in `~/.agents/skills/`:

```bash
git clone git@github.com:wikibonsai/tendr-skill.git
mkdir -p ~/.agents/skills/tendr
ln -s "$(pwd)/tendr-skill/skills/tendr/SKILL.md" ~/.agents/skills/tendr/SKILL.md
```

This makes the skill available to pi, gptme, and OpenClaw from a single install.

### Claude Code

**As a plugin** (recommended):

```bash
git clone git@github.com:wikibonsai/tendr-skill.git ~/.claude/plugins/tendr-skill
```

**As a standalone skill** (user-level, available across all projects):

```bash
git clone git@github.com:wikibonsai/tendr-skill.git
mkdir -p ~/.claude/skills/tendr
ln -s "$(pwd)/tendr-skill/skills/tendr/SKILL.md" ~/.claude/skills/tendr/SKILL.md
```

**As a standalone skill** (project-level, available only in that project):

```bash
git clone git@github.com:wikibonsai/tendr-skill.git
mkdir -p .claude/skills/tendr
ln -s "$(pwd)/tendr-skill/skills/tendr/SKILL.md" .claude/skills/tendr/SKILL.md
```

Invoke with `/tendr` in Claude Code.

### gptme

**User-level:**

```bash
git clone git@github.com:wikibonsai/tendr-skill.git
mkdir -p ~/.config/gptme/skills/tendr
ln -s "$(pwd)/tendr-skill/skills/tendr/SKILL.md" ~/.config/gptme/skills/tendr/SKILL.md
```

**Workspace-level:**

```bash
git clone git@github.com:wikibonsai/tendr-skill.git
mkdir -p .gptme/skills/tendr
ln -s "$(pwd)/tendr-skill/skills/tendr/SKILL.md" .gptme/skills/tendr/SKILL.md
```

gptme auto-loads the skill when "tendr" is mentioned in conversation.

### OpenClaw

**User-level:**

```bash
git clone git@github.com:wikibonsai/tendr-skill.git
mkdir -p ~/.openclaw/skills/tendr
ln -s "$(pwd)/tendr-skill/skills/tendr/SKILL.md" ~/.openclaw/skills/tendr/SKILL.md
```

**Workspace-level:**

```bash
git clone git@github.com:wikibonsai/tendr-skill.git
mkdir -p skills/tendr
ln -s "$(pwd)/tendr-skill/skills/tendr/SKILL.md" skills/tendr/SKILL.md
```

Invoke with `/tendr` in OpenClaw.

### pi

**User-level:**

```bash
git clone git@github.com:wikibonsai/tendr-skill.git
mkdir -p ~/.pi/agent/skills/tendr
ln -s "$(pwd)/tendr-skill/skills/tendr/SKILL.md" ~/.pi/agent/skills/tendr/SKILL.md
```

**Project-level:**

```bash
git clone git@github.com:wikibonsai/tendr-skill.git
mkdir -p .pi/skills/tendr
ln -s "$(pwd)/tendr-skill/skills/tendr/SKILL.md" .pi/skills/tendr/SKILL.md
```

Invoke with `/skill:tendr` in pi.

## Repo Structure

```
tendr-skill/
├── .claude-plugin/
│   └── plugin.json         ← Claude Code plugin metadata
├── skills/
│   ├── tendr/
│   │   └── SKILL.md        ← main skill (syntax, workflow, CLI reference)
│   └── tendr-gc/
│       └── SKILL.md        ← garden consolidation sub-agent
├── hooks/
│   ├── hooks.json          ← Claude Code hooks (session start, recall, gc)
│   ├── pi-hooks.json       ← pi hook config
│   └── gptme-hooks.toml    ← gptme hook config
├── scripts/
│   ├── load.sh             ← preflight, discover garden, print tree + kick-off directive
│   ├── preflight.sh        ← verify tendr-cli is installed and executable
│   ├── recall.sh           ← bounded per-prompt list of relevant nodes (TENDR_RECALL_MAX)
│   └── gc.sh               ← deterministic cleanup (doctor, tree refresh)
├── README.md               ← this file
└── LICENSE                  ← MIT
```

## Configuration

Set `TENDR_DIR` to point to your garden directory:

```bash
export TENDR_DIR=/path/to/garden
```

If unset, the plugin auto-discovers the garden from common locations. The `/tendr` command also accepts a path argument: `/tendr /path/to/garden`.

## Hooks (Auto-Loading)

Skills load on demand, but **hooks** make the garden load *automatically* at session start — so the agent enters the tendr workflow instead of waiting to be reminded. The skill ships three shared, harness- and model-agnostic scripts in `scripts/`; only the wiring differs per harness.

| Script | Fires | Does |
|---|---|---|
| `load.sh` | session start | discovers the garden, prints the semantic tree + a kick-off directive |
| `recall.sh` | each user prompt | surfaces a **bounded** list of relevant nodes as pointers (`name: tldr`); the agent runs `tendr stat <node>` to load one. Cap with `TENDR_RECALL_MAX` (default 5) so per-prompt token cost stays small |
| `gc.sh` | (see note) | deterministic cleanup — `tendr doctor` + tree refresh. Consolidation itself is the `/tendr gc` sub-agent, which a shell hook can't run |

### Claude Code

**As a plugin** — hooks wire automatically from `hooks/hooks.json`. Nothing to do.

**As a standalone skill** — `hooks/hooks.json` is **not** read (no `$CLAUDE_PLUGIN_ROOT` outside a plugin), so wire it yourself in `~/.claude/settings.json` with an **absolute** path:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "*",
        "hooks": [
          { "type": "command", "command": "bash /ABSOLUTE/PATH/TO/tendr-skill/scripts/load.sh", "timeout": 10 }
        ]
      }
    ]
  }
}
```

Merge into existing settings — don't replace. New user-level hooks may need a restart (or opening `/hooks` once) to take effect. For per-prompt recall, add the same shape under `UserPromptSubmit` pointing at `recall.sh`.

### pi

Copy `hooks/pi-hooks.json` into `.pi/hooks/` (project) or `~/.pi/agent/hooks/` (user).

### gptme

Add the `[hooks]` block from `hooks/gptme-hooks.toml` to `~/.config/gptme/config.toml` (or your `gptme.toml`).

### OpenClaw

Per-harness hook wiring isn't shipped yet — the shared `scripts/` are ready, but an OpenClaw hook config is still TODO. Until then, run `/tendr` manually at session start. Contributions welcome.

## Getting Started

Once installed, type `/tendr` to activate the skill in your session. On first use, the agent will set up a garden (knowledge base) with a `config.toml`, `index/`, and `entries/` directory.

Clone a starter knowledge base from [garden-beds](https://github.com/wikibonsai/garden-beds) to get going faster.

## Links

- [WikiBonsai](https://github.com/wikibonsai/wikibonsai) — the project
- [tendr-cli](https://github.com/wikibonsai/tendr-cli) — the CLI tool
- [garden-beds](https://github.com/wikibonsai/garden-beds) — starter knowledge bases
- [wikirefs](https://github.com/wikibonsai/wikirefs) — `[[wikilink]]` spec
- [caml-mkdn](https://github.com/wikibonsai/caml-mkdn) — `: key :: value` spec
- [semtree](https://github.com/wikibonsai/semtree) — semantic tree spec
