alias rr="bundle exec rails runner"
iterm-badge
bundle_login() {
    BUNDLE_RUBYGEMS__PKG__GITHUB__COM="$(gh api /user --jq .login):$(gh auth token)"
    export BUNDLE_RUBYGEMS__PKG__GITHUB__COM
}
