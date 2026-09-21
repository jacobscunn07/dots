# ask-claude.sh -- quick one-shot questions for Claude from the shell.
#
#   ??  <question>   Haiku. Fast reflex lookups.
#   ??? <question>   Sonnet at high effort. For when the first answer was thin.
#
# Both are fixed. Nothing here reads the environment. If you want a different
# model or effort level, that's a real session: run `claude` and pick one.
#
# .zshrc sources this via $ZDOTDIR. It lives in the zsh package because this repo
# is a zsh setup, but nothing in it is zsh-specific, so other shells can source it
# by full path:
#   ~/.bashrc   :  [ -f ~/.config/zsh/ask-claude.sh ] && . ~/.config/zsh/ask-claude.sh
#   ~/.profile  :  [ -f ~/.config/zsh/ask-claude.sh ] && . ~/.config/zsh/ask-claude.sh
#
# POSIX sh throughout: works in zsh, bash, dash and ash. Questions containing ?
# or * are safe in all of them -- see the two alias branches at the bottom.

_ask_claude_prompt='Answer concisely in plain text for a terminal. No markdown formatting.'

# POSIX shells have no noglob, so the non-zsh aliases run this first. Globbing is
# then already off when the shell expands the question, and the entry points below
# restore it before doing anything else.
_ask_claude_glob_off() {
    case $- in
        *f*) _ask_claude_glob_was=off ;;  # caller set -f deliberately, leave it alone
        *)   _ask_claude_glob_was=on ;;
    esac
    set -f
}

# Called first thing by both entry points, ahead of the usage check, so globbing
# comes back even when the question was empty.
_ask_claude_glob_restore() {
    [ "${_ask_claude_glob_was-}" = on ] && set +f
    unset _ask_claude_glob_was
}

# Haiku has no effort levels, so no --effort flag here.
_ask_claude_fast() {
    _ask_claude_glob_restore
    [ "$#" -eq 0 ] && { printf 'usage: ?? <question>\n' >&2; return 2; }
    command -v claude >/dev/null 2>&1 || {
        printf '?? : claude not found in PATH\n' >&2
        return 127
    }
    command claude -p \
        --model haiku \
        --allowed-tools WebSearch \
        --append-system-prompt "$_ask_claude_prompt" \
        "$*"
}

_ask_claude_deep() {
    _ask_claude_glob_restore
    [ "$#" -eq 0 ] && { printf 'usage: ??? <question>\n' >&2; return 2; }
    command -v claude >/dev/null 2>&1 || {
        printf '??? : claude not found in PATH\n' >&2
        return 127
    }
    command claude -p \
        --model sonnet \
        --effort high \
        --allowed-tools WebSearch \
        --append-system-prompt "$_ask_claude_prompt" \
        "$*"
}

if [ -n "${ZSH_VERSION-}" ]; then
    # noglob keeps ? and * in the question from matching filenames. zsh expands the
    # command list too early for the set -f trick below to work, so it needs this.
    alias '??'='noglob _ask_claude_fast'
    alias '???'='noglob _ask_claude_deep'

else
    # bash, dash, ash and friends: set -f is the portable stand-in for noglob. It
    # runs as a separate command, so it takes effect before the shell expands the
    # question that follows.
    alias '??'='_ask_claude_glob_off; _ask_claude_fast'
    alias '???'='_ask_claude_glob_off; _ask_claude_deep'
fi
