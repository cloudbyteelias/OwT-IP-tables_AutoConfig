#!/bin/bash
###################
#Inserir portas para liberação (separar portas por ; )
PORTAS_TCP=""
PORTAS_UDP=""
###################

#cores
VERMELHO='\033[1;31m'
VERDE='\033[1;32m'
AZUL='\033[1;36m'
AMARELO='\033[1;33m'
NC='\033[0m'
####################
    clear
    logo(){
        echo -e "${VERDE}"
    
         cat << "EOF"


      ██╗██████╗ ████████╗ █████╗ ██████╗ ██╗     ███████╗███████╗      
      ██║██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝      
█████╗██║██████╔╝   ██║   ███████║██████╔╝██║     █████╗  ███████╗█████╗
╚════╝██║██╔═══╝    ██║   ██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║╚════╝
      ██║██║        ██║   ██║  ██║██████╔╝███████╗███████╗███████║      
      ╚═╝╚═╝        ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝      
                                                                                                                                  
                                                                     
      
EOF
        banner "INTELIGE - Firewall Básico" 
        echo -e "${VERMELHO}"
    }


    banner(){

        echo -e "${VERMELHO}"
        echo -e "${VERMELHO}+------------------------------------------+"
        printf  "${VERMELHO}| %-40s |\n" "`date`"
        echo -e "${VERMELHO}|                                          |"
        printf  "${VERMELHO}| `tput bold` %-40s `tput sgr0`|\n" "$@"
        echo -e "${VERMELHO}+------------------------------------------+"
        echo -e "${VERMELHO}"
    }

    limpar_regras(){
        iptables -F
        iptables -X
        iptables -t nat -F
        iptables -t nat -X
        iptables -t mangle -F
        iptables -t mangle -X
        echo -e "[${VERMELHO} LIMPANDO REGRAS....]"
    } 
    conexoes_estabelecidas(){
        iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
        iptables -A OUTPUT -m state --state ESTABLISHED,RELATED,NEW -j ACCEPT
        echo -e "[${VERMELHO} SALVANDO CONEXOES..... ]"
    }
    bloqueio(){
        iptables -P INPUT   DROP
        iptables -P OUTPUT  DROP
        iptables -P FORWARD DROP
        echo -e "[${VERMELHO} CRIANDO REGRAS DE BLOQUEIO...... ]"
    }

    ping(){
        #Permite Ping
        iptables -A INPUT -p icmp --icmp-type echo-request -j REJECTDigite uma mensagem
    }

portas(){
    #Permite tráfego para interface loopback
    iptables -A INPUT -i lo -j ACCEPT
    
    portas=$(echo $PORTAS_TCP | tr ";" "\n")
    for porta in $portas
    do
        iptables -A INPUT -p tcp --dport $porta -m state --state NEW -j ACCEPT
        sleep 0.1
        echo -e "[${VERMEHO} REGRA CRIADA COM SUCESSO ! ]"
    done

    portas=$(echo $PORTAS_UDP | tr ";" "\n")
    for porta in $portas
    do
        iptables -A INPUT -p udp --dport $porta -m state --state NEW -j ACCEPT
        sleep 0.1
        echo -e "[${VERMELHO} REGRA CRIADA COM SUCESSO ! ]"
    done
        echo -e "${AMARELO}"
        echo -ne '[#####                     (33%)\r'
        sleep 1
        echo -ne '[#############             (66%)\r'
        sleep 1
        echo -ne '[#######################   (100%)\r'
        echo -ne '\n'
        
        echo -e "${NC}"
        
        }
   
    #funções
    logo
    limpar_regras
    conexoes_estabelecidas
    bloqueio
    portas
    #ping
    #para habilitar ping descomente a função acima
    ######################
