## Authenticated emails

To prevent emails this app sends from ending up in the recipient's spam folder, we have implemented DKIM signing. To send authenticated emails, each server must:

  1. Have a DNS TXT entry containing the public key.
  1. Have a file in the root directory of the app called `howes_grocery.priv` containing the matching private key.

The steps we took to do this were:

### Generating the keypair

It appears that `ssh-keygen` created keys that were invalid for DKIM purposes.  We instead used `openssl`.

1. Private key was generated with:

  ```
  openssl genrsa -des3 -out howes_grocery.priv 2048
  ```

1. Public key was generated with:

  ```
  openssl rsa -in howes_grocery.priv -outform PEM -pubout -out howes_grocery.pub
  ```

1. The passphrase on the private key was removed using the following commands. Otherwise, the passphrase would have needed to be provided when the webserver is started.

  ```
  cp howes_grocery.priv howes_grocery.priv.orig
  openssl rsa -in howes_grocery.priv.orig -out howes_grocery.priv
  rm howes_grocery.priv.orig
  ```

### Creating the DNS TXT entry

The format we used that seems to work looks like this:

     ```
     "v=DKIM1; k=rsa; p=MIIBIjANB..."
     ```

To handle the string-length restrictions, the entry was broken up into multiple shorter double-quoted strings separated by a space (*not* a newline as suggested by Amazon).

The selector and domain used for the DNS TXT entry were the same as those set up in `config/initializers/dkim.rb`.
