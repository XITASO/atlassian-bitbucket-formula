#!/bin/sh
{%- if config.get('catalina_opts') %}
export CATALINA_OPTS="{{ config.catalina_opts }} ${CATALINA_OPTS}"
{%- endif %}
export JAVA_HOME={{ config.java_home }}
export BITBUCKET_HOME={{ config.dirs.home }}
export CATALINA_PID={{ config.pid }}
