---
title: "silky spawner script"
date: 2024-12-14T22:29:48+0700
tags: ["minecraft"]
description: >-
  the script of silky mob spawner addon
lastmod: 2025-12-13T22:29:48+0700
---

# silk spawner code

just copy this code, and paste it on your behavior pack script. or just download the addon [here on **mcpedl**](https://mcpedl.com/silky-mob-spawner/)

{{< youtubeLite id="_mzc4S8TrD0" label="demo" >}}

---

```js
// import minecraft api
import { world, system } from "@minecraft/server";

// addon version
const version = "1.0";

// item use to destroy the spawner
const pickaxe = [
  "minecraft:iron_pickaxe",
  "minecraft:golden_pickaxe",
  "minecraft:diamond_pickaxe",
  "minecraft:netherite_pickaxe",
];

// on block break
world.beforeEvents.playerBreakBlock.subscribe(
  (data) => {
    // extrack data
    const { block, player, itemStack } = data;

    // verify if hold item match pickaxe list above and has silk touch enchantment
    if (!itemStack || !pickaxe.includes(itemStack.typeId)) return;
    if (
      !itemStack
        .getComponent("minecraft:enchantable")
        ?.getEnchantment("silk_touch")
    )
      return;

    data.cancel = true;

    // what to do after
    const spawnPos = centerBlockToEntity(block.location);
    const item = block.getItemStack(1, true);

    // spawn the item and add feedback, on the next active tick, couse beforeEvents run on idle tick or read only
    system.run(() => {
      pickDurability(player);
      block.setType("minecraft:air");
      block.dimension.spawnItem(item, spawnPos);
      player.playSound("block.mob_spawner.break", {
        pitch: randomRange(0.8, 1.2),
        location: block.location,
        volume: 1,
      });
    });
  },
  {
    blockTypes: ["minecraft:mob_spawner"],
  },
);

// convert block position to entity location
function centerBlockToEntity(pos) {
  return {
    x: pos.x + 0.5,
    y: pos.y + 0.5,
    z: pos.z + 0.5,
  };
}

// remove durability from pickaxe
function pickDurability(player) {
  const inv = player.getComponent("inventory").container;
  const item = inv.getItem(player.selectedSlotIndex);
  if (!item) return true;
  const durability = item.getComponent("minecraft:durability");
  const unbreakingLv =
    item.getComponent("minecraft:enchantable")?.getEnchantment("unbreaking")
      ?.level || 0;
  const breakChance = durability.getDamageChance(unbreakingLv);

  if (Math.random() * 100 <= breakChance) durability.damage += 1;
  if (durability.damage >= durability.maxDurability) {
    inv.setItem(player.selectedSlotIndex, undefined);
    player.playSound("random.break", {
      pitch: randomRange(0.8, 1.2),
      location: player.location,
      volume: 1,
    });
    return true;
  }

  inv.setItem(player.selectedSlotIndex, item);
  return false;
}

// just random function
function randomRange(min = 0, max = 1) {
  return Math.random() * (max - min) + min;
}

// just to check if addon work or not
world.afterEvents.playerSpawn.subscribe((data) => {
  if (!data.initialSpawn) return;
  data.player.sendMessage({
    rawtext: [
      {
        text: `§2+ §asilky spawn v${version} is installed`,
      },
    ],
  });
});
```
