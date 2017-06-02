#!/bin/sh
{%- for key, value in config.get('env', {}).items() %}
export {{ key }}="{{ value }}"
{%- endfor %}
export JAVA_HOME={{ config.java_home }}
export BITBUCKET_HOME={{ config.dirs.home }}
