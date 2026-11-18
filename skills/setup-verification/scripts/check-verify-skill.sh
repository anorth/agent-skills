#!/usr/bin/env bash
# Checks the structure of a generated verify-<app> skill: its frontmatter, its driver,
# its feature map, and the journeys the map names. It doesn't launch the app.
# Usage: check-verify-skill.sh <path to .agents/skills/verify-<app>>
# Exits non-zero if any check fails. WARN lines don't fail the run.
set -uo pipefail

if [[ $# -ne 1 || "$1" == -h || "$1" == --help ]]; then
  echo "usage: $0 <path to .agents/skills/verify-<app>>" >&2
  exit 2
fi

dir=$(cd "$1" 2>/dev/null && pwd -P) || { echo "FAIL: no such directory: $1"; exit 1; }
name=$(basename "$dir")
fails=0
fail() { echo "FAIL: $*"; fails=$((fails + 1)); }
warn() { echo "WARN: $*"; }
ok() { [[ $fails -eq $mark ]] && echo "ok:   $*"; mark=$fails; }
mark=0

# Skill file and frontmatter.
skill="$dir/SKILL.md"
if [[ ! -f "$skill" ]]; then
  fail "SKILL.md missing"
else
  front=$(awk 'NR == 1 && $0 != "---" { exit } NR > 1 && $0 == "---" { exit } NR > 1 { print }' "$skill")
  [[ "$name" == verify-* ]] || fail "directory name '$name' doesn't start with verify-"
  grep -qx "name: $name" <<<"$front" || fail "frontmatter lacks 'name: $name'"
  grep -q '^description:' <<<"$front" || fail "frontmatter lacks a description"
  for cmd in launch doctor cleanup journey; do
    grep -q "app $cmd" "$skill" || fail "SKILL.md never shows 'app $cmd'"
  done
  ok "SKILL.md frontmatter and driver invocations checked"
fi

# Driver.
app="$dir/app"
if [[ ! -f "$app" ]]; then
  fail "driver 'app' missing"
elif [[ ! -x "$app" ]]; then
  fail "driver 'app' isn't executable"
else
  if help=$(cd "$dir" && timeout 60 ./app --help 2>&1); then
    for cmd in launch doctor cleanup journey; do
      grep -qw "$cmd" <<<"$help" || fail "'app --help' doesn't list '$cmd'"
    done
    ok "'app --help' runs"
  else
    fail "'app --help' failed: $(head -3 <<<"$help")"
  fi
fi

# Scripts with a shebang must be executable.
while IFS= read -r -d '' f; do
  if [[ "$(head -c 2 "$f")" == '#!' && ! -x "$f" ]]; then
    fail "${f#"$dir"/} has a shebang but isn't executable"
  fi
done < <(find "$dir" -type f -not -path '*/node_modules/*' -not -name '*.md' -print0)

# Feature map.
mark=$fails
map="$dir/features"
index="$map/README.md"
if [[ ! -f "$index" ]]; then
  fail "features/README.md missing"
else
  expected=$'Sub-features\nHow to get to it (user POV)\nDriving it with\nGotchas'
  count=0
  for f in "$map"/*.md; do
    [[ "$f" == "$index" ]] && continue
    count=$((count + 1))
    rel="features/$(basename "$f")"
    grep -q '^# ' "$f" || fail "$rel has no H1 title"
    h2s=$(grep '^## ' "$f" | sed -e 's/^## //' -e 's/^Driving it with .*/Driving it with/')
    [[ "$h2s" == "$expected" ]] ||
      fail "$rel H2s aren't: Sub-features, How to get to it (user POV), Driving it with <harness>, Gotchas"
    journeys=$(awk '/^## Driving it with/ { on = 1; next } /^## / { on = 0 } on' "$f" |
      grep -oE 'journeys/[A-Za-z0-9_./-]+' | sed 's/[.]$//' | sort -u)
    if [[ -z "$journeys" ]]; then
      fail "$rel names no journeys/ script in its Driving section"
    fi
    for j in $journeys; do
      [[ -f "$dir/$j" ]] || fail "$rel names $j, which doesn't exist"
    done
    grep -qE "\]\((\./)?$(basename "$f")\)" "$index" || fail "features/README.md doesn't link $rel"
  done
  [[ $count -gt 0 ]] || fail "no feature files besides features/README.md"
  [[ $count -gt 0 && $count -lt 3 ]] && warn "only $count feature file(s); aim for the top 3–5"
  while IFS= read -r link; do
    [[ -f "$map/$link" ]] || fail "features/README.md links $link, which doesn't exist"
  done < <(grep -oE '\]\([^)#]+\.md\)' "$index" | sed -E 's/^\]\((\.\/)?//; s/\)$//')
  ok "feature map checked: $count feature file(s)"
fi

# Placeholders.
if grep -rnE '\b(TODO|TBD|FIXME)\b' --include='*.md' "$dir" >/dev/null; then
  fail "placeholders left: $(grep -rlE '\b(TODO|TBD|FIXME)\b' --include='*.md' "$dir" | sed "s|$dir/||" | tr '\n' ' ')"
fi

# Harness symlinks.
mark=$fails
if root=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null); then
  found=0
  for skills in .claude/skills .cursor/skills; do
    link="$root/$skills/$name"
    [[ -e "$link" || -L "$link" ]] || continue
    found=1
    if [[ "$(cd "$link" 2>/dev/null && pwd -P)" == "$dir" ]]; then
      ok "$skills/$name resolves to the skill"
    else
      fail "$skills/$name doesn't resolve to $dir"
    fi
  done
  [[ $found -eq 1 ]] || warn "no .claude/skills/$name symlink; add one for each harness in use that doesn't read .agents/skills"
fi

if [[ $fails -gt 0 ]]; then
  echo "$fails check(s) failed"
  exit 1
fi
echo "all checks passed"
