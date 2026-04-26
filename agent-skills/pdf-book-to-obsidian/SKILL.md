---
name: pdf-book-to-obsidian
description: "Extracts a PDF book (technical, reference, or textbook) into a well-structured Obsidian vault of atomic linked notes with embedded figures. The ONLY source of truth is the user-provided PDF — do not add outside information. Use this skill whenever the user asks to convert a PDF book into Obsidian notes, create markdown notes from a PDF, summarize a book into their vault, extract chapter/concept notes from a PDF, or asks things like 'extract this pdf to obsidian', 'make notes from this book', 'turn this pdf into a knowledge base', 'chapter-by-chapter notes in my vault', 'pull figures and diagrams from this PDF into md'. Trigger even when the user only says 'convert pdf to md' if the source is a book-length PDF intended for personal study."
---

# PDF Book → Obsidian Vault

Turn a PDF book into a **set of atomic, linked Obsidian notes** with the original figures embedded. Every fact must come from the PDF itself — no outside knowledge, no paraphrased hallucinations. If something is not in the source, it is not in the notes.

## Why this shape

Obsidian rewards a **graph of small, one-idea notes** linked with wikilinks over long monolithic chapter dumps. Readers navigate by following concepts, not by scrolling. So instead of one `Chapter 1.md` that holds 30 pages, produce:

- One **chapter index note** per chapter (short: abstract + list of links).
- One **concept note per idea** in that chapter (load balancer, cache, SPOF, …).
- One top-level **MOC** (Map of Content) note tying it all together.

## Workflow

Run these steps in order. Keep a task list — this is a multi-step workflow and skipping a step produces worse output.

### 1. Locate the PDF robustly

PDF filenames often contain non-ASCII characters (curly quotes `'`, em dashes `—`, smart dashes). A naive `cp "the book.pdf"` will fail because the shell literal doesn't match the actual bytes. Use Python's `os.listdir` to get the real name, or check with `ls *.pdf | hexdump -C`.

Copy the PDF to a simple path like `/tmp/book.pdf` before doing anything else — every subsequent command becomes safer.

```python
import os, shutil
src_dir = "/path/to/dir/with/pdf"
pdf = [f for f in os.listdir(src_dir) if f.lower().endswith('.pdf')][0]
shutil.copy(os.path.join(src_dir, pdf), '/tmp/book.pdf')
```

### 2. Install and use the right libraries

- `pypdf` — text extraction and page iteration.
- `Pillow` (auto-used by pypdf) — required to extract embedded images. Without it you'll get `ImportError: pillow is required`.

```bash
pip3 install pypdf Pillow
```

Use the bundled helper: `scripts/extract_pdf.py` handles text extraction, chapter detection, image extraction, and figure-based renaming in one pass. See its `--help` for usage. Prefer it over writing ad-hoc scripts.

### 3. Survey structure before writing anything

Before producing any markdown:

1. Read the first ~10 pages via `Read` with the `pages` parameter (PDFs >10 pages need this).
2. Find the **table of contents** and the real chapter boundaries. Don't trust page numbers printed in the book — use the actual PDF page index. The helper script scans every page for `CHAPTER N:` headings and returns a chapter→start-page map.

Store the chapter page ranges before extraction. This is the basis for everything that follows.

### 4. Extract text once per chapter range

Extract text per chapter into a temp file (e.g. `/tmp/book_ch1_3.txt`). Reading 40+ pages via `Read` into context is wasteful when you just need the prose to paraphrase from.

### 5. Extract and rename images to match figure numbers

Extract all embedded images from the chapter's page range. pypdf yields them per page; save them with page-and-index filenames first (`book-p012-1.jpg`), then open a handful to verify which image corresponds to which `Figure X-Y` label in the text. Rename accordingly:

- `book-p012-1.jpg` → `fig-1-5.jpg`
- `book-p035-1.jpg` → `table-2-1.jpg`
- Code snippet images → descriptive names like `code-memcached-api.jpg`.

This matters because in the notes you want to write `![[fig-1-5.jpg]]`, not `![[book-p012-1.jpg]]` — the figure number is what the prose refers to.

Occasionally an image in the text is a screenshot of code or a table, not a flowchart. Keep it — in Obsidian it still renders inline and is the faithful representation of the original.

### 6. Design the vault layout

Always use this exact layout (put it under an existing vault folder, or a new one named after the book):

```
<Book Title>/
├── <Book Title> MOC.md
├── Chapters/
│   ├── Ch01 - <title>.md
│   ├── Ch02 - <title>.md
│   └── ...
├── Concepts/
│   ├── <Concept A>.md
│   ├── <Concept B>.md
│   └── ...
└── attachments/
    ├── fig-1-1.jpg
    ├── fig-1-2.jpg
    └── ...
```

Why this structure:

- `Chapters/` acts as a linear reading path.
- `Concepts/` is the graph — each note is one idea, link-rich, reusable across chapters.
- `attachments/` keeps binary blobs out of the note lists.
- The MOC is the front door.

### 7. Write the Obsidian notes

Every note uses **Obsidian Flavored Markdown**. Follow the patterns in `references/obsidian_patterns.md` (frontmatter, wikilinks, embeds, callouts, Mermaid).

#### Chapter index note

Short. ~1 screen. Contains:

