#!/bin/bash

# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Generates updated api-reference docs from the latest swagger spec.
# Usage: ./update-api-reference-docs.sh <absolute output path>

set -o errexit
set -o nounset
set -o pipefail

echo "Note: This assumes that swagger spec has been updated. Please run hack/update-swagger-spec.sh to ensure that."

KUBE_ROOT=$(dirname "${BASH_SOURCE}")/..
source "${KUBE_ROOT}/hack/lib/init.sh"
source "${KUBE_ROOT}/hack/lib/swagger.sh"
kube::golang::setup_env

REPO_DIR=${REPO_DIR:-"${KUBE_ROOT}"}
DEFAULT_OUTPUT="${REPO_DIR}/docs/api-reference"
OUTPUT=${1:-${DEFAULT_OUTPUT}}

SWAGGER_SPEC_PATH="${REPO_DIR}/api/swagger-spec"

GROUP_VERSIONS=("v1" "extensions/v1beta1" "batch/v1" "authentication.k8s.io/v1beta1" "autoscaling/v1" "certificates.k8s.io/v1alpha1")
GV_DIRS=()
for gv in "${GROUP_VERSIONS[@]}"; do
  GV_DIRS+=("${REPO_DIR}/pkg/$(kube::util::group-version-to-pkg-path "${gv}")")
done

GROUP_VERSIONS="${GROUP_VERSIONS[@]}" GV_DIRS="${GV_DIRS[@]}" kube::swagger::gen_api_ref_docs "${SWAGGER_SPEC_PATH}" "${OUTPUT}"

# ex: ts=2 sw=2 et filetype=sh
