
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
    
    sudo apt -y update && sudo apt -y upgrade
    sudo apt install java-common java-11-amazon-corretto-jdk
    
    echo JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto" | sudo tee -a /etc/environment 
    export JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto"
    
    java -version
    
## Instalação do THEHIVE

    curl https://raw.githubusercontent.com/TheHive-Project/TheHive/master/PGP-PUBLIC-KEY | sudo apt-key add -
    echo 'deb https://deb.thehive-project.org release main' | sudo tee -a /etc/apt/sources.list.d/thehive-project.list
    
    sudo apt -y update && sudo apt -y upgrade
    sudo apt-get install thehive4
    
    sudo systemctl stop thehive

# Configuração 
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
 
 ## Backups dos arquivos de instalação

    cd /etc/thehive
    sudo mkdir -p ./backup
    sudo mv application.conf secret.conf backup/
    
 ## baixando arquivos do git

    cd /tmp
    git clone https://github.com/jshenriquedf/TheHive-4.git
    sudo cp -a TheHive-4/admin/thehive/. /etc/thehive
    
    sudo chown root:thehive /etc/thehive/application.conf
    sudo chown -R root:thehive /etc/thehive/application.conf.d/*
    
    sudo systemctl start thehive
    sudo systemctl status thehive
    sudo systemctl enable thehive
    
    ss -antl | grep LISTEN
    
    
 ## Install Elasticsearch

    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main"  \
        |  sudo tee /etc/apt/sources.list.d/elastic-7.x.list 
    
    sudo apt -y update && sudo apt -y upgrade
    sudo apt install elasticsearch
    
 ## Configuração Elasticsearch

    cat << EOF |  sudo tee /etc/elasticsearch/elasticsearch.yml
    http.host: 127.0.0.1
    transport.host: 127.0.0.1
    cluster.name: hive
    thread_pool.search.queue_size: 100000
    path.logs: "/var/log/elasticsearch"
    path.data: "/var/lib/elasticsearch"
    xpack.security.enabled: false
    script.allowed_types: "inline,stored"
    EOF
    
    cat << EOF | sudo tee -a /etc/elasticsearch/jvm.options.d/jvm.options 
    -Dlog4j2.formatMsgNoLookups=true
    -Xms512m
    -Xmx512m
    EOF
    
    sudo systemctl start elasticsearch
    sudo systemctl status elasticsearch
    sudo systemctl enable elasticsearch
    
    ss -antl | grep LISTEN