- Frontmatter with `tags: [<book-tag>, chapter]`, `source:` field pointing at the PDF, `pdf_pages: "5-33"`.
- A 1-line chapter goal in a `> [!abstract]` callout.
- A Mermaid flowchart or table listing the concepts introduced in that chapter, each as a wikilink.
- Embedded milestone figures (the ones that show the state of the system after each addition) using `![[fig-1-6.jpg]]`.
- A "Summary" section (bullet list) and prev/next chapter links at the bottom.

#### Concept note

One idea per file. ~50-150 lines. Contains:

- Frontmatter with `tags`, `aliases` (the synonyms the concept goes by — e.g., "Primary-replica" for "master-slave").
- A one-line definition in the first paragraph.
- The relevant figure(s) embedded.
- Sections explaining: **what it solves**, **how it works**, **considerations/tradeoffs**, **related concepts**.
- Callouts for key rules of thumb (`> [!tip]`, `> [!warning]`, `> [!important]`).
- A `## Related` section listing ≥3 wikilinks to other concepts — this is what builds the graph.

Cross-linking rules:

- **Every mention** of another concept must be a wikilink: `[[Load Balancer]]`, not plain text "load balancer".
- Forward-reference future chapters freely (`[[Consistent Hashing]]`) — dangling links resolve later when those chapters are extracted.
- Prefer `[[Note]]` over `[[Note|custom text]]` unless grammar requires it — simpler and keeps the graph readable.

#### MOC (top-level index)

Contains:

- A progress callout saying which chapters are extracted so far.
- A chapter table with one-line summaries.
- Concepts grouped by **theme** (Architecture, Data, Performance, Reliability, …), not by chapter — this surfaces reusable ideas.
- A Mermaid `graph TD` showing major concept relationships with `class ... internal-link;` so nodes are clickable.
- A "How these notes are organised" section explaining the folder layout.
- A "Source" section naming the book and clarifying the notes are paraphrased study notes, not a reproduction.

### 8. Content rules — the most important section

This skill is pointless if the notes drift from the source or hallucinate. Read these carefully.

> [!important] Source fidelity
> - Only use facts that appear in the PDF. If the book doesn't say it, the note doesn't claim it.
> - No outside knowledge, no "as of 2024…" updates, no examples from other sources.
> - If you're unsure whether a claim came from the PDF, re-check the extracted text before writing it.

> [!important] Paraphrase, don't reproduce
> - The PDF is copyrighted. Summarise and reorganise in your own words.
> - Never paste long verbatim passages. Short quoted phrases (< ~25 words) inside a `> [!quote]` callout are fine when the original wording is distinctive.
> - Figures and tables can be embedded as images — they're being used faithfully, not re-drawn.
> - If the book uses a memorable analogy or name ("celebrity problem", "five nines"), keep that term but explain it in your own prose.

> [!important] Conclusion preservation
> - Every chapter has a takeaway. Capture it in the chapter's `Summary` section and, if it's a general rule, also mint a short concept note for it (e.g., "Redundancy Everywhere" as its own note).
> - `> [!tip]` and `> [!important]` callouts are the right home for rules of thumb.

### 9. Handoff

At the end of extraction, tell the user:

- Where the vault folder is.
- How many chapter notes, concept notes, and images were produced.
- Which chapters remain to be extracted if the job was partial.
- The top-level MOC path so they can open it first in Obsidian.

Do **not** report a chapter as "extracted" unless:

- Its chapter index note exists.
- Every concept mentioned in that chapter has its own note.
- All figures referenced in the chapter text are in `attachments/` and embedded somewhere.
- The MOC lists the chapter.

## Common pitfalls & fixes

| Symptom | Cause | Fix |
|---------|-------|-----|
| `ENOENT` copying the PDF | Curly quote / em dash in filename | Copy via `os.listdir` in Python; operate on `/tmp/book.pdf` |
| `ImportError: pillow is required` | pypdf can't extract images without PIL | `pip3 install Pillow` |
| `Read` fails on large PDF | >10 pages without `pages` param | Always pass `pages: "1-10"` style ranges, max 20 pages per request |
| Figures in notes don't render | Filename doesn't match embed | Rename images to `fig-X-Y.jpg` and write `![[fig-X-Y.jpg]]` |
| Notes feel like a chapter wall-of-text | Wrote one big note per chapter | Split into atomic concept notes; chapter notes just link |
| Graph view looks sparse | Missing cross-links | Ensure every concept references ≥3 related notes in its `## Related` section |
| Notes contain claims not in the book | Outside knowledge leaked in | Re-read the extracted text file; delete any claim you can't trace to a page |

## References

- `references/obsidian_patterns.md` — all Obsidian-specific syntax (wikilinks, embeds, callouts, frontmatter, Mermaid) with ready-to-copy examples.
- `references/note_templates.md` — copy-paste templates for MOC, chapter note, and concept note.
- `scripts/extract_pdf.py` — extract text + images, detect chapters, rename figures.

## When NOT to use this skill

- **Short non-book PDFs** (articles, invoices, forms) — use plain PDF→markdown extraction.
- **`.md` source files** — the user already has markdown.
- **Live web content** — use a web scraping skill.
- **Vault reorganization** without a PDF — this skill is specifically source→notes.
