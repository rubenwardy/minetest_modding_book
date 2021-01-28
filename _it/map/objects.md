---
title: Oggetti, giocatori e entità
layout: default
root: ../..
idx: 3.4
description: Alla scopera degli ObjectRef
degrad:
    level: warning
    title: Gradi e radianti
    message: La rotazione dell'oggetto figlio è in gradi, mentre quella dell'oggetto è in radianti.
            Assicurati di usare il metodo di misura corretto.
---

## Introduzione <!-- omit in toc -->

In questo capitolo imparerai come manipolare gli oggetti e come definirne di tuoi.

- [Cosa sono gli oggetti, i giocatori e le entità?](#cosa-sono-gli-oggetti-i-giocatori-e-le-entità)
- [Posizione e velocità](#posizione-e-velocità)
- [Proprietà degli oggetti](#proprietà-degli-oggetti)
- [Entità](#entità)
- [Salute e danno](#salute-e-danno)
	- [Punti vita (HP)](#punti-vita-hp)
	- [Pugni, Gruppi Danno e Gruppi Armatura](#pugni-gruppi-danno-e-gruppi-armatura)
	- [Esempi di calcolo del danno](#esempi-di-calcolo-del-danno)
- [Oggetti figli](#oggetti-figli)
- [Il tuo turno](#il-tuo-turno)

## Cosa sono gli oggetti, i giocatori e le entità?

Giocatori e entità sono entrambi tipi di oggetti (ObjectRef, quindi di nuovo un riferimento). Un oggetto è qualcosa che si può muovere indipendentemente dalla griglia di nodi e che ha proprietà come velocità e scala.
Attenzione, tuttavia, a non confonderli con gli oggetti nel senso di "cose che possono essere messe in un inventario" (in inglese hanno infatti nomi diversi: *objects* e *items*), anche perché hanno un sistema di registrazione tutto loro.

Ci sono alcune differenze tra giocatori ed entità.
La più grande è che i primi sono controllati da chi gioca, mentre le seconde sono controllate dalle mod.
Ciò significa che, per esempio, la velocità di un giocatore non può essere modificata dalle mod - i giocatori appartengono al lato client, mentre le entità al lato server.
Un'altra differenza è che i giocatori fanno caricare i Blocchi Mappa che li circondano, le entità invece no: quest'ultime vengono salvate e diventano inattive quando il Blocco Mappa in cui si trovano viene rimosso dalla memoria.

Questa distinzione è resa meno chiara dal fatto che le entità sono controllate tramite una Tabella di Entità Lua che vedremo qui sotto.

## Posizione e velocità

`get_pos` e `set_pos` permettono di ottenere e impostare la posizione di un oggetto.

```lua
local giocatore = minetest.get_player_by_name("bob")
local pos    = giocatore:get_pos()
giocatore:set_pos({ x = pos.x, y = pos.y + 1, z = pos.z })
```

`set_pos` imposta la posizione seduta stante, senza animazione.
Se invece si desidera animare il movimento dell'oggetto verso la nuova posizione, si dovrebbe usare `move_to`.
Questo, tuttavia, funziona soltanto per le entità.

```lua
miaentita:move_to({ x = pos.x, y = pos.y + 1, z = pos.z })
```

Una cosa importante da tenere a mente quando si lavora con le entità è la latenza di rete.
In un mondo ideale, le informazioni riguardo i movimenti delle entità arriverebbero subito, nell'ordine corretto e a intervalli simili a come sono stati inviati.
Tuttavia, a meno che tu non stia giocando in locale, questo non è un mondo ideale.
Le informazioni ci mettono un attimo ad arrivare: per esempio i `set_pos` potrebbero non arrivare in ordine, saltando alcune chiamate.
O lo spazio da coprire di un `move_to` potrebbe non essere suddiviso perfettamente, rendendo l'animazione meno fluida.
Tutto ciò ha come risultato il client che vede cose leggermente diverse dal server, che è una cosa di cui dovresti essere consapevole.

## Proprietà degli oggetti

Le proprietà degli oggetti sono usate per comunicare al client come renderizzare e gestire un oggetto.
Non è possibile definire delle proprietà personalizzate, perché le proprietà sono per definizione fatte per essere usate dall'engine.

Al contrario dei nodi, gli oggetti hanno un comportamento dinamico.
Si può per esempio cambiare il loro aspetto in qualsiasi momento, aggiornandone le proprietà:

```lua
oggetto:set_properties({
    visual      = "mesh",
    mesh        = "omino.b3d",
    textures    = {"omino_texture.png"},
    visual_size = {x=1, y=1},
})
```

Le proprietà aggiornate verranno inviate a tutti i giocatori nelle vicinanze.
Questo è molto utile per avere una vasto ammontare di varietà a basso costo, uno fra tanti l'avere diverse skin per giocatore.

Come mostrato nella prossima sezione, le entità possono avere delle proprietà iniziali, che andranno dichiarate nella loro definizione.

## Entità

Un'entità ha una tabella di definizione che ricorda quella degli oggetti (intesi come *items*).
Questa tabella può contenere metodi di callback, proprietà iniziali e membri personalizzati.

```lua
local MiaEntita = {
    initial_properties = {
        hp_max = 1,
        physical = true,
        collide_with_objects = false,
        collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
        visual = "wielditem",
        visual_size = {x = 0.4, y = 0.4},
        textures = {""},
        spritediv = {x = 1, y = 1},
        initial_sprite_basepos = {x = 0, y = 0},
    },

    messaggio = "Messaggio predefinito",
}

function MiaEntita:imposta_messaggio(msg)
    self.messaggio = msg
end
```

Tuttavia, c'è una differenza sostanziale tra entità e oggetti; perché quando un'entità appare (come quando viene creata o caricata) una nuova tabella viene generata per quell'entità, *ereditando* le proprietà dalla tabella originaria tramite una metatabella.

<!--
Questa eredità avviene usando una metatabella. Le metatabelle rappresentano un aspetto importante di Lua, che bisogna tenere bene a mente in quanto sono una parte essenziale del linguaggio.

In parole povere, le metatabelle permettono di controllare come si comporta una tabella quando viene usata una certa sintassi in Lua.
Vengono usate soprattutto per la loro abilità di usare un'altra tabella come prototipo, fungendo da valori di base di quest'ultima quando essa non contiene le proprietà e i metodi richiesti.

Mettiamo che si voglia accedere al campo `x` della tabella `a` (`a.x`).
Se la tabella `a` ha quel campo, allora ritornerà normalmente.
Tuttavia, se `a.x` non esiste ma esiste una metatabella `b` associata ad `a`, `b` verrà ispezionata alla ricerca di un eventuale `b.x` da ritornare al posto di `nil`.
-->

Sia la tabella di un ObjectRef che quella di un'entità forniscono modi per ottenerne la controparte:

```lua
local entita = oggetto:get_luaentity()
local oggetto = entita.object
print("L'entità si trova a " .. minetest.pos_to_string(oggetto:get_pos()))
```

Ci sono diversi callback disponibili da usare per le entità.
Una lista completa può essere trovata in [lua_api.txt](https://minetest.gitlab.io/minetest/minetest-namespace-reference/#registered-definition-tables).

```lua
function MiaEntita:on_step(dtime)
    local pos      = self.oggetto:get_pos()
    local pos_giu = vector.subtract(pos, vector.new(0, 1, 0))

    local delta
    if minetest.get_node(pos_giu).name == "air" then
        delta = vector.new(0, -1, 0)
    elseif minetest.get_node(pos).name == "air" then
        delta = vector.new(0, 0, 1)
    else
        delta = vector.new(0, 1, 0)
    end

    delta = vector.multiply(delta, dtime)

    self.oggetto:move_to(vector.add(pos, delta))
end

function MiaEntita:on_punch(hitter)
    minetest.chat_send_player(hitter:get_player_name(), self.message)
end
```

Ora, se si volesse spawnare e usare questa entità, si noterà che il messaggio andrebbe perduto quando l'entità diventa inattiva per poi ritornare attiva.
Questo succede perché il messaggio non è salvato.
Al posto di salvare tutto nella tabella dell'entità, Minetest ti permette di scegliere come salvare le cose.
Questo succede nella *Staticdata*, una stringa che contiene tutte le informazioni personalizzate che si vogliono ricordare.

```lua
function MiaEntita:get_staticdata()
    return minetest.write_json({
        messaggio = self.messaggio,
    })
end

function MiaEntita:on_activate(staticdata, dtime_s)
    if staticdata ~= "" and staticdata ~= nil then
        local data = minetest.parse_json(staticdata) or {}
        self:imposta_messaggio(data.messaggio)
    end
end
```

Minetest può chiamare `get_staticdata()` quando e quante volte vuole.
Questo perché non aspetta che un Blocco Mappa diventi inattivo per salvarlo, in quanto comporterebbe una perdita di informazioni.
I Blocchi Mappa sono salvati circa ogni 18 secondi, quindi dovresti notare un simile intervallo per la chiamata a `get_staticdata()`.

`on_activate()`, d'altro canto, viene chiamato solo quando un'entità diventa attiva o nel Blocco Mappa appena caricato o quando spawna.
Questo significa che il suo staticdata inizialmente potrebbe essere vuoto (dato l'intervallo di 18 secondi).

Infine, c'è bisogno di registrare la tabella usando `register_entity`.

```lua
minetest.register_entity("miamod:entita", MiaEntita)
```

L'entità può essere spawnata da una mod nel seguente modo:

```lua
local pos = { x = 1, y = 2, z = 3 }
local oggetto = minetest.add_entity(pos, "miamod:entita", nil)
```

Il terzo parametro è lo staticdata inziale.
Per impostare il messaggio, puoi usare la Tabella di Entità Lua:

```lua
oggetto:get_luaentity():imposta_messaggio("ciao!")
```

## Salute e danno

### Punti vita (HP)

Ogni oggetto ha un valore Punti Vita (HP), che rappresenta la salute attuale.
Nei giocatori è inoltre possibile impostare il valore di salute massima tramite la proprietà `hp_max`.
Al raggiungere gli 0 HP, un oggetto muore.

```lua
local hp = oggetto:get_hp()
oggetto:set_hp(hp + 3)
```

### Pugni, Gruppi Danno e Gruppi Armatura

Il danno è la riduzione degli HP di un oggetto.
Quest'ultimo può prendere "a pugni" un altro oggetto per infliggere danno.
"A pugni" perché non si parla necessariamente di un pugno vero e proprio: può essere infatti un'esplosione, un fendente, e via dicendo.

Il danno complessivo è calcolato moltiplicando i Gruppi Danno del pugno con le vulnerabilità dell'obiettivo.
Questo è poi eventualmente ridotto a seconda di quanto recente è stato il colpo precedente.
Vedremo tra poco nel dettaglio quest'aspetto.

Proprio come i [Gruppi Danno dei nodi](../items/nodes_items_crafting.html#strumenti-capacità-e-friabilità), questi gruppi possono prendere qualsiasi nome e non necessitano di essere registrati.
Tuttavia, si è soliti usare gli stessi nomi di quelli dei nodi.

La vulnerabilità di un oggetto a un certo tipo di danno dipende dalla sua [proprietà](#proprietà-degli-oggetti) `armor_groups`.
Al contrario di quello che potrebbe far intendere il nome, `armor_groups` specifica la percentuale di danno subita da specifici Gruppi Danno, e non la resistenza.
Se un Gruppo Danno non è elencato nei Gruppi Armatura di un oggetto, quest'ultimo ne sarà completamente immune.

```lua
obiettivo:set_properties({
    armor_groups = { fleshy = 90, crumbly = 50 },
})
```

Nell'esempio qui sopra, l'oggetto subirà il 90% di danno `fleshy` e 50% di quello `crumbly`.

Quando un giocatore prende "a pugni" un oggetto, i Gruppi Danno vengono estrapolati dall'oggetto che ha attualmente il mano.
Negli altri casi, saranno le mod a decidere quali Gruppi Danno usare.

### Esempi di calcolo del danno

Prendiamo a pugni l'oggetto `target`:

```lua
local capacita_oggetto = {
    full_punch_interval = 0.8,
    damage_groups = { fleshy = 5, choppy = 10 },

    -- Questo è usato solo per scavare nodi, ma è comunque richiesto
    max_drop_level=1,
    groupcaps={
        fleshy={times={[1]=2.5, [2]=1.20, [3]=0.35}, uses=30, maxlevel=2},
    },
}

local tempo_da_ultimo_pugno = capacita_oggetto.full_punch_interval
obiettivo:punch(oggetto, tempo_da_ultimo_pugno, capacita_oggetto)
```

Ora, calcoliamo a quanto ammonterà il danno.
I Gruppi Danno del pugno sono `fleshy=5` e `choppy=10`, con l'obiettivo che prenderà 90% di danno da fleshy e 0% da choppy.

Per prima cosa, moltiplichiamo i Gruppi Danno per le vulnerabilità, e ne sommiamo il risultato.
Poi, moltiplichiamo per un numero tra 0 e 1 a seconda di `tempo_da_ultimo_pugno`.

```lua
= (5*90/100 + 10*0/100) * limit(tempo_da_ultimo_pugno / full_punch_interval, 0, 1)
= (5*90/100 + 10*0/100) * 1
= 4.5
```

Dato che HP è un intero, il danno è arrotondato a 5 punti.

## Oggetti figli

Gli oggetti figli (*attachments*) si muovono quando il genitore - l'oggetto al quale sono legati - viene mosso.
Un oggetto può possedere un numero illimitato di figli, ma non più di un genitore.

```lua
figlio:set_attach(parent, bone, position, rotation)
```

Il `get_pos()` di un oggetto ritornerà sempre la sua posizione globale, a prescindere dal fatto che sia figlio o meno.
`set_attach` prende invece una posizione relativa, ma non è quello che credi: la posizione del figlio è relativa a quella del genitore *amplificata quest'ultima* di 10 volte.
Quindi, `0,5,0` sarà metà nodo in alto rispetto al genitore.

{% include notice.html notice=page.degrad %}

Per i modelli 3D animati, il parametro `bone` (osso) è usato per collegare un'entità a un osso.
Le animazioni 3D sono basate su degli scheletri - una rete di ossa nel modello dove ogni osso può avere una posizione e rotazione per cambiare il modello, tipo per muovere un braccio.
Il collegamento a un osso è utile se si vuole per esempio far impugnare qualcosa al personaggio:

```lua
oggetto:set_attach(player,
    "Braccio destro",      -- osso predefinito
    {x=0.2, y=6.5, z=3},   -- posizione predefinita
    {x=-100, y=225, z=90}) -- rotazione predefinita
```

## Il tuo turno

* Fai un mulino combinando dei nodi con un'entità.
* Crea un mostro di tua scelta (usando l'API delle entità, e senza usare altre mod).
