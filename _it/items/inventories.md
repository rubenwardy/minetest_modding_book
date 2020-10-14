---
title: ItemStack e inventari
layout: default
root: ../..
idx: 2.4
description: Manipola gli InvRef e gli ItemStack
redirect_from:
- /it/chapters/inventories.html
- /it/chapters/itemstacks.html
- /it/inventories/inventories.html
- /it/inventories/itemstacks.html
---

## Introduzione  <!-- omit in toc -->

In questo capitolo, imparerai come usare e manipolare gli inventari, siano essi quelli di un giocatore, di un nodo o a sé stanti.

- [Cosa sono gli ItemStack e gli inventari?](#cosa-sono-gli-itemstack-e-gli-inventari)
- [ItemStack](#itemstack)
- [Collocazione inventari](#collocazione-inventari)
- [Liste](#liste)
  - [Dimensione e ampiezza](#dimensione-e-ampiezza)
  - [Controllare il contenuto](#controllare-il-contenuto)
- [Modificare inventari e ItemStack](#modificare-inventari-e-itemstack)
  - [Aggiungere a una lista](#aggiungere-a-una-lista)
  - [Rimuovere oggetti](#rimuovere-oggetti)
  - [Manipolazione pile](#manipolazione-pile)
- [Usura](#usura)
- [Tabelle Lua](#tabelle-lua)

## Cosa sono gli ItemStack e gli inventari?

Un ItemStack ( lett. "pila di oggetti") è il dato dietro una singola cella di un inventario.

Un *inventario* è una collezione di *liste* apposite, ognuna delle quali è una griglia 2D di ItemStack.
Lo scopo di un inventario è quello di raggruppare più liste in un singolo oggetto (l'inventario appunto), in quanto a ogni giocatore e a ogni nodo ne può essere associato massimo uno.

## ItemStack

Gli ItemStack sono composti da quattro parametri: nome, quantità, durabilità e metadati.

Il nome dell'oggetto può essere il nome di un oggetto registrato, di uno sconosciuto (non registrato) o un alias.
Gli oggetti sconosciuti sono tipici di quando si disinstallano le mod, o quando le mod rimuovono degli oggetti senza nessun accorgimento, tipo senza registrarne un alias.

```lua
print(stack:get_name())
stack:set_name("default:dirt")

if not stack:is_known() then
    print("È un oggetto sconosciuto!")
end
```

La quantità sarà sempre 0 o maggiore.
Durante una normale sessione di gioco, la quantità non dovrebbe mai essere maggiore della dimensione massima della pila dell'oggetto - `stack_max`.
Tuttavia, comandi da amministratore e mod fallate potrebbero portare a oggetti impilati che superano la grandezza massima.

```lua
print(stack:get_stack_max())
```

Un ItemStack può essere vuoto, nel qual caso avrà come quantità 0.

```lua
print(stack:get_count())
stack:set_count(10)
```

Gli ItemStack possono poi essere creati in diversi modi usando l'omonima funzione.

```lua
ItemStack() -- name="", count=0
ItemStack("default:pick_stone") -- count=1
ItemStack("default:stone 30")
ItemStack({ name = "default:wood", count = 10 })
```

I metadati di un oggetto sono una o più coppie chiave-valore custodite in esso.
Chiave-valore significa che si usa un nome (la chiave) per accedere al dato corrispettivo (il valore).
Alcune chiavi hanno significati predefiniti, come `description` che è usato per specificare la descrizione di una pila di oggetti.
Questo sarà trattato più in dettaglio nel capitolo Storaggio e Metadati.

## Collocazione inventari

La collocazione di un inventario è dove e come un inventario viene conservato.
Ci sono tre tipi di collocazione: giocatore, nodo e separata.
Un inventario è direttamente legato a una e a una sola collocazione.

Gli inventari collocati nei nodi sono associati alle coordinate di un nodo specifico, come le casse.
Il nodo deve essere stato caricato perché viene salvato [nei suoi metadati](../map/storage.html#metadata).

```lua
local inv = minetest.get_inventory({ type="node", pos={x=1, y=2, z=3} })
```

L'esempio in alto ottiene il *riferimento a un inventario*, comunemente definito *InvRef*.
Questi riferimenti sono usati per manipolare l'inventario, e son chiamati così perché i dati non sono davvero salvati dentro all'oggetto (in questo caso "inv"), bensì *puntano* a quei dati.
In questo modo, modificando "inv", stiamo in verità modificando l'inventario.

La collocazione di tali riferimenti può essere ottenuta nel seguente modo:

```lua
local location = inv:get_location()
```

Gli inventari dei giocatori si ottengono in maniera simile, oppure usando il riferimento a un giocatore (*PlayerRef*).
In entrambi casi, il giocatore deve essere connesso.

```lua
local inv = minetest.get_inventory({ type="player", name="player1" })
-- oppure
local inv = player:get_inventory()
```

Gli inventari separati, infine, sono quelli non collegati né a nodi né a giocatori, e al contrario degli altri, vengono persi dopo un riavvio.

```lua
local inv = minetest.get_inventory({
    type="detached", name="nome_inventario" })
```

Un'ulteriore differenza, è che gli inventari separati devono essere creati prima di poterci accedere:

```lua
minetest.create_detached_inventory("inventory_name")
```

La funzione `create_detached_inventory` accetta 3 parametri, di cui solo il primo - il nome - è necessario.
Il secondo parametro prende una tabella di callback, che possono essere utilizzati per controllare come i giocatori interagiscono con l'inventario:

```lua
-- Input only detached inventory
minetest.create_detached_inventory("inventory_name", {
    allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
        return count -- permette di spostare gli oggetti
    end,

    allow_put = function(inv, listname, index, stack, player)
        return stack:get_count() -- permette di inserirli
    end,

    allow_take = function(inv, listname, index, stack, player)
        return -1 -- non permette di rimuoverli
    end,

    on_put = function(inv, listname, index, stack, player)
        minetest.chat_send_all(player:get_player_name() ..
            " ha messo " .. stack:to_string() ..
            " nella cassa delle donazioni da " .. minetest.pos_to_string(player:get_pos()))
    end,
})
```

I callback dei permessi - quelle che iniziano con `allow_` - ritornano il numero degli oggetti da trasferire, e si usa -1 per impedirne del tutto l'azione.

I callback delle azioni - quelle che iniziano con `on_` - non ritornano invece alcun valore.

## Liste

Le liste negli inventari permettono di disporre più griglie nello stesso luogo (l'inventario).
Esse sono particolarmente utili per il giocatore, e infatti di base ogni gioco possiede già delle liste come *main* per il corpo principale dell'inventario e *craft* per l'area di fabbricazione.

### Dimensione e ampiezza

Le liste hanno una dimensione, equivalente al numero totale di celle nella griglia, e un'ampiezza, che è usata esclusivamente dentro il motore di gioco: quando viene disegnato un inventario in una finestra, infatti, il codice dietro di essa già determina che ampiezza usare.

```lua
if inv:set_size("main", 32) then
    inv:set_width("main", 8)
    print("dimensione:  " .. inv.get_size("main"))
    print("ampiezza: " .. inv:get_width("main"))
else
    print("Errore! Nome dell'oggetto o dimensione non validi")
end
```

`set_size` non andrà in porto e ritornerà "false" se il nome della lista o la dimensione dichiarata non risultano valide.
Per esempio, la nuova dimensione potrebbe essere troppo piccola per contenere gli oggetti attualmente presenti nell'inventario.

### Controllare il contenuto

`is_empty` può essere usato per vedere se una lista contiene o meno degli oggetti:

```lua
if inv:is_empty("main") then
    print("La lista è vuota!")
end
```

`contains_item` può invece essere usato per vedere se la lista contiene un oggetto specifico:

```lua
if inv:contains_item("main", "default:stone") then
    print("Ho trovato della pietra!")
end
```

## Modificare inventari e ItemStack

### Aggiungere a una lista

Per aggiungere degli oggetti a una lista (in questo caso "main") usiamo `add_item`.
Nell'esempio sottostante ci accertiamo anche di rispettare la dimensione:

```lua
local stack    = ItemStack("default:stone 99")
local leftover = inv:add_item("main", stack)
if leftover:get_count() > 0 then
    print("L'inventario è pieno! " ..
            leftover:get_count() .. " oggetti non sono stati aggiunti")
end
```

### Rimuovere oggetti

Per rimuovere oggetti da una lista, `remove_item`:

```lua
local taken = inv:remove_item("main", stack)
print("Rimossi " .. taken:get_count())
```

### Manipolare pile

Puoi modificare le singole pile prima ottenendole:

```lua
local stack = inv:get_stack(listname, 0)
```

E poi modificandole impostando le nuove proprietà o usando i metodi che rispettano `stack_size`:

```lua
local pila          = ItemStack("default:stone 50")
local da_aggiungere = ItemStack("default:stone 100")
local resto 	    = pila:add_item(da_aggiungere)
local rimossi       = pila:take_item(19)

print("Impossibile aggiungere "  .. resto:get_count() .. " degli oggetti.")
-- ^ sarà 51

print("Hai " .. pila:get_count() .. " oggetti")
-- ^ sarà 80
--   min(50+100, stack_max) - 19 = 80
--     dove stack_max = 99
```

`add_item` aggiungerà gli oggetti all'ItemStack e ritornerà quelli in eccesso.
`take_item` rimuoverà gli oggetti indicati (o meno se ce ne sono meno), e ritornerà l'ammontare rimosso.

Infine, si imposta la pila modificata:

```lua
inv:set_stack(listname, 0, pila)
```

## Usura

Gli strumenti possono avere un livello di usura; essa è rappresentata da un barra progressiva e fa rompere lo strumento quando completamente logorato.
Nello specifico, l'usura è un numero da 0 a 65535: più è alto, più è consumato l'oggetto.

Il livello di usura può essere manipolato usando `add_wear()`, `get_wear()`, e `set_wear(wear)`.

```lua
local pila = ItemStack("default:pick_mese")
local usi_massimi = 10

-- Questo viene fatto in automatico quando usi uno strumento che scava cose.
-- Aumenta l'usura dell'oggetto dopo un uso
pila:add_wear(65535 / (usi_massimi - 1))
```

Quando si scava un nodo, l'incremento di usura di uno strumento dipende da che tipo di nodo è.
Di conseguenza, `usi_massimi` varia a seconda di cos'è stato scavato.

## Tabelle Lua

Gli ItemStack e gli inventari possono essere convertiti in/dalle tabelle.
Questo è utile per operazioni di copiatura e immagazzinaggio.

```lua
-- Inventario intero
local data = inv1:get_lists()
inv2:set_lists(data)

-- Una lista
local listdata = inv1:get_list("main")
inv2:set_list("main", listdata)
```

La tabella di liste ritornata da `get_lists()` sarà nel seguente formato:

```lua
{
    lista_uno = {
        ItemStack,
        ItemStack,
        ItemStack,
        ItemStack,
        -- inv:get_size("lista_uno") elementi
    },
    lista_due = {
        ItemStack,
        ItemStack,
        ItemStack,
        ItemStack,
        -- inv:get_size("lista_due") elementi
    }
}
```

`get_list()` ritornerà una lista singola fatta di ItemStack.

Una cosa importante da sottolineare è che i metodi `set` qui in alto non cambiano la dimensione delle liste.
Questo significa che si può svuotare una lista dichiarandola uguale a una tabella vuota, e la sua dimensione tuttavia non cambierà:

```lua
inv:set_list("main", {})
```
