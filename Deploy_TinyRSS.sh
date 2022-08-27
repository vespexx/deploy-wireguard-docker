#!/bin/sh

git clone https://git.tt-rss.org/fox/ttrss-docker-compose.git ttrss-docker
cd ttrss-docker
git checkout static-dockerhub

cp .env-dist .env
