# **Description**
- You cannot switch to the spectator team before dying in the game; if you want to switch to the spectator team without losing points by killing yourself, you can use the `!afk` command.
- If the teams are full and you cannot be assigned to the team you selected from the game's team selection menu, you can type `!unafk` to be randomly assigned to a team.

# **Cvar Values**
```c
// 0 -> disable for all 1 -> disable for command user only 2 -> disable for all except command user 3 -> print all chat messages
// -
// Default: "3"
// Minimum: "0.000000"
// Maximum: "3.000000"
sm_vxafk_chatprint "3"

// 0 disables the plugin, 1 enables it
// -
// Default: "1"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_vxafk_enabled "1"

// Minimum required HP to go AFK.
// -
// Default: "50"
// Minimum: "0.000000"
sm_vxafk_minhp "50"

// 0 -> Disable all sound notifications 1 -> Disable deny sound notification 2 -> Disable success sound notification 3 -> Enable all sound notifications
// -
// Default: "3"
// Minimum: "0.000000"
// Maximum: "3.000000"
sm_vxafk_soundnotify "3"
```

# *Translation Values*
```c
"Phrases"
{
	"prefix"
	{
		"tr"	"{darkred}[ {olive}VortéX AFK {darkred}]{default}"
		"en"	"{darkred}[ {olive}VortéX AFK {darkred}]{default}"
	}
	"MustBeInTeam"
	{
		"tr"	"{default}Bu komutu kullanabilmek için bir takımda olmalısın."
		"en"	"{default}You must be in a team to use this command."
	}
	"nowAfk"
	{
		"tr"	"{default}AFK oldunuz."
		"en"	"{default}You are now AFK."	
	}
	"nowAfkAll"
	{
		"#format"	"{1:s}"
		"tr"	"{green}{1}, {default}AFK oldu."
		"en"	"{green}{1} {default}is now AFK."
	}
	"unAfk"
	{
		"#format"	"{1:s}"
		"tr"	"{1} {default}takımına atandınız!"
		"en"	"{default}You have been assigned to the {1} {default}team."
	}
	"unAfkAll"
	{
		"#format"	"{1:s}, {2:s}"
		"tr"	"{green}{1}, {2} {default}takımına atandı!"
	}
	"needToBeInSpec"
	{
		"tr"	"{default}İzleyici takımında olmanız gerekiyor!"
		"en"	"{default}You need to be in the Spectators team!"
	}
	"minHp"
	{
		"#format"	"{1:d}"
		"tr"	"{default}AFK komutunu kullanabilmek için minimum {grey}{1}HP {default}gerekiyor."
		"en"	"{default}To use the AFK command, you must have a minimum of {grey}{1}HP{default}."
	}
}
```