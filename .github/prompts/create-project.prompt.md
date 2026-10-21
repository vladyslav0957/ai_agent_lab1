# Command: create-project

## 1. Призначення
Команда викликає skill `.github/skills/project-scaffold/SKILL.md` і створює початкову структуру кросплатформного проєкту Hello World мовою TypeScript.

## 2. Передумови
* Виконано команду `git-init` (існує Git-репозиторій та базовий файл `.gitignore`).
* Файл навички `.github/skills/project-scaffold/SKILL.md` існує у репозиторії.
* Дотримуються правила маніфесту `.github/agents/build-engineer.agent.md`.

## 3. Дії
1. Прочитати інструкції навички `.github/skills/project-scaffold/SKILL.md` і передати вхідні параметри:
   * `language`: `TypeScript`
   * `project_name`: `ai-agent-lab1`
2. Перевірити наявність каталогів `src/`, `tests/`, `docs/` та створити ті з них, які ще не існують.
3. Перевірити наявність файлу `package.json`:
   * Якщо файл відсутній — створити його з назвою `ai-agent-lab1`, версією `1.0.0` та базовим скриптом запуску `"start": "node dist/hello.js"`.
   * Якщо файл уже існує — перевірити наявність поля `scripts.start` і додати його без видалення чи дублювання наявних налаштувань.
4. Перевірити наявність файлу `src/hello.ts`:
   * Якщо файл відсутній — створити його з виводом рядка `Hello World` у консоль (`console.log("Hello World");`).
   * Якщо файл уже існує — переконатися, що він містить вивід `Hello World`, не руйнуючи інший код у файлі.
5. Перевірити наявність файлів `README.md` та `.gitignore` (зберегти наявний вміст без перезапису).

## 4. Очікувані файли
* `src/hello.ts` — початковий вихідний файл програми Hello World.
* `package.json` — конфігурація проєкту з командою запуску `start`.
* `README.md` — опис проєкту в корені репозиторію.
* `.gitignore` — файл правил ігнорування Git.
* Каталоги `src/`, `tests/`, `docs/`.

## 5. Команди перевірки
* Перевірка існування вихідного файлу `src/hello.ts` та наявності в ньому виводу `Hello World`.
* Перевірка валідності `package.json` та наявності скрипту `start` (`node -e "const p = require('./package.json'); if (!p.scripts || !p.scripts.start) process.exit(1);"`).

## 6. Повідомлення про помилку
* Якщо відсутній файл навички `project-scaffold`:
  `[ERROR create-project]: Не знайдено файл .github/skills/project-scaffold/SKILL.md. Виконання зупинено.`
* Якщо не створено вихідний файл або команду запуску:
  `[ERROR create-project]: Помилка генерації каркаса проєкту — відсутній файл src/hello.ts або скрипт start у package.json.`