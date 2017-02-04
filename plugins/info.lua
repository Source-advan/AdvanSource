local function callback_reply(extra, success, result)
	--icon & rank ------------------------------------------------------------------------------------------------
	userrank = "Member"
	if tonumber(result.from.id) == 175636120 then
		userrank = "Master ⭐⭐⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/master.webp", ok_cb, false)
	elseif is_sudo(result) then
		userrank = "Sudo ⭐⭐⭐⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/sudo.webp", ok_cb, false)
	elseif is_admin2(result.from.id) then
		userrank = "Admin ⭐⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/admin.webp", ok_cb, false)
	elseif is_owner2(result.from.id, result.to.id) then
		userrank = "Owner ⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/leader.webp", ok_cb, false)
	elseif is_momod2(result.from.id, result.to.id) then
		userrank = "Moderator ⭐"
		send_document(org_chat_id,"umbrella/stickers/mod.webp", ok_cb, false)
	elseif tonumber(result.from.id) == tonumber(our_id) then
		userrank = "Signal ⭐⭐⭐⭐⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/umb.webp", ok_cb, false)
	elseif result.from.username then
		if string.sub(result.from.username:lower(), -3) == "bot" then
			userrank = "API Bot"
			send_document(org_chat_id,"umbrella/stickers/api.webp", ok_cb, false)
		end
	end
	--custom rank ------------------------------------------------------------------------------------------------
	local file = io.open("./info/"..result.from.id..".txt", "r")
	if file ~= nil then
		usertype = file:read("*all")
	else
		usertype = "-----"
	end
	--cont ------------------------------------------------------------------------------------------------
	local user_info = {}
	local uhash = 'user:'..result.from.id
	local user = redis:hgetall(uhash)
	local um_hash = 'msgs:'..result.from.id..':'..result.to.id
	user_info.msgs = tonumber(redis:get(um_hash) or 0)
	--msg type ------------------------------------------------------------------------------------------------
	if result.media then
		if result.media.type == "document" then
			if result.media.text then
				msg_type = "استیکر"
			else
				msg_type = "ساير فايلها"
			end
		elseif result.media.type == "photo" then
			msg_type = "فايل عکس"
		elseif result.media.type == "video" then
			msg_type = "فايل ويدئويي"
		elseif result.media.type == "audio" then
			msg_type = "فايل صوتي"
		elseif result.media.type == "geo" then
			msg_type = "موقعيت مکاني"
		elseif result.media.type == "contact" then
			msg_type = "شماره تلفن"
		elseif result.media.type == "file" then
			msg_type = "فايل"
		elseif result.media.type == "webpage" then
			msg_type = "پیش نمایش سایت"
		elseif result.media.type == "unsupported" then
			msg_type = "فايل متحرک"
		else
			msg_type = "ناشناخته"
		end
	elseif result.text then
		if string.match(result.text, '^%d+$') then
			msg_type = "عدد"
		elseif string.match(result.text, '%d+') then
			msg_type = "شامل عدد و حروف"
		elseif string.match(result.text, '^@') then
			msg_type = "یوزرنیم"
		elseif string.match(result.text, '@') then
			msg_type = "شامل یوزرنیم"
		elseif string.match(result.text, '[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]') then
			msg_type = "لينک تلگرام"
		elseif string.match(result.text, '[Hh][Tt][Tt][Pp]') then
			msg_type = "لينک سايت"
		elseif string.match(result.text, '[Ww][Ww][Ww]') then
			msg_type = "لينک سايت"
		elseif string.match(result.text, '?') then
			msg_type = "پرسش"
		else
			msg_type = "متن"
		end
	end
	--hardware ------------------------------------------------------------------------------------------------
	if result.text then
		inputtext = string.sub(result.text, 0,1)
		if result.text then
			if string.match(inputtext, "[a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z]") then
				hardware = "<i>کامپیوتر</i>"
			elseif string.match(inputtext, "[A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z]") then
				hardware = "<i>موبایل</i>"
			else
				hardware = "-----"
			end
		else
			hardware = "-----"
		end
	else
		hardware = "-----"
	end
	--phone ------------------------------------------------------------------------------------------------
	if access == 1 then
		if result.from.phone then
			number = "+"..string.sub(result.from.phone, 3)
			if string.sub(result.from.phone, 0,2) == '98' then
				number = number.."<i>\nکشور: جمهوری اسلامی ایران</i>"
				if string.sub(result.from.phone, 0,4) == '9891' then
					number = number.."<i>\nنوع سیمکارت: همراه اول</i>"
				elseif string.sub(result.from.phone, 0,5) == '98932' then
					number = number.."<i>\nنوع سیمکارت: تالیا</i>"
				elseif string.sub(result.from.phone, 0,4) == '9893' then
					number = number.."<i>\nنوع سیمکارت: ایرانسل<i>"
				elseif string.sub(result.from.phone, 0,4) == '9890' then
					number = number.."<i>\nنوع سیمکارت: ایرانسل</i>"
				elseif string.sub(result.from.phone, 0,4) == '9892' then
					number = number.."<i>\nنوع سیمکارت: رایتل</i>"
				else
					number = number.."<i>\nنوع سیمکارت: سایر</i>"
				end
			else
				number = number.."<i>\nکشور: خارج\nنوع سیمکارت: متفرقه</i>"
			end
		else
			number = "-----"
		end
	elseif access == 0 then
		if result.from.phone then
			number = "<i>شما مجاز نیستید</i>"
			if string.sub(result.from.phone, 0,2) == '98' then
				number = number.."<i>\nکشور: جمهوری اسلامی ایران</i>"
				if string.sub(result.from.phone, 0,4) == '9891' then
					number = number.."<i>\nنوع سیمکارت: همراه اول</i>"
				elseif string.sub(result.from.phone, 0,5) == '98932' then
					number = number.."<i>\nنوع سیمکارت: تالیا</i>"
				elseif string.sub(result.from.phone, 0,4) == '9893' then
					number = number.."<i>\nنوع سیمکارت: ایرانسل</i>"
				elseif string.sub(result.from.phone, 0,4) == '9890' then
					number = number.."<i>\nنوع سیمکارت: ایرانسل</i>"
				elseif string.sub(result.from.phone, 0,4) == '9892' then
					number = number.."<i>\nنوع سیمکارت: رایتل</i>"
				else
					number = number.."<i\nنوع سیمکارت: سایر</i>"
				end
			else
				number = number.."<i>\nکشور: خارج\nنوع سیمکارت: متفرقه</i>"
			end
		else
			number = "-----"
		end
	end
	--info ------------------------------------------------------------------------------------------------
			local url , res = http.request('http://api.gpmod.ir/time/')
            if res ~= 200 then return "<b>No connection</b>" end
            local jdat = json:decode(url)
			local info = "<i>نام کامل:</i> "..string.gsub(msg.from.print_name, "_", " ").."\n"
					.."<i>نام کوچک:</i> "..(msg.from.first_name or "-----").."\n"
					.."<i>نام خانوادگی:</i> "..(msg.from.last_name or "-----").."\n\n"
					.."<i>شماره موبایل:</i> "..number.."\n"
					.."<i>یوزرنیم:</i> @"..(msg.from.username or "-----").."\n\n"
					.."<i>ساعت:</i> "..jdat.FAtime.."\n"
					.."<i>تاريخ:</i> "..jdat.FAdate.."\n"
					.."<i>آیدی:</i> "..msg.from.id.."\n\n"
					.."<i>مقام:</i> "..usertype.."\n"
					.."<i>جایگاه:</i> "..userrank.."\n\n"
					.."<i>رابط کاربری:</i> "..hardware.."\n"
					.."<i>تعداد پیامها:</i> "..user_info.msgs.."\n\n"
					.."<i>نام گروه:</i> "..string.gsub(msg.to.print_name, "_", " ").."\n"
					.."<i>آیدی گروه:</i> "..msg.to.id
	send_large_msg(org_chat_id, info)
