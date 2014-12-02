#!/bin/bash

export JAVA_OPTS="$JAVA_OPTS -XX:+UseG1GC"
export JAVA_OPTS="$JAVA_OPTS -XX:+UseStringDeduplication"

export CATALINA_OPTS="$CATALINA_OPTS -Dspring.profiles.active=dev"
