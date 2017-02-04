local function warn_by_username(extra, success, result) -- /warn <@username>
  if success == 1 then  
  local msg = result
  local target = extra.target
  local receiver = extra.receiver 
  local hash = 'warn:'..target
  local value = redis:hget(hash, msg.id)
  local text = ''
  local name = ''
  if msg.first_name then
   name = string.sub(msg.first_name, 1, 40)
  else
   name = string.sub(msg.last_name, 1, 40)
  end
----------------------------------
  if is_momod2(msg.id, target) and not is_admin2(extra.fromid) then
  return send_msg(receiver, '<i>شما نمیتوانید به مدیر گروه اخطار بدهید!</i>', ok_cb, false) end
--endif--
  if is_admin2(msg.id) then return send_msg(receiver, '<i>شما نمیتوانید به ادمین ربات اخطار بدهید!</i>', ok_cb, false) end
--endif--
  if value then
   if value == '1' then
    redis:hset(hash, msg.id, '2')
   text = '<code>[ '..name..' ]</code>\n <i>شما به دلیل رعایت نکردن قوانین اخطار دریافت میکنید\nتعداد اخطار های شما : ۲/۴</i>'
   elseif value == '2' then
  redis:hset(hash, msg.id, '3')
  text = '<code>[ '..name..' ]</code>\n <i>شما به دلیل رعایت نکردن قوانین اخطار دریافت میکنید\nتعداد اخطار های شما : ۳/۴</i>'
   elseif value == '3' then
   redis:hdel(hash, msg.id, '0')
   local hash =  'banned:'..target
   redis:sadd(hash, msg.id)
  text = '<code>[ '..name..' ]</code>\n <i>به دلیل رعایت نکردن قوانین از گروه اخراج شد (banned)\nتعداد اخطار ها : ۴/۴</i>'
  chat_del_user(receiver, 'user#id'..msg.id, ok_cb, false)
   end
  else
   redis:hset(hash, msg.id, '1')
   text = '<code>[ '..name..' ]</code>\n <i>شما به دلیل رعایت نکردن قوانین اخطار دریافت میکنید\nتعداد اخطار های شما : ۱/۴</i>'
  end
  send_msg(receiver, text, ok_cb, false)
  else
   send_msg(receiver, ' <i>نام کاربری پیدا نشد.</i>', ok_cb, false)
  end
end

--

local function warn_by_reply(extra, success, result) -- (on reply) /warn
  local msg = result
  local target = extra.target
  local receiver = extra.receiver 
  local hash = 'warn:'..msg.to.id
  local value = redis:hget(hash, msg.from.id)
  local text = ''
  local name = ''
  if msg.from.first_name then
   name = string.sub(msg.from.first_name, 1, 40)
  else
   name = string.sub(msg.from.last_name, 1, 40)
  end
----------------------------------
  if is_momod2(msg.from.id, msg.to.id) and not is_admin2(extra.fromid) then
  return send_msg(receiver, '<i>شما نمیتوانید به مدیر گروه اخطار بدهید!</i>', ok_cb, false) end
--endif--
  if is_admin2(msg.from.id) then return send_msg(receiver, '<i>شما نمیتوانید به ادمین ربات اخطار بدهید!</i>', ok_cb, false) end
--endif--
  if value then
   if value == '1' then
    redis:hset(hash, msg.from.id, '2')
   text = '<code>[ '..name..' ]</code>\n <i>.شما به دلیل رعایت نکردن قوانین اخطار دریافت میکنید\nتعداد اخطار های شما : ۲/۴</i>'
   elseif value == '2' then
  redis:hset(hash, msg.from.id, '3')
  text = '<code>[ '..name..' ]</code>\n <i>شما به دلیل رعایت نکردن قوانین اخطار دریافت میکنید.\nتعداد اخطار های شما : ۳/۴</i>'
   elseif value == '3' then
   redis:hdel(hash, msg.from.id, '0')
  text = '<b>[ '..name..' ]</b>\n <i>به دلیل رعایت نکردن قوانین از گروه اخراج شد. (banned)\nتعداد اخطار ها : ۴/۴</i>'
  local hash =  'banned:'..target
  redis:sadd(hash, msg.from.id)
  chat_del_user(receiver, 'user#id'..msg.from.id, ok_cb, false)
   end
  else
   redis:hset(hash, msg.from.id, '1')
   text = '<code>[ '..name..' ]</code>\n <i>شما به دلیل رعایت نکردن قوانین اخطار دریافت میکنید.\nتعداد اخطار های شما : ۱/۴</i>'
  end
  reply_msg(extra.Reply, text, ok_cb, false)
end

