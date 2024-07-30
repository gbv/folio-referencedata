#!/bin/sh

# insert_local_k10plus <OKAPI> <TENANT> <OKAPIUSERNAME> <OKAPIPASSWORD>
# Or set environment variables $OKAPI $TENANT $OKAPIUSERNAME $OKAPIPASSWORD and
# call insert_local_k10plus without arguments.

set -e

: ${OKAPI:=$1}
: ${OKAPI:=http://localhost:8081}
: ${TENANT:=$2}
: ${TENANT:=diku}
: ${OKAPIUSERNAME:=$3}
: ${OKAPIUSERNAME:=diku_admin}
: ${OKAPIPASSWORD:=$4}
: ${OKAPIPASSWORD:=admin}

COOKIES=$( mktemp --tmpdir cookies.XXXXXXXXXX )
LOGIN=$( jq -n -c --arg username "$OKAPIUSERNAME" --arg password "$OKAPIPASSWORD" '{"username": $username, "password": $password}' )
curl -w"\n\n" -sS -D - -j -c $COOKIES -H "X-Okapi-Tenant: $TENANT" -H "Content-type: application/json" -d "$LOGIN" $OKAPI/authn/login-with-expiry

find -type f -name "*.json" | while IFS= read -r file; do
  echo "$file"
  endpoint=$(basename "$(dirname "$file")")
  resource_id=$(jq -r '.id' "$file")
  if [ -z "$resource_id" ]; then
    curl -w"\n" -sS -b $COOKIES -H "X-Okapi-Tenant: $TENANT" -H "Content-Type: application/json" \
      -d "@$file" "$OKAPI/$endpoint"
  else
    response=$(curl -w"\n%{http_code}" -sS -b $COOKIES -X PUT -H "X-Okapi-Tenant: $TENANT" -H "$TOKEN" -H "Content-Type: application/json" \
      -d "@$file" "$OKAPI/$endpoint/$resource_id")
    status_code=$(echo "$response" | tail -n 1)
    if [ "$status_code" = "404" ]; then
      curl -w"\n" -sS -b $COOKIES -H "X-Okapi-Tenant: $TENANT" -H "Content-Type: application/json" \
        -d "@$file" "$OKAPI/$endpoint"
    fi
  fi
done

rm $COOKIES
