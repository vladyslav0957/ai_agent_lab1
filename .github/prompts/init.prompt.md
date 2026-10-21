# Command (Orchestrator): init

## 1. Призначення
Оркестратор-команда `init` координує повний життєвий цикл автоматизованого створення проєкту: перевіряє передумови та послідовно викликає команди `git-init`, `create-project`, `create-build`, `create-actions` і `check` у визначеному порядку із зупинкою при першій помилці (Fail-Fast).

## 2. Передумови
* У репозиторії присутній маніфест агента `.github/agents/build-engineer.agent.md`.
* У каталозі `.github/skills/` присутні навички `project-scaffold`, `build-and-test`, `github-actions`.
* У каталозі `.github/prompts/` присутні всі 5 підпорядкованих команд: `git-init.prompt.md`, `create-project.prompt.md`, `create-build.prompt.md`, `create-actions.prompt.md`, `check.prompt.md`.
* У середовищі встановлені та доступні `git`, `node` та `npm`.

## 3. Дії (Алгоритм оркестрації)
Оркестратор виконує кроки строго послідовно. Наступний крок запускається лише за умови успішного завершення попереднього. Повторний запуск `init` оновлює або перевіряє наявні файли без їх руйнування чи дублювання конфігурацій:

1. **Крок 1 — Ініціалізація Git (`git-init`):**
   * Виконати інструкції з `.github/prompts/git-init.prompt.md`.
   * Перевірити наявність `.gitignore` з правилами `node_modules/`, `dist/`, `build/` та справність `git status`. Якщо виникла помилка — зупинити оркестратор.
2. **Крок 2 — Створення каркаса проєкту (`create-project`):**
   * Виконати інструкції з `.github/prompts/create-project.prompt.md` (викликає skill `project-scaffold` для мови `TypeScript` і проєкту `ai-agent-lab1`).
   * Перевірити наявність `package.json`, `README.md` та вихідного файлу `src/hello.ts`. Якщо виникла помилка — зупинити оркестратор.
3. **Крок 3 — Налаштування складання і тестування (`create-build`):**
   * Виконати інструкції з `.github/prompts/create-build.prompt.md` (викликає skill `build-and-test`).
   * Переконатися, що створено `tsconfig.json`, функцію `add` у `src/hello.ts`, модульний тест `BasicAddition` у `tests/hello.test.ts`, скрипти `ci.sh` та `ci.bat`.
   * Виконати `npm install`, `npm run build` та `npm test`. Якщо компіляція або тест Vitest завершилися з помилкою — негайно зупинити оркестратор.
4. **Крок 4 — Створення GitHub Actions (`create-actions`):**
   * Виконати інструкції з `.github/prompts/create-actions.prompt.md` (викликає skill `github-actions`).
   * Переконатися, що створено `.github/workflows/ci.yml` із матрицею для `ubuntu-latest`, `windows-latest`, `macos-latest` та викликом `ci.sh` і `ci.bat`. Якщо виникла помилка — зупинити оркестратор.
5. **Крок 5 — Фінальна валідація (`check`):**
   * Виконати інструкції з `.github/prompts/check.prompt.md`.
   * Підтвердити успішне проходження всіх перевірок та вивести підсумковий звіт про завершення роботи оркестратора.

## 4. Очікувані файли (після повного циклу)
* `.gitignore`, `README.md`, `package.json`, `tsconfig.json`, `ci.sh`, `ci.bat`
* `src/hello.ts` (вихідний код програми Hello World та функції `add`)
* `dist/hello.js` (скомпільований виконуваний файл, ігнорований у Git)
* `tests/hello.test.ts` (модульний тест `BasicAddition` на Vitest)
* `.github/workflows/ci.yml` (конфігурація CI для трьох ОС)

## 5. Команди перевірки
* `npm run build` — код повернення `0`, існує файл `dist/hello.js`.
* `node dist/hello.js` — виводить `Hello World`.
* `npm test` — тест `BasicAddition` у Vitest проходить успішно.
* `git status` — каталоги `dist/`, `build/` та `node_modules/` не відстежуються Git.

## 6. Повідомлення про помилку
* При збої на будь-якому з етапів оркестратор негайно припиняє роботу і виводить:
  `[ORCHESTRATOR ABORTED at <назва_кроку>]: Виконання сценарію init зупинено через помилку на етапі <назва_кроку>. Причина: <деталі_помилки>. Наступні кроки скасовано до усунення проблеми.`