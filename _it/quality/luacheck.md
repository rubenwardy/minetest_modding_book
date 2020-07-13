---
title: Controllo automatico degli errori
layout: default
root: ../..
idx: 8.2
description: Usa LuaCheck per trovare eventuali errori
redirect_from: /it/chapters/luacheck.html
---

## Introduzione <!-- omit in toc -->

In questo capitolo, imparerai come usare uno strumento chiamato LuaCheck per scansionare automaticamente le tue mod alla ricerca di eventuali errori.
LuaCheck può essere usato in combinazione con l'editor per fornire avvertimenti vari.

- [Installare LuaCheck](#installare-luacheck)
  - [Windows](#windows)
  - [Linux](#linux)
- [Eseguire LuaCheck](#eseguire-luacheck)
- [Configurare LuaCheck](#configurare-luacheck)
  - [Risoluzione problemi](#risoluzione-problemi)
- [Uso nell'editor](#uso-nelleditor)
- [Controllare i commit con Travis](#controllare-i-commit-con-travis)

## Installare LuaCheck

### Windows

Basta scaricare luacheck.exe dall'apposita [pagina delle release su Github](https://github.com/mpeterv/luacheck/releases).

### Linux

Per prima cosa, avrai bisogno di installare LuaRocks:

    sudo apt install luarocks

Poi va installato globalmente LuaCheck:

    sudo luarocks install luacheck

Per controllare che sia stato installato correttamente, fai:

    luacheck -v

## Eseguire LuaCheck

La prima volta che si esegue LuaCheck, segnalerà probabilmente un sacco di falsi errori.
Questo perché ha ancora bisogno di essere configurato.

Su Windows, apri la powershell o la bash nella cartella principale del tuo progetto ed esegui `path\to\luacheck.exe .`

Su Linux, esegui `luacheck .` nella cartella principale del progetto.

## Configurare LuaCheck

Crea un file chiamato .luacheckrc nella cartella principale del tuo progetto.
Questa può essere quella di un gioco, di una modpack o di una mod.

Inserisci il seguente codice all'interno:

```lua
unused_args = false
allow_defined_top = true

globals = {
    "minetest",
}

read_globals = {
    string = {fields = {"split"}},
    table = {fields = {"copy", "getn"}},

    -- Builtin
    "vector", "ItemStack",
    "dump", "DIR_DELIM", "VoxelArea", "Settings",

    -- MTG
    "default", "sfinv", "creative",
}
```

Poi, avrai bisogno di assicurarti che funzioni eseguendo LuaCheck: dovresti ottenere molti meno errori questa volta.
Partendo dal primo errore, modifica il codice per risolvere il problema, o modifica la configurazione di LuaCheck se il codice è corretto.
Dai un occhio alla lista sottostante.

### Risoluzione problemi

* **accessing undefined variable foobar** - Se `foobar` dovrebbe essere una variabile globale, aggiungila a `read_globals`.
  Altrimenti, manca un `local` vicino a `foobar`.
* **setting non-standard global variable foobar** - Se `foobar` dovrebbe essere una variabile globale, aggiungila a `globals`.
  Rimuovila da `read_globals` se presente.
  Altrimenti, manca un `local` vicino a `foobar`.
* **mutating read-only global variable 'foobar'** - Sposta `foobar` da `read_globals` a `globals`, o smetti di modificare `foobar`.

## Uso nell'editor

È caldamente consigliato installare un'estensione per il tuo editor di fiducia che ti mostri gli errori senza eseguire alcun comando.
Queste sono disponibili nella maggior parte degli editor, come:

* **Atom** - `linter-luacheck`;
* **VSCode** - Ctrl+P, poi incolla: `ext install dwenegar.vscode-luacheck`;
* **Sublime** - Installala usando package-control:
        [SublimeLinter](https://github.com/SublimeLinter/SublimeLinter),
        [SublimeLinter-luacheck](https://github.com/SublimeLinter/SublimeLinter-luacheck).

## Controllare i commit con Travis

Se il tuo progetto è pubblico ed è su Github, puoi usare TravisCI - un servizio gratuito per eseguire controlli sui commit.
Questo significa che ogni commit pushato verrà controllato secondo le impostazioni di LuaCheck, e una spunta verde o una X rossa appariranno al suo fianco per segnalare se sono stati trovati errori o meno.
Ciò è utile soprattutto per quando il tuo progetto riceve una richiesta di modifica (*pull request*) per verificare se il codice è scritto bene senza doverlo scaricare.

Prima di tutto, vai su [travis-ci.org](https://travis-ci.org/) ed esegui l'accesso con il tuo account Github.
Dopodiché cerca la repo del tuo progetto nel tuo profilo Travis, e abilita Travis cliccando sull'apposito bottone.

Poi, crea un file chiamato `.travis.yml` con il seguente contenuto:

```yml
language: generic
sudo: false
addons:
  apt:
    packages:
    - luarocks
before_install:
  - luarocks install --local luacheck
script:
- $HOME/.luarocks/bin/luacheck .
notifications:
  email: false
```

Se il tuo progetto è un gioco piuttosto che una mod o un pacchetto di mod, cambia la riga dopo `script:` con:

```yml
- $HOME/.luarocks/bin/luacheck mods/
```

Ora esegui il commit e il push su Github.
Vai alla pagina del tuo progetto e clicca su "commits".
Dovresti vedere un cerchietto arancione di fianco al commit che hai appena fatto.
Dopo un po' di tempo il cerchietto dovrebbe cambiare in una spunta verde o in una X rossa (a seconda dell'esito, come detto prima).
In entrambi i casi, puoi cliccare l'icona per vedere il resoconto dell'operazione e l'output di LuaCheck.
