cpu := arch()

os := os()

home_dir := env_var('HOME')

set dotenv-load := true

set ignore-comments := true

set shell := ["zsh", "-cu"]

set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

foo := / "lib"
# runs all lints and tests.
default: lint test

test:
    @echo running tests
    dart test

# run dart analysis and format all files.
lint:
    @echo running dart analysis
    dart analyze
    @echo formatting files
    dart format .

publish: lint test
    dart pub publish