# React app with dynamic Nginx environment variables

This repo has basic react app generated with [create react app](https://github.com/facebook/create-react-app) and docker file for building and packaging react app for nginx image where dynamic environment variables are supported

## Features

* Uses basically same model for environment variables as [create react app](https://github.com/facebook/create-react-app) but uses `environmentVariable` function for dynamically setting either template env variable or variable directly based on node env
* Multi stage docker file for building and packaging react app into nginx container
* Nginx image with custom `endpoint.sh` that replaces all env variables for react app and nginx config

## How to test

Repo has docker compose with two services with same react app

* `development` webpack dev server based dev service in port 3000
* `production` nginx based production service in port 80

To start services run:

```
docker-compose up --build
```