--

local function unwarn_by_username(extra, success, result) -- /unwarn <@username>
  if success == 1 then  
  local msg = result
  local target = extra.target
  local receiver = extra.receiver 
  local hash = 'warn:'..target
  local value = redis:hget(hash, msg.id)
  local text = ''
----------------------------------
  if is_momod2(msg.id, target) and not is_admin2(extra.fromid) then return end
--endif--
  if is_admin2(msg.id) then return end
--endif--
  if value then
  redis:hdel(hash, msg.id, '0')
  text = '<i>اخطار های کاربر ('..msg.id..') پاک شد\nتعداد اخطار ها : ۰/۴</i>'
  else
   text = '<i>این کاربر اخطاری دریافت نکرده است</i>'
  end
  send_msg(receiver, text, ok_cb, false)
  else
   send_msg(receiver, ' <i>نام کاربری پیدا نشد.</i>', ok_cb, false)
  end
end

--

local function unwarn_by_reply(extra, success, result) -- (on reply) /unwarn
  local msg = result
  local target = extra.target
  local receiver = extra.receiver 
  local hash = 'warn:'..msg.to.id
  local value = redis:hget(hash, msg.from.id)
  local text = ''
----------------------------------
  if is_momod2(msg.from.id, msg.to.id) and not is_admin2(extra.fromid) then
  return end
--endif--
  if is_admin2(msg.from.id) then return end
--endif--
  if value then
  redis:hdel(hash, msg.from.id, '0')
  text = '<i>اخطار های کاربر ('..msg.from.id..') پاک شد\nتعداد اخطار ها : ۰/۴</i>'
  else
   text = '<i>این کاربر اخطاری دریافت نکرده است</i>'
  end
  reply_msg(extra.Reply, text, ok_cb, false)
end

--

local function run(msg, matches)
 local target = msg.to.id
 local fromid = msg.from.id
 local user = matches[2]
 local target = msg.to.id
 local receiver = get_receiver(msg)
 if msg.to.type == 'user' then return end
 --endif--
 if not is_momod(msg) then return '<i>شما مدیر نیستید</i>' end
 --endif--
 ----------------------------------
 if matches[1]:lower() == 'warn' and not matches[2] then -- (on reply) /warn
  if msg.reply_id then
    local Reply = msg.reply_id
    msgr = get_message(msg.reply_id, warn_by_reply, {receiver=receiver, Reply=Reply, target=target, fromid=fromid})
  else return '<i>از نام کاربری یا ریپلی کردن پیام کاربر برای اخطار دادن استفاده کنید</i>' end
 --endif--
 end
 if matches[1]:lower() == 'warn' and matches[2] then -- /warn <@username>
   if string.match(user, '^%d+$') then
      return '<i>از نام کاربری یا ریپلی کردن پیام کاربر برای اخطار دادن استفاده کنید</i>'
    elseif string.match(user, '^@.+$') then
      username = string.gsub(user, '@', '')
      msgr = res_user(username, warn_by_username, {receiver=receiver, user=user, target=target, fromid=fromid})
   end
 end
 if matches[1]:lower() == 'unwarn' and not matches[2] then -- (on reply) /unwarn
  if msg.reply_id then
    local Reply = msg.id
    msgr = get_message(msg.reply_id, unwarn_by_reply, {receiver=receiver, Reply=Reply, target=target, fromid=fromid})
  else return '<i>از نام کاربری یا ریپلی کردن استفاده کنید</i>' end
 --endif--
 end
 if matches[1]:lower() == 'unwarn' and matches[2] then -- /unwarn <@username>
   if string.match(user, '^%d+$') then
      return '<i>از نام کاربری یا ریپلی کردن استفاده کنید</i>'
    elseif string.match(user, '^@.+$') then
      username = string.gsub(user, '@', '')
      msgr = res_user(username, unwarn_by_username, {receiver=receiver, user=user, target=target, fromid=fromid})
   end
 end
end

return {
  patterns = {
    "^[!/#]([Ww][Aa][Rr][Nn])$",
    "^([Ww][Aa][Rr][Nn])$",
    "^[!/#]([Ww][Aa][Rr][Nn]) (.*)$",
    "^([Ww][Aa][Rr][Nn]) (.*)$",
    "^[!/#]([Uu][Nn][Ww][Aa][Rr][Nn])$",
    "^([Uu][Nn][Ww][Aa][Rr][Nn])$",
    "^[!/#]([Uu][Nn][Ww][Aa][Rr][Nn]) (.*)$",
    "^([Uu][Nn][Ww][Aa][Rr][Nn]) (.*)$"
  }, 
  run = run 
}
