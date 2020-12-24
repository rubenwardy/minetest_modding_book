---
title: Sicurezza
layout: default
root: ../..
idx: 8.3
---

## Introduzione <!-- omit in toc -->

La sicurezza è molto importante per evitare che una mod permetta di far perdere il controllo del server al suo proprietario.

- [Concetti fondamentali](#concetti-fondamentali)
- [Formspec](#formspec)
	- [Non fidarsi mai dei campi dei formspec](#non-fidarsi-mai-dei-campi-dei-formspec)
	- [Il momento per controllare non è il momento dell'uso (Time of Check is not Time of Use)](#il-momento-per-controllare-non-è-il-momento-delluso-time-of-check-is-not-time-of-use)
- [Ambienti (non sicuri)](#ambienti-non-sicuri)

## Concetti fondamentali

Il concetto più importante quando si parla di sicurezza è **non fidarsi mai dell'utente**.
Ogni cosa che l'utente può inviare al server deve essere trattata come malevola.
Questo significa che dovresti sempre controllare che le informazioni da loro immesse siano valide, che abbiano i privilegi necessari e che siano autorizzati a fare determinate azioni.

Un'azione malevola non è necessariamente la modifica o la distruzione di dati, ma può essere anche l'accedere a dati sensibili, come gli hash delle password o i messaggi privati.
Questo è grave soprattutto se il server possiede informazioni sugli utenti come le loro e-mail o la loro età, che alcuni potrebbero richiedere per questioni di verifica.

## Formspec

### Non fidarsi mai dei campi dei formspec

Qualsiasi utente può inviare qualsiasi formspec con i valori che preferisce quando preferisce.

Segue del codice trovato realmente in una mod:

```lua
minetest.register_on_player_receive_fields(function(player,
        formname, fields)
    for key, field in pairs(fields) do
        local x,y,z = string.match(key,
                "goto_([%d-]+)_([%d-]+)_([%d-]+)")
        if x and y and z then
            player:set_pos({ x=tonumber(x), y=tonumber(y),
                    z=tonumber(z) })
            return true
        end
    end
end
```

Riesci a vedere il problema? Un utente malintenzionato potrebbe inviare un formspec contenente la propria posizione, permettendogli di venire teletrasportato dovunque vuole.
Addirittura il tutto potrebbe essere automatizzato usando modifiche del client per replicare il comportamento di `/teleport` senza aver bisogno di alcun privilegio.

La soluzione per questo tipo di problematica è usare un [Contesto](../players/formspecs.html#contexts), come mostrato precedentemente nel capitolo dei Formspec.

### Il momento per controllare non è il momento dell'uso (Time of Check is not Time of Use)

Qualsiasi utente può inviare qualsiasi formspec con i valori che preferisce quando preferisce, sì: a meno che il motore di gioco non glielo impedisca:

* L'invio dei formspec di un nodo vengono bloccati se l'utente è troppo distante;
* Dalla 5.0 in poi, i formspec con un nome sono bloccati se non sono stati ancora mostrati.

Questo significa che dovresti controllare che l'utente soddisfi i requisiti per visualizzare il formspec in primis, esattamente come per ogni azione corrispondente.

La vulnerabilità causata dal controllare i privilegi nel `show_formspec` ma non nella gestione del formspec in primis è chiamata *Time Of Check is not Time Of Use* (Il momento per controllare non è il momento dell'uso), o più brevemente TOCTOU.


## Ambienti (non sicuri)

Minetest permette alle mod di richiedere ambienti senza limiti, dando loro accesso all'intera API Lua.

Riesci a individuare la vulnerabilità in questo pezzo di codice??

```lua
local ie = minetest.request_insecure_environment()
ie.os.execute(("path/to/prog %d"):format(3))
```

`string.format` è una funzione nella tabella globale condivisa `string`.
Una mod malevola potrebbe sovrascrivere questa funzione e passare "cose" a `os.execute`:

```lua
string.format = function()
    return "xdg-open 'http://esempio.com'"
end
```

La mod potrebbe passare qualcosa di molto più malevolo dell'apertura di un sito, come dare il controllo remoto della macchina al malintenzionato in questione.

Alcune regole per usare un ambiente non sicuro:

* Tenerlo sempre in una variabile locale e non passarlo mai a una funzione;
* Assicurarsi di potersi fidare di qualsiasi input eseguita in una funzione insicura, per evitare il problema sopracitato.
  Questo significa evitare funzioni globali ridefinibili.
