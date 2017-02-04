do function run(msg, matches)

   if matches[1]:lower() == 'ping' then
	  local text = "آنلاینم\n> <i>"..msg.from.first_name.."</i>"
      return reply_msg(msg.id, text, ok_cb, false)
    end
end
  return {
  description = "",
  usage = "",
  patterns = {
  "^([Pp]ing)$",
  "^[/!#]([Pp]ing)$"
    },
  run = run
}
end
