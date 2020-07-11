---
title: Biomi e decorazioni
author: Shara
layout: default
root: ../..
idx: 6.1
description: Crea biomi e decorazioni per personalizzare la mappa
---

## Introduzione <!-- omit in toc -->

L'abilità di registrare biomi e decorazioni è vitale quando si vuole creare un ambiente di gioco variegato e interessante.
Questo capitolo mostra come registrare nuovi biomi, come controllarne la distribuzione, e come aggiungerci decorazioni.

- [Cosa sono i biomi?](#cosa-sono-i-biomi)
- [Collocare un bioma](#collocare-un-bioma)
  - [Calore e umidità](#calore-e-umidita)
  - [Visualizzare i confini usando i diagrammi di Voronoi](#visualizzare-i-confini-usando-i-diagrammi-di-voronoi)
  - [Creare un diagramma di Voronoi usando Geogebra](#creare-un-diagramma-di-voronoi-usando-geogebra)
- [Registrare un bioma](#registrare-un-bioma)
- [Cosa sono le decorazioni?](#cosa-sono-le-decorazioni)
- [Registrare una decorazione semplice](#registrare-una-decorazione-semplice)
- [Registrare una decorazione composta (schematic)](#registrare-una-decorazione-composta-schematic)
- [Alias del generatore mappa](#alias-del-generatore-mappa)

## Cosa sono i biomi?

In Minetest, un bioma è un ambiente di gioco specifico. Quando viene registrato, se ne possono determinare i vari tipi di nodi che vi appariranno durante la generazione della mappa.
Alcuni dei tipi più comuni - che possono variare da bioma a bioma - sono:

* Nodo superficie: il nodo che si ha più probabilità di trovare sulla superficie.
  Un esempio noto ai più è "Dirt with Grass" in Minetest Game.
* Nodo riempitivo: il livello immediatamente sotto al precedente.
  Nei biomi con l'erba, corrisponde solitamente alla terra.
* Nodo di pietra: il nodo che si ha più probabilità di trovare sottoterra.
* Nodo d'acqua: è solitamente un liquido, ed è il nodo che appare dove ci si aspetterebbe di trovare masse d'acqua.

Si possono incontrare anche altri tipi di nodi tra i biomi, dando la possibilità di creare ambienti altamente variegati all'interno dello stesso gioco.

## Collocare un bioma

### Calore e umidità

Non è sufficiente registrare un bioma; bisogna anche decidere dove deve apparire.
Per farlo, si assegna un valore di calore e umidità a ognuno di essi.

Dovresti pensarci bene prima di inserire questi valori: essi determinano quali biomi
possono confinare tra di loro.
Decisioni frettolose potrebbero risultare in un torrido deserto che condivide i suoi confini con un ghiacciaio, e altre improbabili combinazioni che potresti voler evitare.

In gioco, calore e umidità vanno da un minimo di 0 a un massimo di 100.
Questi valori cambiano gradualmente, aumentando o diminuendo man mano che ci si sposta per la mappa.
Quale bioma apparirà viene determinato prendendo il bioma registrato che ha i valori di calore e umidità più simili a quel punto della mappa.

Dato che i cambiamenti di calore e umidità sono graduali, è buona norma assegnare questi valori ai biomi basandosi su cosa ci si aspetta realisticamente di trovare in un determinato bioma.
Per esempio:

* Un deserto potrebbe avere alte temperature e poca umidità;
* Una foresta innevata potrebbe avere basse temperature e un'umidità moderata;
* Una palude ha senso se ha un'umidità elevata

Così facendo, questo significa che, finché si hanno più biomi, sarà più probabile trovare biomi confinanti che seguono una progressione logica.

### Visualizzare i confini usando i diagrammi di Voronoi

<figure class="right_image">
    <img src="{{ page.root }}/static/biomes_voronoi.png" alt="Voronoi">
    <figcaption>
        Diagramma di Voronoi che mostra il punto più vicino.
		<span class="credit">Di <a href="https://en.wikipedia.org/wiki/Voronoi_diagram#/media/File:Euclidean_Voronoi_diagram.svg">Balu Ertl</a>, CC BY-SA 4.0.</span>
    </figcaption>
</figure>

Regolare i valori di calore e umidità risulta più facile se si riesce a visualizzare come i biomi entrano in relazione l'un con l'altro.
Questo è importante soprattutto se si sta creando un set completo di nuovi biomi personalizzati, ma può essere utile anche quando se ne vuole aggiungere soltanto uno a un set già predefinito.

Il modo più semplice per vedere quali biomi potrebbero condividere un confine è creare un diagramma di Voronoi, che può essere usato per mostrare in un diagramma 2D quali sono, date più posizioni (in nero nell'immagine), i punti nello spazio a loro più vicini (i bordi delle aree colorate).

Un diagramma di Voronoi è utile sia per rivelare eventuali accoppiamenti non desiderati che per dar un'idea generale della distribuzione dei biomi.

Per far ciò, viene segnato un punto per ogni bioma basandosi sui valori di calore e umidità, dove l'asse X è il calore e l'asse Y l'umidità.
Il diagramma è poi suddiviso in aree, in modo che ogni posizione in un'area specifica sia più vicina a un punto che a tutti gli altri.

Ogni area rappresenta un bioma. Se due aree condividono un confine, i biomi a loro associati possono essere trovati a confinare in gioco.
La lunghezza del confine condiviso tra due aree, comparata alla lunghezza condivisa con le altre, ti dirà quanto frequentemente due biomi sono propensi a essere trovati vicini.

### Creare un diagramma di Voronoi usando Geogebra

Oltre che farli a mano, per creare dei diagrammi di Voronoi si possono usare programmi come [Geogebra](https://www.geogebra.org/calculator).

1. Crea dei punti selezionando lo strumento per i punti dall'apposita interfaccia (l'icona del punto con la A) e cliccando per il piano.
   Puoi trascinare i punti dove vuoi o impostare la loro posizione dal menù laterale a sinistra.
   Dovresti anche rinominare ogni punto per rendere il tutto più chiaro.

2. Poi, crea il voronoi inserendo la seguente funzione nel menù laterale a sinistra, sotto i punti:

   ```cpp
   Voronoi({ A, B, C, D, E })
   ```

   Dove ogni punto è contenuto nelle graffe, separato da virgole.

3. Tadaan! Dovresti ora avere un diagramma di Voronoi con tutti i punti trascinabili.

## Registrare un bioma

Il seguente codice registra un semplice bioma chiamato "distesa_erbosa":

```lua
minetest.register_biome({
    name = "distesa_erbosa",
    node_top = "default:dirt_with_grass",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 3,
    y_max = 1000,
    y_min = -3,
    heat_point = 50,
    humidity_point = 50,
})
```

Questo bioma ha uno strato di "Dirt with Grass" sulla superficie, e tre strati di terra al di sotto.
Non specifica tuttavia un nodo di pietra, quindi il nodo definito nella registrazione dell'alias del generatore della mappa (*mapgen*) in `mapgen_stone` sarà presente sotto la terra.

Ci sono molte opzioni da personalizzare quando si registra un bioma, e le si possono trovare documentate nella [API](https://minetest.gitlab.io/minetest/definition-tables/#biome-definition) come al solito.

Non c'è bisogno di definire tutte le opzioni ogni volta che si crea un bioma, seppur in certi casi il dimenticarsi un'opzione specifica o un'alias di generazione della mappa appropriato porti a deli errori nella generazione.

## Cosa sono le decorazioni?

Le decorazioni sono o dei nodi o degli insiemi di nodi (*schematic*) che possono essere piazzati nella mappa durante la generazione.
Alcuni esempi comuni sono i fiori, i cespugli e gli alberi.
Altri usi più creativi possono includere stalattiti e stalagmiti nelle grotte, formazione di cristalli sottoterra o addirittura la collocazione di piccoli edifici.

Le decorazioni possono essere limitate a biomi o ad altezze specifiche, o ancora a determinati nodi.
Sono spesso usate per sviluppare l'atmosfera di un bioma, inserendo piante, alberi o altre caratteristiche che lo rendono particolare.

## Registrare una decorazione semplice

Le decorazioni semplici sono usate per piazzare un singolo nodo nella mappa durante la generazione.
Ricordati che devi specificare il nodo che vuoi usare in quanto decorazione, i dettagli di dove può essere piazzato, e quanto di frequente deve apparire.

Per esempio:

```lua
minetest.register_decoration({
    deco_type = "simple",
    place_on = {"base:dirt_with_grass"},
    sidelen = 16,
    fill_ratio = 0.1,
    biomes = {"distesa_erbosa"},
    y_max = 200,
    y_min = 1,
    decoration = "piante:erba",
})
```

In questo caso, il nodo chiamato `piante:erba` verrà piazzato nel bioma "distesa_erbosa" in cima ai nodi a mo' di prato (`base:dirt_with_grass`) tra altitudine `y = 1` e `y = 20`.

Il valore `fill_ratio` determina quanto di frequente dovrà apparire, con valori più alti di 1 equivalenti a un grande numero di decorazioni piazzate.
È possibile, sennò, usare i parametri di disturbo (*noise parameters*) per determinare la collocazione.

## Registrare una decorazione composta (schematic)

Le schematic sono molto simili alle decorazioni semplici, solo che piazzano più nodi invece che uno solo.
Per esempio:

```lua
minetest.register_decoration({
    deco_type = "schematic",
    place_on = {"base:desert_sand"},
    sidelen = 16,
    fill_ratio = 0.0001,
    biomes = {"desert"},
    y_max = 200,
    y_min = 1,
    schematic = minetest.get_modpath("plants") .. "/schematics/cactus.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
})
```

In quest'esempio, viene piazzata la schematic cactus.mts nel bioma del deserto.
C'è bisogno di fornire il percorso nel quale andare a pescare il file, che in questo caso si trova in una cartella chiamata "schematics" all'interno della mod.

Sempre nell'esempio, inoltre, vengono impostati i contrassegni (le *flag*) per centrare il posizionamento della schematic, e la rotazione è impostata randomicamente.
Quest'ultima opzione agevola l'introduzione di una maggior variazione quando vengono usate schematic asimmetriche.


## Alias del generatore mappa

I giochi disponibili dovrebbero già includere un alias del generatore mappa (*mapgen*) adeguato, quindi devi solo prendere in considerazione se registrarne di personali alla creazione di un nuovo gioco.

Gli alias del generatore mappa forniscono informazioni al generatore principale, e possono essere registrati secondo lo schema:

```lua
minetest.register_alias("mapgen_stone", "base:smoke_stone")
```

Almeno almeno dovresti registrare:

* mapgen_stone
* mapgen_water_source
* mapgen_river_water_source

Se non stai definendo nodi liquidi per le caverne di tutti i biomi, dovresti aggiungere anche:

* mapgen_lava_source
