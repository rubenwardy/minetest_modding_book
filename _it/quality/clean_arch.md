---
title: Introduzione alle architetture pulite
layout: default
root: ../..
idx: 8.4
---

## Introduzione <!-- omit in toc -->

Una volta che una mod raggiunge dimensioni considerevoli, sarà sempre più difficile mantenerne il codice pulito e privo di errori.
Questo è un grosso problema soprattutto quando si usa un linguaggio dinamico come Lua, considerando che il compilatore restituisce pochissimi aiuti quando si tratta di cose come l'assicurarsi di non aver fatto errori di battitura.

Questo capitolo si occupa di concetti importanti, necessari per mantenere il codice pulito, e di strutture utili per realizzarli.
Tieni a mente che lo scopo del capitolo non è quello di essere LA bibbia, bensì di dare un'idea su come muoversi.
Non c'è il modo giusto e il modo sbagliato per ideare una mod, in quanto il loro design è alquanto soggettivo.

- [Coesione, dipendenze, e separazione degli ambiti](#coesione-dipendenze-e-separazione-degli-ambiti)
- [Osservatore](#osservatore)
- [Modello-Vista-Controllo](#modello-vista-controllo)
  - [API-Vista](#api-vista)
- [Conclusione](#conclusione)


## Coesione, dipendenze, e separazione degli ambiti

Senza alcuna pianificazione, il codice di un progetto diverrà man mano un bel fritto misto (o quello che gli inglesi definiscono *spaghetti code*).
Ovvero, mancherà di struttura perché ne è stata fatta un'accozzaglia senza chiare delimitazioni.
Sul lungo corso il progetto diverrà ingestibile, concludendosi con il suo abbandono.

Per evitare ciò, è buona cosa ideare il proprio progetto come un insieme di piccole aree di codice che interagiscono tra di loro.

> All'interno di ogni grande programma, c'è un programma più piccolo che cerca di scappare.
>
>  --C.A.R. Hoare

Questo dovrebbe essere fatto in modo tale da ottenere una "separazione degli ambiti" (*Separation of Concerns*), dove ogni area dovrebe essere distinta e occuparsi di un bisogno specifico.

Questi programmi/aree dovrebbero avere le due seguenti proprietà:

* **Alta coesione** - ciò che succede nell'area dovrebbe essere strettamente legato.
* **Basse dipendenze** - mantenere le dipendenze tra un'area e l'altra più basse possibili, ed evitare di affidarsi a implementazioni interne.
  È davvero ottimo assicurarsi di ciò, in quanto cambiare le API di certe aree risulterà più fattibile.

Tieni a mente che ciò si applica sia nella relazione tra una mod e l'altra, che in quella tra le varie aree all'interno della stessa mod.

## Osservatore

Una maniera semplice per separare le aree di codice è usare lo schema dell'Osservatore (*Observer pattern*).

Si prenda l'esempio di sbloccare un trofeo quando un giocatore uccide per la prima volta un mostro raro.
L'approccio ingenuo è quello di avere il codice del trofeo nella funzione di uccisione del mostro, controllando il suo nome e sbloccando il trofeo se coincide.
Questa è però una cattiva idea, in quanto rende il mob dipendente dal codice dei trofei.
Se si contiuasse su questa strada - per esempio aggiungendo l'esperienza ottenuta uccidendo il mob - si finirebbe con l'avere un sacco di dipendenze alla rinfusa.

Lo schema dell'Osservatore dice invece di far esporre alla mod del mostro un modo per far sì che altre aree di codice possano inserire comodamente dei comportamenti extra e ricevere informazioni riguardo all'evento.

```lua
mieimob.registered_on_death = {}
function mieimob.register_on_death(func)
    table.insert(mieimob.registered_on_death, func)
end

-- nel codice della morte del mob
for i=1, #mieimob.registered_on_death do
    mieimob.registered_on_death[i](entity, reason)
end
```

Quindi l'altro codice registra ciò che gli serve:

```lua
mieimob.register_on_death(function(mob, reason)
    if reason.type == "punch" and reason.object and
            reason.object:is_player() then
        trofei.avvisa_morte_mostro(reason.object, mob.name)
    end
end)
```

Potresti star pensando "aspetta un secondo, questo mi sembra terribilmente familiare".
E hai ragione! L'API di Minetest è molto incentrata sull'Osservatore, per far in modo che il motore di gioco non debba preoccuparsi di cosa è in ascolto di cosa.

## Modello-Vista-Controllo

Nel prossimo capitolo discuteremo di come testare automaticamente il codice, e uno dei problemi che riscontreremo sarà come separare il più possibile la logica (calcoli, cosa bisognerebbe fare) dalle chiamate alle API (`minetest.*`, altre mod).

Un modo per fare ciò è pensare a:

* Che **dati** si hanno;
* Che **azioni** si possono eseguire con quei dati;
* Come gli **eventi** (come formspec, pugni ecc.) inneschino queste azioni, e come quest'ultime abbiano conseguenze nel motore di gioco.

Prendiamo come esempio una mod di protezione del terreno.
I dati di cui si dispone sono quelli delle aree e i metadati ad esse associati.
Le azioni richieste sono `crea`, `modifica` o `cancella`.
Gli eventi che richiamano le azioni sono invece comandi via chat e formspec.

Durante i test sarà possibile assicurarsi che un'azione, quando richiamata, faccia quello che deve fare ai dati.
Non c'è bisogno di testare l'evento che chiama l'azione (ciò richiederebbe usare l'API di Minetest, e l'area di codice dovrebbe comunque rimanere quanto più piccola possibile).

Si dovrebbe scrivere la rappresentazione dei dati usando Lua puro.
"Puro" in questo contesto significa che le funzioni potrebbero venir eseguite al di fuori di Minetest - nessuna delle funzioni del motore di gioco vengono chiamate.

```lua
-- Dati
function terreno.crea(nome, nome_area)
    terreno.terreni[nome_area] = {
        nome  = nome_area,
        owner = nome,
        -- altre cose
    }
end

function terreno.ottieni_da_nome(nome_area)
    return terreno.terreni[nome_area]
end
```

Anche le azioni dovrebbero essere pure, ma chiamare altre funzioni è più accettato che il comportamento qui sopra.

```lua
-- Controllo
function terreno.gestore_invio_crea(nome, nome_area)
    -- processa cose
    -- (tipo controllare se ci sono sovrapposizioni, controllo dei permessi ecc)

    terreno.crea(nome, nome_area)
end

function terreno.gestore_richiesta_crea(nome)
    -- questo è un cattivo esempio, come spiegato poco più avanti
    terreno.mostra_formspec_crea(nome)
end
```

I gestori degli eventi dovranno interagire con la API di Minetest.
Il numero di calcoli dovrebbero essere minimizzati il più possibile, in quanto non sarà fattibile testare quest'area così facilmente.

```lua
-- Vista
function terreno.mostra_formspec_crea(nome)
    -- nota come qui non ci siano calcoli complessi!
    return [[
        size[4,3]
        label[1,0;Questo è un esempio]
        field[0,1;3,1;nome_area;]
        button_exit[0,2;1,1;esci;Esci]
    ]]
end

minetest.register_chatcommand("/land", {
    privs = { terreno = true },
    func = function(name)
        land.gestore_richiesta_crea(name)
    end,
})

minetest.register_on_player_receive_fields(function(player,
            formname, fields)
    terreno.gestore_invio_crea(player:get_player_name(),
            fields.nome_area)
end)
```

L'approccio adottato qui in alto è la struttura Modello-Vista-Controllo (MVC).
Il modello è un insieme di dati aventi funzioni minime.
La vista è un insieme di funzioni che sono in ascolto di eventi per passarli al controllo, e che riceve inoltre chiamate dal controllo per fare qualcosa con l'API di Minetest.
Il controllo è dove le decisioni vengono prese e la maggior parte delle operazioni eseguite.

Il controllo non dovrebbe avere nessuna conoscenza riguardo l'API di Minetest - nota come non ci siano chiamate a Minetest o funzioni nella vista che le ricordino.
*NON* dovresti, quindi, avere una funzione come `vista.hud_aggiungi(giocatore, def)`.
Al contrario, la vista definisce alcune azioni che il controllo può dirle di fare, come `vista.hud_aggiungi(info)` dove `info` è un valore o una tabella che non è imparentata in alcun modo con l'API di Minetest.

<figure class="right_image">
    <img
        width="100%"
        src="{{ page.root }}/static/mvc_diagram.svg"
        alt="Diagramma che mostra la struttura MVC (Modello-Vista-Controllo)">
</figure>

È importante che ogni area comunichi soltanto con i suoi diretti vicini, per ridurre il più possibile la quantità di codice da cambiare al modificare qualcosa.
Per esempio, per cambiare il formspec avrai bisogno di modificare solo la vista.
Per cambiare la API della vista, la vista e il controllo - ma non il modello.

In pratica, questo approccio è raramente utilizzato per via della sua alta complessità e perché non dà molti benefici alla maggior parte delle mod.
Al contrario, un approccio più comune e leggermente meno rigido è quello API-Vista.


### API-Vista

In un mondo ideale, si avrebbero le 3 aree MVC perfettamente separate... ma siamo nel mondo reale.
Un buon compromesso è ridurre la mod in due parti:

* **API** - modello + controllo. Non ci dovrebbe essere nessun uso di `minetest.` nella API.
* **Vista** - la vista, esattamente come quella spiegata sopra.
  È buona norma strutturare questa parte in file separati per ogni tipo di evento.

La [crafting mod](https://github.com/rubenwardy/crafting) di rubenwardy segue ben o male questo schema: `api.lua` è quasi tutto puro Lua che gestisce lo spazio d'archiviazione e i calcoli che farebbe il controllo, `gui.lua` mostra e invia i formspec, e `async_crafter.lua` è la vista e il controllo dei timer e i formspec nei nodi.

Separare la mod in questa maniera permette di testare molto facilmente la API, in quanto non passa per quella di Minetest - come mostrato nel [prossimo capitolo](unit_testing.html).


## Conclusione

Cosa sia del buon codice è soggettivo, e dipende altamente dal progetto che si vuole realizzare.
Come regola generale, cerca di tenere un'alta coesione (parti di codice tra loro connesse vicine) e poche dipendenze.

Suggerisco caldamente, per chi mastica l'inglese, di leggere il libro [Game Programming Patterns](http://gameprogrammingpatterns.com/).
Lo si può leggere gratuitamente [online](http://gameprogrammingpatterns.com/contents.html) e descrive molto più nel dettaglio gli approcci di programmazione da tenere quando si parla di videogiochi.
