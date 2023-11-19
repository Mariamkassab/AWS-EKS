FROM python:3.8-alpine

RUN mkdir /app

ADD ./app /app

WORKDIR /app

RUN pip install -r ./app/requirements.txt

CMD ["python", "hello.py"]

# flask on port 5000
