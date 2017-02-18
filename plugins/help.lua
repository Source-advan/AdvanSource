
do
 function run(msg, matches)
   if msg.to.type == 'channel' then 
   if not is_owner(msg) then
    return
    end
   return [[<b>Helps:👇🏻</b> 
⚓️ /active
برای دریافت اعضای فعال گرو

⚓️ /sticker _text_ _Color_
برای دریافت استیکر متن درخواستی شما
(red,black,blue,green,yellow,pink,orange,brown)

⚓️ /time
برای دریافت ساعت

⚓️/tosticker 
تبدیل عکس شما به استیکر 

⚓️ /tophoto 
تبدیل استیکر شما به عکس
 end
  end
return {
patterns = {
"^[/!#]([Hh]elp)$",
"^help$",
"^راهنما$",
},
run = run
}
end