end

local function callback_res(extra, success, result)
	if success == 0 then
		return send_large_msg(org_chat_id, "<i>یوزرنیم وارد شده اشتباه است</i>")
	end
	--icon & rank ------------------------------------------------------------------------------------------------
	if tonumber(result.id) == 175636120 then
		userrank = "Master ⭐⭐⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/master.webp", ok_cb, false)
	elseif is_sudo(result) then
		userrank = "Sudo ⭐⭐⭐⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/sudo.webp", ok_cb, false)
	elseif is_admin2(result.id) then
		userrank = "Admin ⭐⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/admin.webp", ok_cb, false)
	elseif is_owner2(result.id, extra.chat2) then
		userrank = "Owner ⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/leader.webp", ok_cb, false)
	elseif is_momod2(result.id, extra.chat2) then
		userrank = "Moderator ⭐"
		send_document(org_chat_id,"umbrella/stickers/mod.webp", ok_cb, false)
	elseif tonumber(result.id) == tonumber(our_id) then
		userrank = "Signal ⭐⭐⭐⭐⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/umb.webp", ok_cb, false)
	elseif result.from.username then
		if string.sub(result.from.username:lower(), -3) == "bot" then
			userrank = "API Bot"
			send_document(org_chat_id,"umbrella/stickers/api.webp", ok_cb, false)
	else
		userrank = "Member"
	end
	end
	--custom rank ------------------------------------------------------------------------------------------------
	local file = io.open("./info/"..result.id..".txt", "r")
	if file ~= nil then
		usertype = file:read("*all")
	else
		usertype = "-----"
	end
	--phone ------------------------------------------------------------------------------------------------
	if access == 1 then
		if result.phone then
			number = "+"..string.sub(result.phone, 3)
			if string.sub(result.phone, 0,2) == '98' then
				number = number.."<i>\nکشور: جمهوری اسلامی ایران</i>"
				if string.sub(result.phone, 0,4) == '9891' then
					number = number.."<i>\nنوع سیمکارت: همراه اول</i>"
				elseif string.sub(result.phone, 0,5) == '98932' then
					number = number.."<i>\nنوع سیمکارت: تالیا</i>"
				elseif string.sub(result.phone, 0,4) == '9893' then
					number = number.."<i>\nنوع سیمکارت: ایرانسل</i>"
				elseif string.sub(result.phone, 0,4) == '9890' then
					number = number.."<i>\nنوع سیمکارت: ایرانسل</i>"
				elseif string.sub(result.phone, 0,4) == '9892' then
					number = number.."<i>\nنوع سیمکارت: رایتل</i>"
				else
					number = number.."<i>\nنوع سیمکارت: سایر</i>"
				end
			else
				number = number.."<i>\nکشور: خارج\nنوع سیمکارت: متفرقه</i>"
			end
		else
			number = "-----"
		end
	elseif access == 0 then
		if result.phone then
			number = "<i>شما مجاز نیستید</i>"
			if string.sub(result.phone, 0,2) == '98' then
				number = number.."<i>\nکشور: جمهوری اسلامی ایران</i>"
				if string.sub(result.phone, 0,4) == '9891' then
					number = number.."<i>\nنوع سیمکارت: همراه اول</i>"
				elseif string.sub(result.phone, 0,5) == '98932' then
					number = number.."<i>\nنوع سیمکارت: تالیا</i>"
				elseif string.sub(result.phone, 0,4) == '9893' then
					number = number.."<i>\nنوع سیمکارت: ایرانسل</i>"
				elseif string.sub(result.phone, 0,4) == '9890' then
					number = number.."<i>\nنوع سیمکارت: ایرانسل</i>"
				elseif string.sub(result.phone, 0,4) == '9892' then
					number = number.."<i>\nنوع سیمکارت: رایتل</i>"
				else
					number = number.."<i>\nنوع سیمکارت: سایر</i>"
				end
			else
				number = number.."<i>\nکشور: خارج\nنوع سیمکارت: متفرقه</i>"
			end
		else
			number = "-----"
		end
	end
	--info ------------------------------------------------------------------------------------------------
	info = "<i>نام کامل:</i> "..string.gsub(result.print_name, "_", " ").."\n"
	.."<i>نام کوچک:</i> "..(result.first_name or "-----").."\n"
	.."<i>نام خانوادگی:</i> "..(result.last_name or "-----").."\n\n"
	.."<i>شماره موبایل:</i> "..number.."\n"
	.."<i>یوزرنیم:</i> @"..(result.username or "-----").."\n"
	.."<i>آیدی:</i> "..result.id.."\n\n"
	.."<i>مقام:</i> "..usertype.."\n"
	.."<i>جایگاه:</i> "..userrank.."\n\n"
	send_large_msg(org_chat_id, info)
