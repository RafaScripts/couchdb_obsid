#!/bin/bash

# Aguarda o CouchDB iniciar
sleep 15

# Configurações
HOST="http://localhost:5984"
COUCHDB_USER=${COUCHDB_USER:-admin}
COUCHDB_PASSWORD=${COUCHDB_PASSWORD:-032211}

# Função para criar banco de dados
create_database() {
    local database=$1
    curl -X PUT "${HOST}/${database}" \
        -u "${COUCHDB_USER}:${COUCHDB_PASSWORD}" \
        -H "Content-Type: application/json"
    echo "Criando banco de dados: ${database}"
}

# Cria os bancos de dados do sistema
create_database "_users"
create_database "_replicator"
create_database "_global_changes"

# Verifica se os bancos foram criados
curl -X GET "${HOST}/_all_dbs" \
    -u "${COUCHDB_USER}:${COUCHDB_PASSWORD}" \
    -H "Content-Type: application/json"

# Configura o banco _users com as permissões corretas
curl -X PUT "${HOST}/_users/_security" \
    -u "${COUCHDB_USER}:${COUCHDB_PASSWORD}" \
    -H "Content-Type: application/json" \
    -d '{"admins": {"names": [], "roles": ["_admin"]}, "members": {"names": [], "roles": ["_admin"]}}'

echo "Inicialização concluída!"
