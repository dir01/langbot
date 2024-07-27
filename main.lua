local function mustGetEnv(name)
	local val = os.getenv(name)
	if not val then
		print(name .. " env var is required")
		os.exit(1)
	end
	return val
end

local BOT_TOKEN = mustGetEnv("TELEGRAM_BOT_TOKEN")
local OPENAI_TOKEN = mustGetEnv("OPENAI_TOKEN")
local LANGUAGE = mustGetEnv("LANGUAGE")

-- https://github.com/wrxck/telegram-bot-lua
local tg = require("telegram-bot-lua.core").configure(BOT_TOKEN)

-- https://github.com/leafo/lua-openai
local openai = require("openai").new(OPENAI_TOKEN)

-- openai chat sessions contain all the history and context so they should be treated per-user
local CHATS = {}

local SYSTEM_PROMPT = string.gsub(
	[[
You are a tutor for {language} language. 

Whenever people send you something looking like {language} text 
(transliterated or not), you just provide translation. 

Whenever people ask you some {language}-related questions, you answer them as well as you can. 

Any non-language related questions you interpret as requests for translation and translate.

All non-{language} text you interpret as instructions. 

Whenever replying in {language}, always provide transliteration for all {language} text. 

Whenever benefitial, provide some alternative word forms and same-root words.
]],
	"{language}",
	LANGUAGE
)

print("SYSTEM_PROMPT:\n" .. SYSTEM_PROMPT)

function tg.on_message(message)
	if not message.text then
		return
	end

	local chat = CHATS[message.chat.id]
	if not chat then
		local c = openai:new_chat_session({
			messages = {
				{ role = "system", content = SYSTEM_PROMPT },
			},
			model = "gpt-4o",
		})
		CHATS[message.chat.id] = c
	end
	chat = CHATS[message.chat.id]

	response = chat:send(message.text)

	tg.send_message(message.chat.id, response)
end

tg.run()
