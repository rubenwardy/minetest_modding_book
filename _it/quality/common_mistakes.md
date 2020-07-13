---
title: Errori comuni
layout: default
root: ../..
idx: 8.1
redirect_from: /it/chapters/common_mistakes.html
---

## Introduzione <!-- omit in toc -->

Questo capitolo illustra gli errori più comuni e come evitarli.

- [Non salvare mai ObjectRef (giocatori ed entità)](#non-salvare-mai-objectref-giocatori-ed-entita)
- [Non fidarti dei campi dei formspec](#non-fidarti-dei-campi-dei-formspec)
- [Imposta gli ItemStack dopo averli modificati](#imposta-gli-itemstack-dopo-averli-modificati)

## Non salvare mai ObjectRef (giocatori ed entità)

Se l'oggetto rappresentato da un ObjectRef viene rimosso - per esempio quando il giocatore si disconnette o un'entità viene rimossa dalla memoria - chiamare metodi su quell'oggetto causerà la chiusura improvvisa del server (*crash*).

Sbagliato:

```lua
minetest.register_on_joinplayer(function(player)
    local function func()
        local pos = player:get_pos() -- MALE!
        -- `player` viene salvato per essere utilizzato dopo.
        -- Se il giocatore si disconnette, il server crasha
    end

    minetest.after(1, func)

    foobar[player:get_player_name()] = player
    -- RISCHIOSO
    -- Non è consigliato fare così.
    -- Usa invece minetest.get_connected_players() e minetest.get_player_by_name().
end)
```

Giusto:

```lua
minetest.register_on_joinplayer(function(player)
    local function func(name)
        -- Tenta di ottenere il riferimento
        local player = minetest.get_player_by_name(name)

        -- Controlla che il giocatore sia online
        if player then
            -- è online, procedo
            local pos = player:get_pos()
        end
    end

    -- Passa il nome nella funzione
    minetest.after(1, func, player:get_player_name())
end)
```

## Non fidarti dei campi dei formspec

Client malevoli possono compilare i campi nei formspec quando vogliono, con qualsiasi contenuto vogliono.

Per esempio, il seguente codice presenta una vulnerabilità che permette ai giocatori di assegnarsi da soli il privilegio di moderatore:

```lua
local function show_formspec(name)
    if not minetest.check_player_privs(name, { privs = true }) then
        return false
    end

    minetest.show_formspec(name, "modman:modman", [[
        size[3,2]
        field[0,0;3,1;target;Nome;]
        button_exit[0,1;3,1;sub;Promuovi]
    ]])
    return true
})

minetest.register_on_player_receive_fields(function(player,
        formname, fields)
    -- MALE! Manca il controllo dei privilegi!

    local privs = minetest.get_player_privs(fields.target)
    privs.kick  = true
    privs.ban   = true
    minetest.set_player_privs(fields.target, privs)
    return true
end)
```

Aggiungi un controllo dei privilegi per ovviare:

```lua
minetest.register_on_player_receive_fields(function(player,
        formname, fields)
    if not minetest.check_player_privs(name, { privs = true }) then
        return false
    end

    -- code
end)
```

## Imposta gli ItemStack dopo averli modificati

Se ci si fa caso, nella documentazione si parla di `ItemStack` e non `ItemStackRef`.
Questo perché gli ItemStack NON sono un riferimento, bensì una copia.
Questo vuol dire che modificando la copia, non si modificherà in automatico anche l'originale.

Sbagliato:

```lua
local inv = player:get_inventory()
local pila = inv:get_stack("main", 1)  -- lo copio
pila:get_meta():set_string("description", "Un po' smangiucchiato")
-- MALE! Le modifiche saranno perse
```

Giusto:

```lua
local inv = player:get_inventory()
local pila = inv:get_stack("main", 1)  -- lo copio
pila:get_meta():set_string("description", "Un po' smangiucchiato")
inv:set_stack("main", 1, pila)
-- Corretto! L'ItemStack è stato cambiato con la copia
```

Il comportamento dei callback è leggermente più complicato.

```lua
minetest.register_on_item_eat(function(hp_change, replace_with_item,
        itemstack, user, pointed_thing)
    itemstack:get_meta():set_string("description", "Un po' smangiucchiato")
    -- Quasi corretto! I dati saranno persi se un altro callback annulla questa chiamata
end)
```

Se nessun callback cancella l'operazione, la pila sarà impostata e la descrizione aggiornata; ma se un callback effettivamente cancella l'operazione, l'aggiornamento potrebbe andar perduto.

È meglio quindi fare così:

```lua
minetest.register_on_item_eat(function(hp_change, replace_with_item,
        itemstack, user, pointed_thing)
    itemstack:get_meta():set_string("description", "Un po' smangiucchiato")
    user:get_inventory():set_stack("main", user:get_wield_index(),
            itemstack)
    -- Corretto! La descrizione verrà sempre aggiornata
end)
```
