# syntax=docker/dockerfile:1.4
FROM python:3.10-alpine AS builder

WORKDIR /code

COPY requirements/prod.txt /code
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r prod.txt

EXPOSE 8000

COPY . /code

ENTRYPOINT ["python3"]
CMD ["./src/app.py"]

FROM builder as dev-envs

RUN apk update 
RUN apk add git bash

RUN addgroup -S docker
RUN adduser -S --shell /bin/bash --ingroup docker vscode
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /