# Use a imagem oficial do CouchDB como base
FROM couchdb:latest

# Definir variáveis de ambiente para configuração inicial
ENV COUCHDB_USER=admin
ENV COUCHDB_PASSWORD=032211

# Expor as portas do CouchDB (HTTP e rede)
EXPOSE 5984 4369 9100-9200

# Criar diretório para dados persistentes
VOLUME ["/opt/couchdb/data"]

# Copiar arquivo de configuração personalizado (opcional)
# COPY local.ini /opt/couchdb/etc/local.d/

# Configurar permissões
RUN chown -R couchdb:couchdb /opt/couchdb

# Healthcheck para verificar se o serviço está funcionando
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5984/_up || exit 1

# Diretivas para melhor performance em produção
ENV COUCHDB_MAX_DBS_OPEN=1000
ENV COUCHDB_MAX_DOCUMENT_SIZE=4294967296
ENV COUCHDB_ATTACHMENT_STREAM_BUFFER_SIZE=4096

# Configurações de segurança recomendadas
ENV COUCHDB_REQUIRE_VALID_USER=true
ENV COUCHDB_ENABLE_CORS=true

# Configurações adicionais para otimização
ENV COUCHDB_COMPRESSION_LEVEL=8
ENV COUCHDB_MAINTENANCE_MODE=false

# Script de inicialização para configurar o cluster (opcional)
# COPY setup-cluster.sh /docker-entrypoint-initdb.d/

# Manter os logs dentro do container
ENV COUCHDB_LOG_LEVEL=info
VOLUME ["/opt/couchdb/log"]
