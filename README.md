# 🪴 tendr-skill 🎍

[![A WikiBonsai Project](https://img.shields.io/badge/%F0%9F%8E%8B-A%20WikiBonsai%20Project-brightgreen)](https://github.com/wikibonsai/wikibonsai)

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
│   └── tendr/
│       └── SKILL.md        ← skill content (instructions, syntax, workflow)
├── hooks/
│   └── hooks.json          ← SessionStart + UserPromptSubmit hooks
├── scripts/
│   ├── load-tree.sh        ← discovers garden and prints semantic tree
│   └── recall.sh           ← fuzzy-matches prompt keywords against garden nodes
├── README.md               ← this file
└── LICENSE                  ← MIT
```

## Configuration

Set `TENDR_DIR` to point to your garden directory:

```bash
export TENDR_DIR=/path/to/garden
```

If unset, the plugin auto-discovers the garden from common locations. The `/tendr` command also accepts a path argument: `/tendr /path/to/garden`.

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
