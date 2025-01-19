# Debian/Ubuntu Linux Environment Setup

For Ubuntu laptops, [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers), [GitHub Codespaces](https://docs.github.com/en/codespaces/overview), and Chromebook.

## Copy Repo

```console
git clone https://github.com/pkdone/dotfiles.git
```

## Set Up Terminal, Shell And Aliases

```console
cp dotfiles/bash_aliases ~/.bash_aliases
cp dotfiles/config.fish ~/.config/fish/config.fish
cp dotfiles/config.ghostty ~/.config/ghostty/config
# TODO: install Ghostty
sudo apt install -y fish
chsh -s /usr/bin/fish

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
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb
```

## Install Docker

```console
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

if uname -n | grep -q "penguin"; then
  sudo apt install -y docker-compose
  printf "\nACTION: On Chromebook, the user's password is not known, so right-click (Super-<mouse-click>) the terminal's icon and select 'Shut down Linux' and then start Linux again\n\n"
else
  sudo apt install -y docker-compose-v2
  su - $USER
fi
```

```console
docker run hello-world
docker ps -a
```

## Install Node.js & TypeScript

```console
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt install nodejs
sudo npm install -g typescript
```

## Install MongoDB Enterprise
```console
sudo apt install -y gnupg curl

curl -fsSL https://pgp.mongodb.com/server-8.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
   --dearmor

if cat /etc/issue | grep -q "Ubuntu"; then
  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.com/apt/ubuntu noble/mongodb-enterprise/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-enterprise-8.0.list
else
  echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] http://repo.mongodb.com/apt/debian bookworm/mongodb-enterprise/8.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-enterprise.list
fi

sudo apt update
sudo apt install -y mongodb-enterprise
mkdir -p ~/db/data
cp dotfiles/mongod_local.conf ~/db/mongod_local.conf
mongod -f ~/db/mongod_local.conf
```

## Install VS Code

```console
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code
rm -f packages.microsoft.gpg
echo "Start VS Code and enable sync settings using your GitHub ID"
```

## Clean Up

```console
rm -rf dotfiles
```
