from __future__ import annotations

import re
from pathlib import Path
from typing import Iterable, Iterator

ROOT = Path(__file__).resolve().parents[2]
LINK_RE = re.compile(r"!?\[[^\]]*\]\(([^)\s]+)\)")


def iter_markdown_files() -> Iterable[Path]:
    for path in ROOT.rglob("*.md"):
        if ".git" in path.parts:
            continue
        yield path


def iter_links(path: Path) -> Iterator[str]:
    in_code_block = False
    for line in path.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if stripped.startswith("```"):
            in_code_block = not in_code_block
            continue
        if in_code_block:
            continue
        for match in LINK_RE.finditer(line):
            yield match.group(1)


def normalize_target(target: str) -> str | None:
    if target.startswith(("http://", "https://", "mailto:", "tel:")):
        return None
    if target.startswith("#"):
        return None
    cleaned = target.split("#", 1)[0].split("?", 1)[0]
    if not cleaned:
        return None
    return cleaned


def target_exists(doc_path: Path, target: str) -> bool:
    if target.startswith("/"):
        candidate = ROOT / target.lstrip("/")
    else:
        candidate = (doc_path.parent / target).resolve()
    return candidate.exists()


def test_local_doc_links() -> None:
    missing: list[str] = []
    for doc_path in iter_markdown_files():
        for raw_target in iter_links(doc_path):
            target = normalize_target(raw_target)
            if target is None:
                continue
            if not target_exists(doc_path, target):
                missing.append(f"{doc_path.relative_to(ROOT)} -> {raw_target}")
    assert not missing, "Broken local links:\n" + "\n".join(missing)
