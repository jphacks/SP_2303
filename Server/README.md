# gohan_map-backend

### 環境

Python 3.10  
Poetry

### 開発環境の起動方法

- .env.sample を.env にコピーする
- firebaseAdminKey.json をルートに配置する(開発者に相談)

```bash
docker compose up -d
```

### 開発環境の起動方法 （devcontainer)

VSCode で開発をする場合、devcontainer から起動すると便利です  
FastAPI のサーバーは起動状態になり、ホットリロードされます。

### マイグレーション

DB が起動した状態で以下のコマンドを実行する

```bash
docker compose run --rm app poetry run alembic upgrade head
```

### 本番環境

- .env と firebaseAdminKey.json の設定

```bash
docker compose -f docker-compose.prod.yml build
docker compose -f docker-compose.prod.yml up -d
docker compose -f docker-compose.prod.yml run --rm app poetry run alembic upgrade head
```
