# Настройки окружения для Дмитрия

> Используется сетап:  VS Code + CMake + Docker
в `dev` лежат все необходимые файлы для настройки окружения; необходимо их скопировать в корень проекта c помощью `get_dev_env_files.sh`

## Полезные команды

```bash
# Доступ по SSH без пароля с помощью ключа

# Генерация ключа на клиенте
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "user@orangepi"

# Копирование ключа на сервер
ssh-copy-id user@orangepi

# Отключение запроса Passphrase (SSH Agent)
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# В ~/.ssh/config
Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_ed25519
```

## Экспорт расширений VS Code

```bash
code --list-extensions --profile 'name' > temp-list.txt
sed 's/^/    "/; s/$/"/' temp-list.txt | sed '1s/^/[\n/; $s/$/ ]/' > .vscode/extensions.json
```

## Remote Отладка

```bash
# [1] Запуск DAP-сервера на ОрangePi:
probe-rs dap-server --port 50000

# [2] SSH-туннель на клиенте:
ssh -L 50000:localhost:50000 orangepi@opi-server.local
```
