---
title: Timer dei nodi e ABM
layout: default
root: ../..
idx: 3.2
description: Impara come creare ABM e timer per modificare i blocchi.
redirect_from:
- /it/chapters/abms.html
- /it/map/abms.html
---

## Introduzione <!-- omit in toc -->

Eseguire periodicamente una funzione su certi nodi è abbastanza comune.
Minetest fornisce due metodi per fare ciò: gli ABM (*Active Block Modifiers*, Modificatori di blocchi attivi) e i timer associati ai nodi.

Gli ABM scansionano tutti i Blocchi Mappa alla ricerca dei nodi che rientrano nei canoni:
essi sono quindi ottimali per quei nodi che si trovano con frequenza in giro per il mondo, come l'erba.
Possiedono un alto consumo della CPU, senza invece pressoché impattare sulla memoria e lo storage.

Per i nodi invece non troppo comuni o che già usano metadati, come le fornaci e i macchinari, dovrebbero venire impiegati i timer.
I timer dei nodi tengon traccia dei timer accodati in ogni Blocco Mappa, eseguendoli quando raggiungono lo zero.
Ciò significa che non hanno bisogno di cercare tra tutti i nodi caricati per trovare un match, bensì, richiedendo un po' più di memoria e storage, vanno alla ricerca dei soli nodi con un timer in corso.

- [Timer dei nodi](#timer-dei-nodi)
- [ABM: modificatori di blocchi attivi](#abm-modificatori-di-blocchi-attivi)
- [Il tuo turno](#il-tuo-turno)

## Timer dei nodi

A ogni nodo è associato un timer.
Questi timer possono essere gestiti ottenendo un oggetto NodeTimerRef (quindi un riferimento, come già visto per gli inventari).

```lua
local timer = minetest.get_node_timer(pos)
timer:start(10.5) -- in secondi
```

Nell'esempio sottostante controlliamo che un timer sia attivo (`is_started()`), da quanto (`get_elapsed()`), quanto manca (`get_timeout()`) e infine lo fermiamo (`stop()`)

```lua
if timer:is_started() then
    print("Il timer sta andando, e gli rimangono " .. timer:get_timeout() .. " secondi!")
    print("Sono passati " .. timer:get_elapsed() .. " secondi")
end

timer:stop()
```

Quando un timer raggiunge lo zero, viene eseguito il metodo `on_timer`, che va dichiarato dentro la tabella di definizione del nodo.
`on_timer` richiede un solo parametro, ovvero la posizione del nodo.

```lua
minetest.register_node("porteautomatiche:porta_aperta", {
    on_timer = function(pos)
        minetest.set_node(pos, { name = "porteautomatiche:porta_chiusa" })
        return false
    end
})
```

Ritornando true, il timer ripartirà (con la stessa durata di prima).

Potresti aver tuttavia notato una limitazione: per questioni di ottimizzazione, infatti, è possibile avere uno e un solo timer per tipo di nodo, e solo un timer attivo per nodo.


## ABM: modificatori di blocchi attivi

Erba aliena, a scopo illustrativo del capitolo, è un tipo d'erba che ha una probabilità di apparire vicino all'acqua.

```lua
minetest.register_node("alieni:erba", {
    description = "Erba Aliena",
    light_source = 3, -- Il nodo irradia luce. Min 0, max 14
    tiles = {"alieni_erba.png"},
    groups = {choppy=1},
    on_use = minetest.item_eat(20)
})

minetest.register_abm({
    nodenames = {"default:dirt_with_grass"}, -- nodo sul quale applicare l'ABM
    neighbors = {"default:water_source", "default:water_flowing"}, -- nodi che devono essere nei suoi dintorni (almeno uno)
    interval = 10.0, -- viene eseguito ogni 10 secondi
    chance = 50, -- possibilità di partire su un nodo ogni 50
    action = function(pos, node, active_object_count,
            active_object_count_wider)
        local pos = {x = pos.x, y = pos.y + 1, z = pos.z}
        minetest.set_node(pos, {name = "alieni:erba"})
    end
})
```

Questo ABM viene eseguito ogni 10 secondi, e per ogni nodo d'erba (`default:default_with_grass`) c'è una possibilità su 50 che l'ABM parta.
Quando ciò accade, un nodo di erba aliena (`alieni:erba`) gli viene piazzato sopra (attenzione, tuttavia, che così facendo, il nodo che c'era prima verrà cancellato, quindi sarebbe meglio controllare prima che sopra ci sia dell'aria)

Specificare dei vicini (*neighbors*) è opzionale.
Se ne vengono specificati più di uno, basterà che uno solo di essi sia presente per soddisfare la condizione.

Anche le possibilità (*chance*) sono opzionali.
Se non vengono specificate, l'ABM verrà sempre eseguito quando le altre condizioni sono soddisfatte.

## Il tuo turno

* Tocco di Mida: tramuta l'acqua in oro con una possibilità di 1 su 100, ogni 5 secondi;
* Decadimento: fai che il legno diventi terra quando questo confina con dell'acqua.
* Al fuoco!: fai prendere fuoco a ogni blocco d'aria (suggerimento: "air" e "fire:basic_flame"). Avvertenza: aspettati un crash del gioco
