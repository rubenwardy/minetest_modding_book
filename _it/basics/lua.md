---
title: Programmare in Lua
layout: default
root: ../..
idx: 1.2
description: Un'introduzione a Lua, con inclusa una guida alla portata globale/locale.
redirect_from: /it/chapters/lua.html
---

## Introduzione  <!-- omit in toc -->

In questo capitolo parleremo della programmazione in Lua, degli strumenti necessari, e tratteremo alcune tecniche che troverai probabilmente utili.

- [Editor di codice](#editor-di-codice)
- [Programmare in Lua](#programmare-in-lua)
	- [Flusso del programma](#flusso-del-programma)
	- [Tipi di variabili](#tipi-di-variabili)
	- [Operatori matematici](#operatori-matematici)
	- [Selezione](#selezione)
	- [Operatori logici](#operatori-logici)
- [Programmare](#programmare)
- [Portata locale e globale](#portata-locale-e-globale)
- [Inclusione di altri script Lua](#inclusione-di-altri-script-lua)

## Editor di codice

Un editor di codice con evidenziamento delle parole chiave è sufficiente per scrivere script in Lua.
L'evidenziamento assegna colori diversi a parole e caratteri diversi, a seconda del loro significato, permettendo quindi di individuare più facilmente eventuali errori e inconsistenze.

Per esempio:

```lua
function ctf.post(team,msg)
    if not ctf.team(team) then
        return false
    end
    if not ctf.team(team).log then
        ctf.team(team).log = {}
    end

    table.insert(ctf.team(team).log,1,msg)
    ctf.save()

    return true
end
```

Nel passaggio qui sopra, le parole chiave `if`, `then`, `end` e `return` sono evidenziate.
E Lo stesso vale per le funzioni interne di Lua come `table.insert`.

Tra gli editor più famosi che ben si prestano a lavorare in Lua, troviamo:

* [VSCode](https://code.visualstudio.com/) - software libero (come Code-OSS e VSCodium), rinomato, e che dispone di [estensioni per il modding su Minetest](https://marketplace.visualstudio.com/items?itemName=GreenXenith.minetest-tools).
* [Notepad++](http://notepad-plus-plus.org/) - Solo per Windows

(ne esistono ovviamente anche altri)


## Programmare in Lua

### Flusso del programma

I programmi sono una serie di comandi che vengono eseguiti uno dopo l'altro.
Chiamiamo questi comandi "istruzioni".
Il flusso del programma è il come queste istruzioni vengono eseguite, e a differenti tipi di flusso corrispondono comportamenti diversi.
Essi possono essere:

* Sequenziali: eseguono un'istruzione dopo l'altra, senza salti.
* Selettivi: saltano alcune sequenze a seconda delle condizioni.
* Iteranti: continuano a eseguire le stesse istruzioni finché una condizione non è soddisfatta.

Quindi, come vengono rappresentate le istruzioni in Lua?

```lua
local a = 2     -- Imposta 'a' a 2
local b = 2     -- Imposta 'b' a 2
local risultato = a + b -- Imposta 'risultato' ad a + b, cioè 4
a = a + 10
print("La somma è ".. risultato)
```

In quest'esempio, `a`, `b`, e `risultato` sono *variabili*. Le variabili locali si dichiarano tramite l'uso della parola chiave `local` (che vedremo tra poco), e assegnando eventualmente loro un valore iniziale.

Il simbolo `=` significa *assegnazione*, quindi `risultato = a + b` significa impostare "risultato" ad a + b.
Per quanto riguarda i nomi delle variabili, essi possono essere più lunghi di un carattere - al contrario che in matematica - come visto in `risultato`, e vale anche la pena notare che Lua è *case-sensitive* (differenzia maiuscole da minuscole); `A` è una variabile diversa da `a`.

### Tipi di variabili

Una variabile può equivalere solo a uno dei seguenti tipi e può cambiare tipo dopo l'assegnazione.
È buona pratica assicurarsi che sia sempre solo o nil o diversa da nil.

| Tipo     | Descrizione                     | Esempio        |
|----------|---------------------------------|----------------|
| Nil      | Non inizializzata. La variabile è vuota, non ha valore | `local A`, `D = nil` |
| Numero   | Un numero intero o decimale  | `local A = 4` |
| Stringa  | Una porzione di testo  | `local D = "one two three"` |
| Booleano | Vero o falso (true, false)    | `local is_true = false`, `local E = (1 == 1)` |
| Tabella  | Liste | Spiegate sotto |
| Funzione | Può essere eseguita. Può richiedere input e ritornare un valore | `local result = func(1, 2, 3)` |

### Operatori matematici

Tra gli operatori di Lua ci sono:

| Simbolo | Scopo              | Esempio                   |
|---------|--------------------|---------------------------|
| A + B   | Addizione          | 2 + 2 = 4                 |
| A - B   | Sottrazione        | 2 - 10 = -8               |
| A * B   | Moltiplicazione    | 2 * 2 = 4                 |
| A / B   | Divisione          | 100 / 50 = 2              |
| A ^ B   | Potenze            | 2 ^ 2 = 2<sup>2</sup> = 4 |
| A .. B  | Concatena stringhe | "foo" .. "bar" = "foobar" |

Si tenga presente che questa non è comunque una lista esaustiva.

### Selezione

Il metodo di selezione più basico è il costrutto if.
Si presenta così:

```lua
local random_number = math.random(1, 100) -- Tra 1 e 100.
if random_number > 50 then
    print("Woohoo!")
else
    print("No!")
end
```

Questo esempio genera un numero casuale tra 1 e 100.
Stampa poi "Woohoo!" se il numero è superiore a 50, altrimenti stampa "No!".

### Operatori logici

Tra gli operatori logici di Lua ci sono:

| Simbolo  | Scopo                               | Esempio                                                     |
|---------|--------------------------------------|-------------------------------------------------------------|
| A == B  | Uguale a                             | 1 == 1 (true), 1 == 2 (false)                               |
| A ~= B  | Non uguale a (diverso da)            | 1 ~= 1 (false), 1 ~= 2 (true)                               |
| A > B   | Maggiore di                          | 5 > 2 (true), 1 > 2 (false), 1 > 1 (false)                  |
| A < B   | Minore di                            | 1 < 3 (true), 3 < 1 (false), 1 < 1 (false)                  |
| A >= B  | Maggiore o uguale a                  | 5 >= 5 (true), 5 >= 3 (true), 5 >= 6 (false)                |
| A <= B  | Minore o uguale a                    | 3 <= 6 (true), 3 <= 3 (true)                                |
| A and B | E (entrambi devono essere veri)      | (2 > 1) and (1 == 1)  (true), (2 > 3) and (1 == 1)  (false) |
| A or B  | O (almeno uno dei due vero)          | (2 > 1) or (1 == 2) (true), (2 > 4) or (1 == 3) (false)     |
| not A   | non vero                             | not (1 == 2)  (true), not (1 == 1)  (false)                 |

La lista non è esaustiva, e gli operatori possono essere combinati, come da esempio:

```lua
if not A and B then
    print("Yay!")
end
```

Che stampa "Yay!" se `A` è falso e `B` vero.

Gli operatori logici e matematici funzionano esattamente allo stesso modo; entrambi accettano input e ritornano un valore che può essere immagazzinato. Per esempio:

```lua
local A = 5
local is_equal = (A == 5)
if is_equal then
    print("È equivalente!")
end
```

## Programmare

Programmare è l'azione di prendere un problema, come ordinare una lista di oggetti, e tramutarlo in dei passaggi che il computer può comprendere.

Insegnarti i processi logici della programmazione non rientra nell'ambito di questo libro; tuttavia, i seguenti siti sono alquanto utili per approfondire l'argomento:

* [Codecademy](http://www.codecademy.com/) è una delle migliori risorse per imparare come scrivere codice; offre un'esperienza guidata interattiva.
* [Scratch](https://scratch.mit.edu) è una buona risorsa quando si comincia dalle basi assolute, imparando le tecniche di problem solving necessarie per la programmazione.\\
  Scratch è *ideato per insegnare ai bambini* e non è un linguaggio serio di programmazione.

## Portata locale e globale

L'essere locale o globale di una variabile determina da dove è possibile accederci.
Una variabile locale è accessibile soltanto da dove viene definita. Ecco alcuni esempi:

```lua
-- Accessibile dall'interno dello script
local one = 1

function myfunc()
    -- Accessibile dall'interno della funzione
    local two = one + one

    if two == one then
        -- Accessible dall'interno del costrutto if
        local three = one + two
    end
end
```

Mentre le variabili globali sono accessibili da qualsiasi script di qualsiasi mod.

```lua
function one()
    foo = "bar"
end

function two()
    print(dump(foo))  -- Output: "bar"
end

one()
two()
```

Le variabili locali dovrebbero venire usate il più possibile, con le mod che creano al massimo una globale corrispondente al nome della mod.
Crearne di ulteriori è considerato cattiva programmazione, e Minetest ci avviserà di ciò:

    Assignment to undeclared global 'foo' inside function at init.lua:2

Per ovviare, usa `local`:

```lua
function one()
    local foo = "bar"
end

function two()
    print(dump(foo))  -- Output: nil
end

one()
two()
```

Ricorda che `nil` significa **non inizializzato**.
Ovvero la variabile non è stata ancora assegnata a un valore, non esiste o è stata deinizializzata (cioè impostata a `nil`)

La stessa cosa vale per le funzioni: esse sono variabili di tipo speciale, e dovrebbero essere dichiarate locali, in quanto altre mod potrebbero sennò avere funzioni con lo stesso nome.

```lua
local function foo(bar)
    return bar * 2
end
```

Per permettere alle mod di richiamare le tue funzioni, dovresti creare una tabella con lo stesso nome della mod e aggiungercele all'interno.
Questa tabella è spesso chiamata una API.

```lua
mymod = {}

function mymod.foo(bar)
    return "foo" .. bar
end

-- In un'altra mod o script:
mymod.foo("foobar")
```

## Inclusione di altri script Lua

Il metodo consigliato per includere in una mod altri script Lua è usare *dofile*.

```lua
dofile(minetest.get_modpath("modname") .. "/script.lua")
```

Uno script può ritornare un valore, che è utile per condividere variabili locali private:

```lua
-- script.lua
return "Hello world!"

-- init.lua
local ret = dofile(minetest.get_modpath("modname") .. "/script.lua")
print(ret) -- Hello world!
```

Nei [capitoli seguenti](../quality/clean_arch.html) si parlerà nel dettaglio di come suddividere il codice di una mod.
