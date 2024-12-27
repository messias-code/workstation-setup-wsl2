#!/bin/bash

# Colors
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RESET="\033[0m"

# Utility functions
show_step() {
  echo -e "${BLUE}========================================${RESET}"
  echo -e "${YELLOW}$1${RESET}"
  echo -e "${BLUE}========================================${RESET}"
}

show_status() {
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✔ $1 concluído com sucesso.${RESET}"
  else
    echo -e "${RED}✘ $1 falhou.${RESET}"
  fi
}

prompt_for_sudo() {
  echo -e "${YELLOW}O script precisará de privilégios administrativos.${RESET}"
  sudo -v || (echo -e "${RED}Falha ao autenticar como administrador. Encerrando o script.${RESET}" && exit 1)
}

# Main rollback logic
rollback() {
  # Solicitação de senha no início
  prompt_for_sudo

  show_step "Restaurando shell padrão para bash"
  sudo chsh -s /bin/bash $USER
  show_status "Restaurar shell"

  show_step "Removendo Oh-My-ZSH e configurações ZSH"
  rm -rf ~/.oh-my-zsh ~/.zshrc ~/.zsh_history
  show_status "Remover Oh-My-ZSH e configurações"

  show_step "Removendo pacotes instalados"
  local packages=("git" "curl" "wget" "neovim" "zsh" "texlive" "texlive-latex-extra" "texlive-xetex" "texlive-fonts-recommended" "texlive-plain-generic" "pandoc" "dconf-cli" "python3-pip")
  for package in "${packages[@]}"; do
    echo -e "${YELLOW}Removendo $package...${RESET}"
    sudo apt-get purge -y "$package" --quiet
    show_status "Remover $package"
  done

  show_step "Removendo Docker e suas configurações"
  local docker_packages=("docker-ce" "docker-ce-cli" "containerd.io" "docker-buildx-plugin" "docker-compose-plugin")
  for package in "${docker_packages[@]}"; do
    echo -e "${YELLOW}Removendo $package...${RESET}"
    sudo apt-get purge -y "$package" --quiet
    show_status "Remover $package"
  done
  sudo rm -rf /etc/apt/keyrings/docker.asc /etc/apt/sources.list.d/docker.list /var/lib/docker /var/lib/containerd /etc/docker
  sudo groupdel docker 2>/dev/null || echo -e "${RED}Grupo 'docker' não existe.${RESET}"

  show_step "Removendo Kubernetes e suas configurações"
  sudo systemctl stop kubelet
  sudo systemctl disable kubelet
  sudo apt-mark unhold kubelet kubeadm kubectl
  sudo apt-get purge -y --allow-change-held-packages kubelet kubeadm kubectl
  sudo rm -rf /etc/apt/keyrings/kubernetes-apt-keyring.gpg /etc/apt/sources.list.d/kubernetes.list /usr/local/bin/kubectl /etc/kubernetes /var/lib/kubelet
  sudo rm -rf ~/.minikube /usr/local/bin/minikube
  sudo systemctl daemon-reload
  show_status "Remover Kubernetes"

  show_step "Removendo Azure CLI"
  sudo apt-get purge -y azure-cli
  sudo rm -rf /etc/apt/sources.list.d/azure-cli.list /etc/apt/keyrings/microsoft.asc
  show_status "Remover Azure CLI"

  show_step "Removendo AWS CLI"
  sudo apt-get purge -y awscli
  sudo rm -rf /usr/local/aws-cli /usr/local/bin/aws /tmp/awscliv2.zip /tmp/aws
  show_status "Remover AWS CLI"

  show_step "Removendo Google Cloud CLI"
  if snap list | grep -q "google-cloud-sdk"; then
    sudo snap remove google-cloud-sdk
  else
    echo -e "${RED}Google Cloud CLI não está instalado via Snap.${RESET}"
  fi
  show_status "Remover Google Cloud CLI"

  show_step "Atualizando cache APT"
  sudo apt-get clean && sudo apt-get update --quiet
  show_status "Atualizar cache APT"

  show_step "Executando autoremove"
  sudo apt-get autoremove -y --quiet
  show_status "Autoremove"

  show_step "Limpando pacotes residuais"
  sudo apt-get purge -y $(dpkg -l | awk '/^rc/ { print $2 }') || echo -e "${GREEN}Nenhum pacote residual encontrado.${RESET}"
  show_status "Limpeza de pacotes residuais"

  show_step "Verificação final"
  for dir in ~/.minikube /usr/local/bin/minikube /var/lib/docker /etc/docker /etc/kubernetes ~/.oh-my-zsh; do
    if [ -e "$dir" ]; then
      echo -e "${RED}$dir ainda existe.${RESET}"
    else
      echo -e "${GREEN}$dir foi removido.${RESET}"
    fi
  done

  echo -e "${BLUE}Rollback concluído.${RESET}"
}

# Run rollback
rollback