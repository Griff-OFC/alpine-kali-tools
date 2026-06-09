#!/bin/bash
# By: Silva
# Refactored for Alpine Kali Tools v2.0 - Pure Shell & Native APK Edition

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_msg() {
    echo -e "${GREEN}[*] $1${NC}"
}

print_err() {
    echo -e "${RED}[!] $1${NC}"
}

print_warn() {
    echo -e "${YELLOW}[!] $1${NC}"
}

# Verifica se é root
if [ "$EUID" -ne 0 ]; then
  print_err "Por favor, execute o script como root (sudo ./alpinetools.sh)"
  exit
fi

# Configura repositórios
setup_repos() {
    print_msg "Verificando repositórios..."
    
    if ! grep -qF "community" /etc/apk/repositories; then
        print_warn "Adicionando repositório Community..."
        echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories
    fi
    
    if ! grep -qF "testing" /etc/apk/repositories; then
        print_warn "Adicionando repositório Edge Testing..."
        echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
    fi
    
    print_msg "Atualizando lista de pacotes..."
    apk update > /dev/null 2>&1
}

# Verifica se pacote apk está instalado
is_installed() {
    apk info -e "$1" > /dev/null 2>&1
}

# Instala pacote via apk
install_apk() {
    local pkg=$1
    if is_installed "${pkg%@*}"; then
        print_warn "O pacote '${pkg%@*}' já está instalado."
    else
        print_msg "Instalando $pkg..."
        apk add "$pkg"
        if [ $? -eq 0 ]; then
            print_msg "$pkg instalado com sucesso!"
        else
            print_err "Falha ao instalar $pkg."
        fi
    fi
    sleep 1
}

# Instalação Metasploit (Mantido o método original clonado do git pois não possui apk oficial)
install_metasploit() {
    if [ -d "/opt/metasploit-framework" ]; then
        print_warn "Metasploit já está instalado em /opt/metasploit-framework."
        sleep 1
        return
    fi
    print_msg "Instalando dependências do Metasploit..."
    apk add build-base ruby ruby-bigdecimal ruby-bundler ruby-io-console ruby-webrick ruby-dev libffi-dev openssl-dev readline-dev sqlite-dev postgresql-dev libpcap-dev libxml2-dev libxslt-dev yaml-dev zlib-dev ncurses-dev autoconf bison subversion sqlite nmap libxslt postgresql ncurses git
    
    print_msg "Baixando Metasploit..."
    cd /opt/ && git clone https://github.com/rapid7/metasploit-framework.git
    cd metasploit-framework
    gem install bundler && bundle update && bundle install
    
    ln -sf /opt/metasploit-framework/msfconsole /usr/bin/
    ln -sf /opt/metasploit-framework/msfvenom /usr/bin/
    ln -sf /opt/metasploit-framework/msfrpcd /usr/bin/
    print_msg "Metasploit instalado com sucesso!"
    sleep 2
}

show_menu() {
    clear
    echo -e "${CYAN}================================================================${NC}"
    echo -e "${CYAN}                 🐉 ALPINE KALI TOOLS INSTALLER                 ${NC}"
    echo -e "${CYAN}================================================================${NC}"
    echo -e "Escolha a ferramenta que deseja instalar:\n"
    
    echo -e "${GREEN}[  1 ]${NC} Nmap              ${GREEN}[ 10 ]${NC} Gobuster"
    echo -e "${GREEN}[  2 ]${NC} Nuclei            ${GREEN}[ 11 ]${NC} Aircrack-ng"
    echo -e "${GREEN}[  3 ]${NC} Netdiscover       ${GREEN}[ 12 ]${NC} Wireshark"
    echo -e "${GREEN}[  4 ]${NC} Snort             ${GREEN}[ 13 ]${NC} Responder"
    echo -e "${GREEN}[  5 ]${NC} Hydra             ${GREEN}[ 14 ]${NC} Metasploit-Framework"
    echo -e "${GREEN}[  6 ]${NC} Hashcat           ${GREEN}[ 15 ]${NC} Netcat"
    echo -e "${GREEN}[  7 ]${NC} John the Ripper   ${GREEN}[ 16 ]${NC} Powershell"
    echo -e "${GREEN}[  8 ]${NC} Sqlmap            ${GREEN}[ 17 ]${NC} Steghide"
    echo -e "${GREEN}[  9 ]${NC} Ffuf              ${GREEN}[ 18 ]${NC} rkhunter"
    echo -e " "
    echo -e "${GREEN}[ 99 ]${NC} Instalar TODAS as ferramentas"
    echo -e "${RED}[  0 ]${NC} Sair"
    echo -e "${CYAN}================================================================${NC}"
    echo -ne "Opção: "
}

install_all() {
    install_apk "nmap"
    install_apk "nuclei@testing"
    install_apk "netdiscover@testing"
    install_apk "snort"
    install_apk "hydra"
    install_apk "hashcat"
    install_apk "john"
    install_apk "sqlmap@testing"
    install_apk "ffuf"
    install_apk "gobuster@testing"
    install_apk "aircrack-ng"
    install_apk "wireshark"
    install_apk "responder@testing"
    install_metasploit
    install_apk "netcat-openbsd"
    install_apk "powershell"
    install_apk "steghide@testing"
    install_apk "rkhunter@testing"
    
    print_msg "Todas as ferramentas foram instaladas com sucesso!"
    sleep 3
}

main() {
    setup_repos
    
    while true; do
        show_menu
        read op
        
        case "$op" in
            0) echo -e "${YELLOW}Saindo do instalador...${NC}"; exit 0 ;;
            1) install_apk "nmap" ;;
            2) install_apk "nuclei@testing" ;;
            3) install_apk "netdiscover@testing" ;;
            4) install_apk "snort" ;;
            5) install_apk "hydra" ;;
            6) install_apk "hashcat" ;;
            7) install_apk "john" ;;
            8) install_apk "sqlmap@testing" ;;
            9) install_apk "ffuf" ;;
            10) install_apk "gobuster@testing" ;;
            11) install_apk "aircrack-ng" ;;
            12) install_apk "wireshark" ;;
            13) install_apk "responder@testing" ;;
            14) install_metasploit ;;
            15) install_apk "netcat-openbsd" ;;
            16) install_apk "powershell" ;;
            17) install_apk "steghide@testing" ;;
            18) install_apk "rkhunter@testing" ;;
            99) install_all ;;
            *) print_err "Opção inválida!"; sleep 1 ;;
        esac
    done
}

main
