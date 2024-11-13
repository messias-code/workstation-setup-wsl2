#!/bin/bash

# Função para imprimir mensagens
print_message() {
    echo "========================================"
    echo "$1"
    echo "========================================"
}

# Restaurar shell padrão para bash
print_message "Restaurando shell padrão para bash"
chsh -s /bin/bash $USER

# Remover Oh-My-ZSH, arquivos de configuração e histórico
print_message "Removendo Oh-My-ZSH, .zshrc e histórico do ZSH"
rm -rf /home/$USER/.oh-my-zsh
rm -f /home/$USER/.zshrc
rm -f /home/$USER/.zsh_history

# Remover pacotes gerais
print_message "Removendo pacotes instalados"
for package in git curl wget neovim zsh texlive texlive-latex-extra texlive-xetex texlive-fonts-recommended texlive-plain-generic pandoc dconf-cli python3-pip; do
    if dpkg -l | grep -q $package; then
        sudo apt-get remove --purge -y $package
    else
        echo "Pacote $package não está instalado."
    fi
done

# Remover Docker e suas configurações
print_message "Removendo Docker e suas configurações"
for package in docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; do
    if dpkg -l | grep -q $package; then
        sudo apt-get remove --purge -y $package
    else
        echo "Pacote $package não está instalado."
    fi
done
sudo rm -rf /etc/apt/keyrings/docker.asc /etc/apt/sources.list.d/docker.list
sudo rm -rf /var/lib/docker /var/lib/containerd
sudo rm -rf /etc/docker
sudo groupdel docker

# Remover Azure CLI
print_message "Removendo Azure CLI"
sudo apt remove --purge -y azure-cli
sudo rm -rf /etc/apt/sources.list.d/azure-cli.list
sudo rm -rf /etc/apt/keyrings/microsoft.asc

# Remover AWS CLI
print_message "Removendo AWS CLI"
sudo apt remove --purge awscli
sudo rm -rf /usr/local/aws-cli /usr/local/bin/aws
sudo rm -rf /tmp/awscliv2.zip /tmp/aws

# Remover Google Cloud CLI
print_message "Removendo Google Cloud CLI"
sudo apt remove --purge -y google-cloud-sdk
sudo rm -rf /usr/share/keyrings/cloud.google.gpg /etc/apt/sources.list.d/google-cloud-sdk.list
sudo rm -rf /usr/lib/google-cloud-sdk

# Atualizar cache do APT
print_message "Atualizando cache do APT"
sudo apt clean && sudo apt update

# Executar autoremove para limpar dependências não utilizadas
sudo apt autoremove -y

print_message "Processo de reversão concluído!"