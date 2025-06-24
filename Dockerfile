FROM python:3.13.3-slim-bookworm

ENV PYTHONUNBUFFERED=1
RUN apt-get update && apt-get upgrade -y

COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

ENV UV_COMPILE_BYTECODE=1
ENV UV_PYTHON_DOWNLOADS=never

RUN useradd --create-home app-user
USER app-user
ADD --chown=app-user:app-user ./ /home/app-user/app/
WORKDIR /home/app-user/app/
RUN uv sync

ENTRYPOINT ["uv", "run", "kvo-dates-mcp"]

CMD ["--mcp-port", "8000", "--mcp-transport", "sse"]
