# Debian/Ubuntu Linux Environment Setup

## Copy Repo

```console
git clone https://github.com/pkdone/dotfiles.git
```

## Initialise System

```console
sudo apt update && sudo apt upgrade
cp dotfiles/.bash_aliases ~/
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
# Turn on sync settings in VS Code
```

## Clean Up

```console
rm -rf dotfiles
```