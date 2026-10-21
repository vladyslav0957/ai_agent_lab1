# Command: create-actions

## 1. Призначення
Команда викликає skill `.github/skills/github-actions/SKILL.md` і створює CI workflow у файлі `.github/workflows/ci.yml` для автоматичного складання та тестування проєкту на платформах Windows, Linux і macOS.

## 2. Передумови
* Успішно виконано команду `create-build` (у корені репозиторію існують скрипти `ci.sh` та `ci.bat`).
* У репозиторії існує файл навички `.github/skills/github-actions/SKILL.md`.
* Дотримуються правила маніфесту `.github/agents/build-engineer.agent.md`.

## 3. Дії
1. Прочитати інструкції навички `.github/skills/github-actions/SKILL.md`.
2. Перевірити наявність скриптів `ci.sh` та `ci.bat` у корені проєкту.
3. Перевірити наявність каталогу `.github/workflows/` і створити його за потреби.
4. Створити або оновити файл `.github/workflows/ci.yml` (без дублювання секцій при повторному запуску) із такими параметрами:
   * назва workflow: `CI`;
   * тригери запуску (`on`): `push` та `pull_request` для гілок `develop` і `master`;
   * одна задача (`job`), яка використовує матрицю операційних систем (`strategy.matrix.os`): `ubuntu-latest`, `windows-latest`, `macos-latest`;
   * крок отримання вихідного коду через `actions/checkout@v4`;
   * крок конфігурації середовища Node.js (версія `20`) через `actions/setup-node@v4`;
   * крок запуску скрипту збірки для Linux і macOS (`if: runner.os != 'Windows'`): виконання виключно `bash ./ci.sh`;
   * крок запуску скрипту збірки для Windows (`if: runner.os == 'Windows'`): виконання виключно `.\ci.bat`;
   * крок збереження згенерованого виконуваного файлу `dist/hello.js` як артефакту збірки через `actions/upload-artifact@v4`.
5. Перевірити, що у файлі `.github/workflows/ci.yml` немає жодних секретів, паролів або токенів.

## 4. Очікувані файли
* `.github/workflows/ci.yml` — конфігураційний файл GitHub Actions для трьох операційних систем.

## 5. Команди перевірки
* Перевірка фізичної наявності файлу `.github/workflows/ci.yml`.
* Перевірка вмісту `.github/workflows/ci.yml` на наявність матриці `ubuntu-latest`, `windows-latest`, `macos-latest`, тригерів `develop` і `master` та викликів `ci.sh` і `ci.bat`.

## 6. Повідомлення про помилку
* Якщо відсутні скрипти `ci.sh` або `ci.bat`:
  `[ERROR create-actions]: Не знайдено скрипти збірки ci.sh або ci.bat. Спочатку виконайте команду create-build.`
* Якщо не вдалося створити або валідувати файл `.github/workflows/ci.yml`:
  `[ERROR create-actions]: Помилка створення або некоректна структура файлу .github/workflows/ci.yml.