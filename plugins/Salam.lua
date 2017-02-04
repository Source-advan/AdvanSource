do

function run(msg, matches)
local reply_id = msg['id']
local text = '<i>Hello</i>🌺'
if matches[1] == 'salam' or 'hi' or 'hello 'or 'سلوم'or 'سعلام'or 'سیلام'or 'س'or 's'or 'سلام' then
    if is_momod(msg) then
reply_msg(reply_id, text, ok_cb, false)
end
end 
end
return {
patterns = {
    "^salam$",
    "^hi$",
	  "^hello$",
	  "^سلوم$",
	 "^سعلام$",
	 "^سیلام$",
	 "^س$",
	 "^s$",
    "^سلام$"
},
run = run
}

end


