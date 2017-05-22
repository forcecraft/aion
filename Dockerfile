FROM elixir:1.4.2

WORKDIR /aion
ADD aion /aion
ADD fixtures /fixtures
ADD scripts /scripts

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

# Install python pip and dependencies
RUN apt-get -y install python3-pip \
    && pip3 install -r /fixtures/requirements.txt
