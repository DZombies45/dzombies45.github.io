---
title: silky spawner scripg
date: 2024-12-16 07:04:08 +0700
categories: [addon]
tags: [addon, tutorial]
description: >-
    the script of silky mob spawner addon
---

# silk spawner code

just copy this code, and paste it on your behavior pack script

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
    "minecraft:netherite_pickaxe"
];

// on block break
world.beforeEvents.playerBreakBlock.subscribe(
    data => {
        // extrack data
        const { block, player, itemStack } = data;

        // verify if hold item match pickaxe list above and has silk touch enchantment
        if (!itemStack || !pickaxe.includes(itemStack.typeId)) return;
        if (
            !itemStack.getComponent("enchantable")?.getEnchantment("silk_touch")
        )
            return;

        // what to do after
        const spawnPos = centerBlockToEntity(centerBlock.above(1).location);

        // spawn the item, on active tick, couse beforeEvents run on idle tick or read only
        system.run(() =>
            block.dimension.spawnItem(block.getItemStack(1, true), spawnPos)
        );
    },
    {
        blockTypes: ["minecraft:mob_spawner"]
    }
);

// convert block position to entity location
function centerBlockToEntity(pos) {
    return {
        x: pos.x + 0.5,
        y: pos.y + 0.5,
        z: pos.z + 0.5
    };
}

// just to check if addon work or not
world.afterEvents.playerSpawn.subscribe(data => {
    if (!data.initialSpawn) return;
    data.player.sendMessage({
        rawtext: [
            {
                text: `§2+ §asilky mob spawn v${version} is installed`
            }
        ]
    });
});
```
