---
title: Tipi di nodo
layout: default
root: ../..
idx: 2.3
description: Guida su tutti i tipi di nodo, inclusi cuboidi e mesh.
redirect_from: /it/chapters/node_drawtypes.html
---

## Introduzione <!-- omit in toc -->

Il metodo col quale un nodo viene disegnato in gioco è chiamato *drawtype*.
Ci sono diversi tipi di drawtype: il loro comportamento è determinato dalle proprietà impostate durante la definizione del tipo di nodo.
Queste proprietà sono fisse, uguali per tutte le istanze, tuttavia è possibile manipolarne alcune per singolo nodo usando una cosa chiamata `param2`.

Il concetto di nodo è stato introdotto nello scorso capitolo, ma non è mai stata data una definizione completa.
Il mondo di Minetest è una griglia 3D: un nodo è un punto di quella griglia ed è composto da un tipo (`name`) e due parametri (`param1` e `param2`).
Non farti inoltre ingannare dalla funzione `minetest.register_node`, in quanto è un po' fuorviante: essa non registra infatti un nuovo nodo (c'è solo una definizione di nodo), bensì un nuovo *tipo* di nodo.

I parametri sono infine usati per controllare come un nodo viene renderizzato individualmente: `param1` immagazzina le proprietà di luce, mentre il ruolo di `param2` dipende dalla proprietà `paramtype2`, la quale è situata nella definizione dei singoli tipi.

