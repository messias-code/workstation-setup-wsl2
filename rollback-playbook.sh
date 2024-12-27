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
PACKAGES=("git" "curl" "wget" "neovim" "zsh" "texlive" "texlive-latex-extra" "texlive-xetex" "texlive-fonts-recommended" "texlive-plain-generic" "pandoc" "dconf-cli" "python3-pip")
for package in "${PACKAGES[@]}"; do
    if dpkg -l | grep -q "$package"; then
        sudo apt-get remove --purge -y "$package"
    else
        echo "Pacote $package não está instalado."
    fi
done

# Remover Docker e suas configurações
print_message "Removendo Docker e suas configurações"
DOCKER_PACKAGES=("docker-ce" "docker-ce-cli" "containerd.io" "docker-buildx-plugin" "docker-compose-plugin")
for package in "${DOCKER_PACKAGES[@]}"; do
    if dpkg -l | grep -q "$package"; then
        sudo apt-get remove --purge -y "$package"
    else
        echo "Pacote $package não está instalado."
    fi
done
sudo rm -rf /etc/apt/keyrings/docker.asc
sudo rm -rf /etc/apt/sources.list.d/docker.list
sudo rm -rf /var/lib/docker /var/lib/containerd
sudo rm -rf /etc/docker
sudo groupdel docker || echo "Grupo 'docker' não existe."

# Remover interfaces de rede do Docker
print_message "Removendo interfaces de rede do Docker"
if ip link show docker0 &>/dev/null; then
    sudo ip link delete docker0
else
    echo "Interface docker0 não encontrada."
fi

# Remover Kubernetes e suas configurações
print_message "Removendo Kubernetes e suas configurações"
sudo systemctl stop kubelet
sudo systemctl disable kubelet
sudo apt-mark unhold kubelet kubeadm kubectl
sudo apt-get remove --purge -y --allow-change-held-packages kubelet kubeadm kubectl
sudo rm -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo rm -f /etc/apt/sources.list.d/kubernetes.list
sudo rm -rf /usr/local/bin/kubectl
sudo rm -rf /etc/kubernetes /var/lib/kubelet
sudo rm -rf /home/$USER/.minikube /usr/local/bin/minikube
sudo systemctl daemon-reload

# Remover Azure CLI
print_message "Removendo Azure CLI"
sudo apt remove --purge -y azure-cli
sudo rm -rf /etc/apt/sources.list.d/azure-cli.list
sudo rm -rf /etc/apt/keyrings/microsoft.asc

# Remover AWS CLI
print_message "Removendo AWS CLI"
sudo apt remove --purge -y awscli
sudo rm -rf /usr/local/aws-cli /usr/local/bin/aws
sudo rm -rf /tmp/awscliv2.zip /tmp/aws

# Remover Google Cloud CLI
print_message "Removendo Google Cloud CLI"
if snap list | grep -q "google-cloud-sdk"; then
    sudo snap remove google-cloud-sdk
else
    echo "Google Cloud CLI não está instalado via Snap."
fi

# Atualizar cache do APT
print_message "Atualizando cache do APT"
sudo apt clean && sudo apt update

# Executar autoremove para limpar dependências não utilizadas
print_message "Executando autoremove"
sudo apt autoremove -y

# Limpar pacotes residuais
print_message "Limpando pacotes residuais"
sudo apt-get purge -y $(dpkg -l | awk '/^rc/ { print $2 }') || echo "Nenhum pacote residual encontrado."

# Verificação final
print_message "Verificando remoção completa"
dpkg -l | grep -E "kubectl|docker|zsh|oh-my-zsh"
systemctl list-units | grep -E "docker|kubelet|minikube"
for dir in ~/.minikube /usr/local/bin/minikube /var/lib/docker /etc/docker /etc/kubernetes ~/.oh-my-zsh; do
    if [ -e "$dir" ]; then
        echo "$dir ainda existe."
    else
        echo "$dir foi removido."
    fi
done

print_message "Script concluído!"