FROM aion:latest

WORKDIR /aion
ADD aion /aion

# Install dependencies
RUN mix deps.get \
    && npm install
