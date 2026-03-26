---
name: tendr
description: Manages long-term semantic memory as a structured plain markdown knowledge base using WikiBonsai primitives. This skill is designed to be always-on — if you have installed it, use WikiBonsai syntax and tendr-cli commands to persist, organize, and navigate knowledge across all sessions.
license: GPL-3.0
metadata:
  author: wikibonsai
  version: "0.1"
---

# tendr

WikiBonsai is a knowledge architecture for structured plain text. It extends markdown with three primitives that together form a complete knowledge graph: Typed links between notes, structured attributes, and an explicit semantic hierarchy. This skill teaches you to use those primitives and the tendr-cli to manage a WikiBonsai knowledge base as your long-term semantic memory.

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

In `agent` mode, place the garden (your knowledge base) as close to your auto-memory file as possible. The garden is agent memory, not project data, it should live alongside your other persistent memory, not in the project root.

```
<auto-memory-dir>/
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

### When to Interact

- **Session start**: Run `tendr tree` to orient.
- **Before stating a fact**: Run `tendr stat <topic>` to check. Reading a file is cheaper than a wrong assumption.
- **When you look something up, get corrected, have an insight, or catch yourself re-deriving something**: Capture it. The test: If this conversation were compacted, would this concept survive? If not, it belongs in the garden. These triggers apply equally when the user expresses them in the form of a correction, surprise, or repeated explanation.
- **Session end**: Review the session for concepts worth persisting. Update existing entries over creating new ones. Prune or merge entries that have become redundant. Promote zombie links to stubs. Update working memory retrieval cues if new entries were created.

Maintain retrieval cues in working memory that map question types to garden entries:

```markdown
## Garden Lookup Triggers
- Check assumptions → `tendr stat <topic>`
- Repo dependencies → `tendr stat architecture`
- Book content → `tendr stat book-chapters`
- Deadlines → `tendr stat paper-timeline`
```

### How to Encode

Knowledge grows keyword by keyword, project by project. The same workflow applies whether you're reading a book or working on a codebase: `[[active-reading]]` from a book and `[[middleware-layer]]` from a CLI refactor are both concepts that grow the same way. Add keywords that are **foundational to the task** at hand or at the **edges of understanding**, when a concept is confusing and requires explanation.

Four steps. They don't need to happen in order or in a single session.

**1. Capture**: When you encounter a foundational or unfamiliar concept, add it as a `[[wikiref]]` in a relevant file.

```markdown
// bk.how-to-read-a-book.md

: title :: How To Read A Book

## chapter 1

- [[active-reading]]
- [[aided-discovery]]
- [[unaided-discovery]]
- [[4-levels-of-reading]]
```

This creates "zombie links" or references to notes that don't exist yet. Zombie links are fine. They mark where understanding has edges.

**2. Verbalize**: Create a document for the concept. Add a `title` and a `tldr` or `def` in your own words. Writing the definition is a test of understanding. If you can't explain it, you don't understand it yet.

```markdown
// active-reading.md

: title :: active reading
: tldr  :: "an effortful activity of cooperation between reader and writer; to continually ask questions as you read and search for the corresponding answers."
```

**3. Connect**: Add `[[wikirefs]]` to related concepts. As understanding deepens, promote informal links to formal `: caml :: [[wikiattrs]]` to capture typed relationships.

```markdown
// active-reading.md

: title        :: active reading
: tldr         :: "an effortful activity of cooperation between reader and writer; to continually ask questions as you read and search for the corresponding answers."
: attribute-of :: [[demanding-reader]]
: participants :: [[reader]], [[writer]]
: requires     :: [[effort]]
```

**4. Integrate**: Place the concept in the semantic tree. Find a location that makes sense and illuminates the rules of abstraction. A parent that naturally encapsulates it and children over which it generalizes.

```markdown
// i.index.md
- [[learn]]
  - [[discovery]]
    - [[aided-discovery]]
    - [[unaided-discovery]]
  - [[read]]
    - [[active-reading]]
      - [[4-levels-of-reading]]
    - [[demanding-reader]]
```

Tree position implies expected attributes. Ancestors and parents provide inherited attributes, while siblings will likely share a common attribute shape. Templates (e.g., a `book` doctype prescribing `: title ::`, `: author ::`, `: genre ::`) are the explicit form of this; the same principle applies implicitly throughout the tree.

This 4-step ordering is particularly useful for organic discovery, but you might find it useful to work in reverse when inheriting knowledge or being explicitly instructed.

### Note Progression

Notes grow from sparse to rich over time. Start with a stub and let it develop across sessions and projects. Don't wait for completeness:

| Stage | What it looks like |
|---|---|
| **Zombie** | `[[concept]]` link exists but no file yet |
| **Stub** | File created with `: title ::` and `: tldr ::` |
| **Connected** | `[[wikirefs]]` added; informal links to related concepts |
| **Grounded** | `: caml :: [[wikiattrs]]` formalize relationships; concept has a semtree position |
| **Mature** | Rich attributes, backlinks from other notes, definition refined across multiple encounters |

The same concept encountered across different sources gets richer each time. `[[active-reading]]` from "How To Read A Book" and `[[active-reading]]` from "The Mind Illuminated" accumulate into a single well-connected note.

### What to Encode

- **Foundational concepts**: Keywords you need to understand the domain
- **Decision rationale**: Record both the decision and the reasoning. Future sessions need *why*, not just *what*
- **Surprising corrections**: When assumptions are corrected, encode the correction
- **Evolving artifacts**: Content iterated across multiple sessions

Do NOT write to the garden:

- Information already covered in project documentation.
- Ephemeral task state or routine session details.
- Unverified speculation.

### What Belongs Where

| Information | Working Memory | Long-Term Memory |
|---|---|---|
| User preferences | ✓ | |
| Quick reference paths | ✓ | |
| Retrieval cues into garden | ✓ | |
| Concept definitions | | ✓ |
| Reference tables | | ✓ |
| Dependency maps | | ✓ |
| Decision log with rationale | | ✓ |
| Evolving structured artifacts | | ✓ |
| Domain knowledge with links | | ✓ |

## WikiBonsai Syntax

Three primitives. Full specs linked below.

**wikirefs**: Typed links between notes. Both untyped and typed forms are valid.

```markdown
[[note-name]]               ← untyped link
:cause::[[note-name]]       ← typed link
![[note-name]]              ← embed
```

Full spec: [github.com/wikibonsai/wikirefs](https://github.com/wikibonsai/wikirefs)

**CAML**: Structured attributes with native wikiref support. Unlike frontmatter, CAML can appear anywhere in a file.

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

**semtree**: Explicit semantic hierarchy defined across multiple index files. Each index file can reference another, and semtree merges them into a single unified tree.

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
tendr doctor          # garden health check
tendr tree            # print the full semantic tree
tendr stat <node>     # get a node's position: ancestors, children, backlinks, forelinks
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
