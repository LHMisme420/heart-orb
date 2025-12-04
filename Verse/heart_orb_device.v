using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Fortnite.com/Characters }
using { /Verse.org/Math }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/Audio }

heart_orb_device := class(creative_device):

    @editable
    PlayerOrbClass : bp_heart_orb_player = bp_heart_orb_player{}

    OnBegin<override>()<suspends>:void=
        spawn{ Init() }

    Init():void=
        AllPlayers := GetPlayspace().GetPlayers()
        for (Player : AllPlayers):
            SpawnOrb(Player)

    SpawnOrb(Player:agent):void=
        if (Orb := Spawn[#] PlayerOrbClass):
            Orb.Init(Player)
