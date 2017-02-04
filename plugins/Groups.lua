local function chat_list(msg)
    local data = load_data(_config.moderation.data)
        local groups = 'groups'
        if not data[tostring(groups)] then
                return '<b>No groups at the moment</b>'
        end
        local message = '<b>List of your bot Groups:</b>\n\n> '
        for k,v in pairs(data[tostring(groups)]) do
                local settings = data[tostring(v)]['settings']
                for m,n in pairsByKeys(settings) do
                        if m == 'set_name' then
                                name = n
                        end
                end

                message = message .. '️ '.. name .. ' (ID: ' .. v .. ')\n\n '
        end
        local file = io.open("./system/chats/lists/listed_groups.txt", "w")
        file:write(message)
        file:flush()
        file:close()
        return message
end
local function run(msg, matches)
  if msg.to.type ~= 'chat' or is_sudo(msg) and is_realm(msg) then
	 local data = load_data(_config.moderation.data)
  if is_sudo(msg) or is_vip(msg) then
    if matches[1] == 'link' and data[tostring(matches[2])] then
        if is_banned(msg.from.id, matches[2]) then
	    return '<b>You are in ban</b>'
	 end
      if is_gbanned(msg.from.id) then
            return '<b>You are in Globalban or Superban</b>'
      end
      if data[tostring(matches[2])]['settings']['lock_member'] == 'yes' and not is_owner2(msg.from.id, matches[2]) then
        return '<b>Group is private.</b>'
      end
          local chat_id = "chat#id"..matches[2]
          local user_id = "user#id"..msg.from.id
   	  chat_add_user(chat_id, user_id, ok_cb, false)   
	  local group_link = data[tostring(matches[2])]['settings']['set_link']
      local group_name = data[tostring(matches[2])]['settings']['set_name']
	  return "<b>Group Link is:</b>\n>"..group_link.."\n\n (<b>Group name:</b>"..group_name..")\n>"
	  
    elseif matches[1] == 'link' and not data[tostring(matches[2])] then

         	return "<b>Group not found</b>"
         end
    end
  end

     if matches[1] == 'groups' or matches[1] == 'chats' then
      if is_sudo(msg) and msg.to.type == 'chat' then
         return chat_list(msg)
       elseif msg.to.type ~= 'chat' then
         return chat_list(msg)
      end
 end
 
 if matches[1] == 'help' and msg.to.type == 'user' then
		text = "<b>Welcome to my bot!</b>\n\n<b>To get a list of bot groups use /chats or /groups for list of chats.</b>\n\n>"
     	return text
end

 end
return {
    description = "<b>See link of a group and groups list</b>",
    usage = "!link ID && !groups",
    advan = {
	    "Created by: @janlou",
		  "edit by: @Wow_heh",
    	"CopyRight all right reserved",
    },
patterns = {
	"^[!#/]([Ll]ink) (.*)$",
  "^(link) (.*)$",
	"^[!#/]([Gg]roups)$",
	"^(groups)$",
	"^[!#/]([Cc]hats)$",
	"^(chats)$",
	"^[!#/]([Hh]elp)$",
	"^(help)$",
	},
run = run
}
