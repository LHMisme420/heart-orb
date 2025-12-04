using { /Verse.org/Math }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/Audio }

proximity_merge_logic := class:

    public Player : agent
    public OrbMesh : static_mesh_component
    public GlowTrail : particle_system_component
    public CurrentWarmth : float = 0.0
    public IsMerged : bool = false
    public HapticHandle : haptic_feedback_handle

    Init(P:agent):void=
        Player := P
        OrbMesh.SetMaterial(0, MI_Orb_Base)
        GlowTrail.Deactivate()

    Tick(DeltaTime:float):void=
        if (IsMerged = false):
            Nearest := FindNearestOtherOrb()
            if (Nearest?, Distance := vector{}.Distance(GetTransform().Translation, Nearest.GetTransform().Translation)):
                if (Distance < 400.0): # ~8 meters in game
                    CurrentWarmth := CurrentWarmth + DeltaTime * 0.5
                    UpdateVisualWarmth()
                    PlayHeartbeat()

                    if (CurrentWarmth >= 60.0): # 60 seconds of proximity
                        MergeWith(Nearest)
                else:
                    CurrentWarmth := Max(0.0, CurrentWarmth - DeltaTime * 0.3)

    UpdateVisualWarmth():void=
        T := Clamp(CurrentWarmth / 60.0, 0.0, 1.0)
        OrbMesh.SetMaterial(0, LerpMaterial(MI_Orb_Base, MI_Orb_Warm, T))
        OrbMesh.SetScalarParameterValue("GlowIntensity", T * 5.0)

    PlayHeartbeat():void=
        Intensity := CurrentWarmth / 60.0
        if (HapticHandle?, IsValid(HapticHandle) = false):
            HapticHandle := Player.PlayHapticFeedback(heartbeat_haptic_asset{}, Intensity, Intensity)

    MergeWith(Other:proximity_merge_logic):void=
        IsMerged := true
        Other.IsMerged := true
        GlowTrail.Activate(true)
        Other.GlowTrail.Activate(true)
        Player.ApplyMaterialOverrideToAllCosmetics(MI_ParticleTrail) # permanent trail
        PlaySoundAtLocation(S_Heartbeat_Sync, GetTransform().Translation, 1.0)
