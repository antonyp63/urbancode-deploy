#!/bin/sh

BIN_DOWNLOAD_DIR="/tmp/urbancode-deploy"

mkdir -p ${BIN_DOWNLOAD_DIR}
chmod u+x ./*.sh

wget -P ${BIN_DOWNLOAD_DIR} ${INSTALLER_BASEURL}/${SERVER_INSTALLER_FILENAME}


# note that /tmp represents the working directory and could be parameterized
yum -y install java
unzip -q ${INSTALLER_FILENAME} -d /tmp
echo -e "\nnonInteractive=true" >> ${BIN_DOWNLOAD_DIR}/install.properties
echo -e "\ninstall.server.dir=/opt/ibm-ucd/server" >> ${BIN_DOWNLOAD_DIR}/install.properties
echo "install.java.home=/usr" >> ${BIN_DOWNLOAD_DIR}/install.properties
echo "server.initial.password=admin" >> ${BIN_DOWNLOAD_DIR}/install.properties
printf "install.server.web.host=" >> ${BIN_DOWNLOAD_DIR}/install.properties

hostname -f >> ${BIN_DOWNLOAD_DIR}/install.properties
echo " " > answerFile.txt
echo /usr >> answerFile.txt
${BIN_DOWNLOAD_DIR}/install-server.sh < answerFile.txt > ${BIN_DOWNLOAD_DIR}/ibm-ucd-server-install.log

unzip -q /opt/ibm-ucd/server/opt/tomcat/webapps/ROOT/tools/ibm-ucd-agent.zip -d /tmp
/tmp/ibm-ucd-agent-install/install-agent-from-file.sh /tmp/ibm-ucd-agent-install/install.properties > /tmp/ibm-ucd-agent-install.log


rc=$?
if [[ ${rc} -ne 0 ]] ; then
   echo "Failed to install IBM UrbanCode Deploy."
   exit ${rc}

fi
