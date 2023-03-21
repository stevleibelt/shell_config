#!/bin/bash
# @see: https://lab.uberspace.de/guide_gitea/
####
# @author: stev leibelt <artodeto@bazzline.net>
# @since: 2022-05-16
####

function _do_the_update () 
{
	local BASE_PATH="${1}"
	local LAST_DOWNLOADED_VERSION=0
	local LATEST_GITEAVERSION="${2:-}"

	if [[ ! -d "${BASE_PATH}" ]];
        then
		echo ":: Usage"
		echo "   ${0} <string: gitea_path> [<string: latest_gitea_version>]"
		echo ""

		return 1
        fi

	local PATH_TO_GITEA="${BASE_PATH}/gitea"

	if [[ ! -f "${PATH_TO_GITEA}" ]];
	then
		echo ":: Error"
		echo "   >>${PATH_TO_GITEA}<< is not a file"
		echo ""

		return 2
	fi

	local PATH_TO_NEW_GITEA="${PATH_TO_GITEA}.new"
	local PATH_TO_LAST_DOWNLOADED_VERSION="${BASE_PATH}/.last_downloaded_version"

	#bo: environemnt check
	echo ":: Please visit >>https://github.com/go-gitea/gitea/releases/tag/latest<<."
	echo ""

	if [[ ${#LATEST_GITEAVERSION} -eq 0 ]];
	then
		echo ":: Please insert latest Version number without the v."
		read LATEST_GITEAVERSION
	fi

	if [[ -f ${PATH_TO_LAST_DOWNLOADED_VERSION} ]];
	then
		LAST_DOWNLOADED_VERSION=$(cat ${PATH_TO_LAST_DOWNLOADED_VERSION})

		echo "   Last downloaded version is >>${LAST_DOWNLOADED_VERSION}<<"
		local PATH_TO_BACKUP_GITEA="${BASE_PATH}/gitea.${LAST_DOWNLOADED_VERSION}.previous"
	else
		local PATH_TO_BACKUP_GITEA="${BASE_PATH}/gitea.previous"
	fi

	if [[ "${LAST_DOWNLOADED_VERSION}" != "${LATEST_GITEAVERSION}" ]];
	then
		echo "   Downloading >>https://github.com/go-gitea/gitea/releases/download/v${LATEST_GITEAVERSION}/gitea-${LATEST_GITEAVERSION}-linux-amd64<<"
		echo "   To >>${PATH_TO_NEW_GITEA}<<"

		echo "   Executing >>wget -O \"${PATH_TO_NEW_GITEA}\" \"https://github.com/go-gitea/gitea/releases/download/v${LATEST_GITEAVERSION}/gitea-${LATEST_GITEAVERSION}-linux-amd64\"<<"

		wget -O "${PATH_TO_NEW_GITEA}" "https://github.com/go-gitea/gitea/releases/download/v${LATEST_GITEAVERSION}/gitea-${LATEST_GITEAVERSION}-linux-amd64"

		echo "   Exit code of wget was >>${?}<<"
	else
		echo ":: Skipping"
		echo "   Version >>${LATEST_GITEAVERSION}<< already installed."
		echo "   See content of file >>${PATH_TO_LAST_DOWNLOADED_VERSION}<<."

		return 0
	fi
	#eo: environemnt check

	#bo: upgrade
	if [[ -f "${PATH_TO_GITEA}" ]];
	then
		echo ":: Stopping all running gitea process."

		#killall gitea
		supervisorctl stop gitea

		echo ":: Moving >>${PATH_TO_GITEA}<< to >>${PATH_TO_BACKUP_GITEA}<<"

		mv "${PATH_TO_GITEA}" "${PATH_TO_BACKUP_GITEA}"
	fi

	if [[ -f "${PATH_TO_NEW_GITEA}" ]];
	then
		wget --output-document "${PATH_TO_NEW_GITEA}.asc" "https://github.com/go-gitea/gitea/releases/download/v${LATEST_GITEAVERSION}/gitea-${LATEST_GITEAVERSION}-linux-amd64.asc"

		curl --silent https://keys.openpgp.org/vks/v1/by-fingerprint/7C9E68152594688862D62AF62D9AE806EC1592E2 | gpg --import

		gpg --verify "${PATH_TO_NEW_GITEA}.asc" "${PATH_TO_NEW_GITEA}"

		chmod u+x "${PATH_TO_NEW_GITEA}"

		mv "${PATH_TO_NEW_GITEA}" "${PATH_TO_GITEA}"

		echo "${LATEST_GITEAVERSION}" > ${PATH_TO_LAST_DOWNLOADED_VERSION}

		echo ":: Starting migration"

		${PATH_TO_GITEA} migrate

		echo ":: Starting gitea"

		#${PATH_TO_GITEA} web

		supervisorctl start gitea
	else
		echo ":: Something went wrong."
		echo "   >>${PATH_TO_NEW_GITEA}<< does not exist"

		if [[ -f "${PATH_TO_BACKUP_GITEA}" ]];
		then
			echo ":: Restoring previous gitea."

			mv "${PATH_TO_BACKUP_GITEA}" "${PATH_TO_GITEA}"

			echo ":: Starting gitea"

			#${PATH_TO_GITEA} web
			supervisorctl start gitea
		fi
	fi
	#eo: upgrade
}

_do_the_update "${@}"
