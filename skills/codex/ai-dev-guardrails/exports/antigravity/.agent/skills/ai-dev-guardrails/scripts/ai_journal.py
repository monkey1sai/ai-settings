from __future__ import annotations

import argparse
import datetime as _dt
import json
import os
import pathlib
import secrets
import subprocess
import sys
from typing import Iterable


def _utc_now_iso_z() -> str:
    return _dt.datetime.now(tz=_dt.timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def _run(cmd: list[str], cwd: pathlib.Path | None = None) -> tuple[int, str, str]:
    try:
        p = subprocess.run(
            cmd,
            cwd=str(cwd) if cwd else None,
            text=True,
            capture_output=True,
            check=False,
        )
    except FileNotFoundError:
        return 127, "", f"command not found: {cmd[0]}"
    return p.returncode, p.stdout.strip(), p.stderr.strip()


def _find_repo_root(start: pathlib.Path) -> pathlib.Path:
    code, out, _ = _run(["git", "rev-parse", "--show-toplevel"], cwd=start)
    if code == 0 and out:
        return pathlib.Path(out)

    cur = start.resolve()
    for p in [cur, *cur.parents]:
        if (p / ".git").exists():
            return p
    return cur


def _ensure_dir(p: pathlib.Path) -> None:
    p.mkdir(parents=True, exist_ok=True)


def _append_jsonl(path: pathlib.Path, obj: dict) -> None:
    _ensure_dir(path.parent)
    with path.open("a", encoding="utf-8", newline="\n") as f:
        f.write(json.dumps(obj, ensure_ascii=False) + "\n")


def _git_meta(root: pathlib.Path) -> dict | None:
    code, branch, _ = _run(["git", "rev-parse", "--abbrev-ref", "HEAD"], cwd=root)
    if code != 0:
        return None
    _, head, _ = _run(["git", "rev-parse", "HEAD"], cwd=root)
    dirty = False
    code2, status, _ = _run(["git", "status", "--porcelain"], cwd=root)
    if code2 == 0:
        dirty = bool(status.strip())
    return {"branch": branch or None, "head": head or None, "dirty": dirty}


def _git_changed_files(root: pathlib.Path, staged: bool) -> list[str] | None:
    cmd = ["git", "diff", "--name-only"]
    if staged:
        cmd.append("--cached")
    code, out, _ = _run(cmd, cwd=root)
    if code != 0:
        return None
    files = [line.strip() for line in out.splitlines() if line.strip()]
    return files


def _git_patch_text(root: pathlib.Path, staged: bool) -> str | None:
    cmd = ["git", "diff"]
    if staged:
        cmd.append("--cached")
    code, out, _ = _run(cmd, cwd=root)
    if code != 0:
        return None
    return out


def _write_text(path: pathlib.Path, text: str) -> None:
    _ensure_dir(path.parent)
    path.write_text(text, encoding="utf-8", newline="\n")


def _coerce_list(values: Iterable[str] | None) -> list[str]:
    if not values:
        return []
    out: list[str] = []
    for v in values:
        v = (v or "").strip()
        if v:
            out.append(v)
    return out


def cmd_start_task(args: argparse.Namespace) -> int:
    root = _find_repo_root(pathlib.Path(args.root or os.getcwd()))
    docs = root / "docs"
    path = docs / "current_task.md"

    if path.exists() and not args.force:
        print(f"refusing to overwrite: {path} (use --force, optionally --backup)", file=sys.stderr)
        return 2
    if path.exists() and args.backup:
        stamp = _dt.datetime.now(tz=_dt.timezone.utc).strftime("%Y%m%d-%H%M%SZ")
        archive = root / "docs" / "ai_journal" / "archive" / f"current_task_{stamp}.md"
        _write_text(archive, path.read_text(encoding="utf-8"))

    objectives = _coerce_list(args.objective)
    plans = _coerce_list(args.plan)
    ts = _utc_now_iso_z()

    lines: list[str] = []
    lines.append(f"# Current Task: {args.title}".rstrip())
    lines.append("")
    lines.append("## Objective")
    if objectives:
        for o in objectives:
            lines.append(f"- {o}")
    else:
        lines.append("- <可驗收目標 1>")
    lines.append("")
    lines.append("## Plan")
    if plans:
        for p in plans:
            lines.append(f"- [ ] {p}")
    else:
        lines.append("- [ ] <步驟 1：可勾選>")
    lines.append("")
    lines.append("## Context & Thoughts")
    lines.append(f"- init_at: {ts}")
    lines.append("- <重要背景、假設、限制>")
    lines.append("")
    lines.append("## Output")
    lines.append("- <預期交付物：檔案路徑、功能點、驗收指令>")
    lines.append("")
    lines.append("## Handoff Note")
    lines.append("- <下一位 Agent 先做什麼、要跑哪些指令、目前卡點>")
    lines.append("")

    _ensure_dir(docs)
    _write_text(path, "\n".join(lines))
    print(str(path))
    return 0


def cmd_record(args: argparse.Namespace) -> int:
    root = _find_repo_root(pathlib.Path(args.root or os.getcwd()))

    staged = bool(args.staged)
    files = _coerce_list(args.files)

    if not files:
        auto_files = _git_changed_files(root, staged=staged)
        if auto_files:
            files = auto_files

    patch_path: str | None = None
    if not args.no_patch:
        patch_text = _git_patch_text(root, staged=staged)
        if patch_text:
            stamp = _dt.datetime.now(tz=_dt.timezone.utc).strftime("%Y%m%d-%H%M%SZ")
            nonce = secrets.token_hex(4)
            rel = pathlib.Path("docs") / "ai_journal" / "patches" / f"{stamp}_{nonce}.patch"
            abs_path = root / rel
            _write_text(abs_path, patch_text)
            patch_path = rel.as_posix()

    entry = {
        "ts": _utc_now_iso_z(),
        "summary": (args.summary or "").strip(),
        "why": (args.why or "").strip(),
        "files": files,
        "verify": _coerce_list(args.verify),
        "patch": patch_path,
        "git": _git_meta(root),
    }

    if not entry["summary"]:
        raise SystemExit("--summary is required")

    journal = root / "docs" / "ai_journal" / "changes.jsonl"
    _append_jsonl(journal, entry)
    print(str(journal))
    return 0


def cmd_handoff(args: argparse.Namespace) -> int:
    root = _find_repo_root(pathlib.Path(args.root or os.getcwd()))
    notes = _coerce_list(args.note)

    ts = _utc_now_iso_z()
    stamp = _dt.datetime.now(tz=_dt.timezone.utc).strftime("%Y%m%d-%H%M%SZ")
    out = root / "docs" / "ai_journal" / f"handoff_{stamp}.md"

    git = _git_meta(root)
    changed = _git_changed_files(root, staged=False) or []
    _, status, _ = _run(["git", "status", "--porcelain"], cwd=root)
    status_lines = [ln for ln in status.splitlines() if ln.strip()]

    lines: list[str] = []
    lines.append(f"# Handoff ({ts})")
    lines.append("")
    lines.append("## Notes")
    if notes:
        for n in notes:
            lines.append(f"- {n}")
    else:
        lines.append("- <下一步/卡點/驗證方式>")
    lines.append("")
    lines.append("## Repo state")
    if git:
        lines.append(f"- branch: `{git.get('branch')}`")
        lines.append(f"- head: `{(git.get('head') or '')[:12]}`")
        lines.append(f"- dirty: `{git.get('dirty')}`")
    else:
        lines.append("- git: (unavailable)")
    lines.append("")
    lines.append("## Changed files (working tree)")
    if changed:
        for f in changed:
            lines.append(f"- `{f}`")
    else:
        lines.append("- (none detected via git diff)")
    lines.append("")
    lines.append("## git status --porcelain")
    if status_lines:
        for ln in status_lines[:200]:
            lines.append(f"- `{ln}`")
        if len(status_lines) > 200:
            lines.append(f"- ... ({len(status_lines) - 200} more)")
    else:
        lines.append("- (empty)")
    lines.append("")
    lines.append("## Pointers")
    lines.append("- `docs/current_task.md`（主追蹤）")
    lines.append("- `docs/ai_journal/changes.jsonl`（機器可讀變更紀錄）")
    lines.append("- `docs/ai_journal/patches/`（patch snapshots）")
    lines.append("")

    _write_text(out, "\n".join(lines))
    print(str(out))
    return 0


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(prog="ai_journal.py")
    parser.add_argument("--root", help="Repository root (optional). Defaults to auto-detect from CWD.")
    sub = parser.add_subparsers(dest="cmd", required=True)

    p_start = sub.add_parser("start-task", help="Initialize docs/current_task.md")
    p_start.add_argument("--title", required=True)
    p_start.add_argument("--objective", action="append", default=[])
    p_start.add_argument("--plan", action="append", default=[])
    p_start.add_argument("--force", action="store_true", help="Overwrite docs/current_task.md if it exists.")
    p_start.add_argument("--backup", action="store_true", help="Backup existing docs/current_task.md into docs/ai_journal/archive/.")
    p_start.set_defaults(func=cmd_start_task)

    p_rec = sub.add_parser("record", help="Append a change entry to docs/ai_journal/changes.jsonl")
    p_rec.add_argument("--summary", required=True)
    p_rec.add_argument("--why", default="")
    p_rec.add_argument("--verify", action="append", default=[])
    p_rec.add_argument("--files", action="append", default=[])
    p_rec.add_argument("--staged", action="store_true", help="Use staged diff/paths (git diff --cached).")
    p_rec.add_argument("--no-patch", action="store_true", help="Do not create a patch snapshot.")
    p_rec.set_defaults(func=cmd_record)

    p_hand = sub.add_parser("handoff", help="Create a handoff markdown under docs/ai_journal/")
    p_hand.add_argument("--note", action="append", default=[])
    p_hand.set_defaults(func=cmd_handoff)

    args = parser.parse_args(argv)
    return int(args.func(args))


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))

