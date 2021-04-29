#!/bin/bash

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"

echo '::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog'
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b "${TEMP_PATH}" "${REVIEWDOG_VERSION}" 2>&1
echo '::endgroup::'


export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"


echo Scanning ${INPUT_RIECTORY}

find ${INPUT_RIECTORY} -type f  | sed 's_.*/__' | awk -F"__" '{print $1}' | sort | uniq -d |
while read fileName
do
  find $dirname -type f | grep "${fileName}" |
  while read fname
  do
    echo "${fname}:1:1: Duplicate filename for prefix ${fileName}" >> .dupe.out
  done
done

echo '::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog'
cat .dupe.out
echo '::endgroup::'

echo '::group:: Running dupe-files with reviewdog 🐶 ...'
# shellcheck disable=SC2086
cat .dupe.out | reviewdog -f=golangci-lint \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE:-added}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR:-false}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}

echo '::endgroup::'
