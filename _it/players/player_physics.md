---
title: Fisica del giocatore
layout: default
root: ../..
idx: 4.4
redirect_from: /it/chapters/player_physics.html
---

## Introduzione <!-- omit in toc -->

La fisica del giocatore può essere modificata usando le sovrascritture apposite (*physics ovverrides*).
Esse sono dei moltiplicatori che servono per impostare la velocità di movimento, del salto, o la gravità del singolo giocatore.
Per esempio, un valore di 2 sulla gravità, renderà la gravità di un utente due volte più forte.

- [Esempio base](#esempio-base)
- [Sovrascritture disponibili](#sovrascritture-disponibili)
  - [Vecchio sistema di movimento](#vecchio-sistema-di-movimento)
- [Incompatibilità tra mod](#incompatibilita-tra-mod)
- [Il tuo turno](#il-tuo-turno)

## Esempio base

Segue l'esempio di un comando di antigravità:

```lua
minetest.register_chatcommand("antigrav", {
    func = function(name, param)
        local giocatore = minetest.get_player_by_name(name)
        giocatore:set_physics_override({
            gravity = 0.1, -- imposta la gravità al 10% del suo valore originale
                           -- (0.1 * 9.81)
        })
    end,
})
```

## Sovrascritture disponibili

`set_physics_override()` è una tabella. Stando a [lua_api.txt]({{ page.root }}/lua_api.html#player-only-no-op-for-other-objects), le chiavi possono essere:

* `speed`: moltiplicatore della velocità di movimento (predefinito: 1)
* `jump`: moltiplicatore del salto (predefinito: 1)
* `gravity`: moltiplicatore della gravità (predefinito: 1)
* `sneak`: se il giocatore può camminare di soppiatto o meno (predefinito: true)

### Vecchio sistema di movimento

Il movimento dei giocatori prima della versione 0.4.16 includeva il cosiddetto *sneak glitch*, il quale permetteva vari glitch di movimento come l'abilità di scalare un "ascensore" fatta di certi blocchi premendo shift (la camminata di soppiatto) e salto. Nonostante non fosse una funzionalità voluta, è stata mantenuta nelle sovrascritture dato il suo uso in molti server.

Per ripristinare del tutto questo comportamento servono due chiavi:

* `new_move`: se usare o meno il nuovo sistema di movimento (predefinito: true)
* `sneak_glitch`: se il giocatore può usare o meno il glitch dell'ascensore (default: false)

## Incompatibilità tra mod

Tieni a mente che le mod che sovrascrivono la stessa proprietà fisica di un giocatore tendono a essere incompatibili tra di loro.
Quando si imposta una sovrascrittura, sovrascriverà qualsiasi altro suo simile impostato in precedenza: ciò significa che se la velocità di movimento di un giocatore viene cambiata più volte, solo l'ultimo valore verrà preso in considerazione.

## Il tuo turno

* **Sonic**: Imposta il moltiplicatore di velocità a un valore elevato (almeno 6) quando un giocatore entra in gioco;
* **Super rimbalzo**: Aumenta il valore del salto in modo che il giocatore possa saltare 20 metri (1 cubo = 1 metro);
* **Space**: Fai in modo che la gravità diminuisca man mano che si sale di altitudine.
