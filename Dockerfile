FROM ubuntu:latest

RUN apt update

RUN apt install iputils-ping -y

CMD ["ping", "google.com"]