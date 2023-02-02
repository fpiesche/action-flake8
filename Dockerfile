ARG PYTHON_VERSION="3.7"
FROM python:${PYTHON_VERSION}

ARG REVIEWDOG_VERSION=v0.14.1
ARG FLAKE8_EXTENSIONS=""

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /tmp "${REVIEWDOG_VERSION}" \
    && python -m pip install --upgrade flake8 ${FLAKE8_EXTENSIONS}

ENV FLAKE8_ARGS="" \
    REVIEWDOG_FLAGS="" \
    LEVEL="error" 

WORKDIR /workspace

CMD flake8 . ${FLAKE8_ARGS} 2>&1 | \
    /tmp/reviewdog -f=flake8 \
      -level="${LEVEL}" \
      -name="flake8" \
      -reporter="local" \
      -filter-mode="nofilter" \
      ${REVIEWDOG_FLAGS}
