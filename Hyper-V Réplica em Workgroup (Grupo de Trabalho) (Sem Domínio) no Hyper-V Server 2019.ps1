# Script Hyper-V Réplica em Workgroup (Grupo de Trabalho) (Sem Domínio) no Hyper-V Server 2019 - Créditos Gabriel Luiz - www.gabrielluiz.com ##


## Passo 1 ##

# Instalação usando o Windows Update do FOD.

Add-WindowsCapability -Online -Name ServerCore.AppCompatibility~~~~0.0.1.0 # # Instala o Recurso de compatibilidade de aplicativo do Server Core sob demanda (FOD) usando o Windows Update.

# Observação: Somente o Hyper-V Server 2019 e Windows Server Core Windows Server, versão 1903 e versões posteriores pode instalar o FOD.


## Passo 3 ##


## Instalação da Função de Hyper-V e File Service, ambiente sem domínio - Hyper-V 2019. ##

Install-WindowsFeature -Name File-Services -IncludeManagementTools # Instalação da Função File Service no Hyper-V Server 2019.



## Passo 4 ##

# Adicionar e renomear adaptadores de redes e Desabilitar ipv6 nos adaptadores de redes.

Get-NetAdapterBinding -Name * # Verifica as opções habilitadas nos adaptadores de rede especifico.

Get-NetAdapter -Name "*" | Format-List -Property "Name" # Lista os nomes de todos adaptadores de rede existentes.


# HYR1

Rename-NetAdapter -Name "Ethernet"  -NewName "REDE HOST DE HYPER-V" # Renomear o nome do adaptador de rede.

Rename-NetAdapter -Name "Ethernet 2"  -NewName "REDE VM" # Renomear o nome do adaptador de rede.



# HYR2

Rename-NetAdapter -Name "Ethernet"  -NewName "REDE HOST DE HYPER-V" # Renomear o nome do adaptador de rede.

Rename-NetAdapter -Name "Ethernet 2"  -NewName "REDE VM" # Renomear o nome do adaptador de rede.


# Configuração de IP, DNS e Gateway de cada adaptador de rede.



# HYR1

# Adaptador de rede REDE HOST DE HYPER-V.

New-NetIPAddress 192.168.0.57 -InterfaceAlias "REDE HOST DE HYPER-V" -DefaultGateway 192.168.0.1 -AddressFamily ipv4 -PrefixLength 24 # Configura o IP, a mascara e Gateway Padrão.
Set-DnsClientServerAddress -InterfaceAlias "REDE HOST DE HYPER-V" -ServerAddresses 192.168.0.1 # Configura o DNS espeficifico.



# Adaptador de rede REDE VM.

New-NetIPAddress 192.168.0.60 -InterfaceAlias "REDE VM" -DefaultGateway 192.168.0.1 -AddressFamily ipv4 -PrefixLength 24 # Configura o IP, a mascara e Gateway Padrão.
Set-DnsClientServerAddress -InterfaceAlias "REDE VM" -ServerAddresses 192.168.0.1 # Configura o DNS espeficifico.


# HYR2

# Adaptador de rede REDE HOST DE HYPER-V.

New-NetIPAddress 192.168.0.58 -InterfaceAlias "REDE HOST DE HYPER-V" -DefaultGateway 192.168.0.1 -AddressFamily ipv4 -PrefixLength 24 # Configura o IP, a mascara e Gateway Padrão.
Set-DnsClientServerAddress -InterfaceAlias "REDE HOST DE HYPER-V" -ServerAddresses 192.168.0.1 # Configura o DNS espeficifico.



# Adaptador de rede REDE VM.

New-NetIPAddress 192.168.0.61 -InterfaceAlias "REDE VM" -DefaultGateway 192.168.0.1 -AddressFamily ipv4 -PrefixLength 24 # Configura o IP, a mascara e Gateway Padrão.
Set-DnsClientServerAddress -InterfaceAlias "REDE VM" -ServerAddresses 192.168.0.1 # Configura o DNS espeficifico.



# Desabilitar o ipv6 em todos adaptadores de redes.


# Desabilita o ipv6 de todos adaptadores de rede do HYR1.


Disable-NetAdapterBinding -Name "REDE HOST DE HYPER-V" -ComponentID ms_tcpip6 -PassThru # Desabilita o IPV6 no adaptadores de rede.
Disable-NetAdapterBinding -Name "REDE VM" -ComponentID ms_tcpip6 -PassThru # Desabilita o IPV6 no adaptadores de rede.



# Desabilita o ipv6 de todos adaptadores de rede do HYR2.


