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
  nh clean all --keep-since 10d --keep 20
