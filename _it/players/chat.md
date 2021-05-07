---
title: Chat e comandi
layout: default
root: ../..
idx: 4.2
description: Come registrare un comando e gestire i messaggi della chat
redirect_from: /it/chapters/chat.html
cmd_online:
    level: warning
    title: I giocatori offline possono eseguire comandi
    message: <p>Viene passato il nome del giocatore al posto del giocatore in sé perché le mod possono eseguire comandi in vece di un giocatore offline.
             Per esempio, il bridge IRC permette ai giocatori di eseguire comandi senza dover entrare in gioco.</p>

             <p>Assicurati quindi di non dar per scontato che un giocatore sia connesso.
             Puoi controllare ciò tramite <pre>minetest.get_player_by_name</pre>, per vedere se ritorna qualcosa o meno.</p>

cb_cmdsprivs:
    level: warning
    title: Privilegi e comandi
    message: Il privilegio shout non è necessario per far sì che un giocatore attivi questo callback.
             Questo perché i comandi sono implementati in Lua, e sono semplicemente dei messaggi in chat che iniziano con /.

---

## Introduzione <!-- omit in toc -->

Le mod possono interagire con la chat del giocatore, tra l'inviare messaggi, intercettarli e registrare dei comandi.

- [Inviare messaggi a tutti i giocatori](#inviare-messaggi-a-tutti-i-giocatori)
- [Inviare messaggi a giocatori specifici](#inviare-messaggi-a-giocatori-specifici)
- [Comandi](#comandi)
- [Complex Subcommands](#complex-subcommands)
- [Intercettare i messaggi](#interecettare-i-messaggi)

## Inviare messaggi a tutti i giocatori

Per inviare un messaggio a tutti i giocatori connessi in gioco, si usa la funzione `chat_send_all`:

```lua
minetest.chat_send_all("Questo è un messaggio visualizzabile da tutti")
```

Segue un esempio di come apparirerebbe in gioco:

    <Tizio> Guarda qui
    Questo è un messaggio visualizzabile da tutti
    <Caio> Eh, cosa?

Il messaggio appare su una nuova riga, per distinguerlo dai messaggi dei giocatori.

## Inviare messaggi a giocatori specifici

Per inviare un messaggio a un giocatore in particolare, si usa invece la funzione `chat_send_player`:

```lua
minetest.chat_send_player("Tizio", "Questo è un messaggio per Tizio")
```

Questo messaggio viene mostrato esattamente come il precedente, ma solo, in questo caso, a Tizio.

## Comandi

Per registrare un comando, per esempio `/foo`, si usa `register_chatcommand`:

```lua
minetest.register_chatcommand("foo", {
    privs = {
        interact = true,
    },
    func = function(name, param)
        return true, "Hai detto " .. param .. "!"
    end,
})
```

Nel codice qui in alto, `interact` è elencato come [privilegio](privileges.html) necessario; in altre parole, solo i giocatori che hanno quel privilegio possono usare il comando.

I comandi ritornano un massimo di due valori, dove il primo è un booleano che indica l'eventuale successo, mentre il secondo è un messaggio da inviare all'utente.

{% include notice.html notice=page.cmd_online %}

## Sottocomandi complessi

È spesso necessario creare dei comandi complessi, come per esempio:

* `/msg <a> <messaggio>`
* `/team entra <nometeam>`
* `/team esci <nometeam>`
* `/team elenco`

Questo viene solitamente reso possibile dai [pattern di Lua](https://www.lua.org/pil/20.2.html).
I pattern sono un modo di estrapolare "cose" dal testo usando delle regole ben precise.

```lua
local a, msg = string.match(param, "^([%a%d_-]+) (*+)$")
```

Il codice sovrastante implementa `/msg <a> <messaggio>`. Vediamo cos'è successo partendo da sinistra:

* `^` dice di iniziare a combaciare dall'inizio della stringa;
* `()` è un gruppo - qualsiasi cosa che combaci con ciò che è contenuto al suo interno verrà ritornato da string.match;
* `[]` significa che i caratteri al suo interno sono accettati;
* `%a` significa che accetta ogni lettera e `%d` ogni cifra.
* `[%a%d_-]` significa che accetta ogni lettera, cifra, `_` e `-`.
* `+` dice di combaciare ciò che lo precede una o più volte.
* `*` dice di combaciare qualsiasi tipo di carattere.
* `$` dice di combaciare la fine della stringa.

Detto semplicemente, il pattern cerca un nome (una parola fatta di lettere, numeri, trattini o trattini bassi), poi uno spazio e poi il messaggio (uno o più caratteri, qualsiasi essi siano).
Vengono poi ritornati nome e messaggio, perché sono inseriti nelle parentesi.

Questo è come molte mod implementano comandi complessi.
Una guida più completa ai pattern è probabilmente quella su [lua-users.org](http://lua-users.org/wiki/PatternsTutorial) o la [documentazione PIL](https://www.lua.org/pil/20.2.html).

<p class="book_hide">
	C'è anche una libreria scritta dall'autore di questo libro che può essere usata
	per creare comandi complessi senza l'utilizzo di pattern:
	<a href="https://gitlab.com/rubenwardy/ChatCmdBuilder">Chat Command Builder</a>.
</p>


## Intercettare i messaggi

Per intercettare un messaggio, si usa `register_on_chat_message`:

```lua
minetest.register_on_chat_message(function(name, message)
    print(name .. " ha detto " .. message)
    return false
end)
```

Ritornando false, si permette al messaggio di essere inviato.
In verità `return false` può anche essere omesso in quanto `nil` verrebbe ritornato implicitamente, e nil è trattato come false.

{% include notice.html notice=page.cb_cmdsprivs %}

Dovresti assicurarti, poi, che il messaggio potrebbe essere un comando che invia messaggi in chat,
o che l'utente potrebbere non avere `shout`.

```lua
minetest.register_on_chat_message(function(name, message)
    if message:sub(1, 1) == "/" then
        print(name .. " ha eseguito un comando")
    elseif minetest.check_player_privs(name, { shout = true }) then
        print(name .. " ha detto " .. message)
    else
        print(name .. " ha provato a dire " .. message ..
                " ma non ha lo shout")
    end

    return false
end)
```