end

local function callback_info(extra, success, result)
	if success == 0 then
		return send_large_msg(org_chat_id, "<i>آیدی وارد شده اشتباه است</i>")
	end
	--icon & rank ------------------------------------------------------------------------------------------------
	if tonumber(result.id) == 175636120 then
		userrank = "Master ⭐⭐⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/master.webp", ok_cb, false)
	elseif is_sudo(result) then
		userrank = "Sudo ⭐⭐⭐⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/sudo.webp", ok_cb, false)
	elseif is_admin2(result.id) then
		userrank = "Admin ⭐⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/admin.webp", ok_cb, false)
	elseif is_owner2(result.id, extra.chat2) then
		userrank = "Owner ⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/leader.webp", ok_cb, false)
	elseif is_momod2(result.id, extra.chat2) then
		userrank = "Moderator ⭐"
		send_document(org_chat_id,"umbrella/stickers/mod.webp", ok_cb, false)
	elseif tonumber(result.id) == tonumber(our_id) then
		userrank = "Signal ⭐⭐⭐⭐⭐⭐"
		send_document(org_chat_id,"umbrella/stickers/umb.webp", ok_cb, false)
	elseif result.from.username then
		if string.sub(result.from.username:lower(), -3) == "bot" then
			userrank = "API Bot"
			send_document(org_chat_id,"umbrella/stickers/api.webp", ok_cb, false)
	else
		userrank = "Member"
	end
	end
	--custom rank ------------------------------------------------------------------------------------------------
	local file = io.open("./info/"..result.id..".txt", "r")
	if file ~= nil then
		usertype = file:read("*all")
	else
		usertype = "-----"
	end
	--phone ------------------------------------------------------------------------------------------------
	if access == 1 then
		if result.phone then
			number = "+"..string.sub(result.phone, 3)
			if string.sub(result.phone, 0,2) == '98' then
				number = number.."<i>\nکشور: جمهوری اسلامی ایران</i>"
				if string.sub(result.phone, 0,4) == '9891' then
					number = number.."<i>\nنوع سیمکارت: همراه اول</i>"
				elseif string.sub(result.phone, 0,5) == '98932' then
					number = number.."<i>\nنوع سیمکارت: تالیا</i>"
				elseif string.sub(result.phone, 0,4) == '9893' then
					number = number.."<i>\nنوع سیمکارت: ایرانسل</i>"
				elseif string.sub(result.phone, 0,4) == '9890' then
					number = number.."<i>\nنوع سیمکارت: ایرانسل</i>"
				elseif string.sub(result.phone, 0,4) == '9892' then
					number = number.."<i>\nنوع سیمکارت: رایتل</i>"
				else
					number = number.."<i>\nنوع سیمکارت: سایر</i>"
				end
			else
				number = number.."<i>\nکشور: خارج\nنوع سیمکارت: متفرقه</i>"
			end
		else
			number = "-----"
		end
	elseif access == 0 then
		if result.phone then
			number = "<i>شما مجاز نیستید</i>"
			if string.sub(result.phone, 0,2) == '98' then
				number = number.."<i>\nکشور: جمهوری اسلامی ایران</i>"
				if string.sub(result.phone, 0,4) == '9891' then
					number = number.."<i>\nنوع سیمکارت: همراه اول</i>"
				elseif string.sub(result.phone, 0,5) == '98932' then
					number = number.."<i>\nنوع سیمکارت: تالیا</i>"
				elseif string.sub(result.phone, 0,4) == '9893' then
					number = number.."<i>\nنوع سیمکارت: ایرانسل</i>"
				elseif string.sub(result.phone, 0,4) == '9890' then
					number = number.."<i>\nنوع سیمکارت: ایرانسل</i>"
				elseif string.sub(result.phone, 0,4) == '9892' then
					number = number.."<i>\nنوع سیمکارت: رایتل</i>"
				else
					number = number.."<i>\nنوع سیمکارت: سایر</i>"
				end
			else
				number = number.."<i>\nکشور: خارج\nنوع سیمکارت: متفرقه</i>"
			end
		else
			number = "-----"
		end
	end
	--name ------------------------------------------------------------------------------------------------
	if string.len(result.print_name) > 15 then
		fullname = string.sub(result.print_name, 0,15).."..."
	else
		fullname = result.print_name
	end
	if result.first_name then
		if string.len(result.first_name) > 15 then
			firstname = string.sub(result.first_name, 0,15).."..."
		else
			firstname = result.first_name
		end
	else
		firstname = "-----"
	end
	if result.last_name then
		if string.len(result.last_name) > 15 then
			lastname = string.sub(result.last_name, 0,15).."..."
		else
			lastname = result.last_name
		end
	else
		lastname = "-----"
	end
	--info ------------------------------------------------------------------------------------------------
	info = "<i>نام کامل:</i> "..string.gsub(result.print_name, "_", " ").."\n"
	.."<i>نام کوچک:</i> "..(result.first_name or "-----").."\n"
	.."<i>نام خانوادگی:</i> "..(result.last_name or "-----").."\n\n"
	.."<i>شماره موبایل:</i> "..number.."\n"
	.."<i>یوزرنیم:</i> @"..(result.username or "-----").."\n"
	.."<i>ساعت:</i> "..msg.from.time.."\n"
	.."<i>آیدی:</i> "..result.id.."\n\n"
	.."<i>مقام:</i> "..usertype.."\n"
	.."<i>جایگاه:</i> "..userrank.."\n\n"
	send_large_msg(org_chat_id, info)