Disable-NetAdapterBinding -Name "REDE HOST DE HYPER-V" -ComponentID ms_tcpip6 -PassThru # Desabilita o IPV6 no adaptadores de rede.
Disable-NetAdapterBinding -Name "REDE VM" -ComponentID ms_tcpip6 -PassThru # Desabilita o IPV6 no adaptadores de rede.


# Observações: Devemos alterar as configurações de ip e gateway o hostname do computador cliente, o que será demostrado em vídeo.



## Passo 5 ##


## Renomear o hostname do servidor. ##

hostname # Obtenha o hostname do servidor. 

Rename-Computer -NewName "HYR1" -DomainCredential Hostname\Administrador -Restart

Rename-Computer -NewName "HYR2" -DomainCredential Hostname\Administrador -Restart


# Observações:

# Estes comandos deve ser executado também no segundo servidor, no caso o servidor réplica.

# Ao final da instalação ambos servidores serão reinicializados.

# Em -DomainCredential Hostname substitua pelo hostname do seu servidor.

# Devemos alterar também o hostname do computador cliente, o que será demostrado em vídeo.


## Passo 6 ##

# Adicionar as entradas HOSTS ao arquivo hosts.


Get-Content -Path "C:\Windows\System32\drivers\etc\hosts" # Verfica quais são as entradas no arquivos hosts.

Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "192.168.0.57 HYR1" # Adiciona a entrada no arquivo hosts.

Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "192.168.0.58 HYR2" # Adiciona a entrada no arquivo hosts.

Add-Content -Path "C:\Windows\System32\drivers\etc\hosts" -Value "192.168.0.59 WIN10" # Adiciona a entrada no arquivo hosts.


# Obervação:

# Este comando também deve ser executado também em ambos servidores Hyper-V Réplicar e no computador cliente que vai gerenciar o Hyper-V Server.



## Passo 6 ##

# Abrir as porta do firewall para o ping entre servidor e cliente.


Enable-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" # Libera a porta ICPv4 Solicitação de Eco correspondente em Inglês.

Enable-NetFirewallRule -DisplayName "Compartilhamento de Arquivo e Impressora (Solicitação de Eco - ICMPv4-In)" # Libera a porta ICPv4 Solicitação de Eco correspondente em Português.

Enable-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv6-In)" # Libera a porta ICPv6 Solicitação de Eco correspondente em Inglês.

Enable-NetFirewallRule -DisplayName "Compartilhamento de Arquivo e Impressora (Solicitação de Eco - ICMPv6-In)" # Libera a porta ICPv6 Solicitação de Eco correspondente em Português.


# Obervação:

# Este comando também deve ser executado  no servidor Hyper-V 2019 e no Windows 10.


Enable-NetFirewallRule -DisplayName "Hyper-V Replica HTTPS Listener (TCP-In)" # Libera a porta Ouvinte HTTPS da Réplica do Hyper-V correspondente em Inglês.

Enable-NetFirewallRule -DisplayName "Ouvinte HTTPS da Réplica do Hyper-V (TCP-In)" # Libera a porta Ouvinte HTTPS da Réplica do Hyper-V correspondente em Português.


# Obervação:

# Este comando também deve ser executado em ambos servidores Hyper-V 2019.



## Passo 7 ##

# Criação dos certificados.


# Precisamos criar certificados auto-assinados para que o Hyper-V realize a autenticação nos servidores. Atenção que esta etapa é a mais complexa do processo.

# Vamos criar certificados auto-assinados com o utilitário MakeCert.exe.

# Você deve baixar o Microsoft Platform SDK, que contém o Makecert.exe. Pode baixar desse link: http://www.microsoft.com/en-us/download/details.aspx?id=6510.

# Após a instalação, vá na pasta do Microsoft Platform SDK (Se não alterou nada, está em Arquivos de Programas) e faça uma busca pelo arquivo MakeCert.exe. Copie o arquivo para um local de fácil acesso. (recomendo C:)



New-Item -Path c:\certificado -ItemType directory # Cria a pasta com o nome certificado.


# Obervação:

# Este comando também deve ser executado em ambos servidores Hyper-V 2019.


# Criação do certificado servidor primário.


# No servidor primário:

# Abra o CMD (Prompt de Comando) com privilégios administrativos e execute o comando abaixo: (na pasta onde você colocou o Makecert.exe).

makecert -pe -n "CN=PrimaryTestRootCA" -ss root -sr LocalMachine -sky signature -r "PrimaryTestRootCA.cer"

makecert -pe -n "CN=HYR1" -ss my -sr LocalMachine -sky exchange -eku 1.3.6.1.5.5.7.3.1,1.3.6.1.5.5.7.3.2 -in "PrimaryTestRootCA" -is root -ir LocalMachine -sp "Microsoft RSA SChannel Cryptographic Provider" -sy 12 PrimaryTestCert.cer



