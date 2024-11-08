# 💻⚙️ Configuração da estação de trabalho WSL2

<p align="center">
  <img src="./assets/CODE-ACADEMY-WSL2.png" alt="code-academy-banner">
</p>

> Automatização para configuração de ambiente de desenvolvimento no WSL2 Ubuntu, utilizando Ansible para agilizar e padronizar a instalação de ferramentas e configurações essenciais para profissionais DevOps.
> "Automatize tudo o que puder, documente o resto."

_**Feito com ❤️ para otimizar o tempo de desenvolvedores DevOps**_

---

## 📑 Sumário
- [Sobre o Projeto](#-sobre-o-projeto)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Roadmap](#-roadmap)
- [Funcionalidades](#-funcionalidades)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação](#-instalação)
- [Configuração do Windows Terminal](#️-configuração-do-windows-terminal)
- [Uso](#-uso)
- [Variáveis do Sistema](#-variáveis-do-sistema)
- [Contribuição](#-contribuição)
- [Licença](#-licença)

## 🚀 Sobre o Projeto

Este projeto nasceu da necessidade de otimizar o tempo de configuração de um novo ambiente de desenvolvimento no WSL2 Ubuntu. Através do Ansible, automatizei a instalação e configuração de ferramentas essenciais, garantindo um ambiente consistente e pronto para uso em questão de minutos.

## 📁 Estrutura do Projeto

```
.
├── assets
│   └── CODE-ACADEMY-WSL2.png
├── LICENSE
├── wsl2-setup.yml
└── README.md
```

## 🗺️ Roadmap

Este é um projeto em constante evolução que visa criar um ambiente completo para profissionais DevOps. Ao longo de 2025, novas ferramentas e configurações serão adicionadas, incluindo:

- [x] Oh-My-ZSH com Powerlevel10K e plugins
- [x] Docker Engine e Docker Compose
- [ ] Cloud CLI tools (aws-cli, azure-cli, gcloud)
- [ ] Kubernetes tools (kubectl, helm, k9s)
- [ ] Terraform e outras ferramentas IaC

> 🔄 *Este projeto está em desenvolvimento ativo. Novas features são adicionadas regularmente.*

## 💡 Funcionalidades

O playbook realiza as seguintes configurações:

1. Sistema Base
   - Atualização completa do sistema
   - Instalação de pacotes essenciais (git, curl, wget, etc...)

2. Terminal
   - Instalação e configuração do ZSH
   - Setup do Oh-My-ZSH com Powerlevel10k
   - Configuração de plugins úteis

3. Docker
   - Instalação completa do Docker Engine
   - Configuração de permissões e grupos
   - Instalação do Docker Compose

## 📋 Pré-requisitos

- WSL2 instalado com Ubuntu
- Acesso à internet
- Privilégios de administrador
- Windows Terminal (recomendado)

## 🔧 Instalação

### 1. Instalar o Ansible

```bash
# Atualizar os repositórios
sudo apt update

# Instalar o software-properties-common
sudo apt install software-properties-common

# Adicionar o repositório do Ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible

# Instalar o Ansible
sudo apt install ansible
```

### 2. Clonar o Repositório

```bash
git clone https://github.com/seu-usuario/workspace-setup.git
cd workspace-setup
```

## 🖥️ Configuração do Windows Terminal

1. Baixe a fonte MesloLGS NF:
   - [Download MesloLGS NF Regular](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)

2. Instale a fonte:
   - Clique duas vezes no arquivo baixado
   - Clique em "Instalar"

3. Configure o Windows Terminal:
   - Abra as Configurações (Ctrl+,)
   - Selecione seu perfil do Ubuntu
   - Em "Aparência"
   - Mude a fonte para "MesloLGS NF"

## 📦 Uso

Para executar o playbook:

```bash
ansible-playbook wsl2-setup.yml --ask-become-pass
```

> **OBS: A senha é do seu usuário root**

Após a execução:
1. Certifique-se que a fonte está configurada no Windows Terminal [Configuração do Terminal](#️-configuração-do-windows-terminal)
2. Reinicie o terminal para que as alterações tenham efeito
3. Configure o tema Powerlevel10k na primeira execução do ZSH

## 🔍 Variáveis do Sistema

O Ansible utiliza "facts" para coletar informações do sistema. As principais variáveis utilizadas neste playbook são:

| Variável | Comando para Verificar | Descrição |
|----------|------------------------|-----------|
| `ansible_env.USER` | `whoami` ou `echo $USER` | Nome do usuário atual |
| `ansible_user_id` | `id -u` | ID do usuário atual |
| `ansible_distribution_release` | `lsb_release -cs` | Nome da versão do Ubuntu |

### Uso de Facts no Ansible

O Ansible coleta informações do sistema usando "facts". Para ver todas as informações disponíveis, execute:

```bash
ansible localhost -m setup
```

Este comando exibirá todos os "facts" disponíveis, incluindo variáveis usadas no playbook e outras informações. É uma ferramenta útil para descobrir quais dados estão disponíveis para personalizar seus playbooks, facilitando a adaptação ao seu modelo, caso desejado.

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 🤝 Contato Profissional
Para suporte ou questões relacionadas ao projeto, entre em contato através dos seguintes canais:

[![LinkedIn Badge](https://img.shields.io/static/v1?style=for-the-badge&message=LinkedIn&color=0A66C2&logo=LinkedIn&logoColor=FFFFFF&label=)](https://www.linkedin.com/in/ihanmessias/)
[![Instagram Badge](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/messias.code)

<p align="center">✉ Email de Projetos: messias.code@gmail.com</p>

<p align="center">© CodeAcademy</p>