# Архітектура AI-агента (`build-engineer`)

## 1. Проблеми, які вирішує агент
Агент автоматизує рутинні етапи ініціалізації кросплатформного програмного проєкту мовою **TypeScript** (Варіант 6):
- створення стандартної структури каталогів (`src/`, `tests/`, `docs/`) та конфігурації `.gitignore`;
- налаштування системи складання (`npm scripts`, `tsconfig.json`, `package.json`) і фреймворку модульного тестування **Vitest**;
- створення конфігурації безперервної інтеграції (CI) у GitHub Actions для трьох операційних систем (Windows, Linux, macOS) через скрипти збірки (`ci.sh` та `ci.bat`);
- автоматична перевірка цілісності проєкту, проходження тестів та відсутності зайвих артефактів у Git.

## 2. Навички агента (Skills)
Агент використовує три спеціалізовані навички, розташовані у каталозі `.github/skills/`:
1. **`project-scaffold`** (`.github/skills/project-scaffold/SKILL.md`) — відповідає за створення базової структури проєкту TypeScript, початкового файлу `src/hello.ts` (вивід `Hello World`), `package.json`, `README.md` та `.gitignore`.
2. **`build-and-test`** (`.github/skills/build-and-test/SKILL.md`) — відповідає за створення `tsconfig.json`, додавання функції додавання чисел, налаштування компіляції TypeScript (`npm run build`), створення модульного тесту `BasicAddition` у `tests/hello.test.ts` за допомогою **Vitest** та скриптів локальної збірки (`ci.sh`, `ci.bat`).
3. **`github-actions`** (`.github/skills/github-actions/SKILL.md`) — відповідає за створення workflow-файлу `.github/workflows/ci.yml` із матрицею ОС (`ubuntu-latest`, `windows-latest`, `macos-latest`), який викликає відповідні скрипти збірки (`ci.sh` або `ci.bat`).

## 3. Команди, доступні користувачу (Commands / Prompts)
Команди реалізовані у форматі prompt-файлів GitHub Copilot у каталозі `.github/prompts/`:
- **`git-init`** (`git-init.prompt.md`) — перевіряє стан Git-репозиторію, створює або оновлює `.gitignore` (виключає `node_modules/`, `dist/`, `build/`).
- **`create-project`** (`create-project.prompt.md`) — викликає skill `project-scaffold` для генерації початкового TypeScript-проєкту.
- **`create-build`** (`create-build.prompt.md`) — викликає skill `build-and-test` для налаштування компіляції (`tsconfig.json`), скриптів `ci.sh`/`ci.bat` та юніт-тестів Vitest.
- **`create-actions`** (`create-actions.prompt.md`) — викликає skill `github-actions` для генерації `.github/workflows/ci.yml`.
- **`check`** (`check.prompt.md`) — виконує комплексну валідацію проєкту (перевірка наявності файлів, компіляції, проходження тестів `BasicAddition`, коректності YAML та чистоти `git status`) без внесення змін у код.
- **`init`** (`init.prompt.md`) — команда-оркестратор, яка послідовно запускає всі етапи від ініціалізації до фінальної перевірки.

## 4. Передача даних між етапами
Кожен етап передає наступному стан файлової системи проєкту:

> `[git-init]` ──(.gitignore)──► `[create-project]` ──(package.json, src/hello.ts)──► `[create-build]` ──(tsconfig.json, tests/, ci.sh, ci.bat, dist/)──► `[create-actions]` ──(.github/workflows/ci.yml)──► `[check]`

1. `git-init` готує безпечне Git-середовище та правила ігнорування файлів.
2. `create-project` створює конфігурацію пакета (`package.json`) і вихідний код `src/hello.ts`, які є вхідними даними для етапу складання.
3. `create-build` додає функцію `add` у `src/hello.ts`, тест у `tests/hello.test.ts`, налаштовує компіляцію через `tsconfig.json` і створює скрипти `ci.sh` та `ci.bat`.
4. `create-actions` використовує наявні скрипти `ci.sh` і `ci.bat`, прописуючи їх виклик у `.github/workflows/ci.yml`.
5. `check` перевіряє результати всіх попередніх кроків.

## 5. Обробка помилок оркестратором (`init`)
Оркестратор працює за принципом **Fail-Fast** (зупинка при першій помилці):
- Перед запуском кожного наступного кроку перевіряються умови успішності попереднього.
- Якщо будь-яка команда (`git-init`, `create-project`, `create-build`, `create-actions` або `check`) завершується з помилкою (наприклад, відсутній очікуваний файл, помилка компіляції TypeScript або падіння тесту Vitest), оркестратор негайно зупиняє виконання.
- Оркестратор не приховує помилки і виводить детальний звіт: на якому етапі стався збій, текст помилки та рекомендацію щодо виправлення.