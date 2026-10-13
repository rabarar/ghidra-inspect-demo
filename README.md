# Ghidra MCP + MCP Inspector demo

## Setup

```bash
rm -rf ./ghidra-mcp

git clone --branch dev \
  https://github.com/bethington/ghidra-mcp.git

mkdir -p binaries

printf 'GHIDRA_MCP_AUTH_TOKEN=%s\n' \
  "$(openssl rand -hex 32)" > .env
  
printf 'GHIDRA_MCP_INBOUND_TOKEN=%s\n' \
  "$(openssl rand -hex 32)" >> .env
  
chmod 600 .env

(source .env; docker compose up -d --build)
```

Place a local binary in `binaries/`. Ghidra sees it at `/binaries/<filename>`.

## Browser

Open http://localhost:6274 and obtain the Inspector's access-token URL from:

```bash
docker compose logs inspector
```

Choose **Streamable HTTP** and enter `http://ghidra-mcp:8081/mcp` if the Inspector uses its server-side proxy, or `http://localhost:8081/mcp` if connecting directly from the browser. Supply the bearer token from `.env` if the bridge requests authentication. Click Connect, then List Tools.

## Import binary (headless API)

```bash
set -a; source .env; set +a
curl -f -X POST \
  -H "Authorization: Bearer $GHIDRA_MCP_AUTH_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{"file_path":"/binaries/target"}' \
  http://localhost:8089/import_file
```

Alternatively use the matching import tool in Inspector if exposed by your checked-out version.

## Status

```bash
curl -fsS http://localhost:8089/check_connection
docker compose ps
docker compose logs -f bridge
```

## Stop

```bash
docker compose down
```

Do not use `down -v` unless you want to delete Ghidra projects and Inspector state.

## Security

Ports bind to host loopback only. Do not expose Inspector to the LAN or Internet. The Inspector can execute tools and may spawn processes. Use trusted demonstration binaries, preferably in an isolated VM.
