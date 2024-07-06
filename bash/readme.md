# Bash Configuration Files

This is my personal bash configuration file.


## ALIASES

### Useful / utils

* `bashrc` -> `source "${HOME}/.bashrc"`
* `clr` -> `clear`
* `..` -> `cd ..`
* `...` -> `cd ../..`
* `.3` -> `cd ../../..`
* `.4` -> `cd ../../../..`
* `.5` -> `cd ../../../../..`
* `e` -> `$EDITOR`
* `m` -> `micro`

### Eza / Ls

Will use `eza` if installed, else will use `ls`. You can use `\ls` to use the GNU `ls`.

* `ls` -> Colors and Directories First
* `ll` -> Long listing
* `la` -> Long listing including hidden files
* `lt` -> Tree Listing
* `lg` -> Display group ownership
* `ld` -> Directories only

### Alternative

If Available, It will replace certain command with alternative ones. You can use `\command` to use the the original `command`.

* `grep` -> `rg` Ripgrep alternative
* `cat` -> `bat` / `batcat` Bat alternative
* `find` -> `fd` Find alternative

### Git

* `ga` `gitadd` -> `git add`
* `gall` `gitall` -> `git add -A`
* `gc` `gitcommit` -> `git commit -a -S -m`
* `gp` `gipush` -> `git push`
* `grm` `gitrm` -> `git rm --cached`
* `grmd` `girmd` -> `git rm -r --cached`
* `gs` `gitstatus` -> `git status`
* `gu` `gitaddu` -> `git add -u`
* `gitpull` -> `git pull`

### Docker Compose

* `dcup` -> `docker-compose up -d --forcerecreate && dockercompose logs -tf`
* `dcdwn` -> `docker-compose down`
* `dcupt` -> `docker compose pull && docker-compose up -d --remove-orphans && docker-compose image prune && docker-compose logs -tf`
* `dclog` -> `docker-compose logs -tf`


## FUNCTIONS

Useful functions that can be use in the shell.

### Navigation

* `mkcd` -> `mkdir -p` + `cd`
* `cdls` -> `cd` + `ls`
* `cdll` -> `cd` + `ll`
* `cdla` -> `cd` + `la`

### Extract Archive

* `ex`

You can use this function to extract one or multiple archives of various format.

Require the following programs:

* `tar` -> `*.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar`
* `7z` -> `*.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar`
* `unzip` -> `*.cbz|*.epub|*.zip`
* `unrar` -> `*.cbr|*.rar`
* `unace` -> `*.cba|*.ace`
* `unlzma` -> `*.lzma`
* `bunzip2` -> `*.bz2`
* `gunzip` -> `*.gz`
* `uncompress` -> `*.z`
* `unxz` -> `*.xz`
* `cabextract` -> `*.exe`
* `cpio` -> `*.cpio`

### Backup files / folders

* `backup`

You can use this function to backup a `file` -> `file-YYYY-MM-DD.bck` or a `directory` -> `directory-YYYY-MM-DD.tar.gz`.

* `cleanbck`

You can use this function to cleanup all `.bck` files in the given directory (Not recursive)


## PROMPT

The prompt is aimed to be minimal and only display information when needed.

### Local Minimal Prompt

If use is not root, and connection to the terminal is local.

````
   HH:MM ●●● ~/.../path/3/depth
         ⮊
````

If user is root

````
   HH:MM ●●● ~/.../path/3/depth
         ROOT ⮊
````

### Container Prompt

If use inside a container, the prompt change a bit.

````
   HH:MM ●●● [CT] [hostname] ~/.../path/3/depth
         user ⮊
````

### SSH Prompt

If use inside a SSH session, the prompt change a bit.

````
   HH:MM ●●● (SSH) (hostname) ~/.../path/3/depth
         user ⮊
````

### SSH to Container Prompt

If use inside a SSH session to a container machine.

````
   HH:MM ●●● (SSH) [hostname] ~/.../path/3/depth
         user ⮊
````

### Inside a git repository

If current directory is a git repository with a defined branch.

````
   HH:MM ●●● ~/.../path/3/depth      (branch|+MDR?S)
         ⮊
````

* `branch` is the branch name
* `+` OPTIONAL files have been staged (ready for the next commit)
* `M` OPTIONAL tracked files have been modified and not staged
* `D` OPTIONAL tracked files have been deleted and not staged
* `R` OPTIONAL tracked files have been renamed and not staged
* `?` OPTIONAL untracked files in the directory
* `S` OPTIONAL stached files
* `` OPTIONAL branch is ahead of remote (need push)
* `` OPTIONAL branch is behind of remote (need pull)
* `Empty` instead of `branch`, mean that git is initialized but the commit tree is empty for the branch.

### Virtual env (venv or pyvenv)

It assumed that for the folder `MY-Project`, project name will be MY-Project, and the virtual environement is inside a `.venv` folder.

To create a virtual environment from inside the project root folder `python -m venv .venv`.

To activated the venv `activate`, to deactivate the venv `deactivate`

* White: Current directory have a virtual environment available. (No venv activated)
* Green: Current directory have a virtual environment available. (activated)
* Yellow: Current directory does not have a virtual environment available but one is activated!

````
   HH:MM ●●● ~/.../path/3/depth      |venv:project|
         ⮊
````

* Red: Current directory have a virtual environment available but another one is activated!

````
   HH:MM ●●● ~/.../path/3/depth      |venv:project ! activated: venv|
         ⮊
````
