---
title: Creare giochi
layout: default
root: ../..
idx: 7.1
---

## Introduzione <!-- omit in toc -->

Il punto forte di Minetest è quello di poter sviluppare giochi con facilità senza il bisogno di costruirsi il proprio motore grafico voxel, i propri algoritmi voxel, o la propria parte network.

- [Cos'è un gioco?](#cosè-un-gioco)
- [Cartella di un gioco](#cartella-di-un-gioco)
- [Compatibilità tra giochi](#compatibilità-tra-giochi)
	- [Compatibilità delle API](#compatibilità-delle-api)
	- [Gruppi e alias](#gruppi-e-alias)
- [Il tuo turno](#il-tuo-turno)

## Cos'è un gioco?

I giochi sono una collezione di mod che lavorano insieme per creare un gioco coerente.
Un buon gioco ha una base consistente e una direzione: per esempio, potrebbe essere il classico gioco survival dove picconare e fabbricare oggetti, come potrebbe essere un simulatore spaziale con estetiche steampunk.

Il design di un gioco, tuttavia, è un argomento complesso, tanto che è una branca di specializzazione a parte.
L'intento del libro è giusto farne un accenno.

## Cartella di un gioco

La struttura e la collocazione di un gioco dovrebbero sembrare alquanto familiari dopo aver pasticciato con le mod.
Le cartelle dei giochi si trovano in `minetest/games/` e sono strutturate come segue:

	mio_gioco
	├── game.conf
	├── menu
	│   ├── header.png
	│   ├── background.png
	│   └── icon.png
	├── minetest.conf
	├── mods
	│   └── ... mods
	├── README.txt
	└── settingtypes.txt

L'unica cosa necessaria è la cartella `mods`, ma è raccomandato anche l'inserimento di `game.conf` e `menu/icon.png`.

## Compatibilità tra giochi

### Compatibilità delle API

È buona norma provare a mantenere le API compatibili con quelle di Minetest Game quanto possibile, in quanto renderebbe il porting delle mod (in un altro gioco) molto più semplice.

Il modo migliore per mantenere la compatibilità tra un gioco e l'altro è di mantenere la stessa compatibilità nelle API delle mod che hanno lo stesso nome.
Cosicché, se una mod usa lo stesso nome di un'altra (come fare una mod chiamata `doors`, che già esiste in Minetest Game), non ci saranno problemi.

Questa compatibilità per le mod si traduce in due punti:

* Tabella API Lua - tutte le funzioni nella tabella globale (`mia_mod.funzionivarie`) che condividono lo stesso nome;
* Nodi e oggetti registrati.

Eventuali piccole rotture non sono la fine del mondo (come non avere una funzione che tanto veniva usata solo internamente), ma quando saltano le funzioni principali è un altro paio di maniche.

È difficile mantenere queste compatibilità con modpack disgustatamente grosse come la *default* in Minetest Game, dacché si dovrebbe evitare di chiamare una mod "default".

Infine, le compatibilità delle API si applicano anche a mod e giochi esterni, quindi assicurati che una mod nuova abbia un nome unico.
Per controllare se un nome è già stato preso, prova a cercarlo su [content.minetest.net](https://content.minetest.net/).

### Gruppi e alias

I gruppi e gli alias sono entrambi strumenti utili per mantenere la compatibilità tra giochi, in quanto permettono ai nomi degli oggetti di variare a seconda del gioco.
Nodi comuni come pietra e legno dovrebbero avere dei gruppi per indicarne il materiale.
È anche buona norma fornire degli alias che vanno dai nodi di base a qualsiasi eventuale rimpiazzo.

## Il tuo turno

* Crea un semplice gioco dove il giocatore guadagna punti allo scavare alcuni nodi speciali.
