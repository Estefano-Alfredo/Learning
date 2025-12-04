Compilação: gcc Blockchain_Simplificada.c mtwister.a -o Blockchain -lcrypto

Representação visual de um bloco:

    Bloco  Minerado
| num: xx | nonce: xx |
| data: xxxxxxxxxxxxx | data[184]
| xxxxxxxxxxxxxxxxxxx | hash[SHA256_DIGEST_LENGTH]
| xxxxxxxxxxxxxxxxxxx |
| xxxxxxxxxxxxxxxxxxx |
| xxxxxxxxxxxxxxxxxxM |
| peviousHash: 00xfa0 |
| hash: xx | prox: xx |

Blockchain
next -> chainblock
previous -> chainblock

chainblock
next -> blockchain
previous -> blockchain