# Debian/Ubuntu Linux Environment Setup

For Ubuntu laptop, [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers), [GitHub Codespaces](https://docs.github.com/en/codespaces/overview), and Chromebook.

## Copy Repo

```console
git clone https://github.com/pkdone/dotfiles.git
```

## Set Up Shell Aliases

```console
cp dotfiles/.bash_aliases ~/

if uname -n | grep -q "penguin"; then
  # On Chromebook, password not known so instead, need to log out of the terminal and back in again
  exit
else
  su - $USER
fi
```

## Install Google Chrome

```console
curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb
```

## Install Docker

```console
sudo apt install -y docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

if uname -n | grep -q "penguin"; then
  printf "\nACTION: On Chromebook, the user's password is not known, so you must completely sign out of ChromeOS and then sign back in again\n\n"
else
  su - $USER
fi
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
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor   

if cat /etc/issue | grep -q "Ubuntu"; then
  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.com/apt/ubuntu jammy/mongodb-enterprise/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-enterprise-7.0.list   
else
  echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.com/apt/debian bookworm/mongodb-enterprise/7.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-enterprise.list  
fi

sudo apt-get update
sudo apt-get install -y mongodb-enterprise
mkdir -p ~/db/data

cat > ~/db/mongod_local.conf <<EOF
storage:
    dbPath: "$HOME/db/data"
    #journal:
    #    enabled: true
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

## Install VS Code

```console
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y code
rm -f packages.microsoft.gpg
echo "Start VS Code and enable sync settings using your GitHub ID"
```

## Clean Up

```console
rm -rf dotfiles
```
