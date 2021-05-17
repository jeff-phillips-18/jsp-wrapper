#!/bin/bash

set -x

JSP_UI_SRC_PATH=/opt/app-root/src/jupyterhub-singleuser-profiles/jupyterhub_singleuser_profiles/ui/

cd ${JSP_UI_SRC_PATH}

npm install
npm run build

cd /opt/app-root/share/jupyterhub/static/

# clean out previous run
rm -rf jsp-ui

mkdir jsp-ui
cp -a ${JSP_UI_SRC_PATH}/build/. /opt/app-root/share/jupyterhub/static/jsp-ui

fix-permissions /opt/app-root
