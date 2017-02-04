
do
 function run(msg, matches)
   if msg.to.type == 'channel' then 
   if not is_owner(msg) then
    return
    end
   return [[<b>SuperGroup Helps:👇🏻</b> 
 
<i>⚓️!block 
Kicks a user from SuperGroup 
 
⚓️!ban 
Bans user from the SuperGroup 
 
⚓️!unban 
Unbans user from the SuperGroup 
 
⚓️!id from 
Get ID of user message is forwarded from 
 
⚓️!promote [username|id] 
Promote a SuperGroup moderator 
 
⚓️!demote [username|id] 
Demote a SuperGroup moderator 
 
⚓️[!setname|!setphoto|!setrules|!setabout] 
Sets the chat name, photo, rules, about text 
 
⚓️!newlink 
Generates a new group link 
 
⚓️!link 
Retireives the group link 
 
⚓️[!lock|!unlock] [links|flood|spam|Arabic|member|rtl|sticker|contacts|strict|media|bots|fwd|reply|share|tag|number|operator|poker] 
Lock group settings 
 
⚓️[!mute|!unmute] [all|audio|gifs|photo|video|service] 
mute group message types 
 
⚓️!setflood [value] 
Set [value] as flood sensitivity, Max:20 and Min:5 
 
⚓️!settings 
Returns chat settings 
 
⚓️[!muteslist|!mutelist] 
Returns mutes or mute lists for chat 
 
⚓️!muteuser [username] 
Mute a user in chat 
 
⚓️!banlist 
Returns SuperGroup ban list 
 
⚓️!clean [rules|about|modlist|mutelist] 
 
⚓️!del 
Deletes a message by reply 
 
⚓️!public [yes|no] 
Set chat visibility in pm !chats or !chatlist commands 
 
SuperGroup Commands: (For memebers and moderators!) 
 
⚓️!info 
Displays general info about the SuperGroup 
 
⚓️!admins 
Returns SuperGroup admins list 
 
⚓️!owner 
Returns group owner 
 
⚓️!modlist 
Returns Moderators list 
 
⚓️!id 
Return SuperGroup ID or user id 
 
⚓️!kickme 
Kicks user from SuperGroup 
 
⚓️!note text 
add a note 
 
⚓️!mynote 
get note 
 
⚓️!tosticker 
create sticker with a photo 
 
⚓️!tophoto 
create photo with a sticker 
 
⚓️!rules 
Retrieves the chat rules 
 
⚓️!chats 
show list of bot groups in pv</i>]]
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
