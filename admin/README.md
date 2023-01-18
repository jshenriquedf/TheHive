# Instalação do THEHIVE
Para esse ambiente de teste, foi utilizado o VirtualBox com redirecionamento de portas:
## REQUIRED PACKAGES
Instalação de dependências.

    sudo apt update -qq  &> /dev/null
    sudo RUNLEVEL=1 apt install -yqq wget gnupg apt-transport-https git ca-certificates curl jq software-properties-common lsb-release python3-pip iproute2  &> /dev/null

## Configurações básicas após intalação
### Atualização dos pacotes dos sistema
Acessando a máquina via SSH:

    ssh ceberus@127.0.0.1 -p 2222
    
## Adicionao o usuário "cerberus" ao grupo sudoes:
Logue como root:

    su - 

Verificando os grupos pertencentes ao usuário "Cerberus":
    
    groups cerberus
    # ou
    id -nG cerberus
