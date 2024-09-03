# syntax=docker/dockerfile:1.4
FROM python:3.10-alpine AS builder

WORKDIR /code

COPY requirements/prod.txt /code
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r prod.txt

COPY ./src /code

ENTRYPOINT ["python3"]
CMD ["./src/app.py"]

FROM builder as dev-envs

RUN <<EOF
apk update
apk add git bash
EOF

RUN <<EOF
addgroup -S docker
adduser -S --shell /bin/bash --ingroup docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /