FROM python:3.7

ENV PYTHONBUFFERED

WORKDIR /app

ADD . /app

RUN pip install -r requirements.txt


COPY . /app/
EXPOSE 8000
CMD ["gunicorn", "myproject.wsgi:application", "--bind", "0.0.0.0:8000"]
