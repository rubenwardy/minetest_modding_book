---
title: "SFINV"
layout: default
root: ../..
idx: 4.7
description: una mod per rendere più semplice la creazione di un inventario complesso
redirect_from: /it/chapters/sfinv.html
---

## Introduzione <!-- omit in toc -->

Simple Fast Inventory (SFINV) è una mod presente in Minetest Game, usata per creare il [formspec](formspecs.html) del giocatore.
SFINV ha un'API che permette di aggiungere e altresì gestire le pagine mostrate.

Mentre SFINV di base mostra le pagine come finestre, le pagine sono chiamate tali in quanto è assolutamente possibile che una mod o un gioco decidano di mostrarle in un altro formato.
Per esempio, più pagine possono essere mostrate nel medesimo formspec.

- [Registrare una pagina](#registrare-una-pagina)
- [Ricevere eventi](#ricevere-eventi)
- [Condizioni per la visualizzazione](#condizioni-per-la-visualizzazione)
- [Callback on_enter e on_leave](#callback-onenter-e-onleave)
- [Aggiungere a una pagina esistente](#aggiungere-a-una-pagina-esistente)

## Registrare una pagina

SFINV fornisce la funzione chiamata `sfinv.register_page` per creare nuove pagine.
Basta chiamare la funzione con il nome che si vuole assegnare alla pagina e la sua definizione:

```lua
sfinv.register_page("miamod:ciao", {
    title = "Ciao!",
    get = function(self, player, context)
        return sfinv.make_formspec(player, context,
                "label[0.1,0.1;Ciao mondo!]", true)
    end
})
```

La funzione `make_formspec` circonda il formspec con il codice di SFINV.
Il quarto parametro, attualmente impostato a `true`, determina se l'inventario del giocatore è mostrato.

Rendiamo le cose più eccitanti; segue il codice della generazione di un formspec per gli admin.
Questa finestra permetterà agli admin di cacciare o bannare i giocatori selezionandoli da una lista e premendo un pulsante.

```lua
sfinv.register_page("mioadmin:mioadmin", {
    title = "Finestra",
    get = function(self, player, context)
        local giocatori = {}
        context.mioadmin_giocatori = giocatori

        -- Usare un array per costruire un formspec è decisamente più veloce
        local formspec = {
            "textlist[0.1,0.1;7.8,3;lista_giocatori;"
        }

        -- Aggiunge tutti i giocatori sia alla lista testuale che a quella - appunto - dei giocatori
        local primo = true
        for _ , giocatore in pairs(minetest.get_connected_players()) do
            local nome_giocatore = giocatore:get_player_name()
            giocatori[#giocatori + 1] = nome_giocatore
            if not primo then
                formspec[#formspec + 1] = ","
            end
            formspec[#formspec + 1] =
                    minetest.formspec_escape(nome_giocatore)
            primo = false
        end
        formspec[#formspec + 1] = "]"

        -- Aggiunge i pulsanti
        formspec[#formspec + 1] = "button[0.1,3.3;2,1;caccia;Caccia]"
        formspec[#formspec + 1] = "button[2.1,3.3;2,1;banna;Caccia e Banna]"

        -- Avvolge il formspec nella disposizione di SFINV
        -- (es: aggiunge le linguette delle finestre e lo sfondo)
        return sfinv.make_formspec(player, context,
                table.concat(formspec, ""), false)
    end,
})
```

Non c'è niente di nuovo in questa parte di codice; tutti i concetti sono già stati trattati o qui in alto o nei precedenti capitoli.

<figure>
    <img src="{{ page.root }}//static/sfinv_admin_fs.png" alt="Pagina per gli amministratori">
</figure>

## Ricevere eventi

Puoi ricevere eventi formspec tramite l'aggiunta della funzione `on_player_receive_fields` nella definizione SFINV.

```lua
on_player_receive_fields = function(self, player, context, fields)
    -- TODO: implementarlo
end,
```

`on_player_receive_fields` funziona alla stessa maniera di `minetest.register_on_player_receive_fields`, con la differenza che viene richiesto il contesto al posto del nome del form.
Tieni a mente che gli eventi interni di SFINV, come la navigazione tra le varie finestre, vengono gestiti dentro la mod stessa, e che quindi non verranno ricevuti in questo callback.

Implementiamo ora `on_player_receive_fields` nella mod:

```lua
on_player_receive_fields = function(self, player, context, fields)
    -- evento della lista testuale: controlla il tipo di evento e imposta il nuovo indice se è cambiata la selezione
    if fields.lista_giocatori then
        local event = minetest.explode_textlist_event(fields.lista_giocatori)
        if event.type == "CHG" then
            context.mioadmin_sel_id = event.index
        end

    -- Al premere "Caccia"
    elseif fields.caccia then
        local nome_giocatore =
                context.myadmin_players[context.mioadmin_sel_id]
        if player_name then
            minetest.chat_send_player(player:get_player_name(),
                    "Cacciato " .. nome_giocatore)
            minetest.kick_player(nome_giocatore)
        end

    -- Al premere "Caccia e Banna"
    elseif fields.banna then
        local nome_giocatore =
                context.myadmin_players[context.mioadmin_sel_id]
        if player_name then
            minetest.chat_send_player(player:get_player_name(),
                    "Banned " .. player_name)
            minetest.ban_player(nome_giocatore)
            minetest.kick_player(nome_giocatore, "Banned")
        end
    end
end,
```

C'è, tuttavia, un problema abbastanza grande a riguardo: chiunque può cacciare o bannare i giocatori!
C'è bisogno di un modo per mostrare questa finestra solo a chi ha i privilegi `kick` e `ban`.
Fortunatamente, SFINV ci permette di farlo!

## Condizioni per la visualizzazione

Si può aggiungere una funzione `is_in_nav` nella definizione della pagina se si desidera gestire quando la pagina deve essere mostrata:

```lua
is_in_nav = function(self, player, context)
    local privs = minetest.get_player_privs(player:get_player_name())
    return privs.kick or privs.ban
end,
```

Se si ha bisogno di controllare un solo privilegio o si vuole eseguire un `and`, si bisognerebbe usare `minetest.check_player_privs()` al posto di `get_player_privs`.

Tieni a mente che `is_in_nav` viene chiamato soltanto alla generazione dell'inventario del giocatore.
Questo succede quando un giocatore entra in gioco, si muove tra le finestre, o una mod richiede a SFINV di rigenerare l'inventario.

Ciò significa che hai bisogno di richiedere manualmente la rigenerazione del formspec dell'inventario per ogni evento che potrebbe cambiare il risultato ti `is_in_nav`.
Nel nostro caso, abbiamo bisogno di farlo ogni volta che i permessi `kick` o `ban` vengono assegnati/revocati a un giocatore:

```lua
local function al_cambio_privilegi(nome_target, nome_garante, priv)
    if priv ~= "kick" and priv ~= "ban" then
        return
    end

    local giocatore = minetest.get_player_by_name(nome_target)
    if not giocatore then
        return
    end

    local contesto = sfinv.get_or_create_context(giocatore)
    if contesto.page ~= "mioadmin:mioadmin" then
        return
    end

    sfinv.set_player_inventory_formspec(giocatore, contesto)
end

minetest.register_on_priv_grant(al_cambio_privilegi)
minetest.register_on_priv_revoke(al_cambio_privilegi)
```

## Callback on_enter e on_leave

Un giocatore *entra* in una finestra quando la finestra è selezionata e *esce* dalla finestra quando un'altra finestra è prossima a essere selezionata.
Attenzione che è possibile selezionare più pagine alla volta se viene usata un tema personalizzato.

Si tenga conto, poi, che questi eventi potrebbero non essere innescati dal giocatore, in quanto potrebbe addirittura non avere un formspec aperto in quel momento.
Per esempio, `on_enter` viene chiamato dalla pagina principale anche quando un giocatore entra in gioco, ancor prima che apri l'inventario.

Infine, non è possibile annullare il cambio pagina, in quanto potrebbe potenzialmente confondere il giocatore.

```lua
on_enter = function(self, player, context)

end,

on_leave = function(self, player, context)

end,
```

## Aggiungere a una pagina esistente

Per aggiungere contenuti a una pagina che già esiste, avrai bisogno di sovrascrivere la pagina e modificare il formspec che viene ritornato:

```lua
local vecchia_funzione = sfinv.registered_pages["sfinv:crafting"].get
sfinv.override_page("sfinv:crafting", {
    get = function(self, player, context, ...)
        local ret = vecchia_funzione(self, player, context, ...)

        if type(ret) == "table" then
            ret.formspec = ret.formspec .. "label[0,0;Ciao]"
        else
            -- Retrocompatibilità
            ret = ret .. "label[0,0;Ciao]"
        end

        return ret
    end
})
```
