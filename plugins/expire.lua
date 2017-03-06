local function check_member_superrem2(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  local channel = 'channel#id'..result.to.peer_id
  for k,v in pairs(result) do
    local member_id = v.id
    if member_id ~= our_id then
	  -- Group configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
	  send_large_msg(channel, "<i>به دلیل عدم تمدید گروه ربات از گروه خارج میگردد</i>")
	  chat_del_user(get_receiver(msg), 'user#id'..219201071, ok_cb, false)
	  leave_channel(get_receiver(msg), ok_cb, false)
    end
  end
end

local function superrem2(msg)
	local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_superrem2,{receiver = receiver, data = data, msg = msg})
end
local function pre_process(msg)
	local timetoexpire = 'unknown'
	local expiretime = redis:hget ('expiretime', get_receiver(msg))
	local now = tonumber(os.time())
	if expiretime then    
		timetoexpire = math.floor((tonumber(expiretime) - tonumber(now)) / 86400) + 1
		if tonumber("0") > tonumber(timetoexpire) and not is_sudo(msg) then
		if get_receiver(msg) then
		redis:del('expiretime', get_receiver(msg))
		rem_mutes(msg.to.id)
		superrem2(msg)
		return send_large_msg(get_receiver(msg), '<i>تاریخ اتقضاء گروه به پایان رسید.</i>\n <i>از پشتیبانی در خواست تمدید کنید.</i>[ @Wow_heh ] \n <i>اگر ریپورت هستید به ربات ما مراجعه کنید</i> [ @Wow_heh_bot ]')
		else
			return
		end
	end
	if tonumber(timetoexpire) == 0 then
			if redis:hget('expires0',msg.to.id) then return msg end
		local user = "user#id"..305755551
		local text = "<i>تاریخ انقضای گروه ارسال شده به پایان رسیده است</i>"
			local text12 = "0"
			local data = load_data(_config.moderation.data)
			local group_owner = data[tostring(msg.to.id)]['set_owner']
			if not group_owner then
group_owner = "---"
end
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if not group_link then
group_link = "---"
end
local exppm = '🔊 <i>شارژ گروه به پایان رسید</i>\n'
..'----------------------------------\n'
..'> <i>نام گروه</i> : [<i>'..msg.to.title..'</i>] \n'
..'> <i>شناسه گروه</i> : [<i>'..msg.to.id..'</i>] \n'
..'> <i>مالک گروه</i> :  [<i>'..group_owner..'</i>] \n'
..'> <i>لینک ورود به گروه</i> : ['..group_link..']\n'
..'> <i>اعتبار باقی مانده</i> :\n['..text12..']\n'
..'----------------------------------\n'
..'<i>🔖شارژ گروه(مدت1 ماه) :</i>\n'
..'/setexp_'..msg.to.id..'_30\n'
..'<i>🔖شارژ گروه(مدت3 ماه)</i> :\n'
..'/setexp_'..msg.to.id..'_90\n'
..'<i>🔖شارژ گروه(نامحدود)</i> :\n'
..'/setexp_'..msg.to.id..'_999\n'
..'----------------------------------\n'
..'@Wow_heh'
			local sends = send_msg(user, exppm, ok_cb, false)   
			send_large_msg(get_receiver(msg), '<i>تاریخ انقضاء گروه به پایان رسید!(فعالیت ربات متوقف خواهد شد)\nنسبت به تمدید اقدام کنید.</i>[ Wow_heh] \n <i>اگر ریپورت هستید به ربات ما مراجعه کنید</i> [ @Wow_heh_bot]')
   redis:hset('expires0',msg.to.id,'0')
	end
	if tonumber(timetoexpire) == 1 then
			if redis:hget('expires1',msg.to.id) then return msg end
      local user = "user#id"..219201071
			local text2 = "(1) <i>روز تا پایان تاریخ انقضاء گروه باقی مانده است\nنسبت به تمدید اقدام کنید.</i>[ Wow_heh ] \n <i>اگر ریپورت هستید به ربات ما مراجعه کنید</i> [ @Wow_heh_bot ]"
			local text13 = "1"
			local data = load_data(_config.moderation.data)
			local group_owner = data[tostring(msg.to.id)]['set_owner']
			if not group_owner then
