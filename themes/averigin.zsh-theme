function git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function get_pwd() {
    print ${PWD/$HOME/~}
}

function svn_prompt_info() {
    if [ $(in_svn) ]; then
        echo "$(svn_dirty)$ZSH_THEME_SVN_PROMPT_PREFIX$(svn_get_branch_name)@$(svn_get_rev_nr)$ZSH_THEME_SVN_PROMPT_SUFFIX"
    fi
}

function battery_charge() {
    if [ -e ~/bin/batcharge.py ]
    then
        echo `python ~/bin/batcharge.py`
    else
        echo ''
    fi
}

function put_spacing() {
    local git=$(git_prompt_info)
    if [ ${#git} != 0 ]; then
        ((git=${#git} - 10))
    else
        git=0
    fi

    local svn=$(svn_prompt_info)
    if [ ${#svn} != 0 ]; then
        ((svn=${#svn} - 10))
    else
        svn=0
    fi

    local bat=$(battery_charge)
    if [ ${#bat} != 0 ]; then
        ((bat = ${#bat} - 18))
    else
        bat=0
    fi

    local termwidth
    (( termwidth = ${COLUMNS} - 3 - ${#HOST} - ${#$(get_pwd)} - ${bat} - ${git} - ${svn} ))

    local spacing=""
    for i in {1..$termwidth}; do
        spacing="${spacing} "
    done
    echo $spacing
}

function precmd() {
    print -rP '
$fg[cyan]%m: $fg[yellow]$(get_pwd)$(put_spacing)$(git_prompt_info)$(svn_prompt_info) $(battery_charge)'
}

PROMPT='%{$reset_color%}→ '

ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]+"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"

ZSH_THEME_SVN_PROMPT_PREFIX="[svn:"
ZSH_THEME_SVN_PROMPT_SUFFIX="]$reset_color"
ZSH_THEME_SVN_PROMPT_DIRTY="$fg[red]+"
ZSH_THEME_SVN_PROMPT_CLEAN="$fg[green]"