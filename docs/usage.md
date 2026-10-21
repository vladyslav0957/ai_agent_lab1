# Інструкція з використання AI-агента та запуску проєкту

## 1. Запуск AI-агента у VS Code (GitHub Copilot Chat)

### Повний автоматичний сценарій (Оркестратор `init`)
Для автоматичного виконання всіх етапів з нуля у робочій гілці `feature/ai-project`:
1. Відкрийте бічну панель **GitHub Copilot Chat** у VS Code (`Ctrl + Alt + I`).
2. У нижній частині панелі чату перемкніть режим роботи у стан **`Agent`**.
3. Введіть такий запит і натисніть **Enter**:

> Прочитай маніфест .github/agents/build-engineer.agent.md та запусти оркестратор за інструкцією з файлу .github/prompts/init.prompt.md. Послідовно виконай усі 5 етапів (git-init, create-project, create-build, create-actions, check), створи всі необхідні файли у репозиторії та запусти локальну перевірку.

### Покроковий запуск окремих команд (за потреби)
Кожну операцію агента також можна запускати окремо, вказавши у чаті Copilot відповідний prompt-файл із каталогу `.github/prompts/`:
* `.github/prompts/git-init.prompt.md` — перевірка Git-репозиторію та оновлення `.gitignore`.
* `.github/prompts/create-project.prompt.md` — виклик skill `project-scaffold` та створення початкового проєкту (`package.json`, `src/hello.ts`).
* `.github/prompts/create-build.prompt.md` — виклик skill `build-and-test`, налаштування `tsconfig.json`, функції `add`, юніт-тесту `BasicAddition` (Vitest) та скриптів `ci.sh` і `ci.bat`.
* `.github/prompts/create-actions.prompt.md` — виклик skill `github-actions` та генерація `.github/workflows/ci.yml`.
* `.github/prompts/check.prompt.md` — перевірка структури проєкту, компіляції, тестів та YAML workflow без внесення змін у файли.

## 2. Локальний запуск і перевірка збілдженого проєкту

Для ручної перевірки згенерованого проєкту у терміналі VS Code виконуються такі команди:
1. **Встановлення залежностей:**
   > `npm install`
2. **Складання (компіляція TypeScript у каталог `dist/`):**
   > `npm run build`
3. **Запуск скомпільованого виконуваного файлу:**
   > `node dist/hello.js`
   *(або `npm start` — виводить у консоль рядок `Hello World`)*
4. **Запуск модульних тестів (Vitest, тест `BasicAddition`):**
   > `npm test`
5. **Запуск повного локального CI-скрипту:**
   * Для Windows (PowerShell / CMD): `.\ci.bat`
   * Для Linux / macOS (Bash): `bash ./ci.sh`