# Freqtrade Binance Bot — Railway Deploy

Автоматический трейдинг-бот на Binance (spot). Стратегия: EMA crossover + RSI.  
Деплой: Railway. Старт: dry_run (без реальных денег).

---

## Структура

```
freqtrade-bot/
├── Dockerfile                        # Railway Docker build
├── railway.toml                      # Railway deploy config
└── user_data/
    ├── config.json                   # Конфиг бота (секреты через env vars)
    └── strategies/
        └── EMA_RSI_Strategy.py       # Стратегия EMA+RSI
```

---

## Деплой на Railway

### 1. Создать GitHub репо

```bash
cd freqtrade-bot
git init
git add .
git commit -m "Initial freqtrade bot setup"
gh repo create freqtrade-binance-bot --public --push --source=.
```

### 2. Создать сервис на Railway

1. Зайти на [railway.app](https://railway.app)
2. Открыть проект `kod03`
3. **New Service → GitHub Repo** → выбрать `freqtrade-binance-bot`
4. Railway автоматически найдёт `Dockerfile` и `railway.toml`

### 3. Добавить Volume (обязательно для БД)

1. В сервисе freqtrade → вкладка **Volumes**
2. **New Volume** → Mount Path: `/freqtrade/user_data`
3. Это сохранит базу сделок и логи при перезапусках

### 4. Установить переменные окружения

В разделе **Variables** сервиса добавить:

| Переменная | Значение |
|-----------|----------|
| `FREQTRADE__TELEGRAM__TOKEN` | токен @Searchearth_bot |
| `FREQTRADE__TELEGRAM__CHAT_ID` | 8687929102 |
| `FREQTRADE__API_SERVER__PASSWORD` | придумай пароль |
| `FREQTRADE__API_SERVER__JWT_SECRET_KEY` | случайная строка 32+ символа |
| `FREQTRADE__EXCHANGE__KEY` | *(пусто пока dry_run)* |
| `FREQTRADE__EXCHANGE__SECRET` | *(пусто пока dry_run)* |

**Пока dry_run=true — ключи Binance не нужны!**

### 5. Деплой

Railway сам задеплоит при push в main ветку.

---

## Переключение на реальные деньги

Когда убедишься что бот нормально торгует в dry_run:

1. В `config.json` изменить `"dry_run": false`
2. Добавить реальные ключи Binance в переменные:
   - `FREQTRADE__EXCHANGE__KEY`
   - `FREQTRADE__EXCHANGE__SECRET`
3. Сделать `git commit && git push`

---

## Мониторинг

Бот шлёт сигналы в Telegram (@Searchearth_bot):
- 📈 Открытие сделки
- 📉 Закрытие сделки  
- 💰 P&L отчёты

REST API доступен по Railway URL на порту 8080:  
`https://<service>.up.railway.app/api/v1/ping`
