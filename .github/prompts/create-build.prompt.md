# Command: create-build

## 1. Призначення
Команда викликає skill `.github/skills/build-and-test/SKILL.md` і створює конфігурацію системи складання на базі `npm scripts` та `TypeScript`, функцію додавання чисел, модульний тест `BasicAddition` на фреймворку `Vitest`, а також скрипти збірки `ci.sh` та `ci.bat`.

## 2. Передумови
* Успішно виконано команду `create-project` (існують файли `package.json` та `src/hello.ts`).
* У репозиторії існує файл навички `.github/skills/build-and-test/SKILL.md`.
* У системі доступні `node` та `npm`.
* Дотримуються правила маніфесту `.github/agents/build-engineer.agent.md`.

## 3. Дії
1. Прочитати інструкції навички `.github/skills/build-and-test/SKILL.md`.
2. Оновити файл `package.json` без видалення наявних полів та без дублювання секцій:
   * переконатися, що у `scripts` прописані команди `"build": "tsc"`, `"start": "node dist/hello.js"`, `"test": "vitest run"`;
   * додати у `devDependencies` пакети `typescript` та `vitest` (якщо вони ще не додані).
3. Створити або оновити файл `tsconfig.json` у корені проєкту для компіляції файлів із `src/` у каталог `dist/` (target `ES2022`, module `commonjs`, outDir `./dist`, rootDir `./src`, strict `true`).
4. Оновити файл `src/hello.ts`:
   * додати та експортувати функцію `export function add(a: number, b: number): number { return a + b; }` (якщо вона ще не створена);
   * зберегти вивід `console.log("Hello World");`.
5. Створити або оновити файл модульного тесту `tests/hello.test.ts`:
   * імпортувати `{ describe, it, expect }` із `vitest` та функцію `{ add }` із `../src/hello`;
   * реалізувати тест із точною назвою `BasicAddition`, який перевіряє коректність додавання чисел (наприклад, `expect(add(2, 2)).toBe(4)`).
6. Створити у корені проєкту скрипти складання та тестування для CI:
   * `ci.sh` (для Linux і macOS) — послідовно виконує `npm install`, `npm run build`, перевіряє наявність `dist/hello.js` та запускає `npm test`;
   * `ci.bat` (для Windows) — послідовно виконує `call npm install`, `call npm run build`, перевіряє наявність `dist\hello.js` та запускає `call npm test` із перевіркою кодів повернення `errorlevel`.
7. Виконати у терміналі `npm install`, `npm run build` та `npm test` для підтвердження працездатності.

## 4. Очікувані файли
* `package.json` (та `package-lock.json` після встановлення пакетів) — конфігурація `npm scripts` і залежностей.
* `tsconfig.json` — конфігурація компілятора TypeScript.
* `src/hello.ts` — вихідний код із виводом `Hello World` та функцією `add`.
* `tests/hello.test.ts` — модульний тест `BasicAddition` для Vitest.
* `ci.sh` та `ci.bat` — скрипти автоматичної збірки і тестування.
* `dist/hello.js` — локально згенерований виконуваний файл (ігнорується Git через `.gitignore`).

## 5. Команди перевірки
* `npm run build` — компілює проєкт без помилок і створює файл `dist/hello.js`.
* `node dist/hello.js` — виводить у консоль `Hello World`.
* `npm test` — успішно виконує тест `BasicAddition` через Vitest.

## 6. Повідомлення про помилку
* Якщо відсутній файл навички `build-and-test`:
  `[ERROR create-build]: Не знайдено файл .github/skills/build-and-test/SKILL.md. Виконання зупинено.`
* Якщо збірка `npm run build` завершилася з помилкою або не створила `dist/hello.js`:
  `[ERROR create-build]: Помилка компіляції TypeScript. Виконуваний файл dist/hello.js не створено.`
* Якщо тест `BasicAddition` не проходить:
  `[ERROR create-build]: Модульний тест BasicAddition (Vitest) завершився з помилкою. Виконання зупинено.