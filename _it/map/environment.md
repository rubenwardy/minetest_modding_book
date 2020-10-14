---
title: "Mappa: operazioni base"
layout: default
root: ../..
idx: 3.1
description: Operazioni base come set_node e get_node
redirect_from: /it/chapters/environment.html
---

## Introduzione <!-- omit in toc -->

In questo capitolo imparerai come eseguire semplici azioni sulla mappa.

- [Struttura della mappa](#struttura-della-mappa)
- [Lettura](#lettura)
  - [Lettura dei nodi](#lettura-dei-nodi)
  - [Ricerca dei nodi](#ricerca-dei-nodi)
- [Scrittura](#scrittura)
  - [Scrittura dei nodi](#scrittura-dei-nodi)
  - [Rimozione dei nodi](#rimozione-dei-nodi)
- [Caricamento blocchi](#caricamento-blocchi)
- [Cancellazione blocchi](#cancellazione-blocchi)

## Struttura della mappa

La mappa di Minetest è suddivisa in Blocchi Mappa (*MapBlocks*), cubi di 16x16x16 nodi.
Man mano che i giocatori si addentrano per la mappa, i Blocchi Mappa vengono creati, caricati e rimossi dalla memoria.
Le aree della mappa che non sono ancora caricate sono piene di nodi *ignora*, dei nodi segnaposto che non possono
essere né attraversati né selezionati. Gli spazi vuoti delle aree già caricate, invece, sono nodi *d'aria*, dei
nodi invisibili e attraversabili.

Spesso, ci si rifà ai blocchi caricati (attenzione! Blocco non vuol dire nodo, come detto qui sopra!) chiamandoli *blocchi attivi*.
I blocchi attivi possono essere letti e sovrascritti dalle mod o dai giocatori, e contenere entità attive.
Anche il motore di gioco esegue operazioni sulla mappa, come il calcolare la fisica dei liquidi.

I Blocchi Mappa possono essere sia caricati dal database del mondo che generati.
Essi vengono generati fino al limite di generazione della mappa (`mapgen_limit`), che è impostato di base al suo valore massimo, 31000.
I Blocchi Mappa esistenti, tuttavia, ignorano questo limite quando caricati dal database del mondo.

## Lettura

### Lettura dei nodi

Un nodo può essere letto da un mondo fornendone la posizione:

```lua
local nodo = minetest.get_node({ x = 1, y = 3, z = 4 })
print(dump(nodo)) --> { name=.., param1=.., param2=.. }
```

Se la posizione è un decimale, verrà arrotondata alle coordinate del nodo.
`get_node` ritornerà sempre una tabella contenente le informazioni del nodo:

* `name` - Il nome del nodo, che sarà `ignore` quando l'area non è caricata.
* `param1` - Guarda la definizione dei nodi. È solitamente associato alla luce.
* `param2` - Guarda la definizione dei nodi.

Per vedere se un nodo è caricato si può utilizzare `minetest.get_node_or_nil`, che ritornerà `nil` se il nome del nodo risulta `ignore`
(la funzione non caricherà comunque il nodo).
Potrebbe comunque ritornare `ignore` se un blocco contiene effettivamente `ignore`: questo succede ai limiti della mappa.

### Ricerca dei nodi

Minetest offre un numero di funzioni d'aiuto per accelerare le azioni più comuni legate alla mappa.
Le più frequenti sono quelle per trovare i nodi.

Per esempio, mettiamo che si voglia creare un certo tipo di pianta che cresce più velocemente vicino alla pietra;
si dovrebbe controllare che ogni nodo nei pressi della pianta sia pietra, e modificarne il suo indice di crescita di conseguenza.

```lua
local vel_crescita = 1
local pos_nodo   = minetest.find_node_near(pos, 5, { "default:stone" })
if pos_nodo then
    minetest.chat_send_all("Nodo trovato a: " .. dump(pos_nodo))
    vel_crescita = 2
end
```

Mettiamo ora che l'indice di crescita debba incrementare per ogni nodo di pietra nei dintorni.
Si dovrebbe quindi usare una funzione in grado di trovare più nodi in un'area:

```lua
local pos1       = vector.subtract(pos, { x = 5, y = 5, z = 5 })
local pos2       = vector.add(pos, { x = 5, y = 5, z = 5 })
local lista_pos   =
        minetest.find_nodes_in_area(pos1, pos2, { "default:stone" })
local vel_crescita = 1 + #lista_pos
```

Il codice qui in alto, tuttavia, non fa proprio quello che ci serve, in quanto fa controlli basati su un'area, mentre `find_node_near` li fa su un intervallo.
Per ovviare a ciò, bisogna purtroppo controllare l'intervallo manualmente.

```lua
local pos1       = vector.subtract(pos, { x = 5, y = 5, z = 5 })
local pos2       = vector.add(pos, { x = 5, y = 5, z = 5 })
local lista_pos   =
        minetest.find_nodes_in_area(pos1, pos2, { "default:stone" })
local vel_crescita = 1
for i=1, #lista_pos do
    local delta = vector.subtract(lista_pos[i], pos)
    if delta.x*delta.x + delta.y*delta.y <= 5*5 then
        vel_crescita = vel_crescita + 1
    end
end
```

Ora il codice aumenterà correttamente `vel_crescita` basandosi su quanti nodi di pietra ci sono in un intervallo.
Notare come si sia comparata la distanza al quadrato dalla posizione, invece che calcolarne la radice quadrata per ottenerne la distanza vera e propria.
Questo perché i computer trovano le radici quadrate computazionalmente pesanti, quindi dovresti evitare di usarle il più possibile.

Ci sono altre variazioni delle due funzioni sopracitate, come `find_nodes_with_meta` e `find_nodes_in_area_under_air`, che si comportano in modo simile e sono utili in altre circostanze.

## Scrittura

### Scrittura dei nodi

Puoi usare `set_node` per sovrascrivere nodi nella mappa.
Ogni chiamata a set_node ricalcolerà la luce, il ché significa che set_node è alquanto lento quando usato su un elevato numero di nodi.

```lua
minetest.set_node({ x = 1, y = 3, z = 4 }, { name = "default:stone" })

local nodo = minetest.get_node({ x = 1, y = 3, z = 4 })
print(nodo.name) --> default:stone
```

set_node rimuoverà ogni metadato e inventario associato a quel nodo: ciò non è sempre desiderabile, specialmente se si stanno usando
più definizioni di nodi per rappresentarne concettualmente uno. Un esempio è il nodo fornace: per quanto lo si immagini come un nodo unico,
sono in verità due.

Si può impostare un nuovo nodo senza rimuoverne metadati e inventario con `swap_node`:

```lua
minetest.swap_node({ x = 1, y = 3, z = 4 }, { name = "default:stone" })
```

### Rimozione dei nodi

Un nodo deve sempre essere presente. Per rimuoverlo, basta impostarlo uguale a `air`.

Le seguenti due linee di codice sono equivalenti, rimuovendo in entrambi i casi il nodo:

```lua
minetest.remove_node(pos)
minetest.set_node(pos, { name = "air" })
```

Infatti, `remove_node` non fa altro che richiamare `set_node` con nome `air`.

## Caricamento blocchi

Puoi usare `minetest.emerge_area` per caricare i blocchi mappa.
Questo comando è asincrono, ovvero i blocchi non saranno caricati istantaneamente; al contrario, verranno caricati man mano e il callback associato sarà richiamato a ogni passaggio.

```lua
-- Carica un'area 20x20x20
local mezza_dimensione = { x = 10, y = 10, z = 10 }
local pos1 = vector.subtract(pos, mezza_dimensione)
local pos2 = vector.add     (pos, mezza_dimensione)

local param = {} -- dati persistenti tra un callback e l'altro
minetest.emerge_area(pos1, pos2, mio_callback, param)
```

Minetest chiamerà la funzione locale definita qua sotto `mio_callback` ogni volta che carica un blocco, con delle informazioni sul progresso.

```lua
local function mio_callback(pos, action,
        calls_remaining, param)
    -- alla prima chiamata, registra il numero di blocchi
    if not param.blocchi_totali then
        param.blocchi_totali  = calls_remaining + 1
        param.blocchi_caricati = 0
    end

    -- Incrementa il numero di blocchi caricati
    param.loaded_blocks = param.blocchi_caricati + 1

    -- Invia messaggio indicante il progresso
    if param.blocchi_totali == param.blocchi_caricati then
        minetest.chat_send_all("Ho finito di caricare blocchi!")
    end
        local percentuale = 100 * param.blocchi_caricati / param.blocchi_totali
        local msg  = string.format("Caricamento blocchi %d/%d (%.2f%%)",
                param.blocchi_caricati, param.blocchi_totali, percentuale)
        minetest.chat_send_all(msg)
    end
end
```

Questo non è l'unico modo per caricare blocchi; utilizzando un LVM (nel dettaglio nel capitolo 19) si potranno infatti caricare i blocchi selezionati in maniera sincrona.

## Cancellazione blocchi

Puoi usare `delete_area` per cancellare una serie di blocchi mappa:

```lua
-- Cancella un'area 20x20x20
local mezza_dimensione = { x = 10, y = 10, z = 10 }
local pos1 = vector.subtract(pos, mezza_dimensione)
local pos2 = vector.add     (pos, mezza_dimensione)

minetest.delete_area(pos1, pos2)
```

Questo cancellerà tutti i blocchi mappa in quell'area, anche quelli solo parzialmente selezionati.
