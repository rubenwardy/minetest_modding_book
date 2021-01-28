---
title: Nodi, Oggetti e Fabbricazione
layout: default
root: ../..
idx: 2.1
description: Impara come registrare nodi, oggetti e ricette di fabbricazione usando register_node, register_item e register_craft.
redirect_from: /it/chapters/nodes_items_crafting.html
---

## Introduzione <!-- omit in toc -->

Saper registrare nuovi nodi, oggetti fabbricabili e conseguenti ricette, è un requisito fondamentale per molte mod.

- [Cosa sono i nodi e gli oggetti?](#cosa-sono-i-nodi-e-gli-oggetti)
- [Registrare gli oggetti](#registrare-gli-oggetti)
	- [Nomi oggetto](#nomi-oggetto)
	- [Alias](#alias)
	- [Texture](#texture)
- [Registrare un nodo base](#registrare-un-nodo-base)
- [Azioni e callback](#azioni-e-callback)
	- [on_use](#onuse)
- [Fabbricazione](#fabbricazione)
	- [Fisse (shaped)](#fisse-shaped)
	- [Informi (shapeless)](#informi-shapeless)
	- [Cottura (cooking) e Carburante (fuel)](#cottura-cooking-e-carburante-fuel)
- [Gruppi](#gruppi)
- [Strumenti, Capacità e Friabilità](#strumenti-capacità-e-friabilità)

## Cosa sono i nodi e gli oggetti?

Nodi, oggetti fabbricabili e strumenti sono tutti oggetti.
Un oggetto è qualcosa che può essere trovato in un inventario — anche se potrebbe non risultare possibile durante una normale sessione di gioco.

Un nodo è un oggetto che può essere piazzato o trovato nel mondo.
Ogni coordinata nel mondo deve essere occupata da un unico nodo — ciò che appare vuoto è solitamente un nodo d'aria.

Un oggetto fabbricabile (*craftitem*) non può essere invece piazzato, potendo apparire solo negli inventari o come oggetto rilasciato nel mondo.

Uno strumento (*tool*) può usurarsi e solitamente non possiede la capacità di scavare.
In futuro, è probabile che gli oggetti fabbricabili e gli strumenti verranno fusi in un unico tipo, in quanto la distinzione fra di essi è alquanto artificiosa.

## Registrare gli oggetti

Le definizioni degli oggetti consistono in un *nome oggetto* e una *tabella di definizioni*.
La tabella di definizioni contiene attributi che influenzano il comportamento dell'oggetto.

```lua
minetest.register_craftitem("nomemod:nomeoggetto", {
    description = "Il Mio Super Oggetto",
    inventory_image = "nomemod_nomeoggetto.png"
})
```

### Nomi oggetto

Ogni oggetto ha un nome usato per riferirsi a esso, che dovrebbe seguire la seguente struttura:

    nomemod:nomeoggetto

`nomemod` equivale appunto al nome della mod che registra l'oggetto, e `nomeoggetto` è il nome che si vuole assegnare a quest'ultimo.
Esso dovrebbe essere inerente a quello che rappresenta e deve essere unico nella mod.

### Alias

Gli oggetti possono anche avere degli *alias* che puntano al loro nome.
Un *alias* è uno pseudonimo che dice al motore di gioco di trattarlo come se fosse il nome a cui punta.
Ciò è comunemente usato in due casi:

* Rinominare gli oggetti rimossi in qualcos'altro.
  Ci potrebbero essere nodi sconosciuti nel mondo e negli inventari se un oggetto viene rimosso da una mod senza nessun codice per gestirlo.
* Aggiungere una scorciatoia.
  `/giveme dirt` è più semplice di `/giveme default:dirt`.

Registrare un alias è alquanto semplice.

```lua
minetest.register_alias("dirt", "default:dirt")
```

Un buon modo per ricordarne il funzionamento è `da → a`, dove *da*
è l'alias e *a* è il nome dell'oggetto a cui punta.

Le mod devono inoltre assicurarsi di elaborare gli alias prima di occuparsi direttamente del nome dell'oggeto, in quanto l'engine non lo fa di suo.
Anche in questo caso non è difficile:

```lua
itemname = minetest.registered_aliases[itemname] or itemname
```

### Texture

Per convenzione le texture andrebbero messe nella cartella textures/ con nomi che seguono la struttura `nomemod_nomeoggetto.png`.\\
Le immagini in JPEG sono supportate, ma non supportano la trasparenza e sono generalmente di cattiva qualità nelle basse risoluzioni.
Si consiglia quindi il formato PNG.

Le texture su Minetest sono generalmente 16x16 pixel.
Possono essere di qualsiasi dimensione, ma è buona norma che rientrino nelle potenze di 2, per esempio 16, 32, 64 o 128.
Questo perché dimensioni differenti potrebbero non essere supportate dai vecchi dispositivi, comportando una diminuzione delle performance.

## Registrare un nodo base

```lua
minetest.register_node("miamod:diamante", {
    description = "Diamante alieno",
    tiles = {"miamod_diamante.png"},
    is_ground_content = true,
    groups = {cracky=3, stone=1}
})
```

La proprietà `tiles` è una tabella contenente le texture che il nodo userà.
Quando è presente una sola texture, questa sarà applicata su tutte le facce.
Per assegnarne invece di diverse, bisogna fornire il nome di 6 texture in quest'ordine:

    sopra (+Y), sotto (-Y), destra (+X), sinistra (-X), dietro (+Z), davanti (-Z).
    (+Y, -Y, +X, -X, +Z, -Z)

Ricorda che su Minetest, come nella convenzione della computer grafica 3D, +Y punta verso l'alto.

```lua
minetest.register_node("miamod:diamante", {
    description = "Diamante alieno",
    tiles = {
        "miamod_diamante_up.png",    -- y+
        "miamod_diamante_down.png",  -- y-
        "miamod_diamante_right.png", -- x+
        "miamod_diamante_left.png",  -- x-
        "miamod_diamante_back.png",  -- z+
        "miamod_diamante_front.png", -- z-
    },
    is_ground_content = true,
    groups = {cracky = 3},
    drop = "miamod:diamante_frammenti"
    -- ^  Al posto di far cadere diamanti, fa cadere miamod:diamante_frammenti
})
```

L'attributo is_ground_content è essenziale per ogni nodo che si vuole far apparire sottoterra durante la generazione della mappa.
Le caverne vengono scavate nel mondo dopo che tutti gli altri nodi nell'area sono stati generati.

## Azioni e callback

Minetest usa ampiamente una struttura per il modding incentrata sui callback (richiami).
I callback possono essere inseriti nella tabella di definizioni dell'oggetto per permettere una risposta a vari tipi di eventi generati dall'utente.
Vediamone un esempio.

### on_use

Di base, il callback on_use scatta quando un giocatore clicca col tasto sinistro con l'oggetto in mano.
Avere un callback sull'uso previene che l'oggetto venga utilizzato per scavare nodi.
Un utilizzo comune di questo callback è per il cibo:

```lua
minetest.register_craftitem("miamod:fangotorta", {
    description = "Torta aliena di fango",
    inventory_image = "miamod_fangotorta.png",
    on_use = minetest.item_eat(20),
})
```

Il numero fornito alla funzione minetest.item_eat è il numero di punti salute ripristinati al consumare il cibo.
In gioco ogni cuore equivale a due punti.
Un giocatore ha solitamente un massimo di 10 cuori, ovvero 20 punti salute, e quest'ultimi non devono per forza essere interi - ovvero decimali.

`minetest.item_eat()` è una funzione che ritorna un'altra funzione, in questo caso quindi impostandola come callback di on_use.
Ciò significa che il codice in alto è alquanto simile al seguente:

```lua
minetest.register_craftitem("miamod:fangotorta", {
    description = "Torta aliena di fango",
    inventory_image = "miamod_fangotorta.png",
    on_use = function(...)
        return minetest.do_item_eat(20, nil, ...)
    end,
})
```

Capendo come funziona item_eat, è possibile modificarlo per operazioni più complesse
come per esempio riprodurre un suono personalizzato.

## Fabbricazione

Ci sono diversi tipi di ricette di fabbricazione disponibili, indicate dalla proprietà `type`.

* shaped - Gli ingredienti devono essere nel giusta posizione.
* shapeless - Non importa dove sono gli ingredienti, solo che siano abbastanza.
* cooking - Ricette di cottura per la fornace.
* fuel - Definisce gli oggetti che possono alimentare il fuoco nella fornace.
* tool_repair - Definisce gli oggetti che possono essere riparati.

Le ricette di fabbricazione non sono oggetti, perciò non usano nomi oggetto per identificare in maniera univoca se stesse.

### Fisse (shaped)

Le ricette fisse avvengono quando gli ingredienti devono essere nella forma o sequenza corretta per funzionare.
Nell'esempio sotto, i frammenti necessitano di essere in una figura a forma di sedia per poter fabbricare appunto 99 sedie.

```lua
minetest.register_craft({
    type = "shaped",
    output = "miamod:diamante_sedia 99",
    recipe = {
        {"miamod:diamante_frammenti", "",                         ""},
        {"miamod:diamante_frammenti", "miamod:diamante_frammenti",  ""},
        {"miamod:diamante_frammenti", "miamod:diamante_frammenti",  ""}
    }
})
```

Una cosa da tener presente è la colonna vuota sulla parte destra.
Questo significa che ci *deve* essere una colonna vuota a destra della forma, altrimenti ciò non funzionerà.
Se invece la colonna non dovesse servire, basta ometterla in questo modo:

```lua
minetest.register_craft({
    output = "miamod:diamante_sedia 99",
    recipe = {
        {"miamod:diamante_frammenti", ""                         },
        {"miamod:diamante_frammenti", "miamod:diamante_frammenti"},
        {"miamod:diamante_frammenti", "miamod:diamante_frammenti"}
    }
})
```

Il campo type non è davvero necessario per le ricette fisse, in quanto sono il tipo di base.

### Informi (shapeless)

Le ricette informi sono ricette che vengono usate quando non importa dove sono posizionati gli ingredienti, ma solo che ci siano.

```lua
minetest.register_craft({
    type = "shapeless",
    output = "miamod:diamante 3",
    recipe = {
        "miamod:diamante_frammenti",
        "miamod:diamante_frammenti",
        "miamod:diamante_frammenti",
    },
})
```

### Cottura (cooking) e carburante (fuel)

Le ricette di tipo "cottura" non vengono elaborate nella griglia di fabbricazione, bensì nelle fornaci o in qualsivoglia altro strumento di cottura che può essere trovato nelle mod.

```lua
minetest.register_craft({
    type = "cooking",
    output = "miamod_diamante_frammenti",
    recipe = "default:coalblock",
    cooktime = 10,
})
```

L'unica vera differenza nel codice è che in questo la ricetta non è una tabella (tra parentesi graffe), bensì un singolo oggetto.
Le ricette di cottura dispongono anche di un parametro aggiuntivo "cooktime" che indica in secondi quanto tempo ci impiega l'oggetto a cuocersi.
Se non è impostato, di base è 3.

La ricetta qui sopra genera un'unità di frammenti di diamante dopo 10 secondi quando il blocco di carbone (`coalblock`) è nello slot di input, con un qualche tipo di carburante sotto di esso.

Il tipo "carburante" invece funge da accompagnamento alle ricette di cottura, in quanto definisce cosa può alimentare il fuoco.

```lua
minetest.register_craft({
    type = "fuel",
    recipe = "miamod:diamante",
    burntime = 300,
})
```

Esso non ha un output come le altre ricette, e possiede un tempo di arsura (`burntime`) che definisce in secondi per quanto alimenterà la fiamma.
In questo caso, 300 secondi!

## Gruppi

Gli oggetti possono essere membri di più gruppi, e i gruppi possono avere più membri.
Essi sono definiti usando la proprietà `groups` nella tabella di definizione, e possiedono un valore associato.

```lua
groups = {cracky = 3, wood = 1}
```

Ci sono diverse ragioni per cui usare i gruppi.
In primis, vengono utilizzati per descrivere proprietà come friabilità e infiammabilità.
In secundis, possono essere usati in una ricetta al posto di un nome oggetto per permettere a qualsiasi oggetto nel gruppo di essere utilizzato.

```lua
minetest.register_craft({
    type = "shapeless",
    output = "miamod:diamante_qualcosa 3",
    recipe = {"group:wood", "miamod:diamante"}
})
```

## Strumenti, Capacità e Friabilità

Le friabilità sono dei gruppi particolari utilizzati per definire la resistenza di un nodo quando scavato con un determinato strumento.
Una friabilità elevata equivale a una maggior facilità e velocità nel romperlo.
È possibile combinarne di più tipi per permettere al nodo di essere distrutto da più tipi di strumento, mentre un nodo senza friabilità non può essere distrutto da nessuno strumento.

| Gruppo  | Miglior strumento | Descrizione |
|---------|-------------------|-------------|
| crumbly | pala              | Terra, sabbia |
| cracky  | piccone           | Cose dure e sgretolabili come la pietra |
| snappy  | *qualsiasi*       | Può essere rotto usando uno strumento adatto;<br>es. foglie, piantine, filo, lastre di metallo |
| choppy  | ascia             | Può essere rotto con dei fendenti; es. alberi, assi di legno |
| fleshy  | spada             | Esseri viventi come animali e giocatori.<br>Potrebbe implicare effetti di sangue al colpire |
| explody | ?                 | Predisposti ad esplodere  |
| oddly_breakable_by_hand | *qualsiasi* | Torce e simili — molto veloci da rompere |


Ogni strumento possiede poi delle capacità (*capability*).
Una capacità include una lista di friabilità supportate, e proprietà associate per ognuna di esse come la velocità di scavata e il livello di usura.
Gli strumenti possono anche avere una durezza massima supportata per ogni tipo; ciò serve a prevenire che strumenti più deboli possano rompere nodi meno friabili.
È poi molto comune che uno strumento includa tutte le friabilità nelle sue capacità, con quelle meno adatte equivalenti a proprietà inefficienti.
Se l'oggetto impugnato dal giocatore non ha una capacità esplicitata, verrà allora usata quella della mano.

```lua
minetest.register_tool("miamod:strumento", {
    description = "Il mio strumento",
    inventory_image = "miamod_strumento.png",
    tool_capabilities = {
        full_punch_interval = 1.5,
        max_drop_level = 1,
        groupcaps = {
            crumbly = {
                maxlevel = 2,
                uses = 20,
                times = { [1]=1.60, [2]=1.20, [3]=0.80 }
            },
        },
        damage_groups = {fleshy=2},
    },
})
```
I gruppi limite (`groupcaps`) sono una lista delle friabilità supportate dallo strumento.
I gruppi di danno invece (`damage_groups`) servono a controllare come uno strumento (esterno) danneggia quell'oggetto. Quest'ultimi verranno discussi in seguito nel capitolo Oggetti, Giocatori e Entità.
