# folio-referencedata
A (temporary) place to store and manage local FOLIO Inventory reference value files.

For K10plus, invoke `local_k10plus/insert_local_k10plus` to update the values of a tenant by calling
```
cd local_k10plus
./insert_local_k10plus <okapi_url> <tenant> <username> <password>
```
For example
```
./insert_local_k10plus https://folio-demo.gbv.de/okapi diku diku_admin admin
```
