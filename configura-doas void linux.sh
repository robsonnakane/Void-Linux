#!/bin/bash
# Script para configurar o doas no Void Linux
# Autor: Assistente
# Uso: ./configura-doas.sh
# Executar como usuário comum (vai pedir senha de root)

# Verifica se está rodando no Void Linux
if [ ! -f /etc/void-release ]; then
    echo "Este script é feito para o Void Linux."
    exit 1
fi

# Pergunta o nome do usuário (padrão: usuário atual)
read -p "Digite o nome do usuário que terá acesso ao doas [padrão: $USER]: " USUARIO
USUARIO=${USUARIO:-$USER}

echo "Configurando doas para o usuário: $USUARIO"

# 1. Adiciona o usuário ao grupo wheel
echo "Adicionando $USUARIO ao grupo wheel..."
doas usermod -aG wheel "$USUARIO" 2>/dev/null || \
sudo usermod -aG wheel "$USUARIO" 2>/dev/null || \
su -c "usermod -aG wheel $USUARIO"

if [ $? -ne 0 ]; then
    echo "Erro ao adicionar ao grupo wheel. Você precisa executar como root ou com privilégios."
    exit 1
fi

# 2. Cria/edita /etc/doas.conf com regra segura
echo "Criando/configurando /etc/doas.conf..."
cat << EOF | doas tee /etc/doas.conf > /dev/null 2>&1 || \
             sudo tee /etc/doas.conf > /dev/null 2>&1 || \
             su -c "tee /etc/doas.conf > /dev/null"
# Configuração do doas - Void Linux
# Permite membros do grupo wheel usar doas com cache de senha
permit persist :wheel
EOF

if [ $? -ne 0 ]; then
    echo "Erro ao criar /etc/doas.conf."
    exit 1
fi

# 3. Define permissões corretas no arquivo
echo "Ajustando permissões de /etc/doas.conf..."
doas chown root:root /etc/doas.conf 2>/dev/null || \
sudo chown root:root /etc/doas.conf 2>/dev/null || \
su -c "chown root:root /etc/doas.conf"

doas chmod 400 /etc/doas.conf 2>/dev/null || \
sudo chmod 400 /etc/doas.conf 2>/dev/null || \
su -c "chmod 400 /etc/doas.conf"

# 4. Verificação final
echo
echo "Configuração concluída!"
echo "Importante:"
echo "  - Faça logout e login novamente (ou abra um novo terminal) para o grupo wheel fazer efeito."
echo "  - Teste com: doas whoami (deve retornar 'root')"
echo
echo "Se quiser doas sem pedir senha (menos seguro, só desktop pessoal):"
echo "  Edite /etc/doas.conf e troque por: permit nopass :wheel"

exit 0
