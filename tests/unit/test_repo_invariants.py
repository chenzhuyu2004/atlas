from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def test_version_format() -> None:
    version_file = ROOT / "docker" / "atlas" / "VERSION"
    version = version_file.read_text(encoding="utf-8").strip()
    assert re.match(
        r"^\d+\.\d+(\.\d+)?$", version
    ), f"VERSION should be semver-like (e.g. 1.2 or 1.2.3), got: {version}"


def test_requirements_not_empty() -> None:
    req_dir = ROOT / "docker" / "atlas"
    req_files = sorted(req_dir.glob("requirements*.txt"))
    assert req_files, "Expected at least one requirements*.txt file"
    for req in req_files:
        content = req.read_text(encoding="utf-8").strip()
        assert content, f"{req.name} is empty"


def test_docs_index_exists() -> None:
    repo_docs_index = ROOT / "docs" / "README.md"
    image_docs_index = ROOT / "docker" / "atlas" / "docs" / "README.md"
    assert repo_docs_index.exists(), "docs/README.md is missing"
    assert image_docs_index.exists(), "docker/atlas/docs/README.md is missing"
