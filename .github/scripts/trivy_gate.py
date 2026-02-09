#!/usr/bin/env python3
"""Fail CI if Trivy report contains vulnerabilities of given severities."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Gate on Trivy JSON report severities."
    )
    parser.add_argument(
        "--report",
        default="trivy-pr.json",
        help="Path to Trivy JSON report (default: trivy-pr.json)",
    )
    parser.add_argument(
        "--fail-on",
        default="HIGH,CRITICAL",
        help="Comma-separated severities to fail on (default: HIGH,CRITICAL)",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    report_path = Path(args.report)
    if not report_path.is_file():
        print(f"Trivy report not found: {report_path}")
        return 1

    try:
        report = json.loads(report_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        print(f"Failed to parse Trivy report: {exc}")
        return 1

    severities = {s.strip().upper() for s in args.fail_on.split(",") if s.strip()}
    count = 0
    for result in report.get("Results", []):
        for vuln in result.get("Vulnerabilities") or []:
            sev = str(vuln.get("Severity", "")).upper()
            if not severities or sev in severities:
                count += 1

    label = "/".join(sorted(severities)) if severities else "ALL"
    print(f"{label} vulnerabilities found: {count}")
    return 1 if count > 0 else 0


if __name__ == "__main__":
    sys.exit(main())
