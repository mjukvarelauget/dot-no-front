# Dot-no-front
Hjemmesia til mjukvarelauget

## Byggeprosess
Intaller Make og NPM. 

Når dette er på plass er byggkommandoen `make build`. Makefila lager mappa "build", og fyller den med filene fra "public" samt optimalisert output fra elm-kompilatoren. `make clean` fjerner alle byggfiler.

## Serving
I utgangspunktet skal det fungere å serve mappa "Build" med `index.html` som startpunkt.
