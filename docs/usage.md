# Використання проєкту

## Локальна розробка

У корені репозиторію виконайте:

```sh
npm install
npm run build
npm start
npm test
```

Після складання `npm start` виводить `Hello World`. `npm test` запускає тест
`BasicAddition` через Vitest.

## Локальний CI

На Linux або macOS виконайте `bash ./ci.sh`; на Windows — `.\ci.bat`.
Скрипти встановлюють залежності, збирають TypeScript, перевіряють наявність
`dist/hello.js` і запускають тести.
