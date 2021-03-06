#!/bin/bash -e 
#===============================================================================
#          FILE: package_kaltura_wrapper.sh
#         USAGE: ./package_kaltura_wrapper.sh 
#   DESCRIPTION: 
#       OPTIONS: ---
# 	LICENSE: AGPLv3+
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Jess Portnoy (), <jess.portnoy@kaltura.com>
#  ORGANIZATION: Kaltura, inc.
#       CREATED: 01/10/14 08:46:43 EST
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
SOURCES_RC=`dirname $0`/sources.rc
if [ ! -r $SOURCES_RC ];then
	echo "Could not find $SOURCES_RC"
	exit 1
fi
. $SOURCES_RC 
if [ ! -x "`which svn 2>/dev/null`" ];then
	echo "Need to install svn."
	exit 2
fi

mkdir -p $RPM_SOURCES_DIR/$KDP3WRAPPER_RPM_NAME
#for KDP3WRAPPER_VERSION in $KDP3WRAPPER_VERSIONS;do
kaltura_svn export --force --quiet $KDP3WRAPPER_URI/$KDP3WRAPPER_VERSION $SOURCE_PACKAGING_DIR/$KDP3WRAPPER_RPM_NAME/$KDP3WRAPPER_VERSION
#done

cd $SOURCE_PACKAGING_DIR
# flash things DO NOT need exec perms.
find $KDP3WRAPPER_RPM_NAME -type f -exec chmod -x {} \;
tar jcf $RPM_SOURCES_DIR/$KDP3WRAPPER_RPM_NAME-$KDP3WRAPPER_VERSION.tar.bz2 $KDP3WRAPPER_RPM_NAME
echo "Packaged into $RPM_SOURCES_DIR/$KDP3WRAPPER_RPM_NAME-$KDP3WRAPPER_VERSION.tar.bz2"

if [ -x "`which rpmbuild 2>/dev/null`" ];then
	rpmbuild -ba $RPM_SPECS_DIR/$KDP3WRAPPER_RPM_NAME.spec
fi
