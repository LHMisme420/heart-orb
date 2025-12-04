# Simple manager to keep two players’ controllers beating in sync
heartbeat_manager := class:
    public static SyncPair(Orb1:proximity_merge_logic, Orb2:proximity_merge_logic):void=
        Intensity := 0.8
        Orb1.Player.PlayHapticFeedback(heartbeat_haptic_asset{}, Intensity, Intensity)
        Orb2.Player.PlayHapticFeedback(heartbeat_haptic_asset{}, Intensity, Intensity)
