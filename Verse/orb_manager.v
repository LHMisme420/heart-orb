using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Verse.org/Math }
using { /UnrealEngine.com/Temporary/Audio }

orb_manager := class(creative_device):
    
    @editable
    OrbAsset : creative_prop_asset = creative_prop_asset{}
    
    @editable
    PropManip : prop_manipulator_device = prop_manipulator_device{}
    
    @editable
    HeartbeatHaptic : haptic_feedback_asset = haptic_feedback_asset{}
    
    @editable
    HeartbeatSound : sound_asset = sound_asset{}
    
    @editable
    OrbMatInstance : material_instance_dynamic = material_instance_dynamic{}  # Your emissive sphere mat w/ "Warmth" scalar param (0-1)
    
    var PlayerOrbs : map[player, creative_prop] = map{}
    var PlayerWarmth : map[player, float] = map{}
    var MergedPlayers : set[player] = set{}
    
    OnBegin<override>()<suspends>:void=
        # Hide weapons, set peaceful mode? (Use Mutator Device separately)
        spawn{
            loop:
                UpdateOrbsAndWarmth()
                Sleep(0.05)  # 20Hz smooth
        }
    
    UpdateOrbsAndWarmth():void=
        AllPlayers := GetPlayspace().GetPlayers()
        for (PlayerM : AllPlayers):
            if (Player := PlayerM?):
                if (FortChar := ^Player.GetFortCharacter()):
                    OrbOffset := vector3{Z=250.0}  # Float above head
                    OrbLoc := FortChar.GetTransform().Translation + rotate_vector_by(OrbOffset, FortChar.GetTransform().Rotation)
                    OrbRot := FortChar.GetTransform().Rotation
                    
                    # Spawn/move orb
                    if (var Orb; PlayerOrbs.TryGet(Player, Orb)):
                        PropManip.SetPropWorldTransform(Orb, transform{Translation := OrbLoc, Rotation := OrbRot})
                    else:
                        NewOrb := SpawnProp(OrbAsset, OrbLoc, OrbRot)
                        PlayerOrbs[Player] := NewOrb
                        PropManip.SetPropMaterial(NewOrb, 0, OrbMatInstance)
                    
                    # Warmth calc (nearest player dist)
                    NearestDist := 999999.0
                    for (OtherM : AllPlayers):
                        if (Other := OtherM? , Other != Player):
                            if (OtherChar := ^Other.GetFortCharacter()):
                                Dist := vector3.Distance(OrbLoc, OtherChar.GetTransform().Translation)
                                if (Dist < NearestDist):
                                    NearestDist := Dist
                    
                    # Update warmth
                    if (var CurrentWarmth; PlayerWarmth.TryGet(Player, CurrentWarmth)):
                        if (NearestDist < 400.0):  # 8m
                            NewWarmth := CurrentWarmth + 0.025  # ~1 per sec
                            PlayerWarmth[Player] := FMin(NewWarmth, 60.0)
                            # Haptic pulse
                            Intensity := FMin(CurrentWarmth / 60.0, 1.0)
                            _ := Player.PlayHapticFeedback(HeartbeatHaptic, Intensity, Intensity)
                            # Soft heartbeat sound
                            PropManip.PlayFortAudio2DAtLocation(Player, HeartbeatSound, Intensity)
                        else:
                            Decay := FMax(0.0, CurrentWarmth - 0.015)
                            PlayerWarmth[Player] := Decay
                    
                    # Visual update
                    if (Warmth := ^PlayerWarmth.TryGet(Player)):
                        T := FClamp(Warmth / 60.0, 0.0, 1.0)
                        PropManip.SetScalarParameterValueOnPropMaterial(PlayerOrbs[Player], 0, "Warmth", T * 5.0)  # Glow 0-5
                    
                    # Check merge
                    if (Warmth >= 60.0 , MergedPlayers.Contains(Player) = false):
                        MergePlayer(Player)
    
    MergePlayer(P:player):void=
        MergedPlayers.Add(P)
        # Permanent max glow + trail (spawn persistent trail particle on orb)
        PropManip.SetScalarParameterValueOnPropMaterial(PlayerOrbs[P], 0, "Warmth", 5.0)
        # TODO: Spawn/activate trail Niagara on orb (use PropManip.AttachParticleSystem if avail)
        # Sync haptic burst
        _ := P.PlayHapticFeedback(HeartbeatHaptic, 0.8, 0.8)
        Print("🤍 {P.GetName()} merged!")
