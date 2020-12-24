---
title: Rilasciare una mod
layout: default
root: ../..
idx: 8.6
redirect_from: /it/chapters/releasing.html
---

## Introduzione <!-- omit in toc -->

Rilasciare (o pubblicare) una mod permette ad altre persone di poterne usufruire.
Una volta che una mod è stata rilasciata potrebbe venir usata nelle partite locali (a giocatore singolo) o nei server, inclusi quelli pubblici.

- [Scegliere una licenza](#scegliere-una-licenza)
	- [LGPL e CC-BY-SA](#lgpl-e-cc-by-sa)
	- [CC0](#cc0)
	- [MIT](#mit)
- [Impacchettare](#impacchettare)
	- [README.txt](#readmetxt)
	- [mod.conf / game.conf](#modconf--gameconf)
	- [screenshot.png](#screenshotpng)
- [Caricare](#caricare)
	- [Sistemi di Controllo Versione](#sistemi-di-controllo-versione)
	- [Allegati sul forum](#allegati-sul-forum)
- [Rilasciare su ContentDB](#rilasciare-su-contentdb)
- [Creare la discussione sul forum](#creare-la-discussione-sul-forum)

## Scegliere una licenza

Avrai bisogno di specificare una licenza per la tua mod.
Questo è importante perché dice alle altre persone cosa possono e non possono fare col tuo lavoro.
Se una mod non ha una licenza, la gente non saprà cosa sarà autorizzata a modificare, distribuire o se potrà usarla su un server pubblico.

Le licenze variano anche a seconda di cosa si vuole tutelare: per esempio, le Creative Commons non dovrebbero essere usate per il codice sorgente, ma sono un'ottima opzione per cose come immagini, testi e modelli 3D.

Puoi adottare la licenza che preferisci; tuttavia, sappi che le mod con licenze che ne vietano lavori derivati sono bandite dal forum ufficiale di Minetest (in altre parole, per essere consentita sul forum, gli altri sviluppatori devono poter essere in grado di modificarla e rilasciarne la versione modificata).

Tieni anche a mente che **la licenza di pubblico dominio non è una licenza valida**, perché la sua definizione varia da stato a stato.

### LGPL e CC-BY-SA

Questa è la combinazione più comune nella comunità di Minetest, nonché quella usata sia da Minetest che da Minetest Game.
Si imposta il codice sotto LGPL 2.1 e i contenuti artistici sotto CC-BY-SA.
Ciò significa che:

* Chiunque può modificare, ridistribuire e vendere versioni modificate e non;
* Se qualcuno modifica la tua mod, deve adottare la stessa licenza;
* Devono citare l'autore originale.

### CC0

Queste licenze permettono a chiunque di fare quello che gli va - incluso il non citare l'autore - e possono essere usate sia per il codice che per i contenuti artistici.

È importante sottolineare che la WTFPL (*do What The Fuck you want to Public License*, la "facci il cazzo che ti pare") è caldamente *s*consigliata, e alcune persone potrebbero decidere di non usare la tua mod se ha questa licenza.

### MIT

Questa è una licenza comune per il codice.
La differenza con la LGPL è che le copie derivate in questo caso non devono per forza essere libere (i primi 2 punti della LGPL/GPL), bensì può essere trasformato in codice proprietario.

## Impacchettare

Ci sono alcuni file che è consigliato includere nella propria mod prima di rilasciarla.

### README.txt

Il README dovrebbe dichiarare:

* Cosa fa la mod;
* Che licenza ha;
* Quali dipendenze richiede;
* Come installare la mod;
* Versione corrente della mod;
* Eventualmente, dove segnalare i problemi o comunque richiedere aiuto.

### mod.conf / game.conf

Assicurati di aggiungere una descrizione che spieghi cosa fa la mod, usando la chiave `description`.
Cerca di essere preciso e coinciso: dovrebbe essere breve perché il contenuto verrà mostrato nell'installer del motore di gioco, che ha uno spazio limitato.

Per esempio, consigliato:

    description = Aggiunge zuppa, torte, pane e succhi

Sconsigliato:

    description = Cibo per Minetest

### screenshot.png

Gli screenshot dovrebbero essere in proporzione 3:2 e avere una grandezza minima di 300x200px.

Lo screen verrà mostrato nel bazar delle mod (sono tutte gratuite).

## Caricare

Per far sì che un potenziale utente possa scaricare la tua mod, c'è bisogno di caricarla in uno spazio pubblico.
Ci sono svariati modi per fare ciò quindi usa l'approccio che ritieni più opportuno; l'importante è che esso rispetti i requisiti qui elencati, ed eventuale richieste aggiuntive dei moderatori del forum:

* **Stabile**      - Il sito che conterrà il file non dovrebbe essere propenso a chiudere i battenti da un momento all'altro senza preavviso;
* **Link diretto** - Dovresti essere in grado di cliccare su un link e scaricare il file senza il bisogno di dover passare per altre pagine;
* **Senza virus**  - Le mod con contenuti malevoli saranno rimosse dal forum.

ContentDB soddisfa questi requisiti, richiedendo giusto un file .zip.

### Sistemi di Controllo Versione

Un Sistema di Controllo Versione (VCS, *Version Control System*) è un programma che gestisce i cambiamenti di altri programmi, spesso facilitandone la distribuzione e la collaborazione.

La maggior parte dei creatori di mod su Minetest usa Git e un sito per ospitare il loro codice come GitHub o GitLab.

Usare git può essere difficile all'inizio.
Se hai bisogno di una mano e mastichi l'inglese, prova a dare un occhio a [Pro Git book](http://git-scm.com/book/en/v1/Getting-Started) - gratis da leggere online.

## Rilasciare su ContentDB

ContentDB è il luogo ufficiale dove trovare e distribuire mod, giochi e pacchetti texture.
Gli utenti possono manualmente andare alla ricerca di contenuti tramite il sito, o scaricarli e installarli direttamente dall'integrazione presente nel menù principale di Minetest.

Iscriviti su [ContentDB](https://content.minetest.net) e aggiungi il tuo lavoro.
Assicurati di leggere le linee guida (in inglese) nella sezione d'aiuto (*Help*).

## Creare la discussione sul forum

Puoi anche creare una discussione sul forum per far in modo che gli utenti possano discutere ciò che hai fatto.

Per le mod usa la sezione ["WIP Mods"](https://forum.minetest.net/viewforum.php?f=9) (*Work In Progress*), per i giochi invece ["WIP Games"](https://forum.minetest.net/viewforum.php?f=50).


Puoi ora creare la discussione nella sezione ["WIP Mods"](https://forum.minetest.net/viewforum.php?f=9) (WIP sta per *Work In Progress*, lavori in corso).\\
Quando ritieni che la tua mod abbia raggiunto la sua prima versione ufficiale, puoi [richiedere (in inglese) che venga spostata](https://forum.minetest.net/viewtopic.php?f=11&t=10418) in "Mod Releases".

La discussione dovrebbe contenere contenuti simili al README, con giusto un po' più di coinvolgimento e il link per scaricare la mod.
È buona cosa aggiungere anche degli eventuali screenshot per far capire al volo cosa fa la mod, se possibile.

Il titolo della discussione deve seguire uno dei seguenti formati:

* [Mod] Nome mod [nomemod]
* [Mod] Nome mod [numero versione] [nomemod]

Per esempio:

* [Mod] Blocchi pazzi [0.1] [blocchipazzi]
