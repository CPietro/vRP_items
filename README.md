# vRP Items

## Description
  With this script it's possible to create custom vRP items, such as driving licenses, bank cards, firearms licenses and so on by signing a simple contract.

## Pictures
<details><summary>SHOW</summary>
<p>

![Image1](https://i.postimg.cc/jd8W2RnT/image.png)
</p>
</details>

## Dependencies
 #### Mandatory
 * [Changes](#changes-to-vrp-mandatory) - Mandatory modifications to vRP;
 
 #### Optionals
 * [vRP_cards](https://github.com/CPietro/vRP_cards) - Cards for players to buy stuff with them;

## Installation
  1. [IMPORTANT!] Install the dependencies first;
  2. Move the [vrp_items](#vrp-items) folder to your ```resources``` directory;
  3. Add "```start vrp_items```" to your server.cfg file;
  4. Make any changes you like to the files in the cfg folder;
  5. Enjoy!

## Instructions
  * To add a new item type, add it to the ```config.itemslist``` table in the ```vrp_items\cfg\config.lua``` file.
  * To add an item which is part of an item type, open the ```vrp_items\cfg\adaptive_items.lua``` file, copy an item which is already there, and edit its values to your liking.
  
## Changes to vRP (mandatory)
  * Add the pen item as below to your ```vrp\cfg\items.lua``` file as below:
    <details><summary>SHOW</summary>
    
    ```lua
    ["penna"] = {"Pen", "Use it to write!", nil, 0.05},
    ```
    </details>

## License
  ```
  vRP Items
  Copyright (C) 2020  CPietro - Discord: @TBGaming#9941

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as published
  by the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.

  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
  ```
