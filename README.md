# Debian/Ubuntu Linux Environment Setup

## Copy Repo

```console
git clone https://github.com/pkdone/dotfiles.git
```

## Initialise System

```console
sudo apt update && sudo apt upgrade
cp dotfiles/.bash_aliases ~/
exit
```

## If On Chromebook Linux, Reset Password

```console
sudo su
# passwd <username>
```

## Install Google Chrome

```console
curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
```

## Install VS Code

```console
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y code # or code-insiders
rm packages.microsoft.gpg
# Turn on sync settings in VS Code using GitHub id
```

## Install Docker

```console
sudo apt install -y docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
exit
```

```console
docker run hello-world
docker ps -a
```

## Installl Node.js

```console
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt install nodejs
```

## Install MongoDB Enterprise
```console
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
if cat /etc/issue | grep -q "Ubuntu"; then
  echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
else
  echo "deb http://repo.mongodb.com/apt/debian bullseye/mongodb-enterprise/6.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-enterprise.list
fi
sudo apt-get update
sudo apt-get install -y mongodb-enterprise
mkdir -p ~/db/data
cat > ~/db/mongod_local.conf <<EOF
storage:
    dbPath: "$HOME/db/data"
    journal:
        enabled: true
systemLog:
    destination: file
    path: "$HOME/db/data/mongodb.log"
    logAppend: true
processManagement:
    fork: true
net:
    bindIp: 0.0.0.0
    port: 27017
#security:
#    authorization: enabled
EOF
mongod -f ~/db/mongod_local.conf
```

## Clean Up

```console
rm -rf dotfiles
```
