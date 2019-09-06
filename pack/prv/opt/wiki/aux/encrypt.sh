tar czf wiki.tar.gz wiki/
gpg -e -r renato.fabbri@gmail.com wiki.tar.gz

# recover with
# gpg -d -o mwiki wiki.tar.gz
# tar xzf mwiki

