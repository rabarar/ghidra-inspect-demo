curl -i -X POST http://localhost:8089/import_file \
  -H "Authorization: Bearer $GHIDRA_MCP_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"file_path":"/binaries/Serial"}'  
