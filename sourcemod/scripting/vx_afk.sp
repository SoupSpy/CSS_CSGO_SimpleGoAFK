#include <multicolors>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "0.4"
#define VXSOUND_DENY "buttons/button11.wav"
#define VXSOUND_SUCCESS "buttons/bell1.wav"

public Plugin myinfo = 
{
	name = "[VX] AFK", 
	author = "Yekta.T", 
	description = "Allows players to use the commands !afk & !unafk", 
	version = PLUGIN_VERSION, 
	url = "vortexguys.com"
};

ConVar gc_enabled;
ConVar gc_minhp;
ConVar gc_chatprint;
ConVar gc_soundnotify;

bool gb_enabled;
int gi_minhp;
int gi_chatprint;
int gi_soundnotify;

int nHealthOffset = -1;

//#define prefix "{darkred}[ {olive}VortéX AFK {darkred}]{default}"
#define MAX_MESSAGE_LENGTH 250

static char gs_Teams[2][] = { "{red}Terrorists{default}", "{blue}Counter-Terrorists{default}" };

int g_ioldTeam[MAXPLAYERS + 1] = { 0, ... };

public void OnPluginStart()
{
	gc_enabled = CreateConVar("sm_vxafk_enabled", "1", "0 disables the plugin, 1 enables it", _, true, 0.0, true, 1.0);
	gc_minhp = CreateConVar("sm_vxafk_minhp", "50", "Minimum required hp to go afk.", _, true, 0.0);
	gc_chatprint = CreateConVar("sm_vxafk_chatprint", "3", "0 -> disable for all 1 -> disable for command user only 2 -> disable for all except command user 3 -> print all chat messages", _, true, 0.0, true, 3.0);
	gc_soundnotify = CreateConVar("sm_vxafk_soundnotify", "3", "0 -> Disable all sound notification 1 -> Disable deny sound notification 2 -> Disable success sound notification 3-> Enable all sound notifications", _, true, 0.0, true, 3.0);
	
	
	AddCommandListener(Callback_Chat, "say");
	AddCommandListener(Callback_Chat, "say2");
	AddCommandListener(Callback_Chat, "say_team");
	
	HookConVarChange(gc_enabled, Callback_ConvarChange);
	HookConVarChange(gc_minhp, Callback_ConvarChange);
	HookConVarChange(gc_soundnotify, Callback_ConvarChange);
	HookConVarChange(gc_chatprint, Callback_ConvarChange);
	
	nHealthOffset = FindSendPropInfo("CBasePlayer", "m_iHealth");
	if (nHealthOffset == -1)
	{
		LogError("[VX AFK] Couldn't register prop info: m_iHealth. Therefore min hp is set to 0");
		gi_minhp = 0;
	}
	
	
	LoadTranslations("vx_afk.phrases.txt");
	AutoExecConfig(true, "vx_afk");
}

public void OnMapStart()
{
	PrecacheSound(VXSOUND_DENY, true);
	PrecacheSound(VXSOUND_SUCCESS, true);
}

public void OnConfigsExecuted()
{
	gb_enabled = GetConVarBool(gc_enabled);
	gi_minhp = GetConVarInt(gc_minhp);
	gi_chatprint = GetConVarInt(gc_chatprint);
	gi_soundnotify = GetConVarInt(gc_soundnotify);
}

public void Callback_ConvarChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if (StrEqual(oldValue, newValue))return;
	
	if (convar == gc_enabled)
	{
		gb_enabled = StringToInt(newValue) ? true:false;
	}
	else if (convar == gc_minhp)
	{
		gi_minhp = StringToInt(newValue);
	} else if (convar == gc_chatprint)
	{
		gi_chatprint = StringToInt(newValue);
	} else if (convar == gc_soundnotify)
	{
		gi_soundnotify = StringToInt(newValue);
	}
}

public void OnClientPutInServer(int client)
{
	if (gb_enabled)
	{
		g_ioldTeam[client] = 0;
	}
}

public Action Callback_Chat(int client, const char[] command, int argc)
{
	if (!gb_enabled)
		return Plugin_Continue;
	
	char sArgs[MAX_MESSAGE_LENGTH];
	GetCmdArg(1, sArgs, sizeof(sArgs));
	
	StripQuotes(sArgs);
	TrimString(sArgs);
	
	int team = GetClientTeam(client);
	char sName[32]; GetClientName(client, sName, 32);
	
	if (StrEqual(sArgs, "!afk", false) || StrEqual(sArgs, "/afk", false))
	{
		if (team < 2)
		{
			CPrintToChat(client, "%t %t", "prefix", "MustBeInTeam");
			if (gi_soundnotify && gi_soundnotify != 1)
				EmitSoundToClient(client, VXSOUND_DENY);
			return Plugin_Handled;
		}
		if (gi_minhp)
		{
			//int hp = GetEntProp(client, Prop_Data, "m_iHealth");
			int hp = GetEntData(client, nHealthOffset);
			if (hp < gi_minhp)
			{
				CPrintToChat(client, "%t %t", "prefix", "minHp", gi_minhp);
				if (gi_soundnotify && gi_soundnotify != 1)
					EmitSoundToClient(client, VXSOUND_DENY);
				return Plugin_Handled;
			}
		}
		g_ioldTeam[client] = team;
		ChangeClientTeam(client, 1);
		
		if (gi_chatprint && gi_chatprint != 1)
			CPrintToChat(client, "%t %t", "prefix", "nowAfk");
		if (gi_chatprint && gi_chatprint != 2)
			CPrintToChatAll("%t %t", "prefix", "nowAfkAll", sName);
		
		if (gi_soundnotify && gi_soundnotify != 2)
			EmitSoundToClient(client, VXSOUND_SUCCESS);
		
	} else if (StrEqual(sArgs, "!unafk", false) || StrEqual(sArgs, "/unafk", false))
	{
		if (team < 2)
		{
			int oldteam;
			if (g_ioldTeam[client] > 0)
				oldteam = g_ioldTeam[client];
			else oldteam = GetRandomInt(2, 3);
			
			ChangeClientTeam(client, oldteam);
			if (gi_chatprint && gi_chatprint != 1)
				CPrintToChat(client, "%t %t", "prefix", "unAfk", gs_Teams[oldteam - 2]);
			if (gi_chatprint && gi_chatprint != 2)
				CPrintToChatAll("%t %t", "prefix", "unAfkAll", sName, gs_Teams[oldteam - 2]);
			
			if (gi_soundnotify && gi_soundnotify != 2)
				EmitSoundToClient(client, VXSOUND_SUCCESS);
			
		} else
		{
			CPrintToChat(client, "%t %t", "prefix", "needToBeInSpec");
			if (gi_soundnotify && gi_soundnotify != 1)
				EmitSoundToClient(client, VXSOUND_DENY);
			return Plugin_Handled;
		}
	}
	
	return Plugin_Continue;
}

