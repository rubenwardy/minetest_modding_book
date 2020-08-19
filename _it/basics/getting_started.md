---
title: Per iniziare
layout: default
root: ../..
idx: 1.1
description: Impara come si crea la cartella di una mod, un file init.lua, mod.conf e altro.
redirect_from:
- /it/chapters/folders.html
- /it/basics/folders.html
---

## Introduzione <!-- omit in toc -->

Capire la struttura base della cartella di una mod è un requisito essenziale per creare qualsivoglia contenuto.

- [Cosa sono i giochi e le mod?](#cosa-sono-i-giochi-e-le-mod)
- [Dove vengono salvate le mod?](#dove-vengono-salvate-le-mod)
- [Cartella mod](#cartella-mod)
- [Dipendenze](#dipendenze)
  - [mod.conf](#modconf)
  - [depends.txt](#dependstxt)
- [Pacchetti mod](#pacchetti-mod-mod-pack)
- [Esempio](#esempio)
  - [Cartella mod](#cartella-mod-1)
  - [depends.txt](#dependstxt-1)
  - [init.lua](#initlua)
  - [mod.conf](#modconf-1)


## Cosa sono i giochi e le mod?

Il punto forte di Minetest è l'abilità di sviluppare facilmente giochi senza il bisogno di crearsi da zero il motore grafico, gli algoritmi voxel o tutta la parte network.

In Minetest, un gioco è una collezione di moduli che lavorano insieme per fornire il contenuto e il comportamento di un gioco.
Un modulo, solitamente conosciuto come "mod", è una collezione di script e risorse, e in teoria ne potrebbe bastare uno per creare un intero gioco.
Tuttavia, questo non accade spesso, perché riduce la comodità di poter sostituire o calibrare alcune parti di quest'ultimo in maniera indipendente dalle altre.

È poi anche possibile distribuire le mod come a sé stanti, nel qual caso sono sempre mod nel senso più tradizionale del termine: modifiche.
Esse calibrano o espandono le proprietà di un gioco.

Indipendentemente da come le si voglia usare (specifiche per un gioco o come estensioni generiche) usano la stessa API.

Questo libro coprirà le parti principali della API di Minetest, ed è pensato sia per gli sviluppatori del motore di gioco (Minetest, in C++) che per i creatori di mod.


## Dove vengono salvate le mod?

<a name="mod-locations"></a>

Ogni mod ha la sua cartella personale dove viene messo il suo codice in Lua, le sue texture,
i suoi modelli e i suoi file audio. Minetest fa un check in più punti e questi punti sono generalmente chiamati *percorsi di caricamento mod* (*mod load paths*).

Per un dato mondo/salvataggio, vengono controllati tre punti.
Essi sono, in ordine:

1. Mod di gioco. Queste sono le mod che compongono il gioco che il mondo sta eseguendo.
   Es: `minetest/games/minetest_game/mods/`, `/usr/share/minetest/games/minetest/`
2. Mod globali. Il luogo dove le mod vengono quasi sempre installate. Se si è in dubbio, le si metta qui.
   Es: `minetest/mods/`
3. Mod del mondo. Il luogo dove mettere le mod che sono specifiche di un dato mondo.
   Es: `minetest/worlds/world/worldmods/`

Minetest controllerà questi punti nell'ordine sopraelencato.
Se incontra una mod con lo stesso nome di una incontrata in precedenza, l'ultima verrà caricata al posto della prima.
Questo significa, per esempio, che è possibile sovrascriverne una di gioco se ve n'è una omonima nelle globali.

La posizione di ogni percorso dipende da quale sistema operativo si sta usando, e da come è stato installato Minetest.

* **Windows:**
    * Per le build portatili, per esempio da un file .zip, vai dove hai estratto lo zip e cerca le cartelle `games`, `mods` e `worlds`.
    * Per le build installate, per esempio da un setup.exe, guarda in C:\\\\Minetest o C:\\\\Games\\Minetest.
* **GNU/Linux:**
    * Per le installazioni di sistema, guarda in `~/.minetest`.
      Attenzione che `~` equivale alla cartella home dell'utente, e che i file e le cartelle che iniziano con un punto (`.`) sono nascosti di default.
    * Per le installazioni portatili, guarda nella cartella di build.
    * Per installazioni Flatpak, guarda in `~/.var/app/net.minetest.Minetest/.minetest/mods/`.
* **MacOS**
    * Guarda in `~/Library/Application Support/minetest/`.
      Attenzione che `~` equivale alla cartella home dell'utente, per esempio `/Users/USERNAME/`.

## Cartella mod

![Find the mod's directory]({{ page.root }}/static/folder_modfolder.jpg)

Il *nome mod* è usato per riferirsi a una mod e ognuna di esse dovrebbe averne uno unico.
Questi possono includere lettere, numeri e trattini bassi, e un buon nome dovrebbe descrivere brevemente cosa fa la mod (è anche consigliato nominare la cartella della mod allo stesso modo).
Per scoprire se un nome è disponibile, prova a cercarlo su 
[content.minetest.net](https://content.minetest.net).


    mymod
    ├── init.lua (necessario) - Viene eseguito al lancio del gioco.
    ├── mod.conf (consigliato) - Contiene la descrizione e le dipendneze.
    ├── textures (opzionale)
    │   └── ... qualsiasi texture o immagine
    ├── sounds (opzionale)
    │   └── ... qualsiasi file audio
    └── ... qualsiasi altro tipo di file o cartelle

Solo il file init.lua è necessario in una mod per eseguirla al lanciare un gioco;
tuttavia, mod.conf è consigliato e altri componenti potrebbero essere richiesti a
seconda di quello che si vuole fare.

## Dipendenze

Una dipendenza avviene quando una mod ne richiede un'altra da avviare prima di essa.
Una mod potrebbe infatti richiedere il codice di quest'ultima, i suoi oggetti o altre risorse.

Ci sono due tipi di dipendenze: forti e opzionali.
Entrambe richiedono che la mod richiesta venga caricata prima, con la differenza che se la dipendenza è forte e la mod non viene trovata, l'altra fallirà nel caricare, mentre se è opzionale, verranno semplicemente caricate meno feature.

Una dipendenza opzionale è utile se si vuole integrare opzionalmente un'altra mod; può abilitare contenuti extra se l'utente desidera usare entrambe le mod in contemporanea.

Le dipendenze vanno elencate in mod.conf.

### mod.conf

Questo file è utilizzato per i metadati della mod, che includono il suo nome, la descrizione e altre informazioni.
Per esempio:

    name = lamiamod
    description = Aggiunge X, Y, e Z.
    depends = mod1, mod2
    optional_depends = mod3

### depends.txt

Per questioni di compatibilità con le versioni 0.4.x di Minetest, al posto di specificare le dipendenze solamente in mod.conf, c'è bisogno di fornire un file depends.txt nel quale vanno elencate tutte le dipendenze:

    mod1
    mod2
    mod3?

Ogni nome mod occupa una riga, e quelli seguiti da un punto di domanda indicano una dipendenza opzionale.

## Pacchetti mod (mod pack)

Le mod possono essere raggruppate in pacchetti che permettono di confezionarne e spostarne più alla volta.
Sono comodi se si vogliono fornire più mod al giocatore, ma non si vuole al tempo stesso fargliele scaricare una per una.

    pacchettomod1
    ├── modpack.lua (necessario) - segnala che è un pacchetto mod
    ├── mod1
    │   └── ... file mod
    └── mymod (opzionale)
        └── ... file mod

Attenzione che un pacchetto mod non equivale a un *gioco*. I giochi hanno una propria struttura organizzativa che verrà spiegata nel loro apposito capitolo.

## Esempio

Segue un esempio che mette insieme tutto ciò discusso finora:

### Cartella mod
    lamiamod
    ├── textures
    │   └── lamiamod_nodo.png
    ├── depends.txt
    ├── init.lua
    └── mod.conf

### depends.txt
    default

### init.lua
```lua
print("Questo file parte al caricamento!")

minetest.register_node("lamiamod:nodo", {
    description = "Questo è un nodo",
    tiles = {"lamiamod_nodo.png"},
    groups = {cracky = 1}
})
```

### mod.conf
    name = lamiamod
    descriptions = Aggiunge un nodo
    depends = default

Questa mod ha come nome "lamiamod". Ha tre file di testo: init.lua, mod.conf e depends.txt.\\
Lo script stampa un messaggio e poi registra un nodo – che sarà spiegato nel prossimo capitolo.\\
C'è una sola dipendenza, la [mod default](https://content.minetest.net/metapackages/default/), che
si trova solitamente nel Minetest Game.\\
C'è anche una texture in textures/ per il nodo.
