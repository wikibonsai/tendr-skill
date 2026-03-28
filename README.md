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

- [Claude Code](https://claude.ai/code) (Anthropic)
- [OpenClaw](https://github.com/openclaw/openclaw)

## Install

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
