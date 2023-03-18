# Linux Env Setup

## Copy Repo

```console
git clone https://github.com/pkdone/dotfiles.git
```

## Restore Dotfiles

```console
cp dotfiles/.bash_aliases ~/
```

## Install Google Chrome

```console
curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
```

## Clean Up

```console
rm -rf dotfiles
```
