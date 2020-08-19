---
title: Storaggio e metadati
layout: default
root: ../..
idx: 3.3
description: Scopri come funziona lo spazio d'archiviazione delle mod e come usare i metadati per passare informazioni.
redirect_from:
  - /it/chapters/node_metadata.html
  - /it/map/node_metadata.html
---

## Introduzione <!-- omit in toc -->

In questo capitolo imparerai i vari modi per immagazzinare dati.

- [Metadati](#metadati)
  - [Cos'è un metadato?](#cos-e-un-metadato)
  - [Ottenere i metadati di un oggetto](#ottenere-i-metadati-di-un-oggetto)
  - [Lettura e scrittura](#lettura-e-scrittura)
  - [Chiavi speciali](#chiavi-speciali)
  - [Immagazzinare tabelle](#immagazzinare-tabelle)
  - [Metadati privati](#metadati-privati)
  - [Tabelle Lua](#tabelle-lua)
- [Storaggio mod](#storaggio-mod)
- [Database](#database)
- [Decidere quale usare](#decidere-quale-usare)
- [Il tuo turno](#il-tuo-turno)

## Metadati

### Cos'è un metadato?

In Minetest, un metadato è una coppia chiave-valore usata per collegare dei dati a qualcosa.
Puoi usare i metadati per salvare informazioni nei nodi, nei giocatori o negli ItemStack.

Ogni tipo di metadato usa la stessa identica API.
Ognuno di essi salva i valori come stringhe, ma ci sono comunque dei metodi per convertire e salvare altri tipi di primitivi.

Per evitare conflitti con altre mod, dovresti usare la nomenclatura convenzionale per le chiavi: `nomemod:nomechiave`.
Alcune chiavi hanno invece un significato speciale, come vedremo più in basso.

Ricorda che i metadati sono dati riguardo altri dati.
Il dato in sé, come il tipo di un nodo o la quantità di un ItemStack, non rientra perciò nella definizione.

### Ottenere i metadati di un oggetto

Se si conosce la posizione di un nodo, si possono ottenere i suoi metadati:

```lua
local meta = minetest.get_meta({ x = 1, y = 2, z = 3 })
```

Quelli dei giocatori e degli ItemStack invece sono ottenuti tramite `get_meta()`:

```lua
local p_meta = player:get_meta()
local i_meta = pila:get_meta()
```

### Lettura e scrittura

Nella maggior parte dei casi, per leggere e scrivere metadati saranno usati i metodi `get_<type>()` e `set_<type>()`.

```lua
print(meta:get_string("foo")) --> ""
meta:set_string("foo", "bar")
print(meta:get_string("foo")) --> "bar"
```

Tutti i getter ritorneranno un valore di default se la chiave non esiste, rispettivamente `""` per le stringhe e `0` per gli interi.
Si può inoltre usare `get()` per ritornare o una stringa o nil.

Come gli inventari, anche i metadati sono riferimenti: ogni cambiamento applicato ad essi, cambierà la fonte originale.

Inoltre, se è possibile convertire un intero in stringa e viceversa, basterà cambiare `get_int`/`get_string` per ottenerne la versione corrispondente:

```lua
print(meta:get_int("count"))    --> 0
meta:set_int("count", 3)
print(meta:get_int("count"))    --> 3
print(meta:get_string("count")) --> "3"
```

### Chiavi speciali

`infotext` è usato nei nodi per mostrare una porzione di testo al passare il mirino sopra il nodo.
Questo è utile, per esempio, per mostrare lo stato o il proprietario di un nodo.

`description` è usato negli ItemStack per sovrascrivere la descrizione al passare il mouse sopra l'oggetto in un formspec (come l'inventario, li vedremo più avanti).
È possibile utilizzare `minetest.colorize()` per cambiarne il colore.

`owner` è una chiave comune, usata per immagazzinare il nome del giocatore a cui appartiene l'oggetto o il nodo.

### Immagazzinare tabelle

Le tabelle devono essere convertite in stringhe prima di essere immagazzinate.
Minetest offre due formati per fare ciò: Lua e JSON.

Quello in Lua tende a essere molto più veloce e corrisponde al formato usato da Lua per le tabelle, mentre JSON è un formato più standard, con una miglior struttura, e che ben si presta per scambiare informazioni con un altro programma.

```lua
local data = { username = "utente1", score = 1234 }
meta:set_string("foo", minetest.serialize(data))

data = minetest.deserialize(minetest:get_string("foo"))
```

### Metadati privati

Le voci nei metadati di un nodo possono essere segnate come private, senza venire quindi inviate al client (al contrario delle normali).

```lua
meta:set_string("segreto", "asd34dn")
meta:mark_as_private("segreto")
```

### Tabelle Lua

Le tabelle possono essere convertite da/a stringhe nei metadati tramite `to_table` e `from_table`:

```lua
local tmp = meta:to_table()
tmp.foo = "bar"
meta:from_table(tmp)
```

## Storaggio Mod

Lo spazio d'archiviazione della mod (*storage*) usa la stessa identica API dei metadati, anche se non sono tecnicamente la stessa cosa.
Il primo infatti è per mod, e può essere ottenuto solo durante l'inizializzazione - appunto - della mod.

```lua
local memoria = minetest.get_mod_storage()
```

Nell'esempio è ora possibile manipolare lo spazio d'archiviazione come se fosse un metadato:

```lua
memoria:set_string("foo", "bar")
```

## Database

Se la mod ha buone probabilità di essere usata su un server e tenere traccia di un sacco di dati, è buona norma offrire un database come metodo di storaggio.
Dovresti rendere ciò opzionale, separando il come i dati vengono salvati e il dove vengono usati.

```lua
local backend
if use_database then
    backend =
        dofile(minetest.get_modpath("miamod") .. "/backend_sqlite.lua")
else
    backend =
        dofile(minetest.get_modpath("miamod") .. "/backend_storage.lua")
end

backend.get_foo("a")
backend.set_foo("a", { score = 3 })
```

Il file `backend_storage.lua` dell'esempio (puoi nominarlo come vuoi) dovrebbe includere l'implementazione del metodo di storaggio:

```lua
local memoria = minetest.get_mod_storage()
local backend = {}

function backend.set_foo(key, value)
    memoria:set_string(key, minetest.serialize(value))
end

function backend.get_foo(key, value)
    return minetest.deserialize(memoria:get_string(key))
end

return backend
```

Il file `backend_sqlite.lua` dovrebbe fare una cosa simile, ma utilizzando la libreria Lua *lsqlite3* al posto della memoria d'archiviazione interna.

Usare un database come SQLite richiede l'utilizzo di un ambiente non sicuro (*insecure environment*).
Un ambiente non sicuro è una tabella disponibile solamente alle mod con accesso esplicito dato dall'utente, e contiene una copia meno limitata della API Lua, che potrebbe essere abusata da mod con intenzioni malevole.
Gli ambienti non sicuri saranno trattati più nel dettaglio nel capitolo sulla [Sicurezza](../quality/security.html).

```lua
local amb_nonsicuro = minetest.request_insecure_environment()
assert(amb_nonsicuro, "Per favore aggiungi miamod a secure.trusted_mods nelle impostazioni")

local _sql = amb_nonsicuro.require("lsqlite3")
-- Previene che altre mod usino la libreria globale sqlite3
if sqlite3 then
    sqlite3 = nil
end
```

Spiegare il funzionamento di SQL o della libreria lsqlite non rientra nell'obiettivo di questo libro.

## Decidere quale usare

Il tipo di metodo che si sceglie di utilizzare dipende dal tipo di dati trattati, come sono formattati e quanto sono grandi.
In linea di massima, i dati piccoli vanno fino ai 10KB, quelli medi 10MB, e quelli grandi oltre i 10MB.

I metadati dei nodi sono un'ottima scelta quando si vogliono immagazzinare dati relativi al nodo.
Inserirne di medi (quindi massimo 10MB) è abbastanza efficiente se si rendono privati.

Quelli degli oggetti invece dovrebbero essere usati solo per piccole quantità di dati e non è possibile evitare di inviarli al client.
I dati, poi, saranno anche copiati ogni volta che la pila viene spostata o ne viene fatto accesso tramite Lua.

La memoria interna della mod va bene per i dati di medie dimensioni, tuttavia provare a salvarne di grandi potrebbe rivelarsi inefficiente.
È meglio usare un database per le grandi porzioni di dati, onde evitare di dover sovrascrivere tutti i dati a ogni salvataggio.

I database sono fattibili solo per i server a causa della necessità di lasciar passare la mod nell'ambiente non sicuro.
Si prestano bene per i grandi ammontare di dati.

## Il tuo turno

* Crea un nodo che sparisce dopo essere stato colpito cinque volte.
(Usa `on_punch` nella definizione del nodo e `minetest.set_node`)
