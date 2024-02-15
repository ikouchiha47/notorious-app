#!/bin/bash
#
# run rails migration in remote
#
AWS_ACCOUNT="${AWS_ACCOUNT:-}"
AWS_REGION="${AWS_REGION:-ap-south-1}"
VERSION="${VERSION:-}"

# put this in a common file and source it
function assert_or_panic() {
  local variable_name="$1"

  if [[ -z "${!variable_name}" ]]; then
    echo "$variable_name missing in env"
    exit 1
  fi
}

assert_or_panic "AWS_ACCOUNT"
assert_or_panic "VERSION"

DOCKER_BUILD_TAG="notorious:${VERSION}"

docker exec -it "${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${DOCKER_BUILD_TAG}" bundle exec rails "$@"

