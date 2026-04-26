#!/usr/bin/env python3
"""
Extract text, chapter boundaries, and images from a PDF book.

Usage:
    # Detect chapters
    python extract_pdf.py chapters <pdf>

    # Extract text for a page range into a file
    python extract_pdf.py text <pdf> <start> <end> <out.txt>

    # Extract images from a page range into a folder
    python extract_pdf.py images <pdf> <start> <end> <out_dir>

    # Everything at once (creates {out_dir}/text.txt and image files)
    python extract_pdf.py all <pdf> <start> <end> <out_dir>

Notes:
- Pages are 1-indexed to match how humans refer to PDF pages.
- Images are saved as {prefix}-p{page:03d}-{index}.{ext}. Rename them to
  figure numbers (fig-1-4.jpg) after inspecting a few.
- Requires: pypdf, Pillow. Install with:  pip3 install pypdf Pillow
"""

import argparse
import os
import sys


def require_libs():
    try:
        import pypdf  # noqa: F401
    except ImportError:
        sys.exit("pypdf missing. Install: pip3 install pypdf Pillow")
    try:
        import PIL  # noqa: F401
    except ImportError:
        sys.exit("Pillow missing. Install: pip3 install Pillow")


def locate_pdf(path):
    """Resolve a PDF path even if the filename has awkward unicode."""
    if os.path.isfile(path):
        return path
    # Try directory fallback: if `path` is a directory, pick the single PDF in it.
    if os.path.isdir(path):
        pdfs = [f for f in os.listdir(path) if f.lower().endswith(".pdf")]
        if len(pdfs) == 1:
            return os.path.join(path, pdfs[0])
        sys.exit(f"Ambiguous PDF in {path!r}: {pdfs}")
    # Shell-level filename mismatch (curly quote etc.) — try listing the parent.
    parent = os.path.dirname(path) or "."
    base = os.path.basename(path)
    if os.path.isdir(parent):
        matches = [
            f for f in os.listdir(parent)
            if f.lower().endswith(".pdf") and base.split(".")[0][:15].lower() in f.lower()
        ]
        if len(matches) == 1:
            return os.path.join(parent, matches[0])
    sys.exit(f"Cannot find PDF at {path!r}")


def cmd_chapters(pdf_path):
    from pypdf import PdfReader
    reader = PdfReader(pdf_path)
    print(f"Total pages: {len(reader.pages)}")
    print()
    for i in range(len(reader.pages)):
        text = reader.pages[i].extract_text() or ""
        stripped = text.strip()
        for n in range(1, 50):
            marker = f"CHAPTER {n}:"
            if marker in text and stripped.startswith(marker):
                # Print page + first line of title
                first_line = stripped.split("\n", 1)[0]
                print(f"Ch{n:>2}: page {i + 1:>3}  {first_line[:80]}")
                break


def cmd_text(pdf_path, start, end, out_txt):
    from pypdf import PdfReader
    reader = PdfReader(pdf_path)
    out = []
    for i in range(start - 1, min(end, len(reader.pages))):
        text = reader.pages[i].extract_text() or ""
        out.append(f"\n\n===== PAGE {i + 1} =====\n{text}")
    with open(out_txt, "w") as f:
        f.write("".join(out))
    print(f"Wrote {len(''.join(out))} chars to {out_txt}")


def cmd_images(pdf_path, start, end, out_dir):
    from pypdf import PdfReader
    reader = PdfReader(pdf_path)
    os.makedirs(out_dir, exist_ok=True)
    prefix = "pdf"
    total = 0
    for i in range(start - 1, min(end, len(reader.pages))):
        page = reader.pages[i]
        try:
            images = list(page.images)
        except Exception as exc:
            print(f"Page {i + 1}: error {exc}", file=sys.stderr)
            continue
        for idx, img in enumerate(images):
            ext = os.path.splitext(img.name)[1] or ".png"
            fname = f"{prefix}-p{i + 1:03d}-{idx + 1}{ext}"
            fpath = os.path.join(out_dir, fname)
            with open(fpath, "wb") as f:
                f.write(img.data)
            total += 1
        if images:
            print(f"Page {i + 1}: {len(images)} image(s)")
    print(f"\nTotal: {total} image(s) extracted to {out_dir}")


def main():
    p = argparse.ArgumentParser()
    sub = p.add_subparsers(dest="cmd", required=True)

    c1 = sub.add_parser("chapters", help="Print detected chapter boundaries")
    c1.add_argument("pdf")

    c2 = sub.add_parser("text", help="Extract text from a page range")
    c2.add_argument("pdf")
    c2.add_argument("start", type=int)
    c2.add_argument("end", type=int)
    c2.add_argument("out_txt")

    c3 = sub.add_parser("images", help="Extract images from a page range")
    c3.add_argument("pdf")
    c3.add_argument("start", type=int)
    c3.add_argument("end", type=int)
    c3.add_argument("out_dir")

    c4 = sub.add_parser("all", help="Extract both text and images for a range")
    c4.add_argument("pdf")
    c4.add_argument("start", type=int)
    c4.add_argument("end", type=int)
    c4.add_argument("out_dir")

    args = p.parse_args()
    require_libs()
    pdf_path = locate_pdf(args.pdf)

    if args.cmd == "chapters":
        cmd_chapters(pdf_path)
    elif args.cmd == "text":
        cmd_text(pdf_path, args.start, args.end, args.out_txt)
    elif args.cmd == "images":
        cmd_images(pdf_path, args.start, args.end, args.out_dir)
    elif args.cmd == "all":
        os.makedirs(args.out_dir, exist_ok=True)
        cmd_text(pdf_path, args.start, args.end, os.path.join(args.out_dir, "text.txt"))
        cmd_images(pdf_path, args.start, args.end, args.out_dir)


if __name__ == "__main__":
    main()
