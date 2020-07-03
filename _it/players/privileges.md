---
title: Privilegi
layout: default
root: ../..
idx: 4.1
description: Tu, non puoi, passareee! (Tu invece sì)
redirect_from: /it/chapters/privileges.html
---

## Introduzione <!-- omit in toc -->

I privilegi (*privileges*, solitamente abbreviati in *privs*), danno ai giocatori l'abilità di eseguire certe azioni.
I proprietari dei server possono assegnare e revocare i privilegi per controllare quali cose un giocatore può o non può fare.

- [Privilegi sì e privilegi no](#privilegi-si-e-privilegi-no)
- [Dichiarazione](#dichiarazione)
- [Controlli](#controlli)
- [Ottenere e impostare privilegi](#ottenere-e-impostare-privilegi)
- [Aggiungere privilegi a basic_privs](#aggiungere-privilegi-a-basicprivs)

## Privilegi sì e privilegi no

I privilegi non sono fatti per indicare classi o status.

**Privilegi corretti:**

* interact
* shout
* noclip
* fly
* kick
* ban
* vote
* worldedit
* area_admin - admin functions of one mod is ok

**Privilegi sbagliati:**

* moderatore
* amministratore
* elfo
* nano

## Dichiarazione

Usa `register_privilege` per dichiarare un nuovo privilegio:

```lua
minetest.register_privilege("voto", {
    description = "Può votare nei sondaggi",
    give_to_singleplayer = false
})
```

`give_to_singleplayer` è di base true, quindi non c'è bisogno di specificarlo se non lo si vuole mettere false.

## Controlli

Per controllare velocemente se un giocatore ha tutti i privilegi necessari o meno:

```lua
local celo, manca = minetest.check_player_privs(player_or_name,  {
    interact = true,
    voto = true })
```

In quest'esempio, `celo` è true se il giocatore ha sia `interact` che `voto`.
Se `celo` è false, allora `manca` conterrà una tabella con i privilegi mancanti.

```lua
local celo, manca = minetest.check_player_privs(name, {
        interact = true,
        voto = true })

if celo then
    print("Il giocatore ha tutti i privilegi!")
else
    print("Al giocatore mancano i seguenti privilegi: " .. dump(manca))
end
```

Se non hai bisogno di controllare i privilegi mancanti, puoi inserire `check_player_privs` direttamente nel costrutto if:

```lua
if not minetest.check_player_privs(name, { interact=true }) then
    return false, "Hai bisogno del privilegio 'interact' per eseguire quest'azione!"
end
```

## Ottenere e impostare privilegi

Si può accedere o modificare i privilegi di un giocatore anche se quest'ultimo non risulta online.

```lua
local privs = minetest.get_player_privs(name)
print(dump(privs))

privs.voto = true
minetest.set_player_privs(name, privs)
```

I privilegi sono sempre specificati come una tabella chiave-valore, con il loro nome come chiave e true/false come valore.

```lua
{
    fly = true,
    interact = true,
    shout = true       -- per poter scrivere in chat
}
```

## Aggiungere privilegi a basic_privs

I giocatori con il privilegio `basic_privs` sono in grado di assegnare e revocare un set limitato di privilegi.
È cosa comune assegnarlo ai moderatori in modo che possano mettere o togliere `interact` e `shout` agli altri giocatori, ma che al tempo stesso non possano assegnare privilegi (a loro stessi o ad altri giocatori) con maggiori possibilità di abuso - come `give` e `server`.

Per modificare quali sono i privilegi contenuti in `basic_privs`, va cambiata l'omonima opzione.
Se di base si ha infatti:

    basic_privs = interact, shout

Per aggiungere `vote`, basta fare:

    basic_privs = interact, shout, vote
