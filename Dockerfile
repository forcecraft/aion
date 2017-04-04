FROM elixir:1.4.2

WORKDIR /aion
ADD aion /aion

# Install nodeJS
RUN apt-get update \
    && apt-get -y install curl \
    && curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs

# Install dependencies
RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && npm install

WORKDIR /fixtures
ADD fixtures /fixtures

# Install python pip and dependencies
RUN apt-get -y install python3-pip \
    && pip3 install -r requirements.txt

# Load fixtures
RUN python3 main.py
