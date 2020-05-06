---
title: Creare le texture
layout: default
root: ../..
idx: 2.2
description: Un'introduzione sul come creare texture nel tuo editor di fiducia, e una guida a GIMP.
redirect_from: /it/chapters/creating_textures.html
---

## Introduzione <!-- omit in toc -->

Essere in grado di creare e ottimizare le texture è un'abilità alquanto utile quando si sviluppa
per Minetest.
Ci sono molti approcci sul come creare texture in pixel art, e capire questi approcci
migliorerà nettamente la qualità dei tuoi lavori.

Fornire spiegazioni dettagliate non rientra tuttavia nell'ambito di questo libro:
verranno quindi trattate solo le tecniche più semplici.
Se si vuole approfondire, ci sono comunque molti [buoni tutorial online](http://www.photonstorm.com/art/tutorials-art/16x16-pixel-art-tutorial) disponibili, che si occupano di pixel art in modo molto più dettagliato.

- [Tecniche](#tecniche)
  - [Usare la matita](#usare-la-matita)
  - [Piastrellatura (tiling)](#piastrellatura-tiling)
  - [Trasparenza](#trasparenza)
- [Programmi](#programmi)
  - [MS Paint](#ms-paint)
  - [GIMP](#gimp)

## Tecniche

### Usare la matita

Lo strumento matita è disponibile nella maggior parte dei programmi di disegno.
Quando viene impostato alla dimensione minima, ti permette di disegnare un pixel alla volta
senza alterare le atre parti dell'immagine.
Manipolando i singoli pixel si possono creare texture chiare e nette senza alcuna
sfocatura non voluta, dando inoltre un alto livello di precisione e controllo.

### Piastrellatura (tiling)

Le texture usate per i nodi dovrebbero generalmente essere progettate per ripetersi come
delle piastrelle.
Questo significa che quando piazzi più nodi con la stessa texture vicini, i bordi dovranno
allinearsi correttamente creando un effetto di continuità.

<!-- IMAGE NEEDED - cobblestone that tiles correctly -->

Se non riesci nell'allineamento, il risultato sarà molto meno
gradevole da vedere.

<!-- IMAGE NEEDED - node that doesn't tile correctly -->

### Trasparenza

La trasparenza è importante quando si creano texture per pressoché tutti gli
oggetti fabbricabili e per alcuni nodi, come il vetro.
Non tutti i programmi supportano la trasparenza, perciò assicurati di sceglierne
uno adatto ai tipi di texture che vuoi creare.

## Programmi

### MS Paint

MS Paint è un programma di disegno davvero semplice che può rivelarsi utile
per la creazione di texture base; tuttavia, non supporta la trasparenza.
Ciò di solitò non farà differenza finché ci si limiterà alle facce di un nodo (a parte nodi come il vetro),
tuttavia se la trasparenza è un requisito nelle tue texture dovresti guardare oltre.

### GIMP

GIMP viene impiegato spesso nella comunità di Minetest.
Ha una curva di apprendimento alquanto alta, dato che molte delle sue funzioni
non risultano ovvie nell'immediato.

Quando usi GIMP, puoi selezionare la matita dalla Barra degli Strumenti:

<figure>
    <img src="{{ page.root }}//static/pixel_art_gimp_pencil.png" alt="La matita su GIMP">
</figure>

È anche consigliato spuntare l'opzione "Margine netto" per la gomma.
