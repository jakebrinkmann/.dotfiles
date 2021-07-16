
VERSION=5.0
cd /tmp
curl -L "https://github.com/darold/pgFormatter/archive/refs/tags/v$VERSION.tar.gz" -o "pgFormatter-$VERSION.tar.gz"
tar xzf "pgFormatter-$VERSION.tar.gz"
# cp "pgFormatter-$VERSION/pg_format" ~/.local/bin/
cd "pgFormatter-$VERSION"
perl Makefile.PL
make && sudo make install
cd ..
rm -rf "pgFormatter-$VERSION" "pgFormatter-$VERSION.tar.gz"

echo "pgFormatter Version: $(pg_format --version)"