# No servidor secundário:

# Abra o CMD com privilégios administrativos e execute o comando abaixo: (na pasta onde você colocou o Makecert.exe).

makecert -pe -n "CN=ReplicaTestRootCA" -ss root -sr LocalMachine -sky signature -r "ReplicaTestRootCA.cer"

makecert -pe -n "CN=HYR2" -ss my -sr LocalMachine -sky exchange -eku 1.3.6.1.5.5.7.3.1,1.3.6.1.5.5.7.3.2 -in "ReplicaTestRootCA" -is root -ir LocalMachine -sp "Microsoft RSA SChannel Cryptographic Provider" -sy 12 PrimaryTestCert.cer


# Os arquivos .cer foram gerados (na pasta onde executou o comando), agora vamos copiar e instalar.

# Depois de criar os certificados vamos copiar e instalar nos servidores:



# No servidor primário:

# Copie o arquivo "ReplicaTestRootCA.cer" que está no servidor secundário para a raiz do disco C: e depois execute o seguinte comando:

certutil -addstore -f Root "ReplicaTestRootCA.cer"




# No servidor secundário:

# Copie o arquivo "PrimaryTestRootCA.cer" que está no servidor primário para a raiz do disco C: e depois execute o seguinte comando:

certutil -addstore -f Root "PrimaryTestRootCA.cer"



# Alterar a chave de registro.

# Isso fará com que não seja verificado a revogação do certificado, que no caso de auto-assinado não funciona.


reg add “HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\Replication” /v DisableCertRevocationCheck /d 1 /t REG_DWORD /f


# Observação: Reinicei o servidor após a alteração da chave.



## Passo 8 ##


# Gerenciamento Remoto em Workgroup.


# Altere a Rede de Pública para Privada.


Get-NetConnectionProfile # Verifica em qual perfil de rede estar configurada atualmente.

Set-NetConnectionProfile -InterfaceAlias "Ethernet" -NetworkCategory Private # Altera a perfil da rede para privada.

# Obervação:

# Este comando também deve ser executado no Windows 10.



Set-NetConnectionProfile -InterfaceAlias "REDE VM" -NetworkCategory Private # Altera a perfil da rede para privada.

Set-NetConnectionProfile -InterfaceAlias "REDE HOST DE HYPER-V" -NetworkCategory Private # Altera a perfil da rede para privada.


# Obervação:

# Este comando também deve ser executado em ambos servidores do Hyper-V 2019.



# Habilitar o gerenciamento remoto.


Enable-PSRemoting


# Obervação:

# Este comando deve ser executado no Windows 10.



# Habilita a delegação para os hostnames especificados.

Get-WSManCredSSP  # Verfica a delegação.

$servers = "HYR1", "HYR2" # Adicione aqui os hostnames do servidores para delegação.

Enable-WSManCredSSP -Role "Client" -DelegateComputer $servers


# Obervação:

# Este comando deve ser executado no Windows 10.
 
 

# Adicionar os hostsnames confiáveis.


Get-Item -Path WSMan:\localhost\Client\TrustedHosts # Verfica os hostsnames confiáveis.

Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value HYR1  # Adiciona o hostname HYR1 ao hosts confiáveis.

$curList = (Get-Item WSMan:\localhost\Client\TrustedHosts).value

Set-Item WSMan:\localhost\Client\TrustedHosts -Value "$curList, HYR2" # Adiciona o hostname HYR2 ao hosts confiáveis.


# Obervação:

# Este comando deve ser executado no Windows 10.



# Adiciona a credencial especificada ao computador.


cmdkey /list # Lista as credenciais. 

cmdkey /add:HYR1 /user:Administrator /pass:@abc123 # Adiciona a credencial especificada ao computador.

cmdkey /add:HYR2 /user:Administrator /pass:@abc123 # Adiciona a credencial especificada ao computador.


# Obervação:

# Este comando deve ser executado no Windows 10.


# Teste de conexão Remota Powershell ( Verficar se realemnte a configuração estar funcionando).

Enter-PSSession -ComputerName HYR1

Enter-PSSession -ComputerName HYR2


# Obervação:

# Este comando deve ser executado no Windows 10.


## Passo 9 ##

# Toda parte de configuração, habilitação do Hyper-V Réplica no Host de Hyper-V e na máquina virtual será demostrada em vídeo. Os teste do Hyper-V Réplica também será demostrado em vídeo.

# Link para o vídeo: https://youtu.be/7qFN0OzkGWY
