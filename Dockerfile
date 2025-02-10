FROM python:3.9-slim

WORKDIR /app

ENV myname="ganesh"

RUN mkdir -p /app/temp

COPY . /app
RUN pip install -r require.txt

EXPOSE 5000

CMD ["python", "-u","app.py"]