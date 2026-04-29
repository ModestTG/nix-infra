set quiet

default:
  @just --list

rebuild-pre:
  git add .

apply $HOST="": rebuild-pre
  if [ -n "{{HOST}}" ]; then \
    colmena apply --on {{HOST}}; \
  else \
    colmena apply; \
  fi
build $HOST="": rebuild-pre
  if [ -n "{{HOST}}" ]; then \
    colmena build --on {{HOST}}; \
  else \
    colmena build; \
  fi
check: rebuild-pre
  nix flake check --no-build

rbs $HOST="": rebuild-pre
  nh os switch -H "${HOST:-$(hostname)}" .

rbt $HOST="": rebuild-pre
  nh os test -H "${HOST:-$(hostname)}" .

rbd $HOST="": rebuild-pre
  nh os test -n -H "${HOST:-$(hostname)}" .
  
clean:
  nh clean all --keep-since 10d --keep 5

update:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Updating flake inputs..."
  nix flake update

  # --- spotiflac ---
  echo "Checking latest SpotiFLAC release..."
  SPOTIFLAC_TAG=$(curl -fsSL "https://api.github.com/repos/afkarxyz/SpotiFLAC/releases/latest" | jq -r '.tag_name')
  SPOTIFLAC_URL="https://github.com/afkarxyz/SpotiFLAC/releases/download/${SPOTIFLAC_TAG}/SpotiFLAC.AppImage"
  echo "Fetching hash for SpotiFLAC ${SPOTIFLAC_TAG}..."
  SPOTIFLAC_HASH=$(nix-prefetch-url "${SPOTIFLAC_URL}" 2>/dev/null)
  sed -i "s|version = \"v[^\"]*\";|version = \"${SPOTIFLAC_TAG}\";|" modules/pkgs/spotiflac.nix
  sed -i "s|sha256 = \"[^\"]*\";|sha256 = \"${SPOTIFLAC_HASH}\";|" modules/pkgs/spotiflac.nix
  echo "SpotiFLAC → ${SPOTIFLAC_TAG}"

  # --- helium-browser ---
  echo "Checking latest Helium Browser release..."
  HELIUM_TAG=$(curl -fsSL "https://api.github.com/repos/imputnet/helium-linux/releases/latest" | jq -r '.tag_name')
  HELIUM_VER="${HELIUM_TAG#v}"
  HELIUM_URL="https://github.com/imputnet/helium-linux/releases/download/${HELIUM_TAG}/helium-${HELIUM_VER}-x86_64.AppImage"
  echo "Fetching hash for Helium Browser ${HELIUM_VER}..."
  HELIUM_HASH=$(nix-prefetch-url "${HELIUM_URL}" 2>/dev/null)
  sed -i "s|version = \"[0-9][^\"]*\";|version = \"${HELIUM_VER}\";|" modules/pkgs/helium-browser.nix
  sed -i "s|sha256 = \"[^\"]*\";|sha256 = \"${HELIUM_HASH}\";|" modules/pkgs/helium-browser.nix
  echo "Helium Browser → ${HELIUM_VER}"

  echo "Done. Run 'git diff' to review changes."
