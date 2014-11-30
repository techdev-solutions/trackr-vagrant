#!/bin/bash

export JAVA_OPTS="$JAVA_OPTS -XshowSettings"

export CATALINA_OPTS="$CATALINA_OPTS -Dspring.profiles.active=dev"
