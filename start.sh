#!/bin/bash
# Exit immediately if any command fails so a broken setup doesn't silently boot a half-configured container.
set -e

# Install the reachie profile from GitHub; --yes auto-accepts any prompts.
hermes profile install https://github.com/JHJHJHJH/reachie.git --yes

# Hermes stores profiles under $HERMES_HOME/profiles (set in the container image); fall back to ~/.hermes for local dev.
PROFILE_DIR="${HERMES_HOME:-$HOME/.hermes}/profiles/reachie"
# The profile's runtime .env file that hermes will read.
ENV_FILE="$PROFILE_DIR/.env"
# The example file shipped with the profile; we use its keys as the list of variables to populate.
EXAMPLE_FILE="$PROFILE_DIR/.env.EXAMPLE"

# Truncate (or create) the target .env file so we start from a clean slate.
: > "$ENV_FILE"
# Read EXAMPLE_FILE line by line, splitting on '=' into key and the rest (discarded).
while IFS='=' read -r key _; do
  # Skip blank lines and comment lines (those starting with '#').
  [[ -z "$key" || "$key" == \#* ]] && continue
  # Write "KEY=<value from container env>"; ${!key-} indirectly expands the variable named by $key, empty if unset.
  printf '%s=%s\n' "$key" "${!key-}" >> "$ENV_FILE"
done < "$EXAMPLE_FILE"

# Start the hermes gateway in the background so it runs alongside the dashboard.
hermes -p reachie gateway run &
# Replace the shell with the dashboard process; binds to all interfaces on $PORT (default 9119) for Railway/Docker.
exec hermes -p reachie dashboard --insecure --host 0.0.0.0 --port "${PORT:-9119}"
