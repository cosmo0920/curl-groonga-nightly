# specify Groonga version
export GROONGAVER="8.0.6"
# get Date
# e.g. # => 2014.07.01
export DATE="`date +\"%Y.%m.%d\"`"
export keep_n_days=30
#xarg option
XARGS_NO_RUN=''
if [ `uname` = 'Linux' ]; then
    XARGS_NO_RUN='--no-run-if-empty';
fi
# remove older than 30 days nightly package
find ./*.tar.gz -maxdepth 1 -type f -ctime +${keep_n_days} | \
  xargs $XARGS_NO_RUN rm
# curl
curl --fail -O "${GROONGA_NIGHTLY_PACKAGE_BASE:-"http://packages.groonga.org/nightly"}/groonga-${GROONGAVER}.${DATE}.tar.gz"

# building Groonga
find ./ -maxdepth 1 -type f -ctime +${keep_n_days} | \
  xargs $XARGS_NO_RUN rm -rf groonga-*

tar xzvf groonga-${GROONGAVER}.${DATE}.tar.gz

cd groonga-${GROONGAVER}.${DATE}
OPENSSL_OPT=`brew --prefix openssl`
OPENSSL_BASE=${OPENSSL_OPT:-"/usr/local/opt/openssl"}
./configure --with-zlib --disable-zeromq --enable-mruby --without-libstemmer PKG_CONFIG_PATH=${OPENSSL_BASE}/lib/pkgconfig:$PKG_CONFIG_PATH
make -j `/usr/sbin/sysctl -n hw.ncpu`
