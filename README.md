# Dot-no-front
Hjemmesia til mjukvarelauget

## Byggeprosess
Installer NPM og make.

Når dette er på plass er byggkommandoen `npm run build`. Scriptet i package.json lager mappa "build", og fyller den med filene fra "public" samt optimalisert output fra elm-kompilatoren.

## Serving
I utgangspunktet skal det fungere å serve mappa "build" med `index.html` som startpunkt.
