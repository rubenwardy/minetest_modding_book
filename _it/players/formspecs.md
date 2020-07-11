---
title: GUI (Formspec)
layout: default
root: ../..
idx: 4.5
description: Tempo di interagire con le finestre
redirect_from: /it/chapters/formspecs.html
submit_vuln:
    level: warning
    title: Client malevoli possono inviare qualsiasi cosa quando più gli piace
    message: Non dovresti mai fidarti di un modulo di compilazione - anche se non hai mai mostrato loro il formspec.
             Questo significa che dovresti controllarne i privilegi e assicurarti che dovrebbero effettivamente essere in grado di eseguire quest'azione.
---

## Introduzione <!-- omit in toc -->

<figure class="right_image">
    <img src="{{ page.root }}//static/formspec_example.png" alt="Furnace Inventory">
    <figcaption>
        Screenshot del formspec di una fornace e della sua struttura.
    </figcaption>
</figure>

In questo capitolo impareremo come creare un formspec e mostrarlo all'utente.
Un formspec è il codice di specifica di un modulo (*form*, da qui *form*-*spec*).
In Minetest, i moduli sono delle finestre come l'inventario del giocatore e possono contenere un'ampia gamma di elementi, come le etichette, i pulsanti e i campi.

Tieni presente che se non si ha bisogno di ricevere input dal giocatore, per esempio quando si vogliono far apparire semplicemente delle istruzioni a schermo, si dovrebbe considerare l'utilizzo di una [HUD (Heads Up Display)](hud.html) piuttosto che quello di un formspec, in quanto le finestre inaspettate (con tanto di mouse che appare) tendono a impattare negativamente sulla giocabilità.

