# Obsidian Flavored Markdown — patterns used by this skill

Quick reference for the specific Obsidian features the PDF-to-vault workflow relies on.

## Frontmatter

```yaml
---
title: Cache
tags:
  - system-design
  - concept
  - performance
aliases:
  - Caching
  - Cache tier
source: "System Design Interview: An Insider's Guide — Alex Xu"
pdf_pages: "15-16"
---
```

- `title` — the canonical display name (usually matches filename).
- `tags` — used by Obsidian's tag filter; at least one broad tag (`system-design`) and one narrow tag (`concept`, `chapter`, `MOC`).
- `aliases` — alternative names this concept is known by. Obsidian's link autocomplete picks these up, so `[[Primary-replica]]` resolves to the Database Replication note.
- `source` / `pdf_pages` — provenance. Always include these so future-you can find the passage.

## Wikilinks vs markdown links

Use wikilinks for internal vault links. They survive renames.

```markdown
[[Load Balancer]]                    → link to note by title
[[Load Balancer|LB]]                 → custom display text
[[Ch01 - Scale from Zero#Summary]]   → link to a heading
```

Use markdown links **only** for external URLs: `[AWS](https://aws.amazon.com)`.

## Embeds (for figures)

```markdown
![[fig-1-4.jpg]]          Full-width embed
![[fig-1-4.jpg|500]]      Width-limited embed
![[Another Note]]         Embed an entire note
![[Another Note#Heading]] Embed a specific section
```

Prefer full-width embeds for most figures — Obsidian scales them sanely.

## Callouts

| Type | Use for |
|------|---------|
| `> [!abstract]` | Chapter goal (one line at the top of a chapter note) |
| `> [!tip]` | Rules of thumb, best practices |
| `> [!warning]` | Pitfalls, things that break at scale |
| `> [!important]` | Load-bearing principles ("stateless is a prerequisite for …") |
| `> [!example]` | Concrete scenarios / real-world references |
| `> [!quote]` | Short attributed quote from the book |
| `> [!info]` | Meta info (e.g. extraction progress on the MOC) |

Collapsed callouts use `-` (collapsed) or `+` (expanded): `> [!faq]- Collapsed by default`.

## Mermaid diagrams

Great for the MOC's concept graph and for chapter-level flowcharts.

````markdown
```mermaid
graph LR
    A[Single server] --> B[DB split]
    B --> C[Load balancer]
    class A,B,C internal-link;
```
````

`class ... internal-link;` turns nodes into clickable Obsidian links.

## Tables

Plain markdown tables render fine. Use them for comparison matrices (Stateful vs Stateless, SQL vs NoSQL, Vertical vs Horizontal).

## Math

Inline: `$O(n \log n)$`. Block:

```markdown
$$
\text{QPS} = \frac{\text{DAU} \times \text{actions per user}}{86400}
$$
```

## Block IDs (for deep links)

Attach an ID to any paragraph so you can link right to it:

```markdown
The celebrity problem causes shard overload. ^celebrity-def
```

Then `[[Database Sharding#^celebrity-def]]` jumps to that exact paragraph.

## Highlight

`==highlighted==` renders as a yellow highlight. Use sparingly — reserve for the single most important phrase in a note.

## Anti-patterns in an Obsidian vault

- **Long monolithic notes** — hard to link into and hard to read.
- **Duplicating content across notes** — use embeds (`![[Note#Section]]`) instead.
- **Plain-text concept names** — always wikilink a concept the first time (and usually every time) it appears.
- **Generic filenames** — `fig1.jpg` is useless; use `fig-1-4.jpg` or descriptive names.
- **Mixing book source with personal commentary without marking it** — use a callout (`> [!note] My take`) so future-you can tell what came from the book.
