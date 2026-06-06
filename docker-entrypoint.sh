#!/usr/bin/env bash
# Container entrypoint: bootstrap the user-state files from config.py, then
# hand off to the given command (default: the Flask web server).
#
# setup.py's generators are non-interactive (the interactive systemd/cron
# prompts live only in its main()), so we call them directly. profile.md is
# always regenerated from config; vacancies.md / analyses.json are created
# only if missing, preserving collected vacancies across restarts.
set -euo pipefail

python3 - <<'PY'
import setup

setup.generate_profile()
setup.generate_vacancies_md()
setup.generate_analyses_json()
PY

exec "$@"
