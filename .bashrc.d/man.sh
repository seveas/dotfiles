# Colorized manpages (ab)using termcap
man() {
    LESS_TERMCAP_mb=$'\e'"[34m" \
    LESS_TERMCAP_md=$'\e'"[32m" \
    LESS_TERMCAP_us=$'\e'"[31m" \
    LESS_TERMCAP_so=$'\e'"[37;2;7m" \
    LESS_TERMCAP_me=$'\e'"[0m" \
    LESS_TERMCAP_se=$'\e'"[0m" \
    LESS_TERMCAP_ue=$'\e'"[0m" \
    command man "$@"
}