- [Nodi cubici: normali e a facciate piene](#nodi-cubici-normali-e-a-facciate-piene)
- [Nodi vitrei](#nodi-vitrei)
	- [Vitreo incorniciato](#vitreo-incorniciato)
- [Nodi d'aria](#nodi-d-aria)
- [Luce e propagazione solare](#luce-e-propagazione-solare)
- [Nodi liquidi](#nodi-liquidi)
- [Nodi complessi](#nodi-complessi)
	- [Nodi complessi a muro](#nodi-complessi-a-muro)
- [Nodi mesh](#nodi-mesh)
- [Nodi insegna](#nodi-insegna)
- [Nodi pianta](#nodi-pianta)
- [Nodi fiamma](#firelike-nodes)
- [Altri drawtype](#altri-drawtype)


## Nodi cubici: normali e a facciate piene

<figure class="right_image">
    <img src="{{ page.root }}//static/drawtype_normal.png" alt="Drawtype normale">
    <figcaption>
        Drawtype normale
    </figcaption>
</figure>

Il *drawtype* normale è tipicamente usato per renderizzare un nodo cubico.
Se il lato di uno di questi nodi tocca un nodo solido, allora quel lato non sarà renderizzato, risultando in un grande guadagno sulle prestazioni.

Al contrario, i *drawtype* a facciate piene (*allfaces*) renderizzeranno comunque il lato interno quando è contro un nodo solido.
Ciò è buono per quei nodi con facce in parte trasparenti come le foglie.
Puoi inoltre usare il drawtype `allfaces_optional` per permettere agli utenti di fare opt-out dal rendering più pesante, facendo comportare il nodo come se fosse di tipo normale.

```lua
minetest.register_node("miamod:diamante", {
    description = "Diamante alieno",
    tiles = {"miamod_diamante.png"},
    groups = {cracky = 3},
})

minetest.register_node("default:foglie", {
    description = "Foglie",
    drawtype = "allfaces_optional",
    tiles = {"default_foglie.png"}
})
```

Attenzione: il drawtype normale è quello predefinito, quindi non c'è bisogno di specificarlo ogni volta.

## Nodi vitrei

La differenza tra i nodi vitrei (*glasslike*) e quelli normali è che piazzando i primi vicino a un nodo normale, non nasconderanno il lato di quest'ultimo.
Questo è utile in quanto i nodi vitrei tendono a essere trasparenti, perciò permettono di vedere attraverso.

<figure>
    <img src="{{ page.root }}//static/drawtype_glasslike_edges.png" alt="Bordi vitrei">
    <figcaption>
        Bordi vitrei
    </figcaption>
</figure>

```lua
minetest.register_node("default:obsidian_glass", {
    description = "Vetro d'ossidiana",
    drawtype = "glasslike",
    tiles = {"default_obsidian_glass.png"},
    paramtype = "light",
    is_ground_content = false,
    sunlight_propagates = true,
    sounds = default.node_sound_glass_defaults(),
    groups = {cracky=3,oddly_breakable_by_hand=3},
})
```

### Vitreo incorniciato

Questa opzione crea un solo bordo lungo tutto l'insieme di nodi, al posto di crearne più per singolo nodo.

<figure>
    <img src="{{ page.root }}//static/drawtype_glasslike_framed.png" alt="Bordi vitrei incorniciati">
    <figcaption>
        Bordi vitrei incorniciati
    </figcaption>
</figure>

```lua
minetest.register_node("default:glass", {
    description = "Vetro",
    drawtype = "glasslike_framed",
    tiles = {"default_glass.png", "default_glass_detail.png"},
    inventory_image = minetest.inventorycube("default_glass.png"),
    paramtype = "light",
    sunlight_propagates = true, -- Sunlight can shine through block
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    sounds = default.node_sound_glass_defaults()
})
```

Puoi inoltre usare il *drawtype* `glasslike_framed_optional` per permettere un opt-in all'utente.

## Nodi d'aria

I nodi d'aria (*airlike*) non sono renderizzati e perciò non hanno texture.

```lua
minetest.register_node("miaaria:aria", {
    description = "Mia Aria",
    drawtype = "airlike",
    paramtype = "light",
    sunlight_propagates = true,

    walkable     = false, -- Il giocatore può collidere col nodo
    pointable    = false, -- Non è selezionabile
    diggable     = false, -- Non può essere scavato
    buildable_to = true,  -- Può essere rimpiazzato da altri nodi
                          -- (basta costruire nella stessa coordinata)

    air_equivalent = true,
    drop = "",
    groups = {not_in_creative_inventory=1}
})
```


## Luce e propagazione solare

La luce di un nodo è salvata in `param1`.
Per capire come ombreggiare il lato di un nodo, viene utilizzato il valore di luminosità dei nodi adiacenti.
Questo comporta un blocco della luce da parte dei nodi solidi.

Di base, non viene salvata la luce in nessun nodo né nelle sue istanze.
È invece solitamente preferibile farla passare in tipi quali quelli d'aria e vitrei.
Per fare ciò, ci sono due proprietà che devono essere definite:

```lua
paramtype = "light",
sunlight_propagates = true,
```

La prima riga dice a `param1` di immagazzinare l'indice di luminosità, mentre la seconda permette alla luce del sole di propagarsi attraverso il nodo senza diminuire il proprio valore.

## Nodi liquidi

<figure class="right_image">
    <img src="{{ page.root }}//static/drawtype_liquid.png" alt="Drawtype liquido">
    <figcaption>
        Drawtype liquido
    </figcaption>
</figure>

Ogni tipo di liquido richiede due definizioni di nodi: una per la sorgente e l'altra per il liquido che scorre.

```lua
-- Alcune proprietà sono state rimosse perché non
--  rilevanti per questo capitolo
minetest.register_node("default:water_source", {
    drawtype = "liquid",
    paramtype = "light",

    inventory_image = minetest.inventorycube("default_water.png"),
    -- ^ questo è necessario per impedire che l'immagine nell'inventario sia animata

    tiles = {
        {
            name = "default_water_source_animated.png",
            animation = {
                type     = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length   = 2.0
            }
        }
    },

    special_tiles = {
        -- Nuovo stile per il materiale dell'acqua statica (praticamente inutilizzato)
        {
            name      = "default_water_source_animated.png",
            animation = {type = "vertical_frames", aspect_w = 16,
                aspect_h = 16, length = 2.0},
            backface_culling = false,
        }
    },

    --
    -- Comportamento
    --
    walkable     = false, -- Il giocatore può attraversarlo
    pointable    = false, -- Il giocatore non può selezionarlo
    diggable     = false, -- Il giocatore non può scavarlo
    buildable_to = true,  -- Può essere rimpiazzato da altri nodi

    alpha = 160,

    --
    -- Proprietà del liquido
    --
    drowning = 1,
    liquidtype = "source",

    liquid_alternative_flowing = "default:water_flowing",
    -- ^ quando scorre

    liquid_alternative_source = "default:water_source",
    -- ^ quando è sorgente (statico)

    liquid_viscosity = WATER_VISC,
    -- ^ quanto veloce

    liquid_range = 8,
    -- ^ quanto lontano

    post_effect_color = {a=64, r=100, g=100, b=200},
    -- ^ colore dello schermo quando il player ne è immerso
})
```

I nodi fluidi hanno una definizione simile, ma con nome e animazione differenti.
Guarda default:water_flowing nella mod default di minetest_game per un esempio completo.


## Nodi complessi

<figure class="right_image">
    <img src="{{ page.root }}//static/drawtype_nodebox.gif" alt="Drawtype complesso">
    <figcaption>
        Drawtype complesso
    </figcaption>
</figure>

I nodi complessi (*nodebox*) ti permettono di creare un nodo che non è cubico, bensì un insieme di più cuboidi.

```lua
minetest.register_node("stairs:stair_stone", {
    drawtype = "nodebox",
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
            {-0.5, 0, 0, 0.5, 0.5, 0.5},
        },
    }
})
```

La parte più importante è la tabella `node_box`:

```lua
{-0.5, -0.5, -0.5,       0.5,    0,  0.5},
{-0.5,    0,    0,       0.5,  0.5,  0.5}
```

Ogni riga corrisponde a un cuboide e l'insieme delle righe forma il nodo complesso: i primi tre numeri sono le coordinate (da -0.5 a 0.5) dell'angolo davanti in basso a sinistra, mentre gli altri tre equivalgono all'angolo opposto.
Essi sono in formato X, Y, Z, dove Y indica il sopra.


Puoi usare [NodeBoxEditor](https://forum.minetest.net/viewtopic.php?f=14&t=2840) per creare nodi complessi più facilmente, in quanto permette di vedere in tempo reale le modifiche sul nodo che si sta modellando.

### Nodi complessi a muro

Certe volte si vogliono avere nodi complessi che cambiano a seconda della loro posizione sul pavimento, sul muro e sul soffitto, come le torce.

```lua
minetest.register_node("default:sign_wall", {
    drawtype = "nodebox",
    node_box = {
        type = "wallmounted",

        -- Soffitto
        wall_top    = {
            {-0.4375, 0.4375, -0.3125, 0.4375, 0.5, 0.3125}
        },

        -- Pavimento
        wall_bottom = {
            {-0.4375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125}
        },

        -- Muro
        wall_side   = {
            {-0.5, -0.3125, -0.4375, -0.4375, 0.3125, 0.4375}
        }
    },
})
```

## Nodi mesh

Mentre i nodi complessi sono generalmente più semplici da fare, essi sono limitati in quanto possono essere composti solo da cuboidi.
I nodi complessi sono anche non ottimizzati: le facce interne, infatti, saranno comunque renderizzate, anche quando completamente nascoste.

Una faccia è una superficie piatta di una mesh.
Una faccia interna appare quando le facce di due nodi complessi si sovrappongono, rendendo invisibili parti del modello ma renderizzandole comunque.

Puoi registrare un nodo mesh come segue:

```lua
minetest.register_node("miamod:meshy", {
    drawtype = "mesh",

    -- Contiene le texture di ogni materiale
    tiles = {
        "mymod_meshy.png"
    },

    -- Percorso della mesh
    mesh = "mymod_meshy.b3d",
})
```

Assicurati che la mesh sia presente nella cartella `models`.
La maggior parte delle volte la mesh dovrebbe essere nella cartella della tua mod, tuttavia è ok condividere una mesh fornita da un'altra mod dalla quale dipendi.
Per esempio, una mod che aggiunge più tipi di mobili potrebbe usfruire di un modello fornito da una mod di mobili base.

## Nodi insegna

I nodi insegna (*signlike*) sono nodi piatti che possono essere affissi sulle facce di altri nodi.

Al contrario del loro nome, i cartelli non rientrano nei nodi insegna bensì in quelli complessi, per fornire un effetto 3D.
I tipi insegna tuttavia, sono comunemente usati dalle scale a pioli.

```lua
minetest.register_node("default:ladder_wood", {
    drawtype = "signlike",

    tiles = {"default_ladder_wood.png"},

    -- Necessario: memorizza la rotazione in param2
    paramtype2 = "wallmounted",

    selection_box = {
        type = "wallmounted",
    },
})
```

## Nodi pianta

<figure class="right_image">
    <img src="{{ page.root }}//static/drawtype_plantlike.png" alt="Drawtype pianta">
    <figcaption>
        Drawtype pianta
    </figcaption>
</figure>

I nodi pianta (*plantlike*) raffigurano la loro texture in un pattern a forma di X.

```lua
minetest.register_node("default:papyrus", {
    drawtype = "plantlike",

    -- Viene usata solo una texture
    tiles = {"default_papyrus.png"},

    selection_box = {
        type = "fixed",
        fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.5, 6 / 16},
    },
})
```

## Nodi fiamma

I nodi fiamma (*firelike*) sono simili ai pianta, ad eccezione del fatto che sono ideati per avvinghiarsi ai muri e ai soffitti.

<figure>
    <img src="{{ page.root }}//static/drawtype_firelike.png" alt="Drawtype fiamma">
    <figcaption>
        Drawtype fiamma
    </figcaption>
</figure>

```lua
minetest.register_node("miamod:avvinghiatutto", {
    drawtype = "firelike",

    -- Viene usata solo una texture
    tiles = { "miamod:avvinghiatutto" },
})
```

## Altri drawtype

Questa non è una lista esaustiva, in quanto ci sono infatti altri tipi di nodi come:

* Nodi staccionata
* Nodi pianta radicata - per quelle acquatiche
* Nodi rotaia - per i binari del carrello
* Nodi torcia - per nodi 2D su pavimenti/muri/soffitti.
  Le torce in Minetest Game usano in verità due diverse definizioni dei
  nodi mesh (default:torch e default:torch_wall).

Come al solito, consulta la [documentazione sull'API Lua](https://minetest.gitlab.io/minetest/nodes/#node-drawtypes) per l'elenco completo.
