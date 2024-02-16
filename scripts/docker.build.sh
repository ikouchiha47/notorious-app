#!/bin/sh

set -eE -o functrace
#
# Build and Upload image to ecr
#
APP_NAME=notorious
AWS_PROFILE="${AWS_PROFILE:-default}"
AWS_REGION="${AWS_REGION:-ap-south-1}"
DOCKER_FILE="${DOCKERFILE:Dockerfile}"

ECR_URL="${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com"

VERSION=$(git rev-parse --short=8 HEAD)
DOCKER_BUILD_TAG="${APP_NAME}:${VERSION}"


function assert_or_panic() {
  local variable_name="$1"

  if [[ -z "${!variable_name}" ]]; then
    echo "$variable_name missing in env"
    exit 1
  fi
}

function failure() {
  local lineno=$1
  local msg=$2
  echo "Failed at $lineno: $msg"
}

trap 'failure ${LINENO} "$BASH_COMMAND"' ERR

function check_ecr_exists() {
  _=$(aws ecr describe-repositories --repository-name "${APP_NAME}" --profile "${AWS_PROFILE}" --region "${AWS_REGION}")
  echo $?
}

function create_ecr_repo() {
  _=$(aws ecr create-repository --repository-name "${APP_NAME}" --region "${AWS_REGION}" --profile "${AWS_PROFILE}")
}

function get_account_id() {
  val=$(aws sts get-caller-identity --profile default --region "${AWS_REGION}" --query "Account"  --output text)
  echo "$val"
}


function docker_build_image() {
  echo "Building docker image with tag $DOCKER_BUILD_TAG"
  docker build --platform linux/amd64 -f "${DOCKER_FILE}" --build-arg RAILS_MASTER_KEY=${RAILS_MASTER_KEY} -t "${DOCKER_BUILD_TAG}" .
}

function docker_push_ecr() {
  echo "tagging ${DOCKER_BUILD_TAG} to ecr uri"
  docker tag "${DOCKER_BUILD_TAG}" "${ECR_URL}/${DOCKER_BUILD_TAG}"

  echo "pushing to ecr"
  aws ecr get-login-password --region "${AWS_REGION}" --profile "${AWS_PROFILE}" | docker login --username AWS --password-stdin "${ECR_URL}"
  docker push "${ECR_URL}/${DOCKER_BUILD_TAG}"
}


function publish() {
  if [[ $(check_ecr_exists) -ne 0 ]]; then
    echo "ecr repo: ${APP_NAME} doesn't exists"
    echo "creating..."

    create_ecr_repo
  fi

  docker_push_ecr
}

cmd="$1"

echo "invokiing $cmd"

case "$cmd" in
  "get:aws:id")
    get_account_id
    ;;
    
  "publish")
    assert_or_panic "AWS_ACCOUNT"

    publish
    ;;

  "build")
    assert_or_panic "RAILS_MASTER_KEY"
    assert_or_panic "AWS_ACCOUNT"
    
    docker_build_image
    ;;

  *)
    echo "invalid command invoked"
    exit 1
    ;;
esac

exit $?