- [Coordinate reali o datate](#coordinate-reali-o-datate)
- [Anatomia di un formspec](#anatomia-di-un-formspec)
  - [Elementi](#elementi)
  - [Intestazione](#intestazione)
- [Esempio: indovina un numero](#esempio-indovina-un-numero)
  - [Imbottitura e spaziatura](#imbottitura-e-spaziatura)
  - [Ricevere i moduli di compilazione](#ricevere-i-moduli-di-compilazione)
  - [Contesti](#contesti)
- [Ricavare un formspec](#ricavare-un-formspec)
  - [Formspec nei nodi](#formspec-nei-nodi)
  - [Inventario del giocatore](#inventario-del-giocatore)
  - [Il tuo turno](#il-tuo-turno)


## Coordinate reali o datate

Nelle vecchie versioni di Minetest, i formspec erano incoerenti.
Il modo in cui elementi diversi venivano posizionati nel formspec variava in maniere inaspettate; era difficile predirne la collocazione e allinearli correttamente.
Da Minetest 5.1.0, tuttavia, è stata introdotta una funzione chiamata Coordinate Reali (*real coordinates*), la quale punta a correggere questo comportamento tramite l'introduzione di un sistema di coordinate coerente.
L'uso delle coordinate reali è caldamente consigliato, onde per cui questo capitolo non tratterà di quelle vecchie.

## Anatomia di un formspec

### Elementi

Il formspec è un linguaggio di dominio specifico con un formato insolito.
Consiste in un numero di elementi che seguono il seguente schema:

    tipo[param1;param2]

Viene prima dichiarato il tipo dell'elemento, seguito dai parametri nelle parentesi quadre.
Si possono concatenare più elementi, piazzandoli eventualmente su più linee:

    foo[param1]bar[param1]
    bo[param1]

Gli elementi sono o oggetti come i campi di testo e i pulsanti, o dei metadati come la grandezza e lo sfondo.
Per una lista esaustiva di tutti i possibili elementi, si rimanda a [lua_api.txt](../../lua_api.html#elements).

### Intestazione

L'intestazione di un formspec contiene informazioni che devono apparire prima di tutto il resto.
Questo include la grandezza del formspec, la posizione, l'ancoraggio, e se il tema specifico del gioco debba venir applicato.

Gli elementi nell'intestazione devono essere definiti in un ordine preciso, altrimenti ritorneranno un errore.
L'ordine è dato nel paragrafo qui in alto e, come sempre, documentato in [lua_api.txt](../../lua_api.html#sizewhfixed_size).

La grandezza è in caselle formspec - un'unità di misura che è circa 64 pixel, ma varia a seconda della densità dello schermo e delle impostazioni del client.
Ecco un formspec di 2x2:

    formspec_version[3]
    size[2,2]

Notare come è stata esplicitamente definita la versione del linguaggio: senza di essa, il sistema datato sarebbe stato usato di base - che avrebbe impossibilitato il posizionamento coerente degli elementi e altre nuove funzioni.

La posizione e l'ancoraggio degli elementi sono usati per collocare il formspec nello schermo.
La posizione imposta dove si troverà (con valore predefinito al centro, `0.5,0.5`), mentre l'ancoraggio da dove partire, permettendo di allineare il formspec con i bordi dello schermo.
Per esempio, lo si può posizionare ancorato a sinistra in questo modo:

    formspec_version[3]
    size[2,2]
    real_coordinates[true]
    position[0,0.5]
    anchor[0,0.5]

Per l'esattezza è stato messo il centro del formspec sul bordo sinistro dello schermo (`position[0, 0.5]`) e poi ne è stato spostato l'ancoraggio in modo da allineare il lato sinistro del formspec con quello dello schermo.

## Esempio: indovina un numero

<figure class="right_image">
    <img src="{{ page.root }}/static/formspec_guessing.png" alt="Guessing Formspec">
    <figcaption>
        Il formspec del gioco dell'indovinare un numero
    </figcaption>
</figure>

Il modo migliore per imparare è sporcarsi le mani, quindi creiamo un gioco.
Il principio è semplice: la mod decide un numero, e il giocatore deve tentare di indovinarlo.
La mod, poi, comunica se si è detto un numero più alto o più basso rispetto a quello corretto.

Prima di tutto, costruiamo una funzione per creare il formspec.
È buona pratica fare ciò, in quanto rende il riutilizzo più comodo.

<div style="clear: both;"></div>

```lua
indovina = {}

function indovina.prendi_formspec(nome)
    -- TODO: comunicare se il numero del tentativo era più alto o più basso
    local testo = "Sto pensando a un numero... Prova a indovinare!"

    local formspec = {
        "size[6,3.476]",
        "label[0.375,0.5;", minetest.formspec_escape(testo), "]",
        "field[0.375,1.25;5.25,0.8;numero;Numero;]",
        "button[1.5,2.3;3,0.8;indovina;Indovina]"
    }

    -- table.concat è più veloce della concatenazione di stringhe - `..`
    return table.concat(formspec, "")
end
```

Nel codice qui sopra abbiamo inserito un'etichetta (*label*), un campo (*field*) e un pulante (*button*).
Un campo ci permete di inserire del testo, mentre useremo il pulsante per inviare il modulo.
Noterai che gli elementi sono posizionati attentamente per aggiungere imbottitura e spaziatura (*padding* e *spacing*),
ma ci arriveremo tra poco.

Come prossima cosa, vogliamo permettere al giocatore di visualizzare il formspec.
Il metodo principale per farlo è usare `show_formspec`:

```lua
function indovina.mostra_a(nome)
    minetest.show_formspec(nome, "indovina:gioco", indovina.prendi_formspec(nome))
end

minetest.register_chatcommand("gioco", {
    func = function(name)
        indovina.mostra_a(name)
    end,
})
```

La funzione `show_formspec` prende il nome del giocatore, il nome del formspec e il formspec stesso.
Il nome di quest'ultimo dovrebbe seguire il formato del nome degli oggetti, tipo `nomemod:nomeoggetto`.

### Imbottitura e spaziatura

<figure class="right_image">
    <img src="{{ page.root }}/static/formspec_padding_spacing.png" alt="Padding and spacing">
    <figcaption>
        Il formspec del gioco dell'indovinare un numero
    </figcaption>
</figure>

L'imbottitura (*padding*) è lo spazio che intercorre tra il bordo del formspec e i suoi contenuti, o tra elementi non in relazione fra loro - mostrato in rosso.
La spaziatura (*spacing*) è invece lo spazio tra elementi in comune - mostrata in blu.

È abbastanza uno standard avere un'imbottitura di `0.375` e una spaziatura di `0.25`.

<div style="clear: both;"></div>


### Ricevere i moduli di compilazione

Quando `show_formspec` viene chiamato, il formspec viene inviato al client per essere visualizzato.
Per far sì che i formspec siano utili, le informazioni devono essere ritornate dal client al server.
Il metodo per fare ciò è chiamato Campo di Compilazione (*formspec field submission*), e per `show_formspec` quel campo viene ottenuto usando un callback globale:

```lua
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "indovina:gioco" then
        return
    end

    if fields.indovina then
        local p_name = player:get_player_name()
        minetest.chat_send_all(p_name .. " ha tentato di indovinare con il numero " .. fields.numero)
    end
end)
```

La funzione data in `minetest.register_on_player_receive_fields` è chiamata ogni volta che un utente invia un modulo.
La maggior parte dei callback necessiteranno di controllare il nome fornito alla funzione, e uscire se non è quello esatto; tuttavia, alcuni potrebbero necessitare di operare su più moduli, se non addirittura su tutti.

Il parametro `fields` è una tabella di tutti i valori inviati dall'utente, indicizzati per stringhe.
I nomi degli elementi appariranno nel campo con il loro nome, ma solo se sono rilevanti per l'evento che ha causato l'invio.
Per esempio, un elemento "pulsante" apparirà nei campi solo se quel particolare pulsante è stato premuto.

{% include notice.html notice=page.submit_vuln %}

Quindi, ora il formspec è stato inviato al client e il client ritorna quelle informazioni.
Il prossimo passaggio è generare e ricordare il valore ricevuto, e aggiornare il formspec basandosi sui tentativi.
Il modo per fare ciò è usare un concetto chiamato "contesto".


### Contesti

In molti casi si può desiderare che le informazioni passate da `show_formspec` al callback non raggiungano il client.
Ciò potrebbe includere con cosa è stato chiamato un comando via chat, o di cosa tratta la finestra di dialogo.
In questo caso, il valore che si necessita di ricordare.

Un contesto (*context*) è una tabella assegnata a ogni giocatore per immagazzinare informazioni, e i contesti di tutti i giocatori sono
salvati in una variabile locale di file:

```lua
local _contesti = {}
local function prendi_contesto(nome)
    local contesto = _contesto[nome] or {}
    _contesti[nome] = contesto
    return contesto
end

minetest.register_on_leaveplayer(function(player)
    _contexts[player:get_player_name()] = nil
end)
```

Ora abbiamo bisogno di modificare il codice da mostrare, per aggiornare il contesto prima di mostrare il formspec:

```lua
function indovina.mostra_a(nome)
    local contesto = prendi_contesto(nome)
    contesto.soluzione = contesto.soluzione or math.random(1, 10)

    local formspec = indovina.prendi_formspec(nome, contesto)
    minetest.show_formspec(nome, "indovina:gioco", formspec)
end
```

Abbiamo anche bisogno di modificare la generazione del formspec per usare il contesto:

```lua
function indovina.prendi_formspec(nome, contesto)
    local testo
    if not contesto.tentativo then
        testo = "Sto pensando a un numero... Prova a indovinare!"
    elseif contesto.tentativo == contesto.soluzione then
        testo = "Yeee, hai indovinato!"
    elseif contesto.tentativo > contesto.soluzione then
        testo = "Troppo alto!"
    else
        testo = "Troppo basso!"
    end
```

Tieni a mente che quando si ottiene il formspec è buona norma leggerne il contesto, senza però aggiornalo.
Questo può rendere la funzione più semplice, e anche più facile da testare.

E in ultimo, abbiamo bisogno di aggiornare il contesto con il tentativo del giocatore:

```lua
if fields.indovina then
    local nome = player:get_player_name()
    local contesto = prendi_contesto(nome)
    contesto.tentativo = tonumber(fields.numero)
    indovina.mostra_a(nome)
end
```

## Ricavare un formspec

Ci sono tre diversi modi per far sì che un formspec sia consegnato al client:

* [show_formspec](#esempio-indovina-un-numero): il metodo usato qui sopra. I campi sono ottenuti tramite `register_on_player_receive_fields`;
* [Metadati di un nodo](#formspec-nei-nodi): si aggiunge il formspec nel nodo tramite metadati, che viene mostrato *immediatamente* al giocatore che preme il nodo col tasto destro.
      I campi vengono ricevuti attraverso un metodo nella definizione del nodo chiamato `on_receive_fields`.
* [Inventario del giocatore](#inventario-del-giocatore): il formspec viene inviato al client in un certo momento, e mostrato immediatamente quando il giocatore preme "I".
      I campi vengono ricevuti tramite `register_on_player_receive_fields`.

### Formspec nei nodi

`minetest.show_formspec` non è l'unico modo per mostrare un formspec; essi possono infatti essere aggiunti anche ai [metadati di un nodo](node_metadata.html).
Per esempio, questo è usato con le casse per permettere tempi più veloci d'apertura - non si ha bisogno di aspettare che il server invii il formspec della cassa al giocatore.

```lua
minetest.register_node("miamod:tastodestro", {
    description = "Premimi col tasto destro del mouse!",
    tiles = {"miamod_tastodestro.png"},
    groups = {cracky = 1},
    after_place_node = function(pos, placer)
        -- Questa funzione è eseguita quando viene piazzato il nodo.
        -- Il codice che segue imposta il formspec della cassa.
        -- I metadati sono un modo per immagazzinare dati nel nodo.

        local meta = minetest.get_meta(pos)
        meta:set_string("formspec",
                "formspec_version[3]" ..
                "size[5,5]"..
                "label[1,1;Questo è mostrato al premere col destro]"..
                "field[1,2;2,1;x;x;]")
    end,
    on_receive_fields = function(pos, formname, fields, player)
        if(fields.quit) then return end
        print(fields.x)
    end
})
```

I formspec impostati in questo modo non innescano lo stesso callback.
Per far in modo di ricevere il modulo di input per i formspec nei nodi, bisogna includere una voce `on_receive_fields` al registrare il nodo.

Questo stile di callback viene innescato al premere invio in un campo, che è possibile grazie a `minetest.show_formspec`; tuttavia, questi tipi di moduli possono essere mostrati solo
tramite il premere col tasto destro del mouse su un nodo. Non è possibile farlo programmaticamente.

### Inventario del giocatore

L'inventario del giocatore è un formspec, che viene mostrato al premere "I".
Il callback globale viene usato per ricevere eventi dall'inventario, e il suo nome è `""`.

Ci sono svariate mod che permettono ad altrettante mod di personalizzare l'inventario del giocatore.
La mod ufficialmente raccomandata è [Simple Fast Inventory (sfinv)](sfinv.html), ed è inclusa in Minetest Game.

### Il tuo turno

* Estendi l'indovina il numero per far in modo che tenga traccia del risultato migliore di ogni giocatore, dove con "risultato migliore" si intende il minor numero di tentativi per indovinare.
* Crea un nodo chiamato "Casella delle lettere" dove gli utenti possono aprire un formspec e lasciare messaggi.
  Questo nodo dovrebbe salvare il nome del mittente come `owner` nei metadati, e dovrebbe usare `show_formspec` per mostrare formspec differenti a giocatori differenti.
