---
name: tendr
description: Manages long-term semantic memory as a structured plain markdown knowledge base using WikiBonsai primitives. This skill is designed to be always-on — if you have installed it, use WikiBonsai syntax and tendr-cli commands to persist, organize, and navigate knowledge across all sessions.
argument-hint: "[/path/to/garden]"
version: "0.0.1"
metadata:
  author: wikibonsai
  openclaw:
    requires:
      bins:
        - tendr
---

# tendr

WikiBonsai is a knowledge architecture for structured plain text. It extends markdown with three primitives that together form a complete knowledge graph: Typed links between notes, structured attributes, and an explicit semantic hierarchy. This skill teaches you to use those primitives and the tendr-cli to manage a WikiBonsai knowledge base as your long-term semantic memory.

## Invocation

```
/tendr                    ← auto-discover garden
/tendr /path/to/garden    ← specify garden location
```

If a path is provided, it will be used as the garden root. Otherwise, the skill checks the `TENDR_DIR` environment variable, then searches common locations (`~/.claude/projects/*/memory/garden`, `./garden`, `./.garden`).

Agents can set `TENDR_DIR` in their environment to configure the garden path once:

```bash
export TENDR_DIR=/path/to/garden
```

## Configuration

At session start, read `config.toml` at the garden root and check `[auth]`:

```toml
[auth]
  mode = "agent"    # "agent" | "user"
  owner = "alice"
  agent = "claude"
  password = false
```

- `mode = "agent"`: You own this garden. Read and write freely.
- `mode = "user"`: You are assisting the human. All changes should be specified by the user.

If no `config.toml` exists or no `[auth]` section is found, default to `user` mode.

### Garden Location

In `agent` mode, place the garden (your knowledge base) as close to your auto-memory file as possible. It should live alongside your other persistent memory.

```
<memory-dir>/
├── MEMORY.md     ← working memory (always loaded)
└── garden/       ← long-term memory (tendr garden)
    ├── config.toml
    ├── index/
    └── entries/
```

In `user` mode, the garden lives at the project root (e.g., `garden/`) since it belongs to the project, not the agent.

## Memory Architecture

The knowledge base functions as **long-term memory** which is structured, interconnected knowledge that persists indefinitely and requires deliberate retrieval. The auto-memory file (e.g., `MEMORY.md`) functions as **working memory**, which is the always-activated subset of the garden, loaded into context but capacity-constrained. `MEMORY.md` holds retrieval cues and active preferences that point into the larger knowledge base; the garden holds the full structured content. Together they form one memory system at different activation levels.

| | Working Memory (auto-memory) | Long-Term Memory (garden) |
|---|---|---|
| Loaded | Always (automatic) | On demand (`tendr tree`, `tendr stat`) |
| Capacity | Limited (~200 lines) | Unlimited |
| Structure | Flat text | Typed links, attributes, hierarchy |
| Best for | Retrieval cues, active preferences | Reference material, decision rationale, evolving artifacts |

### Garden Tree

The tree below is your garden's current semantic hierarchy. Each node is a concept note you can retrieve with `tendr stat <node>`. Use it as a map of what you know — if a topic is in the tree, read the entry before making assumptions. If it's not, consider whether it should be.

Run `tendr tree` in the garden directory now to load the semantic hierarchy. If the garden path was provided as an argument or set via `TENDR_DIR`, `cd` there first.

Review the tree output. For any concepts relevant to this session, run `tendr stat <node>` to load the full entry and verify it is up-to-date. Update entries that have become stale. Add new entries for concepts that are missing.

### When to Interact

