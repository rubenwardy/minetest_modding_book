---
title: Testing d'unità automatici
layout: default
root: ../..
idx: 8.5
---

## Introduzione <!-- omit in toc -->

I testing d'unità sono uno strumento essenziale nell'assicurarsi che il codice sia corretto.
Questo capitolo ti mostrerà come scrivere questi per le mod e i giochi di Minetest usando Busted.
Scrivere i testing d'unità per le funzioni dove vengono chiamate quelle di Minetest è alquanto difficile, ma per fortuna abbiamo già discusso [nel capitolo precedente](clean_arch.html) come strutturare il codice in modo da non complicarci la vita.

- [Installare Busted](#installare-busted)
- [Il tuo primo test](#il-tuo-primo-test)
  - [init.lua](#initlua)
  - [api.lua](#apilua)
  - [tests/api_spec.lua](#testsapispeclua)
- [Simulare: usare funzioni esterne](#simulare-usare-funzioni-esterne)
- [Controllare commit con Travis](#controllare-commit-con-travis)
- [Conclusione](#conclusione)

## Installare Busted

Prima di tutto, c'è bisogno di installare LuaRocks.

* Windows: segui le istruzioni sulla [wiki di LuaRocks](https://github.com/luarocks/luarocks/wiki/Installation-instructions-for-Windows).
* Debian/Ubuntu Linux: `sudo apt install luarocks`

Poi, dovresti installare Busted a livello globale:

    sudo luarocks install busted

Infine, controlla che sia installato:

    busted --version


## Il tuo primo test

Busted è il quadro strutturale (o *framework*) per eccellenza di Lua.
Quello che fa è cercare i file Lua con il nome che termina in `_spec`, eseguendoli poi in un ambiente Lua a sé stante.

    miamod/
    ├── init.lua
    ├── api.lua
    └── test
        └── api_spec.lua


### init.lua

```lua
miamod = {}

dofile(minetest.get_modpath("miamod") .. "/api.lua")
```



### api.lua

```lua
function miamod.somma(x, y)
    return x + y
end
```

### tests/api_spec.lua

```lua
-- Cerca le cose necessarie in package.path = "../?.lua;" .. package.path

-- Imposta la globale miamod per far sì che l'API possa scriverci sopra
_G.mymod = {} --_
-- Esegue il file api.lua
require("api")

-- Test vari
describe("somma", function()
    it("aggiunge", function()
        assert.equals(2, miamod.somma(1, 1))
    end)

    it("supporta valori negativi", function()
        assert.equals(0,  miamod.somma(-1,  1))
        assert.equals(-2, miamod.somma(-1, -1))
    end)
end)
```

Puoi ora eseguire i vari test aprendo un terminale nella cartella della mod ed eseguendo `busted .`.

È importante che il file dell'API non crei da sé la tabella, in quanto le variabili globali su Busted funzionano diversamente.
Ogni variabile che dovrebbe essere globale su Minetest è invece un file locale su Busted.
Sarebbe stato un modo migliore per Minetest di gestire le cose, ma è ormai troppo tardi per renderlo realtà.

Un'altra cosa da notare è che qualsiasi file si stia testando, bisognerebbe evitare che chiami funzioni al di fuori di esso.
Si tende infatti a scrivere i test che controllino un solo file alla volta.


## Simulare: usare funzioni esterne

Il simulare (*mocking*) è la pratica di sostituire le funzioni dalle quali la parte di codice da testare è dipendente.
Questo può avere due obiettivi: il primo, la funzione potrebbe non essere disponibile nell'area di testing; il secondo, si potrebbero voler catturare le chiamate alla funzione e gli argomenti da essa passati.

Se si sono seguiti i consigli nel capitolo delle [Architetture pulite](clean_arch.html), si avrà già un file bello pronto da testare, anche se si dovrà comunque simulare le cose non contenute nell'area di testing (per esempio, la vista quando si testa il controllo/API).
Se invece si è deciso di lasciar perdere quella parte, allora le cose sono un po' più complicate in quanto ci sarà da simulare anche la API di Minetest.

```lua
-- come prima, crea una tabella
_G.minetest = {}

-- Definisce la funzione simulata
local chiamate_chat_send_all = {}
function minetest.chat_send_all(name, message)
    table.insert(chiamate_chat_send_all, { nome = name, messaggio = message })
end

-- Test
describe("elenca_aree", function()
    it("ritorna una riga per ogni area", function()
        chiamate_chat_send_all = {} -- resetta la tabella

        miamod.elenca_aree_chat("singleplayer", "singleplayer")

        assert.equals(2, #chiamate_chat_send_all)
    end)

    it("invia al giocatore giusto", function()
        chiamate_chat_send_all = {} -- resetta la tabella

        miamod.elenca_aree_chat("singleplayer", "singleplayer")

        for _, chiamata in pairs(chiamate_chat_send_all) do --_
            assert.equals("singleplayer", chiamata.nome)
        end
    end)

    -- I due test qui in alto in verità sono inutili in quanto
    -- questo li esegue entrambi
    it("ritorna correttamente", function()
        chiamate_chat_send_all = {} -- resetta la tabella

        miamod.elenca_aree_chat("singleplayer", "singleplayer")

        local previsto = {
            { nome = "singleplayer", messaggio = "Town Hall (2,43,63)" },
            { nome = "singleplayer", messaggio = "Airport (43,45,63)" },
        }
        assert.same(previsto, chiamate_chat_send_all)
    end)
end)
```


## Controllare commit con Travis

Lo script di Travis usato nel capitolo [Controllo automatico degli errori](luacheck.html) può essere modificato per eseguire (anche) Busted

```yml
language: generic
sudo: false
addons:
  apt:
    packages:
    - luarocks
before_install:
  - luarocks install --local luacheck && luarocks install --local busted
script:
- $HOME/.luarocks/bin/luacheck .
- $HOME/.luarocks/bin/busted .
notifications:
  email: false
```


## Conclusione

I testing d'unità aumenteranno notevolmente la qualità e l'affidabilità di un progetto se usati adeguatamente, ma ti richiederanno di strutturare il codice in maniera diversa dal solito.

Per un esempio di mod con molti testing d'unità, vedere la [crafting di rubenwardy](https://github.com/rubenwardy/crafting).
