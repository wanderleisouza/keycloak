#!/usr/bin/env bash

# Get Access token
# In the request we provide:
# 1. Тhe `admin-cli` client which is a public client created by default;
# 2. The username and password of the user we created during the initialization of the Keycloak server
# 3. Password as grant type
json=$(curl \
  -d "client_id=admin-cli" \
  -d "username=admin" \
  -d "password=admin" \
  -d "grant_type=password" \
  "http://localhost:9191/auth/realms/master/protocol/openid-connect/token") \
&& token=$(echo $json | sed "s/{.*\"access_token\":\"\([^\"]*\).*}/\1/g") \
&& echo "token = $token"

#Configure Keycloak
# In the request we provide:
# 1. `application/json` as Content type;
# 2. The Access token received as response from the previous request
# 3. The name of the file in which the JSON configuration is stored
curl  -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: bearer $token" \
  --data "@realm-configuration.json" \
  "http://localhost:9191/auth/admin/realms"