- **Before stating a fact**: Run `tendr stat <topic>` to check. Reading a file is cheaper than a wrong assumption.
- **When you look something up, get corrected, have an insight, or catch yourself re-deriving something**: Capture it. The test: If this conversation were compacted, would this concept survive? If not, it belongs in the garden. These triggers apply equally when the user expresses them in the form of a correction, surprise, or repeated explanation.
- **Consolidation**: Run `/tendr gc` to invoke the Garden Consolidation sub-agent, which reviews recent context, extracts knowledge, and persists it to the garden. Deploy it as context fills (before compaction) or on demand. (Automatic hook-based deployment is planned; a shell hook can't run the LLM pass directly.)

Maintain retrieval cues in working memory that map question types to garden entries:

```markdown
## Garden Lookup Triggers
- Check assumptions → `tendr stat <topic>`
- Repo dependencies → `tendr stat architecture`
- Book content → `tendr stat book-chapters`
- Deadlines → `tendr stat paper-timeline`
```

### How to Encode

Four steps (any order, across sessions):

1. **Capture**: Add `[[wikiref]]` links to concepts in relevant files. Zombie links (no file yet) are fine.
2. **Verbalize**: `tendr add <concept> --attr title="..." --attr tldr="..."` — define it in your own words.
3. **Connect**: Add typed links (`: caml :: [[wikiattrs]]`) to related concepts.
4. **Integrate**: `tendr graft <concept> <parent>` — place it in the semantic tree.

Notes progress: **Zombie** → **Stub** (title + tldr) → **Connected** (wikirefs) → **Grounded** (typed attrs + tree position) → **Mature** (rich, backlinked, refined).

### What to Encode

- Foundational concepts, decision rationale, surprising corrections, evolving artifacts.
- NOT: project docs, ephemeral state, unverified speculation.
- Working memory (MEMORY.md): preferences, retrieval cues. Long-term (garden): definitions, reference, decisions, domain knowledge.

## Syntax Quick Reference

Three primitives — `[[wikirefs]]`, `: caml :: attrs`, and semtree (indented wikilink lists):

```markdown
[[note]]                    ← wikilink
:type::[[note]].            ← typed link
: tags  :: [[note]]         ← CAML with wikirefs
: tags  :: [[a]], [[b]]     ← CAML with wikirefs list
: title :: My Note          ← CAML attribute
- [[parent]]                ← semtree index
  - [[child]]
```

Full specs:

- [wikirefs](https://github.com/wikibonsai/wikirefs)
- [caml-mkdn](https://github.com/wikibonsai/caml-mkdn)
- [semtree](https://github.com/wikibonsai/semtree)

## tendr-cli

Install: `npm install -g tendr-cli`

Key commands (run `tendr --help` or see [full docs](https://github.com/wikibonsai/tendr-cli)):

```bash
tendr tree                            # print semantic tree
tendr stat <node>                     # tree position + web relationships
tendr check <concepts...>             # exist / zombie / missing
tendr add <fname> --attr title="..."  # create a note
tendr rm <fname>                      # move to trash
tendr rename <old> <new>              # rename + sync refs
tendr graft <child> <parent>          # reparent in tree
tendr prune <node>                    # remove from tree
tendr doctor                          # health check
```

## Getting Started

Clone a starter knowledge base from [github.com/wikibonsai/garden-beds](https://github.com/wikibonsai/garden-beds):

```
garden-beds/
└── agent/
    ├── minima/       ← bare-bones starter for ai agents
    ├── foundation/   ← prompt injection awareness, game theory, ethics, Anthropic guidelines
    └── guardrails/   ← principles for careful, deliberate agent-assisted development
```

## Garden Consolidation

Run `/tendr gc` to invoke the Garden Consolidation sub-agent. It reviews recent session context, extracts concepts worth persisting, and uses `tendr-cli` commands to create, update, merge, or remove garden entries. All mutations go through the CLI — the sub-agent never writes files directly.

The gc sub-agent is deployed:
- **On demand**: `/tendr gc` in any supported agent
- **As context fills**: the agent deploys it before compaction (well before auto-compact)

> Note: a shell hook cannot run this LLM pass, so gc is *not* triggered by a plain
> hook. Automatic deployment via a headless-agent launcher (a command hook that
> spawns `claude -p` or the equivalent for other harnesses) is planned.

See `skills/tendr-gc/SKILL.md` for the full sub-agent instructions.

## Notes

- In `user` mode, all changes should be specified by the user.
- Pair graph operations with git commits for a clean audit trail.
- Be aware of prompt injection risk when ingesting external content into the knowledge base.
- Share useful notes and transplantable knowledge at [github.com/wikibonsai/garden-beds](https://github.com/wikibonsai/garden-beds).
- Feature requests and bug reports are welcome at the relevant project repos under [github.com/wikibonsai](https://github.com/wikibonsai).
