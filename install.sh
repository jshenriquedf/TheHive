#!/bin/bash
## SCRIPT DE INSTALAÇÃO PARA LINUX (SUSE)
# Esse script é baseado no script do thehive 5
# 
# Sistemas suportados
# - SUSE SLE SP4
#
# Requirements: 
# - 2 vCPU
# - 4 GB of RAM
# 

#############
# VARIÁVEIS #
#############

HEADER="
Script de instalação do TheHive e do Cortex para o sistema operacional Linux.

Segue as opções para instalação:
  - Definir as configurações de Proxy
  - Instalação do TheHive 4.x (x86_64)
  - Instalação do Cortex (utilizar os Analyzers e Responders com Docker) (x86_64)
  - Instalação do Cortex (utilizar os Analyzers e Responders no host) (x86_64 only)

Sistemas suportados
  - SUSE SLE SP4

Requirements: 
  - 2 vCPU
  - 4 GB of RAM
---

"

THEHIVE="---
Softwares a serem instalados e configurados
  - Cassandra 3.11.x
  - Elasticsearch 7.x
  - TheHive 4.1
  - Nginx
  - thehive4py

"

CORTEX="---
Softwares a serem instalados e configurados
  - Elasticsearch 7.x
  - Cortex 3.x
  - Docker engine (optional)
  - Cortex-Analyzers and their dependencies (optional)
"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
LOGFILE="/tmp/install.log"
OSRPM="fedora35 fedora37 rhel8.5"
OSDEB="ubuntu20.04 ubuntu22.04 debian11"
MINREQRAM="4000000"
MINREQCPU="2"
CHECKSAMESERVER=true
PROXYHOST=""
PROXYPORT=""
CACERT=""


############################
# MANAGE LOG FILE & OUTPUT #
############################

[[ -f ${LOGFILE} ]] && rm ${LOGFILE}
exec 3>$(tty)
exec 2>&1> ${LOGFILE}

display_info() {
  log message "Algo deu errado. Mais informações estão disponíveis no arquivo ${LOGFILE}."
}

IP=`hostname -I| cut -d ' ' -f 1`

display-cortex-success() {
  log success "
  ---
  Sucesso Cotex
  "
}

display-thehive-success() {
  log success "
  ---
  Sucesso thehive
  "
}


log () {
  TYPE=$1
  MESSAGE=$2

  case $1 in
    "success" )
    TAG=""
    COLOR=${WHITE}
    ;;

    "ko" )
    TAG="[ERROR]: "
    COLOR=${RED}
    ;;

    "ok" )
    TAG="[INFO]: "
    COLOR=${BLUE}
    ;;

    "message" )
    TAG="[INFO]: "
    COLOR=${BLUE}
    ;;
    
  esac

  echo -e "${TAG}${MESSAGE}"
  echo -e "${COLOR}${TAG}${MESSAGE}${NC}" >&3
}






recipe-cortex() {
  APPLICATION="CORTEX"
  display-cortex-success
  exit 0
}


recipe-thehive() {
  APPLICATION="THEHIVE"
  display-thehive-success
  exit 0
}



#######
# RUN #     
#######

## HEADER
clear >&3 
log success "${HEADER}"
PS3='Selecione uma opção: '
COLUMNS=1
options=("Definir configurações de proxy" "Instalar o TheHive" "Instalar o Cortex (utilizar Neurons com docker)" "Instalar o Cortex (utilizar Neurons local)" "Sair")
select opt in "${options[@]}"
do
    case $opt in
        "Definir configurações de proxy")
            check-supported-os
            prepare-installation
            ;;
        "Instalar o TheHive")
            recipe-thehive
            ;;
        "Instalar o Cortex (utilizar Neurons com docker)")
            recipe-cortex
            ;;
        "Instalar o Cortex (utilizar Neurons local)")
            recipe-cortex
            ;;
        "Sair")
            break
            ;;
        *) echo "Opção inválida $REPLY";;
    esac
    REPLY=
done

