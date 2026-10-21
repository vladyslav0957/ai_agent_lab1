# Лабораторна робота №1: Проєктування AI-агента для автоматизації розробки та CI/CD

- **ПІБ:** Пільганський Владислав Ігорович
- **Група:** КІ-407
- **Варіант:** 6 (TypeScript, npm scripts, Vitest)

## Короткий опис проєкту
Цей репозиторій містить спеціалізованого AI-агента (`build-engineer`), його навички (`skills`) та команди (`commands`/`prompts`) для автоматичної генерації, складання, тестування та налаштування CI/CD кросплатформного застосунку **Hello World** мовою TypeScript з використанням `npm scripts` та фреймворку тестування `Vitest`.

## Спосіб запуску агента
1. Відкрийте проєкт у середовищі VS Code з активованим розширенням **GitHub Copilot Chat**.
2. Перейдіть у робочу гілку (`feature/ai-project`).
3. Відкрийте панель Copilot Chat (`Ctrl + Alt + I`), перемкніть режим у стан **`Agent`** та виконайте запит для запуску оркестратора `.github/prompts/init.prompt.md`:
   > Прочитай маніфест .github/agents/build-engineer.agent.md та запусти оркестратор за інструкцією з файлу .github/prompts/init.prompt.md. Послідовно виконай усі 5 етапів (git-init, create-project, create-build, create-actions, check), створи всі необхідні файли у репозиторії та запусти локальну перевірку.
4. Агент послідовно виконає команди `git-init`, `create-project`, `create-build`, `create-actions` та фінальну перевірку `check`.

## Локальний запуск згенерованого проєкту
- Встановлення залежностей: `npm install`
- Складання проєкту (створює `dist/hello.js`): `npm run build`
- Запуск скомпільованої програми (виводить `Hello World`): `npm start` (або `node dist/hello.js`)
- Запуск юніт-тестів (`BasicAddition` у Vitest): `npm test`
- Повний локальний запуск CI-скрипту: `.\ci.bat` (Windows) або `bash ./ci.sh` (Linux/macOS)