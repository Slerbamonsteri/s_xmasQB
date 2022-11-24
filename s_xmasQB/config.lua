Config = {}

--Every player can only claim one gift each tree
Config.maxGifts = 10 --Max gift amount each tree, put ridiculous amount if you want no restriction.

--Enable or disable blips for trees
Config.EnableBlips = true
Config.BlipName = 'Christmas Presents'

--Setup as many trees as you want
Config.Trees = {
  {pos = vector3(242.05, -879.18, 30.49)},
  {pos = vector3(233.09, -875.96, 30.49)},
}


--Setup your default loots
Config.LootTable = {
  [1] = {
    {itemtype = 'item', item = 'bread', amount = 1},
  },
  [2] = {
    {itemtype = 'money', item = 'money', amount = math.random(1,100)},
  },
  [3] = {
    {itemtype = 'weapon', item = 'WEAPON_PISTOL', amount = 1},
  }, --Amount is for ammo when itemtype == weapon
}



--Setup your rare loots
--Check serverside math.randoms and edit to your likings, i defaulted it to 20% chance. Basic maths

Config.RareLootTable = {
  [1] = {
    {itemtype = 'item', item = 'bread', amount = 1},
  },
  [2] = {
    {itemtype = 'money', item = 'money', amount = math.random(1,100)},
  },
  [3] = {
    {itemtype = 'weapon', item = 'WEAPON_PISTOL', amount = 1},
  }, --Amount is for ammo when itemtype == weapon
}