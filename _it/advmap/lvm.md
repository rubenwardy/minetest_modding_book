---
title: Manipolatori di voxel Lua
layout: default
root: ../..
idx: 6.2
description: Impara come usare gli LVM per accelerare le operazioni nella mappa.
redirect_from:
  - /it/chapters/lvm.html
  - /it/map/lvm.html
mapgen_object:
    level: warning
    title: LVM e generatore mappa
    message: Non usare `minetest.get_voxel_manip()` con il generatore mappa, in quanto può causare glitch.
            Usa invece `minetest.get_mapgen_object("voxelmanip")`.
---

## Introduzione <!-- omit in toc -->

Le funzioni introdotte nel capitolo [Mappa: operazioni base](environment.html) sono comode e facili da usare, ma per le grandi aree non sono efficienti.
Ogni volta che `set_node` e `get_node` vengono chiamati da una mod, la mod deve comunicare con il motore di gioco.
Ciò risulta in una costante copia individuale dei singoli nodi, che è lenta e abbasserà notevolmente le performance del gioco.
Usare un Manipolatore di Voxel Lua (*Lua Voxel Manipulator*, da qui LVM) può essere un'alternativa migliore.
- [Concetti](#concetti)
- [Lettura negli LVM](#lettura-negli-lvm)
- [Lettura dei nodi](#lettura-dei-nodi)
- [Scrittura dei nodi](#scrittura-dei-nodi)
- [Esempio](#esempio)
- [Il tuo turno](#il-tuo-turno)

## Concetti

Un LVM permette di caricare grandi pezzi di mappa nella memoria della mod che ne ha bisogno.
Da lì si possono leggere e modificare i dati immagazzinati senza dover interagire ulteriormente col motore di gioco, e senza eseguire callback; in altre parole, l'operazione risulta molto più veloce.
Una volta fatto ciò, si può passare l'area modificata al motore di gioco ed eseguire eventuali calcoli riguardo la luce.

## Lettura negli LVM

Si possono caricare solamente aree cubiche negli LVM, quindi devi capire da te quali sono le posizioni minime e massime che ti servono per l'area da modificare.
Fatto ciò, puoi creare l'LVM:

```lua
local vm         = minetest.get_voxel_manip()
local emin, emax = vm:read_from_map(pos1, pos2)
```

Per questioni di performance, un LVM non leggerà quasi mai l'area esatta che gli è stata passata.
Al contrario, è molto probabile che ne leggerà una maggiore. Quest'ultima è data da `emin` ed `emax`, che stanno per posizione minima/massima emersa (*emerged min/max pos*).
Inoltre, un LVM caricherà in automatico l'area passatagli - che sia da memoria, da disco o dal generatore di mappa.

{% include notice.html notice=page.mapgen_object %}

## Lettura dei nodi

Per leggere il tipo dei nodi in posizioni specifiche, avrai bisogno di usare `get_data()`.
Questo metodo ritorna un array monodimensionale dove ogni voce rappresenta il tipo.

```lua
local data = vm:get_data()
```

Si possono ottenere param2 e i dati della luce usando i metodi `get_light_data()` e `get_param2_data()`.

Avrai bisogno di usare `emin` e `emax` per capire dove si trova un nodo nei metodi sopraelencati.
C'è una classe di supporto per queste cose chiamate `VoxelArea` che gestisce i calcoli al posto tuo.

```lua
local a = VoxelArea:new{
    MinEdge = emin,
    MaxEdge = emax
}

-- Ottiene l'indice del nodo
local idx = a:index(x, y, z)

-- Legge il nodo
print(data[idx])
```

All'eseguire ciò, si noterà che `data[idx]` è un intero.
Questo perché il motore di gioco non salva i nodi come stringhe per motivi di performance; al contrario, usa un intero chiamato "ID di contenuto" (*content ID*).
Per scoprire qual è l'ID assegnato a un tipo di nodo, si usa `get_content_id()`.
Per esempio:

```lua
local c_pietra = minetest.get_content_id("default:stone")
```

Si può ora controllare se un nodo è effettivamente di pietra:

```lua
local idx = a:index(x, y, z)
if data[idx] == c_pietra then
    print("è pietra!")
end
```

Si consiglia di ottenere e salvare (in una variabile locale) gli ID di contenuto al caricare della mod in quanto questi non possono cambiare.

Le coordinate dei nodi nell'array di un LVM sono salvate in ordine inverso (`z, y, x`), quindi se le si vuole iterare, si tenga presente che si inizierà dalla Z:

```lua
for z = min.z, max.z do
    for y = min.y, max.y do
        for x = min.x, max.x do
            local idx = a:index(x, y, z)
            if data[idx] == c_pietra then
                print("è pietra!")
            end
        end
    end
end
```

Per capire la ragione di tale iterazione, bisogna parlare un attimo di architettura dei computer: leggere dalla RAM - la memoria principale - è alquanto dispendioso, quindi i processori hanno molteplici livelli di memoria a breve termine (la *cache*).
Se i dati richiesti da un processo sono in quest'ultima memoria, si possono ottenere velocemente.
Al contrario, se i dati lì non ci sono, verranno pescati dalla RAM *e* inseriti in quella a breve termine, nel caso dovessero servire di nuovo.
Questo significa che una buona regola per l'ottimizzazione è quella di iterare in modo che i dati vengano letti in sequenza, evitando di arrivare fino alla RAM ogni volta (*cache thrashing*).

## Scrittura dei nodi

Prima di tutto, bisogna impostare il nuovo ID nell'array:

```lua
for z = min.z, max.z do
    for y = min.y, max.y do
        for x = min.x, max.x do
            local idx = a:index(x, y, z)
            if data[idx] == c_pietra then
                data[idx] = c_aria
            end
        end
    end
end
```

Una volta finito con le operazioni nell'LVM, bisogna passare l'array al motore di gioco:

```lua
vm:set_data(data)
vm:write_to_map(true)
```

Per la luce e param2, invece si usano `set_light_data()` e `set_param2_data()`.

`write_to_map()` richiede un booleano che è `true` se si vuole che venga calcolata anche la luce. 
Se si passa `false` invece, ci sarà bisogno di ricalcolarla in un secondo tempo usando `minetest.fix_light`.

## Esempio

```lua
-- ottiene l'ID di contenuto al caricare della mod, salvandolo in variabili locali
local c_terra  = minetest.get_content_id("default:dirt")
local c_erba = minetest.get_content_id("default:dirt_with_grass")

local function da_erba_a_terra(pos1, pos2)
    -- legge i dati nella LVM
    local vm = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map(pos1, pos2)
    local a = VoxelArea:new{
        MinEdge = emin,
        MaxEdge = emax
    }
    local data = vm:get_data()

    -- modifica i dati
    for z = pos1.z, pos2.z do
        for y = pos1.y, pos2.y do
            for x = pos1.x, pos2.x do
                local idx = a:index(x, y, z)
                if data[idx] == c_erba then
                    data[idx] = c_terra
                end
            end
        end
    end

    -- scrive i dati
    vm:set_data(data)
    vm:write_to_map(true)
end
```

## Il tuo turno

* Crea una funzione `rimpiazza_in_area(da, a, pos1, pos2)`, che sostituisce tutte le istanze di `da` con `a` nell'area data, dove `da` e `a` sono i nomi dei nodi;
* Crea una funzione che ruota tutte le casse di 90&deg;;
* Crea una funzione che usa un LVM per far espandere i nodi di muschio sui nodi di pietra e pietrisco confinanti.
  La tua implementazione fa espandere il muschio di più di un blocco alla volta? Se sì, come puoi prevenire ciò?
