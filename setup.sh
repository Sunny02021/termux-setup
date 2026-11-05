#!/data/data/com.termux/files/usr/bin/bash

set -e

# script de: Sunny (https://github.com/Sunny02021)
# minhas configuracoes pessoais do termux

# tambem uso o termux-styling:
# instale o app e, no termux, segure na tela até
# o menu aparecer. va em "mais", "style" e coloco:
# Cor: Catppuccin Mocha
# Fonte: Meslo

git_email="$1"
git_name="$2"

if [ -z "$git_email" ]; then
    echo " ∆ O email não foi informado"
    exit 1
fi

if [ -z "$git_name" ]; then
    echo " ∆ O nome não foi informado"
    exit 1
fi

echo " ∆ Configuracao de armazenamento"
termux-setup-storage

echo " ∆ Remove mensagem de login"
touch ~/.hushlogin

echo " ∆ Atualizacao dos repositorios"
pkg update

echo " ∆ Atualizacao dos pacotes"
pkg upgrade -y

echo " ∆ Pacotes essenciais"
pkg install zsh gh wget which curl git zip clang fastfetch make cmake gdb python micro nasm binutils openjdk-17 -y

echo " ∆ Trocando shell padrao (bash -> zsh)"
chsh -s zsh
# ↑ se isso nao funcionar, roda o comando
# dps q o script terminar de rodar

echo " ∆ Instalando Oh-My-Zsh"

# a opcao chsh=no faz com que o shell nao seja
# substituido quando o omz for instalado
# fiz pq o shell ja foi trocado no passo anterior

# a opcao runzsh=no impede que quando o omz
# for instalado, ele entre e encerre o programa

export CHSH=no RUNZSH=no KEEP_ZSHRC=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo " ∆ Configuracao do Micro"
mkdir -p ~/.config/micro
mkdir -p  ~/.config/micro/colorschemes

# tema: catppuccin-mocha
wget -O ~/.config/micro/colorschemes/catppuccin-mocha.micro \
https://raw.githubusercontent.com/catppuccin/micro/main/themes/catppuccin-mocha.micro

# settings.json
# idk se metade dessas opções ainda existem
echo '{
    "autoindent": true,
    "autoclose": true,
    "autosave": 0,
    "basename": false,
    "colorcolumn": 80,
    "colorscheme": "catppuccin-mocha",
    "cursorline": true,
    "diff": false,
    "eofnewline": true,
    "fastdirty": false,
    "fileformat": "unix",
    "ftoptions": true,
    "hlsearch": true,
    "incsearch": true,
    "indentchar": " ",
    "infobar": true,
    "keepautoindent": true,
    "matchbrace": true,
    "truecolor": "on",
    "matchbraceleft": true,
    "mkparents": true,
    "mouse": true,
    "parsecursor": true,
    "paste": false,
    "permbackup": false,
    "pluginchannels": [],
    "readonly": false,
    "rmtrailingws": true,
    "ruler": true,
    "savecursor": true,
    "savehistory": true,
    "saveundo": true,
    "scrollbar": true,
    "scrollmargin": 3,
    "scrollspeed": 2,
    "smartpaste": true,
    "softwrap": false,
    "splitbottom": true,
    "splitright": true,
    "statusline": true,
    "tabmovement": false,
    "tabsize": 4,
    "tabstospaces": true,
    "termtitle": true,
    "useprimary": true,
    "wordwrap": false
}' > ~/.config/micro/settings.json

# configuração do git
echo " ∆ Configurando git"

git config --global user.email "$git_email"
git config --global user.name "$git_name"
git config --global init.defaultBranch main
git config --global core.editor "micro"
git config --global color.ui auto
git config --global column.ui auto

# gera chave ssh
echo " ∆ Gerando chave SSH; aperte Enter quando solicitado"

ssh-keygen -t ed25519 -C "$git_email"

# inicia agente ssh e adiciona a chave
mkdir -p ~/.ssh/agent/
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# coloca pro agente ssh iniciar junto com o zsh
echo 'if [ -z "$SSH_AUTH_SOCK" ]; then
    mkdir -p $TMPDIR
    eval $(TMPDIR=$TMPDIR ssh-agent -s) > /dev/null
fi' >> ~/.zshrc

# instruções adicionais
echo " ∆ Pronto!"
echo ""
echo " ∆ Use 'cat ~/.ssh/id_ed25519.pub' e copie sua chave SSH"
echo " ∆ Então vá aqui https://github.com/settings/ssh/new"
echo " ∆ Coloque o título que você quiser"
echo " ∆ Em 'Key Type', coloque 'Authentication Key'"
echo " ∆ Em 'Key', coloque a chave que você copiou"
echo " ∆ Clique em 'Add SSH Key'"
echo ""
echo " ∆ Use o comando 'ssh -T git@github.com' e digite 'yes'."
echo ""
echo " ∆ Pra clonar via SSH:"
echo " ∆ git clone git@github.com:USUARIO/REPOSITORIO.git"
echo ""
echo " ∆ Pra criar um repo local e conectar a um repo remoto:"
echo " ∆ git init (dentro da pasta)"
echo " ∆ git remote add origin git@github.com:USUARIO/REPOSITORIO.git"

echo ""
echo " ∆ Reinicie o termux para certas configurações se aplicarem."
