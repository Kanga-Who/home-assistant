#!/usr/bin/env bash

    if command -v docker > /dev/null 2>&1; then
        echo "Docker is installed "
      else
        echo "Docker is not present - installing now"
        curl -fsSL get.docker.com | sh
    fi
