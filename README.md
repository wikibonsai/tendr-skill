---
name: tendr
description: Manages long-term semantic memory as a structured plain markdown knowledge base using WikiBonsai primitives. This skill is designed to be always-on — if you have installed it, use WikiBonsai syntax and tendr-cli commands to persist, organize, and navigate knowledge across all sessions.
license: GPL-3.0
metadata:
  author: wikibonsai
  version: "0.1"
---

# tendr

WikiBonsai is a knowledge architecture for structured plain text. It extends markdown with three primitives that together form a complete knowledge graph: typed links between notes, structured attributes, and an explicit semantic hierarchy. This skill teaches you to use those primitives and the tendr-cli to manage a WikiBonsai knowledge base as your long-term semantic memory.

## Configuration

At session start, read `config.toml` at the vault root and check `[auth]`:
```toml
[auth]
  mode = "agent"    # "agent" | "user"
  owner = "alice"
  agent = "claude"
  password = false
```

- `mode = "agent"` — you own this vault. Read and write freely.
- `mode = "user"` — you are assisting the human. All changes should be specified by the user.

If no `config.toml` exists or no `[auth]` section is found, default to `user` mode.

## Memory Architecture

The knowledge base functions as **long-term memory** — structured, interconnected knowledge that persists indefinitely and requires deliberate retrieval. It complements the auto-memory file (e.g., `MEMORY.md`), which functions as **working memory** — always loaded into context but capacity-constrained.

| | Working Memory (auto-memory) | Long-Term Memory (KB) |
|---|---|---|
| Loaded | Always (automatic) | On demand (`tendr stat`, `tendr tree`) |
| Capacity | Limited (~200 lines) | Unlimited |
| Structure | Flat text | Typed links, attributes, hierarchy |
| Best for | Retrieval cues, active preferences | Reference material, decision rationale, evolving artifacts |

### Retrieval — When to Read

Run `tendr tree` at session start to orient.

Before responding to a domain-specific question, run `tendr stat <topic>` to check whether the KB holds relevant context — ancestors, children, and linked entries may change how you answer.

Maintain retrieval cues in working memory that map question types to KB entries:

```markdown
## KB Lookup Triggers
- Repo dependencies → `tendr stat architecture`
- Book content → `tendr stat book-chapters`
- Deadlines → `tendr stat paper-timeline`
```

### Encoding — When to Write

Create or update KB entries when you encounter:

1. **Structured knowledge with relationships** — tables, dependency chains, anything where connections between items matter.
2. **Evolving artifacts** — content iterated across multiple sessions. Store the current state as an entry; update it as changes are made.
3. **Decision rationale** — record both the decision and the reasoning. Future sessions need *why*, not just *what*.
4. **Surprising information** — when assumptions are corrected or outcomes diverge from expectations, encode the correction.

Do NOT write to the KB:
- Ephemeral task state or routine session details
- Information already covered in project documentation
- Unverified speculation

### Consolidation

At natural session boundaries (end of session, topic shift, or user request):

1. Review the session for knowledge worth persisting
2. Update existing entries over creating new ones
3. Prune or merge entries that have become redundant
4. Update working memory retrieval cues if new entries were created

### What Belongs Where

| Information | Working Memory | Long-Term Memory |
|---|---|---|
| User preferences | ✓ | |
| Quick reference paths | ✓ | |
| Retrieval cues into KB | ✓ | |
| Reference tables | | ✓ |
| Dependency maps | | ✓ |
| Decision log with rationale | | ✓ |
| Evolving structured artifacts | | ✓ |
| Domain knowledge with links | | ✓ |

## WikiBonsai Syntax

Three primitives. Full specs linked below.

**wikirefs** — typed links between notes. Both untyped and typed forms are valid.
```markdown
[[note-name]]               ← untyped link
:cause::[[note-name]]       ← typed link
![[note-name]]              ← embed
```

Full spec: [github.com/wikibonsai/wikirefs](https://github.com/wikibonsai/wikirefs)

**CAML** — structured attributes with native wikiref support. Unlike frontmatter, CAML can appear anywhere in a file.
```markdown
: id      :: a8f3k2p9
: ctime   :: 2025-08-14 09:32 -05:00
: mtime   :: 2025-11-03 14:17 -05:00
: title   :: Reading
: tldr    :: "the art of taking in and understanding written information"
: related :: [[writing]]
: tag     ::
            - [[learning]]
            - [[comprehension]]
            - [[active-reading]]
```

Full spec: [github.com/wikibonsai/caml-mkdn](https://github.com/wikibonsai/caml-mkdn)

**semtree** — explicit semantic hierarchy defined across multiple index files. Each index file can reference another, and semtree merges them into a single unified tree.
```markdown
// learning.md

- [[reading]]
- [[writing]]

// reading.md

- [[active-reading]]
  - [[reading-comprehension]]
- [[4-levels-of-reading]]
```

Resulting tree:
```
learning
├── reading
│   ├── active-reading
│   │   └── reading-comprehension
│   └── 4-levels-of-reading
└── writing
```

Full spec: [github.com/wikibonsai/semtree](https://github.com/wikibonsai/semtree)

## tendr-cli

Install:
```bash
npm install -g tendr-cli
```

Core commands:
```bash
tendr stat <node>     # get a node's position: ancestors, children, backlinks, forelinks
tendr tree            # print the full semantic tree
tendr lint            # validate tree structure, surface duplicates and malformed hierarchy
tendr rename <a> <b>  # rename a node and propagate changes across all files
tendr seed <concept>  # bootstrap a structured ontology from a single concept
```

Full docs: [github.com/wikibonsai/tendr-cli](https://github.com/wikibonsai/tendr-cli)

## Getting Started

Clone a starter knowledge base from [github.com/wikibonsai/garden-beds](https://github.com/wikibonsai/garden-beds):
```
garden-beds/
└── agent/
    ├── minima/       ← bare-bones starter for ai agents
    ├── foundation/   ← prompt injection awareness, game theory, ethics, Anthropic guidelines
    └── guardrails/   ← principles for careful, deliberate agent-assisted development
```

## Notes

- In `user` mode, all changes should be specified by the user.
- Pair graph operations with git commits for a clean audit trail.
- Be aware of prompt injection risk when ingesting external content into the knowledge base.
- Share useful notes and transplantable knowledge at [github.com/wikibonsai/garden-beds](https://github.com/wikibonsai/garden-beds).
- Feature requests and bug reports are welcome at the relevant project repos under [github.com/wikibonsai](https://github.com/wikibonsai).
