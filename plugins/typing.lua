--Typing.lua By @SoLiD021
function solid(msg, matches)
local receiver = get_receiver(msg)
local hash = 'typing:'..receiver
     if matches[1] == 'typing' and is_sudo(msg) then
--Enable Typing
     if matches[2] == 'on' then
    redis:del(hash)
   return 'Typing has been enabled'
--Disable Typing
     elseif matches[2] == 'off' then
    redis:set(hash, true)
   return 'Typing has been disabled'
--Typing Status
      elseif matches[2] == 'status' then
      if not redis:get(hash) then
   return 'Typing is enable'
       else
   return 'Typing is disable'
         end
      end
   end
      if not redis:get(hash) then
send_typing(get_receiver(msg), ok_cb, false)
   end
end
return { 
patterns = {
"^[!/#](typing) (.*)$",
"(.*)",
},
run = solid
}
--By @SoLiD021
