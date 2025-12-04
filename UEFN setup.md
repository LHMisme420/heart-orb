# UEFN Build Guide (<2hrs)

## 1. Prerequisites
- Enroll Island Creator: create.fortnite.com/enroll (instant if Fortnite verified) [](grok_render_citation_card_json={"cardIds":["70bfc3","4a5448"]})
- Epic Launcher → Library → Install Fortnite + UEFN (free).

## 2. New Project
- Launch UEFN → New Project → "Empty Island"
- Save: "HeartOrb_v1"

## 3. Map (10min)
- Devices tab → Search "Environment Spawner" → Drop Winter Forest pack (free Marketplace).
- Scale flat snow area 5x5km. Foggy twilight lighting (Sky device).

## 4. Assets (20min)
- **Orb Prop**: Props → Basic → Sphere (scale 0.6). Material: New Material Instance (Emissive white, Scalar Param "Warmth" drives color lerp white→pink + emissive 0-5).
- **Haptic**: Content Browser → New → Haptic Feedback → "Heartbeat" preset.
- **Sound**: Free 60bpm heartbeat (Marketplace or import public domain WAV).
- **Trail**: New Niagara → Ribbon emitter (white→pink particles). (Optional for v1).

## 5. Devices
- Drop Prop Manipulator Device (link to all orbs later).
- Verse Explorer → Right-click project → New Verse File → Paste orb_manager.v → Compile (fix imports if needed).
- Drop orb_manager Device → Edit: Assign OrbAsset=Sphere, PropManip=your manip, Haptics/Sound/Mat.

## 6. Polish
- Mutator Device: Disable weapons, jumping? Set peaceful.
- Round Timer? Infinite.
- Title: 🤍 | Description blank.

## 7. Test & Publish
- Play → Verify: Orbs follow, glow on approach, haptic after 60s.
- ESC → My Islands → Publish → "Unlisted" → Copy 12-digit code (e.g. 8274-9421-8910).
- Update README with code.

## Seed
TikTok: 11yo streamers play live, "🤍 island... feels good weird".
