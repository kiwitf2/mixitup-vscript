::MAX_WEAPONS <- 8
::MAX_PLAYERS <- MaxClients().tointeger()
::TF_GAMERULES <- Entities.FindByName(null, "tf_gamerules")

PrecacheModel("models/weapons/c_models/c_bigaxe/c_bigaxe.mdl")
PrecacheModel("models/weapons/c_models/c_big_mallet/c_big_mallet.mdl")

::clearCosmetics <- function()
{
    for (local wearable = self.FirstMoveChild(); wearable != null; wearable = wearable.NextMovePeer())
    {
        if(wearable.IsValid() != true)
            continue

        if(wearable.GetClassname() != "tf_wearable" && wearable.GetClassname() != "tf_wearable_campaign_item" && wearable.GetClassname() != "tf_powerup_bottle" && wearable.GetClassname() != "tf_wearable_demoshield")
        {
            continue
        }

        if(wearable != null)
        {
            EntFireByHandle(wearable, "Kill", "", -1, null, null)
        }
    }
}

::ChangePlayerTeamMvM <- function(player, teamnum)
{
	local gamerules = Entities.FindByClassname(null, "tf_gamerules")
	NetProps.SetPropBool(gamerules, "m_bPlayingMannVsMachine", false)
	player.ForceChangeTeam(teamnum, false)
	NetProps.SetPropBool(gamerules, "m_bPlayingMannVsMachine", true)
}

::SpawnTank <- function () {
    local tank_name = DoUniqueString("yoinkedbees_tank");
    local tank = SpawnEntityFromTable("tank_boss", {
        targetname = tank_name,
        health = 20000
    })   
    local ScaleValue = RandomFloat(0.25, 1.0); // random float value between 25% of size and normal size
    tank.SetModelScale(ScaleValue,0.0); 
    tank.SetHealth(50/ScaleValue); // division to allow smaller tanks to have more health
    EntityOutputs.AddOutput(tank, "OnKilled", "boss_dead_relay", "Trigger", "", 0, -1);
    EntityOutputs.AddOutput(tank, "OnUser1", "!self", "FireUser2", "", 8.0, -1);
    EntityOutputs.AddOutput(tank, "OnUser2", "boss_deploy_relay", "Trigger", "", 0.0, -1);

    Entities.FindByName(null, "boss_path_34").AcceptInput("AddOutput", "OnPass " + tank_name + ",FireUser1,,0,-1", null, null);

    EntFireByHandle(tank, "TeleportToPathTrack", "boss_path_1", 0, null, null);
}

::SpawnHorseman <- function(donorname, teamnum) {
    local hhh = Entities.FindByClassname(null, "headless_hatman")

    if (hhh != null)
    {
        local hhhpos = hhh.GetOrigin()
        hhh.SetHealth(hhh.GetHealth() + 3000)
        SendGlobalGameEvent("show_annotation", {
            worldPosX = hhhpos.x
            worldPosY = hhhpos.y
            worldPosZ = hhhpos.z
            id = 0
            text = "" + donorname + " gave the Horseman +3000 HP!"
            lifetime = 3.0
        })
        return hhh
    }

    local hhh_name = DoUniqueString("yoinkedbees_hhh");
    hhh = SpawnEntityFromTable("headless_hatman", {
        targetname = hhh_name,
        team = teamnum
    })
    for (local entity; entity = Entities.FindByClassname(entity, "prop_dynamic");)
    {
        if (entity.GetModelName() == "models/weapons/c_models/c_bigaxe/c_bigaxe.mdl")
            entity.SetModel("models/player/heavy.mdl") // weapons/c_models/c_big_mallet/c_big_mallet.mdl
    }
    local pathpos = Entities.FindByName(null, "boss_path_1b").GetOrigin()
    local startpos = Vector(pathpos.x, pathpos.y - 1700, pathpos.z + 50)
    hhh.SetAbsOrigin(startpos)
    SendGlobalGameEvent("show_annotation", {
        worldPosX = startpos.x
        worldPosY = startpos.y
        worldPosZ = startpos.z
        id = 0
        text = "" + donorname + " has summoned the Horseless Headless Horseman!"
        lifetime = 3.0
    })
    return hhh
}
