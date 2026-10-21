# Command: check

## 1. Призначення
Команда виконує повну перевірку проєкту в режимі тільки для читання (не змінює та не видаляє файли проєкту): перевіряє наявність маніфесту агента, skills, commands, структуру проєкту, конфігурацію складання, створення виконуваного файлу, проходження юніт-тестів Vitest, коректність YAML workflow та відсутність build-каталогів і секретів у Git.

## 2. Передумови
* Виконано попередні етапи створення агента та проєкту (`git-init`, `create-project`, `create-build`, `create-actions`).
* У системі встановлені `git`, `node` та `npm`.
* Команда працює строго без модифікації вихідного коду чи конфігурацій.

## 3. Дії
1. **Перевірка структури агента:**
   * переконатися, що існує `.github/agents/build-engineer.agent.md` і він містить роль, обмеження та критерії завершення;
   * переконатися, що існують усі три skills (`project-scaffold`, `build-and-test`, `github-actions`) із визначеними входами, виходами та перевірками;
   * переконатися, що існують усі файли команд у `.github/prompts/`.
2. **Перевірка структури та конфігурації проєкту:**
   * перевірити наявність `README.md`, `docs/architecture.md`, `docs/usage.md`, `.gitignore`, `package.json`, `tsconfig.json`, `src/hello.ts`, `tests/hello.test.ts`, `ci.sh` та `ci.bat`.
3. **Перевірка складання та виконуваного файлу:**
   * запустити `npm run build` і переконатися, що компіляція завершується з кодом `0`;
   * перевірити наявність згенерованого файлу `dist/hello.js` та виконати `node dist/hello.js` (очікується вивід `Hello World`).
4. **Перевірка тестування:**
   * запустити `npm test` і переконатися, що фреймворк Vitest успішно виконує тест `BasicAddition`.
5. **Перевірка YAML workflow:**
   * перевірити, що `.github/workflows/ci.yml` існує, містить матрицю для `ubuntu-latest`, `windows-latest`, `macos-latest` і викликає скрипти `ci.sh` та `ci.bat`.
6. **Перевірка безпеки та чистоти Git:**
   * виконати `git status --porcelain` та переконатися, що каталоги `node_modules/`, `dist/`, `build/` ігноруються і не потрапляють під Git-контроль, а у файлах немає секретів чи токенів.
7. Вивести підсумковий табличний звіт із результатами кожного пункту перевірки (`PASS` або `FAIL`).

## 4. Очікувані файли (які повинні існувати на момент перевірки)
* `.github/agents/build-engineer.agent.md`
* `.github/skills/project-scaffold/SKILL.md`, `.github/skills/build-and-test/SKILL.md`, `.github/skills/github-actions/SKILL.md`
* `.github/prompts/git-init.prompt.md`, `create-project.prompt.md`, `create-build.prompt.md`, `create-actions.prompt.md`, `check.prompt.md`, `init.prompt.md`
* `.github/workflows/ci.yml`
* `package.json`, `tsconfig.json`, `ci.sh`, `ci.bat`, `.gitignore`, `README.md`
* `src/hello.ts`, `tests/hello.test.ts`, `dist/hello.js`

## 5. Команди перевірки
* `npm run build` — перевірка компіляції проєкту.
* `node dist/hello.js` — перевірка роботи виконуваного файлу (`Hello World`).
* `npm test` — перевірка проходження модульного тесту `BasicAddition`.
* `git status` — перевірка відсутності `dist/`, `build/` та `node_modules/` у списку неігнорованих файлів.

## 6. Повідомлення про помилку
* Якщо відсутній будь-який обов'язковий файл:
  `[ERROR check]: Перевірка не пройдена — відсутній обов'язковий файл: <шлях_до_файлу>.`
* Якщо не проходить складання або тест `BasicAddition`:
  `[ERROR check]: Перевірка не пройдена — помилка під час виконання npm run build або npm test (BasicAddition).`
* Якщо у Git відстежуються каталоги збірки або знайдено секрети:
  `[ERROR check]: Перевірка безпеки не пройдена — каталоги складання (dist/ або build/) не додані до .gitignore або виявлено секрети.`