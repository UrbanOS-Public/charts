GIT_ROOT=$(git rev-parse --show-toplevel)

ln -s $GIT_ROOT/scripts/pre-commit $GIT_ROOT/.git/hooks/pre-commit
