# Instalação do THEHIVE
Para esse ambiente de teste, foi utilizado o VirtualBox com redirecionamento de portas:
## REQUIRED PACKAGES
Instalação de dependências.

    sudo apt update -qq  &> /dev/null
    
    sudo RUNLEVEL=1 apt install -yqq wget gnupg apt-transport-https git ca-certificates  \
    curl jq software-properties-common lsb-release python3-pip iproute2  &> /dev/null

## Configurações básicas após intalação
### Instalação do Java 11

    wget -qO- https://apt.corretto.aws/corretto.key | sudo gpg --dearmor  -o /usr/share/keyrings/corretto.gpg
    echo "deb [signed-by=/usr/share/keyrings/corretto.gpg] https://apt.corretto.aws stable main" |  sudo tee -a /etc/apt/sources.list.d/corretto.sources.list
    
    sudo apt update
    sudo apt install java-common java-11-amazon-corretto-jdk
    
    echo JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto" | sudo tee -a /etc/environment 
    export JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto"
    
    java -version
    
## Adicionao o usuário "cerberus" ao grupo sudoes:
Logue como root:

    su - 

Verificando os grupos pertencentes ao usuário "Cerberus":
    
    groups cerberus
    # ou
    id -nG cerberus
