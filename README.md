## Run local

```bash
docker build -t hermes-reachie .
docker run --rm -it --env-file .env -p 9119:9119 hermes-reachie
```