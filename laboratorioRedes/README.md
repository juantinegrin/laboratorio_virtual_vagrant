# Rede de Servidores com Vagrant

Este é um ambiente de laboratório configurado usando o Vagrant para administração de redes. O ambiente consiste em três máquinas virtuais (VMs) com as seguintes configurações:

## VM1 - Servidor Web (Privado)

- **Sistema Operacional:** Ubuntu Server 20.04 LTS
- **Interface de Rede 1 (eth0):** IP Privado Estático (192.168.50.10)
- **Função:** Servidor Web (Apache)
- **Pasta Compartilhada:** `/var/www/html` na máquina host está compartilhada com `/var/www/html` na VM1.

## VM2 - Servidor de Banco de Dados (Privado)

- **Sistema Operacional:** Ubuntu Server 20.04 LTS
- **Interface de Rede 1 (eth0):** IP Privado Estático (192.168.50.11)
- **Função:** Servidor de Banco de Dados (MySQL ou PostgreSQL)

## VM3 - Gateway (Privado DHCP e Pública)

- **Sistema Operacional:** Ubuntu Server 20.04 LTS
- **Interface de Rede 1 (eth0):** IP Privado Estático (192.168.50.12)
- **Interface de Rede 2 (eth1):** IP Público DHCP
- **Função:** Gateway de Rede
- **Fornecer Acesso à Internet:** VM1 e VM2 têm acesso à Internet através da interface de rede pública da VM3.

## Configuração do Vagrantfile

O ambiente é criado e configurado usando um arquivo Vagrantfile. Aqui está uma visão geral das configurações no Vagrantfile:

- VM1, VM2 e VM3 são definidas e configuradas individualmente no Vagrantfile.
- As configurações de rede, como endereços IP privados, são especificadas usando o Vagrant.
- Pacotes e serviços são instalados nas VMs usando o provisionamento com script shell.
- Uma pasta compartilhada é configurada entre a máquina host e a VM3 para compartilhar arquivos.

## Explicando Vagrantfile

1. Linha 7 adiciona o IP Privado Estático a máquina (isso acontece para todas as máquinas).
2. A linha 11 compartilha a pasta 'var/www/html' do host com a da VM1, porém como este trabalho foi feito em um host windows, a linha 12 mostra um exemplo de como adicionar o equivalente da 'var/www/html' no windows. Para usar no linux apenas remova a # de comentário e adicione na linha de baixo.
3. Linha 18 e 34 adicionam o IP da VM3 como gateway das VM1 e VM2.
4. Os provisions instalam e configuram o servidor web apache e o servidor mysql, além de instalar o net-tools para usar o ifconfig para verificar se as configurações estam corretas.
5. A linha 47 compartilha os arquivos da pasta para a VM3, para que possar executar o script dentro da VM, para garantir que não ocorram erros.

## Como executar

1. Abra o terminal na pasta deste arquivo que estam o Vagrantfile e o script.sh, depois suba as máquinas com o comando vagrant up.
2. Depois que as máquinas estiverem no ar, acesse a VM3 pode ser por meio de ssh, ou simplesmente pelo Virtual Box, para acessar via ssh use o comando vagrant ssh vm3(nome da maquina), username: vagrant, password: vagrant
3. Dentro da VM3 digite o comando sudo su, após isso esta logado como root então digite o comando ./script.sh para executar os processos de configuração do sysctl que liberam o ipv4, e o iptables, que transformam a VM3 em um gateway, assim as máquinas VM1 e VM2, podem acessar a internet a partir dela.
4. Para verificar se as máquinas VM1 e VM2 tem internet acesse cada uma e digite o comando ping 8.8.8.8 isso testara a conexão com os servidores do google.
5. Para testar o servidor apache, acesse a VM1 e digite no seu navegador http://192.168.50.10 isto deve mostrar o banner padrão do apache.
6. Para testar o servidor mysql, acesse a VM2 e digite o comando systemctl status mysql, isso mostrará as configurações do mysql-server, se estiver 'active (running)' em Active estará ativo.
7. Se quiser testar a conexão entre a VM1 e VM2 basta acessar qualquer uma e digite o IP da outra, exemplo: acessar a VM1 e digitar o comando ping 192.168.50.11 que é o IP da VM2.
8. E por último se quiser desativar a conexão com a internet bastar desligar a VM3, com um comando init 0 dentro da máquina ou vagrant halt vm3 no cmd.


