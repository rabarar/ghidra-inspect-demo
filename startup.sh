

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
