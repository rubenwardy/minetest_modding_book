---
title: Chat Command Builder
layout: default
root: ../..
idx: 4.3
description: Creazione di comandi complessi semplificandosi la vita
redirect_from: /it/chapters/chat_complex.html
---

## Introduzione <!-- omit in toc -->

Questo capitolo ti mostrerà come creare comandi complessi con ChatCmdBuilder, come `/msg <nome> <messaggio>`, `/team entra <nometeam>` o `/team esci <nometeam>`.

Tieni conto che ChatCmdBuilder è una libreria creata dall'autore di questo libro, e che molti modder tendono a usare il metodo illustrato nel capitolo [Chat e comandi](chat.html#complex-subcommands).

- [Perché ChatCmdBuilder?](#perche-chatcmdbuilder)
- [Tratte](#tratte)
- [Funzioni nei sottocomandi](#funzioni-nei-sottocomandi)
- [Installare ChatCmdBuilder](#installare-chatcmdbuilder)
- [Esempio: comando complesso /admin](#esempio-comando-complesso-admin)

## Perché ChatCmdBuilder?

Le mod tradizionali implementano questi comandi complessi usando i pattern Lua.

```lua
local nome = string.match(param, "^join ([%a%d_-]+)")
```

Io, tuttavia, trovo i pattern Lua illeggibili e scomodi.
Per via di ciò, ho creato una libreria che ti semplifichi la vita.

```lua
ChatCmdBuilder.new("sethp", function(cmd)
    cmd:sub(":target :hp:int", function(name, target, hp)
        local giocatore = minetest.get_player_by_name(target)
        if giocatore then
            giocatore:set_hp(hp)
            return true, "Gli hp di " .. target .. " sono ora " .. hp
        else
            return false, "Giocatore " .. target .. " non trovato"
        end
    end)
end, {
    description = "Imposta gli hp del giocatore",
    privs = {
        kick = true
        -- ^ è probabilmente meglio impostare un nuovo privilegio
    }
})
```

`ChatCmdBuilder.new(name, setup_func, def)` crea un nuovo comando chiamato `name`.
Poi, chiama la funzione passatagli (`setup_func`), che crea a sua volta i sottocomandi.
Ogni `cmd:sub(route, func)` è un sottocomando.

Un sottocomando è una particolare risposta a un parametro di input.
Quando un giocatore esegue il comando, il primo sottocomando che combacia con l'input verrà eseguito.
Se non ne viene trovato nessuno, il giocatore verrà avvisato della sintassi non valida.
Nel codice qui in alto, per esempio, se qualcuno scrive qualcosa come `/sethp nickname 12`, la funzione corrispondente verrà chiamata.
Tuttavia, qualcosa come `/sethp 12 bleh` genererà un messaggio d'errore.

`:name :hp:int` è una tratta.
Descrive il formato del parametro passato a /teleport.

## Tratte

Una tratta è composta di fermate e variabili, dove le prime sono obbligatorie.
Una fermata è per esempio `crea` in `/team crea :nometeam :giocatorimassimi:int`, ma anche gli spazi contano come tali.

Le variabili possono cambiare valore a seconda di cosa scrive l'utente. Per esempio `:nometeam` e `:giocatorimassimi:int`.

Le variabili sono definite con `:nome:tipo`: il nome è usato nella documentazione, mentre il tipo è usato per far combaciare l'input.
Se il tipo non è specificato, allora sarà di base `word`.

I tipi consentiti sono:

* `word`   - Predefinito. Qualsiasi stringa senza spazi;
* `int`    - Qualsiasi numero intero;
* `number` - Qualsiasi numero, decimali inclusi;
* `pos`    - Coordinate. Il formato può essere 1,2,3, o 1.1,2,3.4567, o (1,2,3), o ancora 1.2, 2 ,3.2;
* `text`   - Qualsiasi stringa, spazi inclusi. Può esserci solo un `text` e non può essere seguito da nient'altro.

In `:nome :hp:int`, ci sono due variabili:

* `name` - di tipo `word` in quanto non è stato specificato
* `hp` - di tipo `int`, quindi un numero intero

## Funzioni nei sottocomandi

Il primo parametro è il nome di chi invia il comando. Le variabili sono poi passate alla funzione nell'ordine in cui sono state dichiarate.

```lua
cmd:sub(":target :hp:int", function(name, target, hp)
    -- funzione del sottocomando
end)
```

## Installare ChatCmdBuilder

Il codice sorgente può essere trovato e scaricato su
[Github](https://github.com/rubenwardy/ChatCmdBuilder/).

Ci sono due modi per installarlo:

1. Installarlo come una mod a sé stante;
2. Includere nella tua mod l'init.lua di ChatCmdBuilder rinominandolo chatcmdbuilder.lua, e integrarlo tramite `dofile`.

## Esempio: comando complesso /admin

Segue un esempio che crea un comando che aggiunge le seguenti funzioni per chi ha il permesso `kick` e `ban` (quindi, in teoria, un admin):

* `/admin uccidi <nome>` - uccide un utente;
* `/admin sposta <nome> a <pos>` - teletrasporta un utente;
* `/admin log <nome>` - mostra il log di un utente;
* `/admin log <nome> <messaggio>` - aggiunge un messaggio al log di un utente.

```lua
local admin_log
local function carica()
    admin_log = {}
end
local function salva()
    -- todo
end
carica()

ChatCmdBuilder.new("admin", function(cmd)
    cmd:sub("uccidi :nome", function(name, target)
        local giocatore = minetest.get_player_by_name(target)
        if giocatore then
            giocatore:set_hp(0)
            return true, "Hai ucciso " .. target
        else
            return false, "Unable to find " .. target
        end
    end)

    cmd:sub("sposta :nome to :pos:pos", function(nome, target, pos)
        local giocatore = minetest.get_player_by_name(target)
        if giocatore then
            giocatore:setpos(pos)
            return true, "Giocatore " .. target .. " teletrasportato a " ..
                    minetest.pos_to_string(pos)
        else
            return false, "Giocatore " .. target .. " non trovato"
        end
    end)

    cmd:sub("log :nome", function(name, target)
        local log = admin_log[target]
        if log then
            return true, table.concat(log, "\n")
        else
            return false, "Nessuna voce per " .. target
        end
    end)

    cmd:sub("log :nome :messaggio", function(name, target, messaggio)
        local log = admin_log[target] or {}
        table.insert(log, messaggio)
        admin_log[target] = log
        salva()
        return true, "Aggiunto"
    end)
end, {
    description = "Strumenti per gli admin",
    privs = {
        kick = true,
        ban = true
    }
})
```