group_owner = "---"
end
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if not group_link then
group_link = "---"
end
local exppm = '<i>🔊 شارژ گروه به پایان رسید</i>\n'
..'----------------------------------\n'
..'> <i>نام گروه</i> : [<i>'..msg.to.title..'</i>] \n'
..'> <i>شناسه گروه</i> : [<i>'..msg.to.id..'</i>] \n'
..'> <i>مالک گروه</i> : [<i>'..group_owner..'</i>] \n'
..'> <i>لینک ورود به گروه</i> : ['..group_link..'] \n'
..'> <i>اعتبار باقی مانده</i> :\n['..text13..']\n'
..'----------------------------------\n'
..'<i>🔖شارژ گروه(مدت1 ماه)</i> :\n'
..'/setexp_'..msg.to.id..'_30\n'
..'<i>🔖شارژ گروه(مدت3 ماه)</i> :\n'
..'/setexp_'..msg.to.id..'_90\n'
..'<i>🔖شارژ گروه(نامحدود)</i> :\n'
..'/setexp_'..msg.to.id..'_999\n'
..'----------------------------------\n'
..'@Wow_heh'
		local sends = send_msg(user, exppm, ok_cb, false)
			send_large_msg(get_receiver(msg), '(1) <i>روز تا پایان تاریخ انقضاء گروه باقی مانده است\nنسبت به تمدید اقدام کنید.</i> [ @Wow_heh ] \n <i>اگر ریپورت هستید به ربات ما مراجعه کنید</b> [ @Wow_heh_bot ]')
		redis:hset('expires1',msg.to.id,'1')
	end
	if tonumber(timetoexpire) == 2 then
		if redis:hget('expires2',msg.to.id) then return msg end
		send_large_msg(get_receiver(msg), '(2) <i>روز تا پایان تاریخ انقضاء گروه باقی مانده است\nنسبت به تمدید اقدام کنید.</i> [ @Wow_heh ] \n <i>اگر ریپورت هستید به ربات ما مراجعه کنید</i> [ @Wow_heh_bot ]')
		redis:hset('expires2',msg.to.id,'2')
	end
	if tonumber(timetoexpire) == 3 then
					if redis:hget('expires3',msg.to.id) then return msg end
		send_large_msg(get_receiver(msg), '(3) <i>روز تا پایان تاریخ انقضاء گروه باقی مانده است\nنسبت به تمدید اقدام کنید.</i>[ @Wow_heh ] \n <i>اگر ریپورت هستید به ربات ما مراجعه کنید</i> [ @Wow_heh_bot ]')
			redis:hset('expires3',msg.to.id,'3')
	end
	if tonumber(timetoexpire) == 4 then
					if redis:hget('expires4',msg.to.id) then return msg end
		send_large_msg(get_receiver(msg), '(4) <i>روز تا پایان تاریخ انقضاء گروه باقی مانده است\nنسبت به تمدید اقدام کنید.</i>[ @Wow_heh_bot ] \n <i>اگر ریپورت هستید به ربات ما مراجعه کنید</i> [ @Mrr619bot ]')
		redis:hset('expires4',msg.to.id,'4')
	end
	if tonumber(timetoexpire) == 5 then
					if redis:hget('expires5',msg.to.id) then return msg end
		send_large_msg(get_receiver(msg), '(5) <i>روز تا پایان تاریخ انقضاء گروه باقی مانده است\nنسبت به تمدید اقدام کنید.</i>[ @Wow_heh ] \n <i>اگر ریپورت هستید به ربات ما مراجعه کنید</i> [ @Mrr619bot ]')
		redis:hset('expires5',msg.to.id,'5')
	end
