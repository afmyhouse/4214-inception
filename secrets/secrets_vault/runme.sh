openssl enc -aes-256-cbc -salt -pbkdf2 -in ./secrets.txt -out ../secrets.enc -pass pass:$(cat ./decryptkey.txt)
