
do
 function run(msg, matches)
   if msg.to.type == 'channel' then 
   if not is_owner(msg) then
    return
    end
   return [[🔰 تعرفه ربات🔰
 
➖➖➖➖➖➖➖➖➖
برای خریـــد👈      @Wow_heh_bot
➖➖➖➖➖➖➖➖➖
💵یک مــاه :     5000 تومــان🎗
💴دو مـــاه :   9000 تومــان🎗
💴سه مــاه: 13000

💶سه ماه : دو. ربــاتــ:♲
17000
  هــزيــنه بـــه صورتــــ: انجام مـيــشود🔰
1⇇كــارتـــ به كــارتــ🎗
2⇇كــارتــ شــارژ بــيشتر🎗
➖➖➖➖➖➖➖➖➖
پشتیــبــانی 🌐                                        
 @Wow_heh
➖➖➖➖➖➖➖➖]]
end
 end
return {
patterns = {
"^[/!#]([Nn]erkh)$",
"^nerkh$",
"^نرخ$",
},
run = run
}
end
