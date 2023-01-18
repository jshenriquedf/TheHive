
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
    echo "deb [signed-by=/usr/share/keyrings/corretto.gpg] https://apt.corretto.aws stable main"  \
        |  sudo tee -a /etc/apt/sources.list.d/corretto.sources.list
    
    sudo apt update
    sudo apt install java-common java-11-amazon-corretto-jdk
    
    echo JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto" | sudo tee -a /etc/environment 
    export JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto"
    
    java -version
    
## Instalação do THEHIVE

    curl https://raw.githubusercontent.com/TheHive-Project/TheHive/master/PGP-PUBLIC-KEY | sudo apt-key add -
    echo 'deb https://deb.thehive-project.org release main' | sudo tee -a /etc/apt/sources.list.d/thehive-project.list
    
    sudo apt-get update
    sudo apt-get install thehive4
    
    sudo systemctl stop thehive

# COnfiguração 
## Esturura de Configuração
 
 /etc/thehive
 |-- application.conf
 |-- application.conf.d
 |   |-- secret.conf
 |   |-- service.conf
 |   |-- ssl.conf
 |   |-- proxy.conf
 |   |-- database
 |   |   |-- database.conf
 |   |   |-- database.conf
 |   |   |-- database.conf
 |   |-- storage
 |   |   |-- storage.conf
 |   |-- cluster
 |   |   |-- cluster.conf
 |   |-- authentication
 |   |   |-- authentication.conf
 |   |-- connectors
 |   |   |-- cortex.conf
 |   |   |-- misp.conf
 |   |   |-- webhooks
 |   |   |   |-- webhooks.conf
 -- logback.xml
    
