FROM python:3.7

ENV PYTHONBUFFERED

WORKDIR /app

ADD . /app

RUN pip install -r requirements.txt
