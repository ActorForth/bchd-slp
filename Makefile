


.PHONY: pki
pki:
	mkdir -p data/pki
	#CA key
ifeq (,$(wildcard ./data/pki/CA.key))
	openssl genrsa -out ./data/pki/CA.key 2048
endif
	#CA cert
ifeq (,$(wildcard ./data/pki/CA.crt))
	openssl req -x509 -new -nodes -subj "/C=PE/ST=Lima/L=Lima/O=Acme Inc. /OU=IT Department/CN=acme.com" -key ./data/pki/CA.key -sha256 -days 1825 -out ./data/pki/CA.crt
endif
	#Server key
ifeq (,$(wildcard ./data/pki/server.key))
	openssl genrsa -out ./data/pki/server.key 2048
endif
	#server cert
ifeq (,$(wildcard ./data/pki/server.crt))
	#csr
	openssl req -new -key data/pki/server.key  -subj "/C=PE/ST=Lima/L=Lima/O=Acme Inc. /OU=IT Department/CN=acme.com" -out ./data/pki/server.csr
	#cert itself
	openssl x509 -req -in ./data/pki/server.csr -CA ./data/pki/CA.crt -CAkey ./data/pki/CA.key -CAcreateserial -out ./data/pki/server.crt -days 825 -sha256 -extfile domains.ext
endif

.PHONY: build
build:
	docker-compose build

.PHONY: up
up: pki build
	docker-compose up -d
