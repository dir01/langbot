# LangBot
A quick and simple Telegram bot that uses OpenAI API to teach you languages.
It's written in Lua because I wanted to write something in Lua. 

## Local Development
```
docker build . -t langbot; docker run -e TELEGRAM_BOT_TOKEN=$(cat ./tg-bot-token) -e OPENAI_TOKEN=$(cat ./openai-token) langbot
```