end

local function run(msg, matches)
	local data = load_data(_config.moderation.data)
	org_channel_id = "channel#id"..msg.to.id
	if is_sudo(msg) then
		access = 1
	else
		access = 0
	end
	if matches[1] == 'infodel' and is_sudo(msg) then
		azlemagham = io.popen('rm ./info/'..matches[2]..'.txt'):read('*all')
		return '<i>از مقام خود عزل شد</i>'
	elseif matches[1] == 'Info' and is_sudo(msg) then
		local name = string.sub(matches[2], 1, 50)
		local text = string.sub(matches[3], 1, 10000000000)
		local file = io.open("./info/"..name..".txt", "w")
		file:write(text)
		file:flush()
		file:close() 
		return "<i>مقام ثبت شد</i>"
	elseif #matches == 2 then
		local cbres_extra = {chatid = msg.to.id}
		if string.match(matches[2], '^%d+$') then
			return user_info('user#id'..matches[2], callback_info, cbres_extra)
		else
			return res_user(matches[2]:gsub("@",""), callback_res, cbres_extra)
		end
	else
		--custom rank ------------------------------------------------------------------------------------------------
		local file = io.open("./info/"..msg.from.id..".txt", "r")
		if file ~= nil then
			usertype = file:read("*all")
		else
			usertype = "-----"
		end
		--hardware ------------------------------------------------------------------------------------------------
		if matches[1] == "info" then
			hardware = "<i>کامپیوتر</i>"
		else
			hardware = "<i>موبایل</i>"
		end
		if not msg.reply_id then
			--contor ------------------------------------------------------------------------------------------------
			local user_info = {}
			local uhash = 'user:'..msg.from.id
			local user = redis:hgetall(uhash)
			local um_hash = 'msgs:'..msg.from.id..':'..msg.to.id
			user_info.msgs = tonumber(redis:get(um_hash) or 0)
			--icon & rank ------------------------------------------------------------------------------------------------
			if tonumber(msg.from.id) == 175636120 then
				userrank = "Master ⭐⭐⭐⭐"
				send_document("chat#id"..msg.to.id,"umbrella/stickers/master.webp", ok_cb, false)
			elseif is_sudo(msg) then
				userrank = "Sudo ⭐⭐⭐⭐⭐"
				send_document("chat#id"..msg.to.id,"umbrella/stickers/sudo.webp", ok_cb, false)
			elseif is_admin(msg) then
				userrank = "Admin ⭐⭐⭐"
				send_document("chat#id"..msg.to.id,"umbrella/stickers/admin.webp", ok_cb, false)
			elseif is_owner(msg) then
				userrank = "Owner ⭐⭐"
				send_document("chat#id"..msg.to.id,"umbrella/stickers/leader.webp", ok_cb, false)
			elseif is_momod(msg) then
				userrank = "Moderator ⭐"
				send_document("chat#id"..msg.to.id,"umbrella/stickers/mod.webp", ok_cb, false)
			else
				userrank = "Member"
			end
			--number ------------------------------------------------------------------------------------------------
			if msg.from.phone then
				numberorg = string.sub(msg.from.phone, 3)
				number = "****+"..string.sub(numberorg, 0,6)
				if string.sub(msg.from.phone, 0,2) == '98' then
					number = number.."<i>\nکشور: جمهوری اسلامی ایران</i>"
					if string.sub(msg.from.phone, 0,4) == '9891' then
						number = number.."<i>\nنوع سیمکارت: همراه اول</i>"
					elseif string.sub(msg.from.phone, 0,5) == '98932' then
						number = number.."<i>\nنوع سیمکارت: تالیا</i>"
					elseif string.sub(msg.from.phone, 0,4) == '9893' then
						number = number.."<i>\nنوع سیمکارت: ایرانسل</i>"
					elseif string.sub(msg.from.phone, 0,4) == '9890' then
						number = number.."<i>\nنوع سیمکارت: ایرانسل</i>"
					elseif string.sub(msg.from.phone, 0,4) == '9892' then
						number = number.."<i>\nنوع سیمکارت: رایتل</i>"
					else
						number = number.."<i>\nنوع سیمکارت: سایر</i>"
					end
				else
					number = number.."<i>\nکشور: خارج\nنوع سیمکارت: متفرقه</i>"
				end
			else
				number = "-----"
			end
			--time ------------------------------------------------------------------------------------------------
			local url , res = http.request('http://api.gpmod.ir/time/')
            if res ~= 200 then return "<b>No connection</b>" end
            local jdat = json:decode(url)
			local info = "نام کامل: "..string.gsub(msg.from.print_name, "_", " ").."\n"
					.."<i>نام کوچک:</i> "..(msg.from.first_name or "-----").."\n"
					.."<i>نام خانوادگی:</i> "..(msg.from.last_name or "-----").."\n\n"
					.."<i>شماره موبایل:</i> "..number.."\n"
					.."<i>یوزرنیم:</i> @"..(msg.from.username or "-----").."\n\n"
					.."<i>ساعت :</i> "..jdat.FAtime.."\n"
					.."<i>تاريخ :</i>"..jdat.FAdate.."\n"
					.."<i>آیدی:</i> "..msg.from.id.."\n\n"
					.."<i>مقام:</i> "..usertype.."\n"
					.."<i>جایگاه:</i> "..userrank.."\n\n"
					.."<i>رابط کاربری:</i> "..hardware.."\n"
					.."<i>تعداد پیامها:</i> "..user_info.msgs.."\n\n"
					.."<i>نام گروه:</i> "..string.gsub(msg.to.print_name, "_", " ").."\n"
					.."<i>آیدی گروه:</i> "..msg.to.id
			return info
		else
			get_message(msg.reply_id, callback_reply, false)
		end
	end
end

return {
	description = "User Infomation",
	usage = {
		user = {
			"/info: اطلاعات شما",
			"/info (reply): اطلاعات دیگران",
			},
		sudo = {
			"Info (id) (txt) : اعطای مقام",
			"infodel : حذف مقام",
			},
		},
	patterns = {
		"^(infodel) (.*)$",
		"^(Info) ([^%s]+) (.*)$",
		"^[!/#](info) (.*)$",
		"^(info) (.*)$",
		"^[!/#](info)$",
		"^(info)$",
		"^[!/#](Info)$",
		"^(Info)$",
	},
	run = run,
}