end
return msg
end
function run(msg, matches)
	if matches[1]:lower() == 'setexpire' then
		if not is_sudo(msg) then return end
		local time = os.time()
		local buytime = tonumber(os.time())
		local timeexpire = tonumber(buytime) + (tonumber(matches[2]) * 86400)
		redis:hset('expiretime',get_receiver(msg),timeexpire)
		return "<i>🔖 انجام شد:\n> مدت زمان انقضاء گروه به</i> [<b>"..matches[2].. "</b>] <i>روز دیگر تنظیم شد.</i>"
	end
	
	if matches[1]:lower() == 'setexp' then
		if not is_sudo(msg) then return end
    local expgp = "channel#id"..matches[2]
		local time = os.time()
		local buytime = tonumber(os.time())
		local timeexpire = tonumber(buytime) + (tonumber(matches[3]) * 86400)
		redis:hset('expiretime',expgp,timeexpire)
		return "🔖<i> انجام شد:\n> مدت زمان انقضاء گروه به</i> [<b>"..matches[3].. "</b>] <i>روز دیگر تنظیم شد.</i>"
	end
	if matches[1]:lower() == 'expire' then
		local expiretime = redis:hget ('expiretime', get_receiver(msg))
		if not expiretime then return '<i>تاریخ انقضاء گروه ثبت نشده است!</i>' else
			local now = tonumber(os.time())
			local text = (math.floor((tonumber(expiretime) - tonumber(now)) / 86400) + 1)
			return (math.floor((tonumber(expiretime) - tonumber(now)) / 86400) + 1) .. " <i>روز دیگر تا پایان مدت کارکرد ربات در گروه باقی مانده است(در صورت تمایل به شارژ مجدد عبارت زیر را ارسال کنید)</i>\n /charge"
		
		end
		end
			if matches[1]:lower() == 'charge' then
			if not is_owner(msg) then return end
			local expiretime = redis:hget ('expiretime', get_receiver(msg))
			local now = tonumber(os.time())
			local text4 = (math.floor((tonumber(expiretime) - tonumber(now)) / 86400) + 1)
			if not expiretime then 
				expiretime = "-"
				end
local text3 = "<i>درخواست شارژ گروه توسط صاحب گروه ارسال شده است</i>"
local user = "user#id"..305755551
local data = load_data(_config.moderation.data)
local group_owner = data[tostring(msg.to.id)]['set_owner']
if not group_owner then
group_owner = "---"
end
local group_link = data[tostring(msg.to.id)]['settings']['set_link']
if not group_link then
group_link = "---"
end
local exppm = '🔊 <i>درخواست شارژ گروه</i>\n'
..'----------------------------------\n'
..'> <i>نام گروه</i> : [<i>'..msg.to.title..'</i>] \n'
..'> <i>شناسه گروه</i> : [<i>'..msg.to.id..'</i>] \n'
..'> <i>مالک گروه</i> :  [<i>'..group_owner..'</i>] \n'
..'> <i>لینک ورود به گروه</i> : ['..group_link..'] \n'
..'> <i>اعتبار باقی مانده</i> : ['..text4..']  \n'
..'> <i>متن ارسالی</i> :\n['..text3..']  \n'
..'----------------------------------\n'
..'<i>🔖شارژ گروه(مدت1 ماه)</i> :\n'
..'/setexp_'..msg.to.id..'_30 +'..text4..'\n'
..'🔖<i>شارژ گروه(مدت3 ماه)</i> :\n'
..'/setexp_'..msg.to.id..'_90 +'..text4..'\n'
..'🔖<i>شارژ گروه(نامحدود)</i> :\n'
..'/setexp_'..msg.to.id..'_999\n'
..'----------------------------------\n'
..'@Wow_heh'
			local sends = send_msg(user, exppm, ok_cb, false)
		return "<i> > درخواست شارژ مجدد گروه برای ادمین ربات ارسال گردید </i>"
end
end
return {
  patterns = {
    "^(setexpire) (.*)$",
		"^(setexp)_(.*)_(.*)$",
	  "^(expire)$",
		"^(charge)$",
		"^[!#/](charge)$",
		"^[!#/](setexpire) (.*)$",
		"^[!#/](setexp)_(.*)_(.*)$",
	"^[!#/](expire)$",
  },
  run = run,
  pre_process = pre_process
}
