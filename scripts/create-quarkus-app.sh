#!/usr/bin/env bash
set -e

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR=$(mktemp -d -t cqa-XXXXXXXXXX)
echo $SCRIPTS_DIR

ADDED_DIR="${SCRIPTS_DIR}"/added
LAUNCH_DIR="${SCRIPTS_DIR}"/launch
BUILD_DIR="${SCRIPTS_DIR}"/build

export KOGITO_HOME=$SCRIPTS_DIR
export JBOSS_CONTAINER_JAVA_JVM_MODULE=$LAUNCH_DIR
export MAVEN_SETTINGS_PATH="${LAUNCH_DIR}/.m2/settings.xml"

mkdir $ADDED_DIR
mkdir -p $LAUNCH_DIR/.m2/
mkdir $BUILD_DIR


cp -rf $CURRENT_DIR/../modules/kogito-swf/common/build/added/* $BUILD_DIR
cp -rf $CURRENT_DIR/../modules/kogito-swf/common/scripts/added/* $LAUNCH_DIR
cp -rf $CURRENT_DIR/../modules/kogito-logging/added/* $LAUNCH_DIR
cp -rf $CURRENT_DIR/../modules/kogito-dynamic-resources/added/* $LAUNCH_DIR
cp -rf $CURRENT_DIR/../modules/kogito-maven/3.8.x/maven/* $LAUNCH_DIR/.m2/
cp -rf $CURRENT_DIR/../modules/kogito-maven/3.8.x/added/* $LAUNCH_DIR

chmod +x -R $ADDED_DIR
chmod +x -R $LAUNCH_DIR
chmod +x -R $BUILD_DIR

# Create app
"${LAUNCH_DIR}"/create-app.sh

"${BUILD_DIR}"/cleanup_project.sh
"${BUILD_DIR}"/zip_files.sh

rm -rf $SCRIPTS_DIR

