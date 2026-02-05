from __future__ import annotations

import argparse
import pathlib
import zipfile


def _find_repo_root(start: pathlib.Path) -> pathlib.Path:
    cur = start.resolve()
    for p in [cur, *cur.parents]:
        if (p / ".git").exists():
            return p
    return cur


def _zip_dir(src_dir: pathlib.Path, zip_path: pathlib.Path, arc_prefix: str) -> None:
    zip_path.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for path in sorted(src_dir.rglob("*")):
            if path.is_dir():
                continue
            if path.suffix == ".pyc":
                continue
            if "__pycache__" in path.parts:
                continue
            rel = path.relative_to(src_dir).as_posix()
            zf.write(path, f"{arc_prefix}{rel}")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", default="dist", help="Output directory (relative to repo root).")
    args = parser.parse_args(argv)

    script_path = pathlib.Path(__file__).resolve()
    skill_root = script_path.parents[1]
    repo_root = _find_repo_root(skill_root)

    out_dir = (repo_root / args.out).resolve()
    exports = skill_root / "exports"

    gemini_ext_root = exports / "gemini-cli" / "ai-dev-guardrails"
    antigravity_root = exports / "antigravity"

    if not gemini_ext_root.exists():
        raise SystemExit(f"missing: {gemini_ext_root}")
    if not antigravity_root.exists():
        raise SystemExit(f"missing: {antigravity_root}")

    _zip_dir(
        gemini_ext_root,
        out_dir / "ai-dev-guardrails.gemini-cli-extension.zip",
        arc_prefix="ai-dev-guardrails/",
    )
    _zip_dir(
        antigravity_root,
        out_dir / "ai-dev-guardrails.antigravity-pack.zip",
        arc_prefix="",
    )

    print(str(out_dir / "ai-dev-guardrails.gemini-cli-extension.zip"))
    print(str(out_dir / "ai-dev-guardrails.antigravity-pack.zip"))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
