IncludeScript("defines.nut")
// IncludeScript("mvmtwitch/buster.nut")

function twitchHandler(username, amount, message) {
    ClientPrint(null, 3, "\x07ffffff[\x07ff00fftwitch intergration\x07ffffff] \x07FF3F3F" + username + " \x01donated: \x03$" + amount/100 + " \x01with message: " + message)
    switch (amount) {
        case 1200: // $12.00
            ClientPrint(null, 3, "\x07FF3F3F" + username + "\x01 donated \x03$" + amount/100 + "\x01, spawning the horseman!")
            SpawnHorseman(username, Constants.ETFTeam.TF_TEAM_PVE_INVADERS)
            break;
        case 2000:
            ChangePlayerTeamMvM(GetListenServerHost(), Constants.ETFTeam.TF_TEAM_PVE_INVADERS) //Constants.ETFTeam.TF_TEAM_BLUE is also perfectly valid
            DoEntFire("!self", "RunScriptCode", "self.ForceRespawn()", 0, null, GetListenServerHost());
            ClientPrint(null, 3, "\x07FF3F3F" + username + "\x01 donated \x03$" + amount/100 + "\x01, switching to robot!")
            printl("case for 20 dollars")
            break;
        case 2500:
            Convars.SetValue("sv_gravity", RandomInt(0, 500))
            ClientPrint(null, 3, "\x07FF3F3F" + username + "\x01 donated \x03$" + amount/100 + "\x01, randomising gravity!")
            printl("case for 25 dollars")
            break;
        case 3000:
            SpawnTank()
            ClientPrint(null, 3, "\x07FF3F3F" + username + "\x01 donated \x03$" + amount/100 + "\x01, spawning a tank!!")
            printl("case for 30 dollars")
            break;
    }
}
