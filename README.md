# Dot-no-front: Mjukvarelaugets hjemmeside
Mjukvarelaugets hjemmeside, med blogg, prosjektsider, de nyeste albummene fra Astronomisk Tussmørke, og mye annet ræl.

## Byggeprosess
Sia er satt opp med create-react-app, og bruker npm som byggsystem. Installer avhengigheter med
```
npm i
```

Deretter kan sia testes med `npm start`, eller bygges med `npm run build`.

## React og Elm
Hjemmesiden kjører som en react-app, men enkelte komponenter er skrevet i Elm. Byggprosessen inkluderer derfor et kompileringssteg fra Elm til javascript/react. Det er imidlertid ikke mulig å se output fra Elm-kompilatoren når man bruker de vanlige byggscriptene. For å se advarsler og feil fra elm-kompilerier det satt opp et script i `npm run testelm`, dette kompilerer elm-filene, printer eventuelle feilmeldinger og skriver resultatet til /dev/null.