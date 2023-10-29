FROM python:3.10.13-slim-bookworm
ENV PYTHONUNBUFFERED=1

WORKDIR /src

RUN apt-get update

RUN pip install poetry

COPY ../../. ./

RUN poetry config virtualenvs.in-project true
RUN poetry install --no-root --no-dev

EXPOSE 8000

# uvicornのサーバーを立ち上げる
CMD ["poetry", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--reload"]