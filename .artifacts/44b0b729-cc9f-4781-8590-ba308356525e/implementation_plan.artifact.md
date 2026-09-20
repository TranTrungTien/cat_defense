# Implementation Plan: Merge Cats: Endless Outpost

This plan outlines the transition of the current "cat_defense" base into the "Merge Cats: Endless Outpost" roguelite lane-defense game. The development is divided into logical phases, prioritizing core combat and the signature merge/evolution mechanic.

## User Review Required

> [!IMPORTANT]
> The transition from level-based to endless run-based gameplay will require a major refactor of `CatDefenseGame` and its wave management.
> The "Team Energy" system will replace the current item-based skill cost.

## Proposed Changes

### Phase 1: Core Combat & Skill Systems
Focus on adding depth to the cats and introducing the shared resource management.

#### [MODIFY] [game_data.dart](file:///C:/Users/cat_defense-master/lib/game_data.dart)
- Update `CatLevelData` to include `activeSkill`, `energyCost`, `cooldown`, and `synergyTags`.
- Update `EnemyTypeData` to include `role` (Walker, Ranged, etc.) and `skills`.

#### [MODIFY] [cat_component.dart](file:///C:/Users/cat_defense-master/lib/components/cat_component.dart)
- Implement `ActiveSkill` activation logic.
- Add `Stability` (HP) and Knock-out state.
- Implement target priorities (Sniper prioritizes elite, etc.).

#### [MODIFY] [cat_defense_game.dart](file:///C:/Users/cat_defense-master/lib/cat_defense_game.dart)
- Add `teamEnergy` (ValueNotifier).
- Implement energy regeneration and gain on kill.
- Add `teamUltimate` progress.

---

### Phase 2: Branching Merge & Evolution
Implement the signature decision-making mechanic during merge.

#### [MODIFY] [placement_slot.dart](file:///C:/Users/cat_defense-master/lib/components/placement_slot.dart)
- Update merge logic to trigger a choice when multiple evolution branches are available.

#### [NEW] [evolution_dialog.dart](file:///C:/Users/cat_defense-master/lib/ui/evolution_dialog.dart)
- A new UI component to show two evolution options with descriptions and stats.

---

### Phase 3: Tactical Zombies & AI Director
Enhance enemy variety and introduce adaptive difficulty.

#### [MODIFY] [enemy_component.dart](file:///C:/Users/cat_defense-master/lib/components/enemy_component.dart)
- Implement `Ranged`, `Support`, and `Disruptor` behaviors.
- Add skill telegraphing and charging states.
- Implement `Morale` and `Rage` (CC resistance).

#### [NEW] [ai_director.dart](file:///C:/Users/cat_defense-master/lib/managers/ai_director.dart)
- Manage wave intensity based on player performance and current build.

---

### Phase 4: Roguelite Loop (Endless Journey)
Implement the map, perks, and biomes.

#### [NEW] [run_manager.dart](file:///C:/Users/cat_defense-master/lib/managers/run_manager.dart)
- Manage the lifecycle of a single run (Starting cats -> Map -> Waves -> Rewards).

#### [NEW] [roguelite_map.dart](file:///C:/Users/cat_defense-master/lib/screens/roguelite_map.dart)
- Node-based map selection (Battle, Elite, Shop, Event).

#### [NEW] [perk_selector.dart](file:///C:/Users/cat_defense-master/lib/ui/perk_selector.dart)
- UI for choosing one of three random perks after waves.

---

### Phase 5: Meta Progression & Online
Persistent upgrades and social features.

#### [MODIFY] [player_data.dart](file:///C:/Users/cat_defense-master/lib/models/player_data.dart)
- Add fields for unlocked cats, base upgrades, and run history.

#### [NEW] [leaderboard_screen.dart](file:///C:/Users/cat_defense-master/lib/screens/leaderboard_screen.dart)
- Show seasonal and daily run rankings.

## Verification Plan

### Automated Tests
- Unit tests for `MergeLogic` to ensure branching works correctly.
- Simulation tests for `AIDirector` to verify wave scaling.

### Manual Verification
- Verify Skill activation UI and cooldown feedback.
- Test "Team Energy" balance in a full wave.
- Verify "Mutation" effects after boss kills.
