#!/bin/bash
set -e

PROJECT_DIR="fastapi_project"
echo "🚀 Начинаем настройку FastAPI проекта..."

if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo "❌ Ошибка: Python не установлен."
    exit 1
fi

if [ -d "$PROJECT_DIR" ]; then
    echo "⚠️ Директория '$PROJECT_DIR' уже существует."
    read -p "Хотите очистить её и продолжить? (y/n): " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        rm -rf "$PROJECT_DIR"/*
        rm -rf "$PROJECT_DIR"/.* 2>/dev/null || true
    else
        echo "❌ Скрипт прерван."
        exit 0
    fi
else
    mkdir "$PROJECT_DIR"
fi

cd "$PROJECT_DIR"

echo "🐍 Создание виртуального окружения..."
python3 -m venv venv || python -m venv venv

echo "🔌 Активация виртуального окружения..."
source venv/bin/activate || source venv/Scripts/activate

echo "📝 Создание requirements.txt..."
cat << 'REQEOF' > requirements.txt
fastapi
uvicorn
pydantic
REQEOF

echo "📦 Установка зависимостей..."
pip install -r requirements.txt

echo "📂 Создание директорий static/ и logs/..."
mkdir -p static logs

echo "💻 Создание main.py..."
cat << 'PYEOF' > main.py
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, FastAPI! Скрипт отработал успешно."}
PYEOF

echo "✅ Настройка завершена! Запускаем сервер..."
uvicorn main:app --reload
