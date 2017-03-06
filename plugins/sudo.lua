local function set_bot_photo(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local file = 'system/photos/bot.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    set_profile_photo(file, ok_cb, false)
    send_large_msg(receiver, 'Photo changed!', ok_cb, false)
    redis:del("bot:photo")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
-- data saved to moderation.json
-- check moderation plugin
do
	
local function parsed_url(link)
  local parsed_link = URL.parse(link)
  local parsed_path = URL.parse_path(parsed_link.path)
  return parsed_path[2]
end

local function create_group(msg)
     -- superuser and admins only (because sudo are always has privilege)
    if is_sudo(msg) or is_realm(msg) and is_admin1(msg) then
		local group_creator = msg.from.print_name
		create_group_chat (group_creator, group_name, ok_cb, false)
		return '<b>Group</b> [ '..string.gsub(group_name, '_', ' ')..' ] <b>has been created.</b>'
	end
end

local function create_realm(msg)
        -- superuser and admins only (because sudo are always has privilege)
	if is_sudo(msg) or is_realm(msg) and is_admin1(msg) then
		local group_creator = msg.from.print_name
		create_group_chat (group_creator, group_name, ok_cb, false)
		return '<b>Realm</b> [ '..string.gsub(group_name, '_', ' ')..' ] <b>has been created.</b>'
	end
end


local function killchat(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local chat_id = "chat#id"..result.peer_id
  local chatname = result.print_name
  for k,v in pairs(result.members) do
    kick_user_any(v.peer_id, result.peer_id)
  end
end

local function killrealm(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local chat_id = "chat#id"..result.peer_id
  local chatname = result.print_name
  for k,v in pairs(result.members) do
    kick_user_any(v.peer_id, result.peer_id)
  end
end

local function get_group_type(msg)
  local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
    if not data[tostring(msg.to.id)]['group_type'] then
		if msg.to.type == 'chat' and not is_realm(msg) then
			data[tostring(msg.to.id)]['group_type'] = 'Group'
			save_data(_config.moderation.data, data)
		elseif msg.to.type == 'channel' then
			data[tostring(msg.to.id)]['group_type'] = 'SuperGroup'
			save_data(_config.moderation.data, data)
		end
    end
		local group_type = data[tostring(msg.to.id)]['group_type']
		return group_type
	else
    return '<b>Chat type not found.</b>'
  end
end

local function callbackres(extra, success, result)
--vardump(result)
  local user = result.peer_id
  local name = string.gsub(result.print_name, "_", " ")
  local chat = 'chat#id'..extra.chatid
  local channel = 'channel#id'..extra.chatid
  send_large_msg(chat, user..'\n'..name)
  send_large_msg(channel, user..'\n'..name)
  return user
end

local function set_description(msg, data, target, about)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
    local data_cat = 'description'
        data[tostring(target)][data_cat] = about
        save_data(_config.moderation.data, data)
        return '<b>Set group description to:</b>\n'..about
end

local function set_rules(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
    local data_cat = 'rules'
        data[tostring(target)][data_cat] = rules
        save_data(_config.moderation.data, data)
        return '<b>Set group rules to:</b>\n'..rules
end
-- lock/unlock group name. bot automatically change group name when locked
local function lock_group_name(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
    local group_name_set = data[tostring(target)]['settings']['set_name']
    local group_name_lock = data[tostring(target)]['settings']['lock_name']
        if group_name_lock == 'yes' then
            return '<b>Group name is already locked</b>'
        else
            data[tostring(target)]['settings']['lock_name'] = 'yes'
                save_data(_config.moderation.data, data)
                rename_chat('chat#id'..target, group_name_set, ok_cb, false)
        return '<b>Group name has been locked</b>'
    end
end

local function unlock_group_name(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
    local group_name_set = data[tostring(target)]['settings']['set_name']
    local group_name_lock = data[tostring(target)]['settings']['lock_name']
        if group_name_lock == 'no' then
            return '<b>Group name is already unlocked</b>'
        else
            data[tostring(target)]['settings']['lock_name'] = 'no'
            save_data(_config.moderation.data, data)
        return '<b>Group name has been unlocked</b>'
    end
end
--lock/unlock group member. bot automatically kick new added user when locked
local function lock_group_member(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
    local group_member_lock = data[tostring(target)]['settings']['lock_member']
        if group_member_lock == 'yes' then
            return '<b>Group members are already locked</b>'
        else
            data[tostring(target)]['settings']['lock_member'] = 'yes'
            save_data(_config.moderation.data, data)
        end
        return '<b>Group members has been locked</b>'
end

local function unlock_group_member(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
    local group_member_lock = data[tostring(target)]['settings']['lock_member']
        if group_member_lock == 'no' then
            return '<b>Group members are not locked</b>'
        else
            data[tostring(target)]['settings']['lock_member'] = 'no'
            save_data(_config.moderation.data, data)
        return '<b>Group members has been unlocked</b>'
	end
end

--lock/unlock group photo. bot automatically keep group photo when locked
local function lock_group_photo(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
    local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
        if group_photo_lock == 'yes' then
            return '<b>Group photo is already locked</b>'
        else
            data[tostring(target)]['settings']['set_photo'] = 'waiting'
            save_data(_config.moderation.data, data)
        end
	return '<b>Please send me the group photo now</b>'
end

local function unlock_group_photo(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
    local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
        if group_photo_lock == 'no' then
            return '<b>Group photo is not locked</b>'
        else
            data[tostring(target)]['settings']['lock_photo'] = 'no'
            save_data(_config.moderation.data, data)
        return '<b>Group photo has been unlocked</b>'
	end
end

local function lock_group_flood(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
    local group_flood_lock = data[tostring(target)]['settings']['flood']
        if group_flood_lock == 'yes' then
            return '<b>Group flood is locked</b>'
        else
            data[tostring(target)]['settings']['flood'] = 'yes'
            save_data(_config.moderation.data, data)
        return '<b>Group flood has been locked</b>'
	end
end

local function unlock_group_flood(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
    local group_flood_lock = data[tostring(target)]['settings']['flood']
        if group_flood_lock == 'no' then
            return '<b>Group flood is not locked</b>'
        else
            data[tostring(target)]['settings']['flood'] = 'no'
            save_data(_config.moderation.data, data)
        return '<b>Group flood has been unlocked</b>'
	end
end

local function lock_group_arabic(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'yes' then
    return '<b>Arabic is already locked</b>'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Arabic has been locked</b>'
  end
end

local function unlock_group_arabic(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'no' then
    return '<b>Arabic/Persian is already unlocked</b>'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Arabic/Persian has been unlocked</b>'
  end
end

local function lock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'yes' then
    return '<b>RTL char. in names is already locked</b>'
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>RTL char. in names has been locked</b>'
  end
end

local function unlock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'no' then
    return '<b>RTL char. in names is already unlocked</b>'
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>RTL char. in names has been unlocked</b>'
  end
end

local function lock_group_links(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'yes' then
    return '<b>Link posting is already locked</b>'
  else
    data[tostring(target)]['settings']['lock_link'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Link posting has been locked</b>'
  end
end

local function unlock_group_links(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'no' then
    return '<b>Link posting is not locked</b>'
  else
    data[tostring(target)]['settings']['lock_link'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>Link posting has been unlocked</b>'
  end
end

local function lock_group_spam(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'yes' then
    return '<b>SuperGroup spam is already locked</b>'
  else
    data[tostring(target)]['settings']['lock_spam'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>SuperGroup spam has been locked</b>'
  end
end

local function unlock_group_spam(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'no' then
    return '<b>SuperGroup spam is not locked</b>'
  else
    data[tostring(target)]['settings']['lock_spam'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>SuperGroup spam has been unlocked</b>'
  end
end

local function lock_group_rtl(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'yes' then
    return '<b>RTL char. in names is already locked</b>'
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>RTL char. in names has been locked</b>'
  end
end

local function unlock_group_rtl(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'no' then
    return '<b>RTL char. in names is already unlocked</b>'
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>RTL char. in names has been unlocked</b>'
  end
end

local function lock_group_sticker(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'yes' then
    return '<b>Sticker posting is already locked</b>'
  else
    data[tostring(target)]['settings']['lock_sticker'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Sticker posting has been locked</b>'
  end
end

local function unlock_group_sticker(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
	local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
	if group_sticker_lock == 'no' then
		return '<b>Sticker posting is already unlocked</b>'
	else
		data[tostring(target)]['settings']['lock_sticker'] = 'no'
		save_data(_config.moderation.data, data)
		return '<b>Sticker posting has been unlocked</b>'
	end
end

local function set_public_membermod(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
	local group_public_lock = data[tostring(target)]['settings']['public']
	if group_public_lock == 'yes' then
		return '<b>Group is already public</b>'
	else
		data[tostring(target)]['settings']['public'] = 'yes'
		save_data(_config.moderation.data, data)
	end
  return '</b>SuperGroup is now: public</b>'
end

local function unset_public_membermod(msg, data, target)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
	local group_public_lock = data[tostring(target)]['settings']['public']
	if group_public_lock == 'no' then
		return '<b>Group is not public</b>'
	else
		data[tostring(target)]['settings']['public'] = 'no'
		save_data(_config.moderation.data, data)
		return '<b>SuperGroup is now: not public</b>'
	end
end

-- show group settings
local function show_group_settings(msg, data, target)
    local data = load_data(_config.moderation.data, data)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['public'] then
			data[tostring(target)]['settings']['public'] = 'no'
		end
	end
    local settings = data[tostring(target)]['settings']
    local text = "<b>Group settings for "..target..":\nLock group name : "..settings.lock_name.."\nLock group photo : "..settings.lock_photo.."\nLock group member : "..settings.lock_member.."\nPublic:</b> "..settings.public
end

-- show SuperGroup settings
local function show_super_group_settings(msg, data, target)
    local data = load_data(_config.moderation.data, data)
    if not is_admin1(msg) then
        return "<b>For admins only!</b>"
    end
	if data[tostring(msg.to.id)]['settings'] then
		if not data[tostring(msg.to.id)]['settings']['public'] then
			data[tostring(msg.to.id)]['settings']['public'] = 'no'
		end
	end
		if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_rtl'] then
			data[tostring(target)]['settings']['lock_rtl'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_member'] then
			data[tostring(target)]['settings']['lock_member'] = 'no'
		end
	end
    local settings = data[tostring(target)]['settings']
    local text = "<b>SuperGroup settings for "..target..":\nLock links : "..settings.lock_link.."\nLock flood: "..settings.flood.."\nLock spam: "..settings.lock_spam.."\nLock Arabic: "..settings.lock_arabic.."\nLock Member: "..settings.lock_member.."\nLock RTL: "..settings.lock_rtl.."\nLock sticker: "..settings.lock_sticker.."\nPublic: "..settings.public.."\nStrict settings:</b> "..settings.strict
    return text
end

local function returnids(cb_extra, success, result)
	local i = 1
    local receiver = cb_extra.receiver
    local chat_id = "chat#id"..result.peer_id
    local chatname = result.print_name
    local text = '<b>Users in</b> '..string.gsub(chatname,"_"," ")..' (<b>ID:</b> '..result.peer_id..'):\n\n'
    for k,v in pairs(result.members) do
		if v.print_name then
			local username = ""
			text = text ..i..' - '.. string.gsub(v.print_name,"_"," ") .. "  [" .. v.peer_id .. "] \n\n"
		    i = i + 1
		end
    end
	local file = io.open("./system/chats/lists/"..result.peer_id.."memberlist.txt", "w")
	file:write(text)
	file:flush()
	file:close()
end

local function cb_user_info(cb_extra, success, result)
	local receiver = cb_extra.receiver
	if result.first_name then
		first_name = result.first_name:gsub("_", " ")
	else
		first_name = "None"
	end
	if result.last_name then
		last_name = result.last_name:gsub("_", " ")
	else
		last_name = "None"
	end
	if result.username then
		username = "@"..result.username
	else
		username = "@[none]"
	end
	text = "<b>User Info:</b>\n\n<b>ID:</b> "..result.peer_id.."\n<b>First:</b> "..first_name.."\n<b>Last:</b> "..last_name.."\n<b>Username:</b> "..username
	send_large_msg(receiver, text)
end

local function admin_promote(msg, admin_id)
	if not is_sudo(msg) then
        return "<b>Access denied!</b>"
    end
	local admins = 'admins'
	if not data[tostring(admins)] then
		data[tostring(admins)] = {}
		save_data(_config.moderation.data, data)
	end
	if data[tostring(admins)][tostring(admin_id)] then
		return admin_id..' <b>is already an admin.</b>'
	end
	data[tostring(admins)][tostring(admin_id)] = admin_id
	save_data(_config.moderation.data, data)
	return admin_id..' <b>has been promoted as admin.</b>'
end

local function admin_demote(msg, admin_id)
    if not is_sudo(msg) then
        return "<b>Access denied!</b>"
    end
    local data = load_data(_config.moderation.data)
        local admins = 'admins'
	if not data[tostring(admins)] then
		data[tostring(admins)] = {}
		save_data(_config.moderation.data, data)
	end
	if not data[tostring(admins)][tostring(admin_id)] then
		return admin_id..' <b>is not an admin.</b>'
	end
	data[tostring(admins)][tostring(admin_id)] = nil
	save_data(_config.moderation.data, data)
	return admin_id..' <b>has been demoted from admin.</b>'
end

local function admin_list(msg)
    local data = load_data(_config.moderation.data)
	local admins = 'admins'
	if not data[tostring(admins)] then
		data[tostring(admins)] = {}
		save_data(_config.moderation.data, data)
	end
	local message = '<b>List of global admins:</b>\n '
	for k,v in pairs(data[tostring(admins)]) do
		message = message .. '- (at)' .. v .. ' [' .. k .. '] ' ..'\n'
	end
	return message
end

local function groups_list(msg)
	local data = load_data(_config.moderation.data)
	local groups = 'groups'
	if not data[tostring(groups)] then
		return '<b>No groups at the moment</b>'
	end
	local message = '<b>List of groups:</b>\n >'
	for k,v in pairs(data[tostring(groups)]) do
		if data[tostring(v)] then
			if data[tostring(v)]['settings'] then
			local settings = data[tostring(v)]['settings']
				for m,n in pairs(settings) do
					if m == 'set_name' then
						name = n
					end
				end
                local group_owner = "<b>No owner</b>"
                if data[tostring(v)]['set_owner'] then
                        group_owner = tostring(data[tostring(v)]['set_owner'])
                end
                local group_link = "<b>No link</b>"
                if data[tostring(v)]['settings']['set_link'] then
					group_link = data[tostring(v)]['settings']['set_link']
				end
				message = message .. '- '.. name .. ' (' .. v .. ') ['..group_owner..'] \n {'..group_link.."}\n"
			end
		end
	end
    local file = io.open("./system/chats/lists/groups.txt", "w")
	file:write(message)
	file:flush()
	file:close()
    return message
end
local function realms_list(msg)
    local data = load_data(_config.moderation.data)
	local realms = 'realms'
	if not data[tostring(realms)] then
		return '<b>No Realms at the moment</b>'
	end
	local message = '<b>List of Realms:</b>\n'
	for k,v in pairs(data[tostring(realms)]) do
		local settings = data[tostring(v)]['settings']
		for m,n in pairs(settings) do
			if m == 'set_name' then
				name = n
			end
		end
		local group_owner = "<b>No owner</b>"
		if data[tostring(v)]['admins_in'] then
			group_owner = tostring(data[tostring(v)]['admins_in'])
		end
		local group_link = "<b>No link</b>"
		if data[tostring(v)]['settings']['set_link'] then
			group_link = data[tostring(v)]['settings']['set_link']
		end
		message = message .. '- '.. name .. ' (' .. v .. ') ['..group_owner..'] \n {'..group_link.."}\n"
	end
	local file = io.open("./system/chats/lists/realms.txt", "w")
	file:write(message)
	file:flush()
	file:close()
    return message
end
local function admin_user_promote(receiver, member_username, member_id)
        local data = load_data(_config.moderation.data)
        if not data['admins'] then
                data['admins'] = {}
            save_data(_config.moderation.data, data)
        end
        if data['admins'][tostring(member_id)] then
            return send_large_msg(receiver, '@'..member_username..' <b>is already an admin.</b>')
        end
        data['admins'][tostring(member_id)] = member_username
        save_data(_config.moderation.data, data)
	return send_large_msg(receiver, '@'..member_username..' <b>has been promoted as admin.</b>')
end

local function admin_user_demote(receiver, member_username, member_id)
    local data = load_data(_config.moderation.data)
    if not data['admins'] then
		data['admins'] = {}
        save_data(_config.moderation.data, data)
	end
	if not data['admins'][tostring(member_id)] then
		send_large_msg(receiver, "@"..member_username..' <b>is not an admin.</b>')
		return
    end
	data['admins'][tostring(member_id)] = nil
	save_data(_config.moderation.data, data)
	send_large_msg(receiver, '<b>Admin</b> @'..member_username..' <b>has been demoted.</b>')
end

local function username_id(cb_extra, success, result)
   local mod_cmd = cb_extra.mod_cmd
   local receiver = cb_extra.receiver
   local member = cb_extra.member
   local text = '<b>No user</b> @'..member..' <b>in this group.</b>'
   for k,v in pairs(result.members) do
      vusername = v.username
      if vusername == member then
        member_username = member
        member_id = v.peer_id
        if mod_cmd == 'addadmin' then
            return admin_user_promote(receiver, member_username, member_id)
        elseif mod_cmd == 'removeadmin' then
            return admin_user_demote(receiver, member_username, member_id)
        end
      end
   end
   send_large_msg(receiver, text)
end

local function res_user_support(cb_extra, success, result)
   local receiver = cb_extra.receiver
   local get_cmd = cb_extra.get_cmd
   local support_id = result.peer_id
	if get_cmd == 'addsupport' then
		support_add(support_id)
		send_large_msg(receiver, "<b>User ["..support_id.."] has been added to the support team</b>")
	elseif get_cmd == 'removesupport' then
		support_remove(support_id)
		send_large_msg(receiver, "<b>User ["..support_id.."] has been removed from the support team</b>")
	end
end

local function set_log_group(target, data)
  if not is_admin1(msg) then
    return
  end
  local log_group = data[tostring(target)]['log_group']
  if log_group == 'yes' then
    return '<b>Log group is already set</b>'
  else
    data[tostring(target)]['log_group'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<b>Log group has been set</b>'
  end
end

local function unset_log_group(msg)
  if not is_admin1(msg) then
    return
  end
  local log_group = data[tostring(target)]['log_group']
  if log_group == 'no' then
    return '<b>Log group is not set</b>'
  else
    data[tostring(target)]['log_group'] = 'no'
    save_data(_config.moderation.data, data)
    return '<b>log group has been disabled</b>'
  end
end

function run(msg, matches)
	
	--Set bot photo:
	local receiver = get_receiver(msg)
    local group = msg.to.id
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
    if msg.media and is_admin1(msg) then
      	if msg.media.type == 'photo' and redis:get("bot:photo") then
      		if redis:get("bot:photo") == 'waiting' then
        		load_photo(msg.id, set_bot_photo, msg)
      		end
      	end
    end
    if matches[1] == "setbotphoto" then
    	redis:set("bot:photo", "waiting")
    	return '<b>Please send me bot photo now</b>'
end
	--Set bot photo.
	--Broadcast:
	if matches[1] == 'bc' then
		if is_admin1(msg) or is_vip(msg) then
		local response = matches[3]
		--send_large_msg("chat#id"..matches[2], response)
		send_large_msg("channel#id"..matches[2], response)
	end
	end
	if matches[1] == 'broadcast' then
		if is_sudo(msg) then -- Only sudo !
			local data = load_data(_config.moderation.data)
			local groups = 'groups'
			local response = matches[2]
			for k,v in pairs(data[tostring(groups)]) do
				chat_id =  v
				local chat = 'chat#id'..chat_id
				local channel = 'channel#id'..chat_id
				send_large_msg(chat, response)
				send_large_msg(channel, response)
			end
		end
   end
   --Broadcast.
   --Get plugin:
   if matches[1] == "get" then
    local file = matches[2]
    if is_sudo(msg) or is_vip(msg) then
      local receiver = get_receiver(msg)
      send_document(receiver, "./plugins/"..file..".lua", ok_cb, false)
    end
  end
   --Get plugin.
   --Pm:
   if matches[1] == "pm" then
   if is_sudo(msg) or is_vip(msg) then
    local text = "<b>Message From</b> "..(msg.from.username or msg.from.last_name).."\n\n<b>Message</b> : "..matches[3]
    send_large_msg("user#id"..matches[2],text)
    return "<b>Message has been sent</b>"
   end
   end
   --Pm.
   --Markread :
if matches[1] == "markread" then
    if is_sudo(msg) then
    	if matches[2] == "on" then
    		redis:set("bot:markread", "on")
    		return "<b>Mark read</b> > <i>on</i>"
    	end
    	if matches[2] == "off" then
    		redis:del("bot:markread")
    		return "<b>Mark read</b> > <i>off</i>"
    	end
    	return
    end
end
   --Markread.
	
   	local name_log = user_print_name(msg.from)
		if matches[1] == 'log' and is_owner(msg) then
		local receiver = get_receiver(msg)
		send_document(receiver,"./system/chats/logs/"..msg.to.id.."log.txt", ok_cb, false)
    end

	if matches[1] == 'who' and msg.to.type == 'chat' and is_momod(msg) then
		local name = user_print_name(msg.from)
		local receiver = get_receiver(msg)
		chat_info(receiver, returnids, {receiver=receiver})
		local file = io.open("./system/chats/lists/"..msg.to.id.."memberlist.txt", "r")
		text = file:read("*a")
        send_large_msg(receiver,text)
        file:close()
	end
	if matches[1] == 'wholist' and is_momod(msg) then
		local name = user_print_name(msg.from)
		local receiver = get_receiver(msg)
		chat_info(receiver, returnids, {receiver=receiver})
		send_document("chat#id"..msg.to.id,"./system/chats/lists/"..msg.to.id.."memberlist.txt", ok_cb, false)
	end

	if matches[1] == 'whois' and is_momod(msg) then
		local receiver = get_receiver(msg)
		local user_id = "user#id"..matches[2]
		user_info(user_id, cb_user_info, {receiver = receiver})
	end

	if not is_sudo(msg) then
		if is_realm(msg) and is_admin1(msg) then
			print("Admin detected")
		else
			return
		end
 	end

    if matches[1] == 'creategroup' and matches[2] then
        group_name = matches[2]
        group_type = 'group'
        return create_group(msg)
    end
    
    if is_sudo(msg) then
		if matches[1] == 'go' and matches[2] then
        local hash = parsed_url(matches[2])   
        join = import_chat_link(hash,ok_cb,false)
        end
    end

	--[[ Experimental
	if matches[1] == 'createsuper' and matches[2] then
	if not is_sudo(msg) or is_admin1(msg) and is_realm(msg) then
		return "You cant create groups!"
	end
        group_name = matches[2]
        group_type = 'super_group'
        return create_group(msg)
    end]]

    if matches[1] == 'createrealm' and matches[2] then
			if not is_sudo(msg) then
				return "<b>Sudo users only !</b>"
			end
        group_name = matches[2]
        group_type = 'realm'
        return create_realm(msg)
    end

    local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
			if matches[1] == 'setabout' and matches[2] == 'group' and is_realm(msg) then
				local target = matches[3]
				local about = matches[4]
				return set_description(msg, data, target, about)
			end
			if matches[1] == 'setabout' and matches[2] == 'sgroup'and is_realm(msg) then
				local channel = 'channel#id'..matches[3]
				local about_text = matches[4]
				local data_cat = 'description'
				local target = matches[3]
				channel_set_about(channel, about_text, ok_cb, false)
				data[tostring(target)][data_cat] = about_text
				save_data(_config.moderation.data, data)
				return "<b>Description has been set for</b> ["..matches[2]..']'
			end
			if matches[1] == 'setrules' then
				rules = matches[3]
				local target = matches[2]
				return set_rules(msg, data, target)
			end
			if matches[1] == 'lock' then
				local target = matches[2]
				if matches[3] == 'name' then
					return lock_group_name(msg, data, target)
				end
				if matches[3] == 'member' then
					return lock_group_member(msg, data, target)
				end
				if matches[3] == 'photo' then
					return lock_group_photo(msg, data, target)
				end
				if matches[3] == 'flood' then
					return lock_group_flood(msg, data, target)
				end
				if matches[2] == 'arabic' then
					return lock_group_arabic(msg, data, target)
				end
				if matches[3] == 'links' then
					return lock_group_links(msg, data, target)
				end
				if matches[3] == 'spam' then

					return lock_group_spam(msg, data, target)
				end
				if matches[3] == 'rtl' then
					return unlock_group_rtl(msg, data, target)
				end
				if matches[3] == 'sticker' then
					return lock_group_sticker(msg, data, target)
				end
			end
			if matches[1] == 'unlock' then
				local target = matches[2]
				if matches[3] == 'name' then
					return unlock_group_name(msg, data, target)
				end
				if matches[3] == 'member' then
					return unlock_group_member(msg, data, target)
				end
				if matches[3] == 'photo' then
					return unlock_group_photo(msg, data, target)
				end
				if matches[3] == 'flood' then
					return unlock_group_flood(msg, data, target)
				end
				if matches[3] == 'arabic' then
					return unlock_group_arabic(msg, data, target)
				end
				if matches[3] == 'links' then
					return unlock_group_links(msg, data, target)
				end
				if matches[3] == 'spam' then
					return unlock_group_spam(msg, data, target)
				end
				if matches[3] == 'rtl' then
					return unlock_group_rtl(msg, data, target)
				end
				if matches[3] == 'sticker' then
					return unlock_group_sticker(msg, data, target)
				end
			end

		if matches[1] == 'settings' and matches[2] == 'group' and data[tostring(matches[3])]['settings'] then
			local target = matches[3]
			text = show_group_settingsmod(msg, target)
			return text.."\n<b>ID:</b> "..target.."\n"
		end
		if  matches[1] == 'settings' and matches[2] == 'sgroup' and data[tostring(matches[3])]['settings'] then
			local target = matches[3]
			text = show_supergroup_settingsmod(msg, target)
			return text.."<b>ID:</b> "..target.."\n"
		end

		if matches[1] == 'setname' and is_realm(msg) then
			local settings = data[tostring(matches[2])]['settings']
			local new_name = string.gsub(matches[2], '_', ' ')
			data[tostring(msg.to.id)]['settings']['set_name'] = new_name
			save_data(_config.moderation.data, data)
			local group_name_set = data[tostring(msg.to.id)]['settings']['set_name']
			local to_rename = 'chat#id'..msg.to.id
			rename_chat(to_rename, group_name_set, ok_cb, false)
        end

		if matches[1] == 'setgpname' and is_admin1(msg) then
		    local new_name = string.gsub(matches[3], '_', ' ')
		    data[tostring(matches[2])]['settings']['set_name'] = new_name
		    save_data(_config.moderation.data, data)
		    local group_name_set = data[tostring(matches[2])]['settings']['set_name']
		    local chat_to_rename = 'chat#id'..matches[2]
			local channel_to_rename = 'channel#id'..matches[2]
		    rename_chat(to_rename, group_name_set, ok_cb, false)
			rename_channel(channel_to_rename, group_name_set, ok_cb, false)
		end

		--[[if matches[1] == 'set' then
			if matches[2] == 'loggroup' and is_sudo(msg) then
				local target = msg.to.peer_id
				return set_log_group(target, data)
			end
		end
		if matches[1] == 'rem' then
			if matches[2] == 'loggroup' and is_sudo(msg) then
				local target = msg.to.id
				return unset_log_group(target, data)
			end
		end]]
		if matches[1] == 'kill' and matches[2] == 'chat' and matches[3] then
			if not is_admin1(msg) then
				return
			end
			if is_realm(msg) then
				local receiver = 'chat#id'..matches[3]
				return modrem(msg),
				print("Closing Group: "..receiver),
				chat_info(receiver, killchat, {receiver=receiver})
			else
				return '<b>Error: Group '..matches[3]..' not found</b>'
			end
		end
		if matches[1] == 'kill' and matches[2] == 'realm' and matches[3] then
			if not is_admin1(msg) then
				return
			end
			if is_realm(msg) then
				local receiver = 'chat#id'..matches[3]
				return realmrem(msg),
				print("Closing realm: "..receiver),
				chat_info(receiver, killrealm, {receiver=receiver})
			else
				return '<b>Error: Realm '..matches[3]..' not found</b>'
			end
		end
		if matches[1] == 'rem' and matches[2] then
			-- Group configuration removal
			data[tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
			local groups = 'groups'
			if not data[tostring(groups)] then
				data[tostring(groups)] = nil
				save_data(_config.moderation.data, data)
			end
			data[tostring(groups)][tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
			send_large_msg(receiver, 'Chat '..matches[2]..' removed')
		end

		if matches[1] == 'chat_add_user' then
		    if not msg.service then
		        return
		    end
		    local user = 'user#id'..msg.action.user.id
		    local chat = 'chat#id'..msg.to.id
		    if not is_admin1(msg) and is_realm(msg) then
				  chat_del_user(chat, user, ok_cb, true)
			end
		end
		if matches[1] == 'addadmin' then
		    if not is_sudo(msg) then-- Sudo only
				return
			end
			if string.match(matches[2], '^%d+$') then
				local admin_id = matches[2]
				print("<b>user "..admin_id.." has been promoted as admin</b>")
				return admin_promote(msg, admin_id)
			else
			  local member = string.gsub(matches[2], "@", "")
				local mod_cmd = "addadmin"
				chat_info(receiver, username_id, {mod_cmd= mod_cmd, receiver=receiver, member=member})
			end
		end
		if matches[1] == 'removeadmin' then
		    if not is_sudo(msg) then-- Sudo only
				return
			end
			if string.match(matches[2], '^%d+$') then
				local admin_id = matches[2]
				print("<b>user "..admin_id.." has been demoted</b>")
				return admin_demote(msg, admin_id)
			else
			local member = string.gsub(matches[2], "@", "")
				local mod_cmd = "removeadmin"
				chat_info(receiver, username_id, {mod_cmd= mod_cmd, receiver=receiver, member=member})
			end
		end
		if matches[1] == 'support' and matches[2] then
			if string.match(matches[2], '^%d+$') then
				local support_id = matches[2]
				print("<b>User "..support_id.." has been added to the support team</b>")
				support_add(support_id)
				return "<b>User ["..support_id.."] has been added to the support team</b>"
			else
				local member = string.gsub(matches[2], "@", "")
				local receiver = get_receiver(msg)
				local get_cmd = "addsupport"
				resolve_username(member, res_user_support, {get_cmd = get_cmd, receiver = receiver})
			end
		end
		if matches[1] == '-support' then
			if string.match(matches[2], '^%d+$') then
				local support_id = matches[2]
				print("<b>User "..support_id.." has been removed from the support team</b>")
				support_remove(support_id)
				return "<b>User ["..support_id.."] has been removed from the support team</b>"
			else
				local member = string.gsub(matches[2], "@", "")
				local receiver = get_receiver(msg)
				local get_cmd = "removesupport"
				resolve_username(member, res_user_support, {get_cmd = get_cmd, receiver = receiver})
			end
		end
		if matches[1] == 'type'then
             local group_type = get_group_type(msg)
			return group_type
		end
		if matches[1] == 'list' then
			if matches[2] == 'admins' then
				return admin_list(msg)
			end
		--	if matches[2] == 'support' and not matches[2] then
			--	return support_list()
		--	end
		end
		
		if matches[1] == 'list' and matches[2] == 'groups' then
			if msg.to.type == 'chat' or msg.to.type == 'channel' then
				groups_list(msg)
				send_document("chat#id"..msg.to.id, "./system/chats/lists/groups.txt", ok_cb, false)
				send_document("channel#id"..msg.to.id, "./system/chats/lists/groups.txt", ok_cb, false)
				return "<b>Group list created</b>" --group_list(msg)
			elseif msg.to.type == 'user' then
				groups_list(msg)
				send_document("user#id"..msg.from.id, "./system/chats/lists/groups.txt", ok_cb, false)
				return "<b>Group list created</b>" --group_list(msg)
			end
		end
		if matches[1] == 'list' and matches[2] == 'realms' then
			if msg.to.type == 'chat' or msg.to.type == 'channel' then
				realms_list(msg)
				send_document("chat#id"..msg.to.id, "./system/chats/lists/realms.txt", ok_cb, false)
				send_document("channel#id"..msg.to.id, "./system/chats/lists/realms.txt", ok_cb, false)
				return "<b>Realms list created</b>" --realms_list(msg)
			elseif msg.to.type == 'user' then
				realms_list(msg)
				send_document("user#id"..msg.from.id, "./system/chats/lists/realms.txt", ok_cb, false)
				return "<b>Realms list created</b>" --realms_list(msg)
			end
		end
   		if matches[1] == 'res' and is_momod(msg) then
      		local cbres_extra = {
        		chatid = msg.to.id
     		}
      	local username = matches[2]
      	local username = username:gsub("@","")
      	return resolve_username(username,  callbackres, cbres_extra)
    end
end


return {
  patterns = {
    "^[#!/](creategroup) (.*)$",
		"^(creategroup) (.*)$",
	"^[#!/](createsuper) (.*)$",
	"^(createsuper) (.*)$",
    "^[#!/](createrealm) (.*)$",
		"^(createrealm) (.*)$",
    "^[#!/](setabout) (%d+) (.*)$",
		"^(setabout) (%d+) (.*)$",
    "^[#!/](setrules) (%d+) (.*)$",
		"^(setrules) (%d+) (.*)$",
    "^[#!/](setname) (.*)$",
		"^(setname) (.*)$",
    "^[#!/](setgpname) (%d+) (.*)$",
		"^(setgpname) (%d+) (.*)$",
    "^[#!/](setname) (%d+) (.*)$",
		"^(setname) (%d+) (.*)$",
    "^[#!/](lock) (%d+) (.*)$",
		"^(lock) (%d+) (.*)$",
    "^[#!/](unlock) (%d+) (.*)$",
		"^(unlock) (%d+) (.*)$",
	"^[#!/](mute) (%d+)$",
	"^(mute) (%d+)$",
	"^[#!/](unmute) (%d+)$",
	"^(unmute) (%d+)$",
    "^[#!/](settings) (.*) (%d+)$",
		"^(settings) (.*) (%d+)$",
    "^[#!/](wholist)$",
		"^(wholist)$",
    "^[#!/](who)$",
		"^(who)$",
	"^[#!/]([Ww]hois) (.*)",
	"^([Ww]hois) (.*)",
    "^[#!/](type)$",
		"^(type)$",
    "^[#!/](markread) (on)$",
		"^(markread) (on)$",
	"^[#!/](markread) (off)$",
	"^(markread) (off)$",
    "^[#!/](kill) (chat) (%d+)$",
		"^(kill) (chat) (%d+)$",
    "^[#!/](kill) (realm) (%d+)$",
		"^(kill) (realm) (%d+)$",
    "^[#!/]([Gg]o) (.*)$",
		"^([Gg]o) (.*)$",
	"^[#!/](rem) (%d+)$",
	"^(rem) (%d+)$",
    "^[#!/](addadmin) (.*)$", -- sudoers only
		"^(addadmin) (.*)$", -- sudoers only
    "^[#!/](removeadmin) (.*)$", -- sudoers only
		"^(removeadmin) (.*)$", -- sudoers only
	"^[#!/](support)$",
	"^(support)$",
	"^[#!/](support) (.*)$",
	"^(support) (.*)$",
    "^[#!/](-support) (.*)$",
	  "^(-support) (.*)$",
    "^[#!/](list) (.*)$",
		"^(list) (.*)$",
    "^[#!/](log)$",
		"^(log)$",
    "^[#!/](setbotphoto)$",
		"^(setbotphoto)$",
    "^[#!/](broadcast) +(.+)$",
		"^(broadcast) +(.+)$",
    "^[#!/](bc) (%d+) (.*)$",
		"^(bc) (%d+) (.*)$",
    "^[#!/](get) (.*)$",
		"^(get) (.*)$",
    "^[#!/](pm) (%d+) (.*)$",
		"^(pm) (%d+) (.*)$",
    "^!!tgservice (.+)$",
    "%[(photo)%]",
  },
  run = run
}
end
