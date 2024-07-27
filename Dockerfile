FROM akorn/luarocks:lua5.4-alpine

RUN apk add git
RUN apk add gcc
RUN apk add libc-dev
RUN apk add openssl-dev
RUN luarocks install telegram-bot-lua
RUN luarocks install lua-openai


COPY . .

CMD lua main.lua


