---
title: HUD
layout: default
root: ../..
idx: 4.6
description: come creare elementi a schermo
redirect_from: /it/chapters/hud.html
---

## Introduzione <!-- omit in toc -->

Le HUD (Heads Up Display) ti permettono di mostrare testi, immagini e altri elementi grafici senza interrompere il giocatore.
Le HUD, infatti, non accettano input dall'utente, lasciando quel ruolo ai [formspec](formspecs.html).

- [Posizionamento](#posizionamento)
	- [Posizione e scostamento](#posizione-e-scostamento)
	- [Allineamento](#allineamento)
	- [Esempio: tabellone segnapunti](#esempio-tabellone-segnapunti)
- [Elementi di testo](#elementi-di-testo)
	- [Parametri](#parametri)
	- [Tornando all'esempio](#tornando-allesempio)
- [Elementi immagine](#elementi-immagine)
	- [Parametri](#parametri-1)
	- [Tornando all'esempio](#tornando-allesempio-1)
- [Cambiare un elemento](#cambiare-un-elemento)
- [Salvare gli ID](#salvare-gli-id)
- [Altri elementi](#altri-elementi)

## Posizionamento

### Posizione e scostamento

<figure class="right_image">
    <img
        width="300"
        src="{{ page.root }}//static/hud_diagram_center.svg"
        alt="Diagramma che mostra un elemento di testo centrato">
</figure>

Essendoci schermi di tutte le dimensioni e risoluzioni, per funzionare bene le HUD devono sapersi adattare a ognuno di essi.

Per ovviare al problema, Minetest specifica il collocamento di un elemento usando sia una posizione in percentuale che uno scostamento (*offset*).
La posizione percentuale è relativa alla grandezza dello schermo, dacché per posizionarne un elemento al centro, bisogna fornire un valore di 0.5 (cioè il 50%).

Lo scostamento è poi usato per - appunto - scostare un elemento in relazione alla sua posizione.

<div style="clear:both;"></div>

### Allineamento

L'allineamento (*alignment*) è dove il risultato della posizione e dello scostamento viene applicato sull'elemento - per esempio, `{x = -1.0, y = 0.0}` allineerà i valori degli altri due parametri sulla sinistra dell'elemento.
Questo è particolarmente utile quando si vuole allineare del testo a sinistra, a destra o al centro.

<figure>
    <img
        width="500"
        src="{{ page.root }}//static/hud_diagram_alignment.svg"
        alt="Diagramma che mostra i vari tipi di allineamento">
</figure>

Il diagramma qui in alto mostra mostra tre finestre (in blu), ognuna contenente un elemento HUD (in giallo) con ogni volta un allineamento diverso.
La freccia è il risultato del calcolo di posizione e scostamento.

### Esempio: tabellone segnapunti

Per capire meglio il capitolo, vedremo come posizionare e aggiornare un pannello contenente dei punti come questo:

<figure>
    <img
        src="{{ page.root }}//static/hud_final.png"
        alt="Screenshot dell'HUD da realizzare">
</figure>

Nello screenshot sovrastante, tutti gli elementi hanno la stessa posizione percentuale (100%, 50%) - ma scostamenti diversi.
Questo permette all'intero pannello di essere ancorato sulla destra della finestra, senza posizioni/scostamenti strani al ridimensionarla.

## Elementi di testo

Puoi creare un elemento HUD una volta ottenuto il riferimento al giocatore al quale assegnarla:

```lua
local giocatore = minetest.get_player_by_name("tizio")
local idx = giocatore:hud_add({
     hud_elem_type = "text",
     position      = {x = 0.5, y = 0.5},
     offset        = {x = 0,   y = 0},
     text          = "Ciao mondo!",
     alignment     = {x = 0, y = 0},  -- allineamento centrato
     scale         = {x = 100, y = 100}, -- lo vedremo tra poco
})
```

La funzione `hud_add` ritorna l'ID di un elemento, che è utile per modificarlo o rimuoverlo.

### Parametri

Il tipo dell'elemento è ottenuto usando la proprietà `hud_elem_type` nella tabella di definizione.
Cambiando il tipo, cambia il significato di alcune delle proprietà che seguono.

`scale` sono i limiti del testo; se esce da questo spazio, viene tagliato - nell'esempio `{x=100, y=100}`.

`number` è il colore del testo, ed è in [formato esadecimale](http://www.colorpicker.com/) - nell'esempio `0xFF0000`.


### Tornando all'esempio

Andiamo avanti e piazziamo tutto il testo nel nostro pannello (si son tenute le stringhe in inglese per non confondere con l'immagine, NdT):

```lua
-- Ottiene il numero di blocchi scavati e piazzati dallo spazio d'archiviazione; se non esiste è 0
local meta        = giocatore:get_meta()
local digs_testo   = "Digs: " .. meta:get_int("punteggio:digs")
local places_testo = "Places: " .. meta:get_int("punteggio:places")

giocatore:hud_add({
    hud_elem_type = "text",
    position  = {x = 1, y = 0.5},
    offset    = {x = -120, y = -25},
    text      = "Stats",
    alignment = 0,
    scale     = { x = 100, y = 30},
    number    = 0xFFFFFF,
})

giocatore:hud_add({
    hud_elem_type = "text",
    position  = {x = 1, y = 0.5},
    offset    = {x = -180, y = 0},
    text      = digs_testo,
    alignment = -1,
    scale     = { x = 50, y = 10},
    number    = 0xFFFFFF,
})

giocatore:hud_add({
    hud_elem_type = "text",
    position  = {x = 1, y = 0.5},
    offset    = {x = -70, y = 0},
    text      = places_testo,
    alignment = -1,
    scale     = { x = 50, y = 10},
    number    = 0xFFFFFF,
})
```

Il risultato è il seguente:

<figure>
    <img
        src="{{ page.root }}//static/hud_text.png"
        alt="Screenshot della HUD finora">
</figure>


## Elementi immagine

Le immagini sono create in un modo molto simile a quelli del testo:

```lua
player:hud_add({
    hud_elem_type = "image",
    position  = {x = 1, y = 0.5},
    offset    = {x = -220, y = 0},
    text      = "punteggio_sfondo.png",
    scale     = { x = 1, y = 1},
    alignment = { x = 1, y = 0 },
})
```

Siamo ora a questo punto:

<figure>
    <img
        src="{{ page.root }}//static/hud_background_img.png"
        alt="Screenshot della HUD finora">
</figure>

### Parametri

Il campo `text` in questo caso viene usato per fornire il nome dell'immagine.

Se una coordinata in `scale` è positiva, allora è un fattore scalare dove 1 è la grandezza originale, 2 è il doppio e così via.
Tuttavia, se una coordinata è negativa, sarà la percentuale della grandezza dello schermo.
Per esempio, `x=-100` equivale al 100% della larghezza di quest'ultimo.

### Tornando all'esempio

Creiamo la barra di progresso per il nostro tabellone usando `scale`:

```lua
local percentuale = tonumber(meta:get("punteggio:score") or 0.2)

giocatore:hud_add({
    hud_elem_type = "image",
    position  = {x = 1, y = 0.5},
    offset    = {x = -215, y = 23},
    text      = "barra_punteggio_vuota.png",
    scale     = { x = 1, y = 1},
    alignment = { x = 1, y = 0 },
})

giocatore:hud_add({
    hud_elem_type = "image",
    position  = {x = 1, y = 0.5},
    offset    = {x = -215, y = 23},
    text      = "barra_punteggio_piena.png",
    scale     = { x = percentuale, y = 1},
    alignment = { x = 1, y = 0 },
})
```

Abbiamo ora una HUD uguale identica a quella della prima immagine!
C'è un problema, tuttavia: non si aggiornerà al cambiare delle statistiche.

## Cambiare un elemento

Per cambiare un elemento si usa l'ID ritornato dal metodo `hud_add`.

```lua
local idx = giocatore:hud_add({
     hud_elem_type = "text",
     text          = "Ciao mondo!",
     -- parametri rimossi per brevità
})

giocatore:hud_change(idx, "text", "Nuovo testo")
giocatore:hud_remove(idx)
```

Il metodo `hud_change` prende l'ID dell'elemento, la proprietà da cambiare e il nuovo valore.
La chiamata qui sopra cambia la proprietà `text` da "Ciao mondo!" a "Nuovo test".

Questo significa che fare `hud_change` subito dopo `hud_add` è funzionalmente equivalente a
fare ciò che segue, in maniera alquanto inefficiente:

```lua
local idx = giocatore:hud_add({
     hud_elem_type = "text",
     text          = "Nuovo testo",
})
```

## Salvare gli ID

```lua
local hud_salvate = {}

function punteggio.aggiorna_hud(giocatore)
    local nome_giocatore = giocatore:get_player_name()

    -- Ottiene il numero di blocchi scavati e piazzati dallo spazio d'archiviazione; se non esiste è 0
    local meta            = giocatore:get_meta()
    local digs_testo      = "Digs: " .. meta:get_int("punteggio:digs")
    local places_testo    = "Places: " .. meta:get_int("punteggio:places")
    local percentuale     = tonumber(meta:get("punteggio:score") or 0.2)

    local ids = hud_salvate[nome_giocatore]
    if ids then
        giocatore:hud_change(ids["places"], "text", places_testo)
        giocatore:hud_change(ids["digs"],   "text", digs_testo)
        giocatore:hud_change(ids["bar_foreground"],
                "scale", { x = percentuale, y = 1 })
    else
        ids = {}
        hud_salvate[player_name] = ids

        -- crea gli elementi HUD e imposta gli ID in `ids`
    end
end

minetest.register_on_joinplayer(punteggio.aggiorna_hud)

minetest.register_on_leaveplayer(function(player)
    hud_salvate[player:get_player_name()] = nil
end)
```


## Altri elementi

Dai un occhio a [lua_api.txt](https://minetest.gitlab.io/minetest/hud/) per una lista completa degli elementi HUD.
