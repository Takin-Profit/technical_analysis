#!/bin/bash
#
# Copyright (c) 2023.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.
#

# github.com/go-courier/husky
husky_url="https://github.com/go-courier/husky/releases/download/v1.8.1/husky_1.8.1_darwin_arm64.tar.gz"

ls_lint_url="https://github.com/loeffel-io/ls-lint/releases/download/v1.11.2/ls-lint-darwin"

just_url="https://just.systems/install.sh"

pub_cache=~/.pub-cache/bin
ls_lint=$pub_cache/ls-lint


curl --proto '=https' --tlsv1.2 -sSf $just_url | bash -s -- --to $pub_cache/

curl -sL -o $ls_lint $ls_lint_url && chmod +x $ls_lint


curl -L $husky_url -o $pub_cache/husky.tar.gz

# Extract the downloaded tar.gz file
tar -xzf $pub_cache/husky.tar.gz -C $pub_cache

# Remove the downloaded tar.gz file
rm $pub_cache/husky.tar.gz

rm $pub_cache/CHANGELOG.md

rm $pub_cache/LICENSE

rm $pub_cache/README.md

# Give execute permissions to extracted file(s)
chmod +x $pub_cache/husky
