# folio-referencedata
A (temporary) place to store and manage local FOLIO Inventory reference value files.

1. 
For K10plus, invoke `local_k10plus/insert_local_k10plus` to update the values of a tenant by calling
```
cd local_k10plus
./insert_local_k10plus <okapi_url> <tenant> <username> <password>
```
For example
```
./insert_local_k10plus https://folio-demo.gbv.de/okapi diku diku_admin admin
```
2.
For K10plus, invoke `delete_folio_reference_data` to delete the values in toBeDeleted.tsv
```
cd local_k10plus
./delete_folio_reference_data <okapi_url> <tenant> <username> <password>
```
For example
```
./delete_folio_reference_data https://folio-demo.gbv.de/okapi diku diku_admin admin
```
