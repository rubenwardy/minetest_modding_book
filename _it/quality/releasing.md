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

- [Scegliere la licenza](#scegliere-la-licenza)
  - [LGPL e CC-BY-SA](#lgpl-e-cc-by-sa)
  - [CC0](#cc0)
  - [MIT](#mit)
- [Impacchettare](#impacchettare)
  - [README.txt](#readmetxt)
  - [description.txt](#descriptiontxt)
  - [screenshot.png](#screenshotpng)
- [Caricare](#caricare)
  - [Sistemi di Controllo Versione](#sistemi-di-controllo-versione)
  - [Allegati sul forum](#allegati-sul-forum)
- [Creare la discussione sul forum](#creare-la-discussione-sul-forum)
  - [Titolo](#titolo)

## Scegliere la licenza

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

### description.txt

Questo file spiega cosa fa la mod.
Cerca di essere preciso e coinciso: dovrebbe essere breve perché il contenuto verrà mostrato nell'installer del motore di gioco, che ha uno spazio limitato.

Per esempio, consigliato:

    Aggiunge zuppa, torte, pane e succhi.

Sconsigliato:

    Cibo per Minetest.

### screenshot.png

Gli screenshot dovrebbero essere in proporzione 3:2 e avere una grandezza minima di 300x200px.

Lo screen verrà mostrato nel bazar delle mod (sono tutte gratuite).

## Caricare

Per far sì che un potenziale utente possa scaricare la tua mod, c'è bisogno di caricarla in uno spazio pubblico.
Ci sono svariati modi per fare ciò quindi usa l'approccio che ritieni più opportuno; l'importante è che esso rispetti i requisiti qui elencati, ed eventuale richieste aggiuntive aggiunta dai moderatori del forum:

* **Stabile**      - Il sito che conterrà il file non dovrebbe essere propenso a morire da un momento all'altro senza preavviso;
* **Link diretto** - Dovresti essere in grado di cliccare su un link sul forum e scaricare il file senza il bisogno di dover passare per altre pagine;
* **Senza virus**  - Le mod con contenuti malevoli saranno rimosse dal forum.

### Sistemi di Controllo Versione

È consigliato usare un sistema di controllo versione che:

* Permetta agli altri sviluppatori di inviare le loro modifiche facilmente;
* Permetta al codice di essere visualizzato prima di essere scaricato;
* Permetta agli utenti di fare segnalazioni (bug, domande ecc).

La maggior parte dei creatori di mod su Minetest usa GitHub o GitLab come sito per ospitare il loro codice, ma esistono anche altre opzioni.

Usare siti come GitHub e GitLab può essere difficile all'inizio.
Se hai bisogno di una mano e mastichi l'inglese, prova a dare un occhio a [Pro Git book](http://git-scm.com/book/en/v1/Getting-Started) - gratis da leggere online.

### Allegati sul forum

Un'alternativa all'usare un sistema di controllo versione è il caricare le mod come allegati sul forum.
Questo può essere fatto alla creazione della discussione nella sezione delle mod (spiegato sotto).

Prima di tutto, avrai bisogno di creare uno zip con i file della mod (il procedimento varia da sistema operativo a sistema operativo, ma solitamente si parla di premere il tasto destro su uno dei file dopo averli selezionati tutti).

Quando crei una discussione sul forum - nella pagina "Create a Topic" illustrata sotto - vai alla "Upload Attachment" situata in basso.
Clicca poi su "Browse", selezionando il file zip.
È inoltre consigliato specificare la versione della mod nel campo dei commenti ("File comment").

<figure>
    <img src="{{ page.root }}/static/releasing_attachments.png" alt="Upload Attachment">
    <figcaption>
        La scheda Upload Attachment.
    </figcaption>
</figure>

## Creare la discussione sul forum

Puoi ora creare la discussione nella sezione ["WIP Mods"](https://forum.minetest.net/viewforum.php?f=9) (WIP sta per *Work In Progress*, lavori in corso).\\
Quando ritieni che la tua mod abbia raggiunto la sua prima versione ufficiale, puoi [richiedere (in inglese) che venga spostata](https://forum.minetest.net/viewtopic.php?f=11&t=10418) in "Mod Releases".

La discussione dovrebbe contenere contenuti simili al README, con giusto un po' più di coinvolgimento e il link per scaricare la mod.
È buona cosa aggiungere anche degli eventuali screenshot per far capire al volo cosa fa la mod, se possibile.

La formattazione del forum di Minetest è in bbcode.
Segue un esempio di una mod chiamata "superspecial" (si è tenuto l'esempio in inglese dato che bisogna scrivere appunto in inglese sul forum, NdT):


    Adds magic, rainbows and other special things.

    See download attached.

    [b]Version:[/b] 1.1
    [b]License:[/b] LGPL 2.1 or later

    Dependencies: default mod (found in minetest_game)

    Report bugs or request help on the forum topic.

    [h]Installation[/h]

    Unzip the archive, rename the folder to superspecial and
    place it in minetest/mods/

    (  GNU/Linux: If you use a system-wide installation place
        it in ~/.minetest/mods/.  )

    (  If you only want this to be used in a single world, place
        the folder in worldmods/ in your world directory.  )

    For further information or help see:
    [url]https://wiki.minetest.net/Installing_Mods[/url]

Se hai intenzione di usare questo esempio per la tua mod, ricordati ovviamente di cambiare "superspecial" con il nome vero e proprio.

### Titolo

Il titolo della discussione deve seguire uno dei seguenti formati:

* [Mod] Nome mod [nomemod]
* [Mod] Nome mod [numero versione] [nomemod]

Per esempio:

* [Mod] Blocchi pazzi [0.1] [blocchipazzi]
