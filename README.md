### Brif

State:
: in progress
Stage:
: scope design

### About
Script to automate steps after installing Arch Linux on my PC.

### Overview
General workflow is:
00. Arch Linux official installer finished succesfully.
Script have to :
01. Base system config ('first steps').
02. Setup timeserver, enable timerver service.
03. Install Intel microcode.
04. Install Nvidia drivers.
05. Install wacom drivers ( ? and soft ? ).
06. Install fonts.
07. Install packages for base environment ('evergreens').
08. Setup packages for base environment (load and place dotfiles).
09. Install environment manager (miniconda3).
10. Install and setup environments.
11. ?

Workflow devided into stages.
Stages, which needs reboot, are located in separate scripts.
Head .sh is to rule stages workflow via sequential execution of functions.
Base actions are is in separate 'functions'.
Data for messages and configs are in separate files.

### TODO

- [ ] 1. ...
- [ ] 2. ...
- [ ] 3. ...
- [ ] 4. ...

### Important notes

- aaa
- bbb
- ccc




##### Create a new repository on the command line

- touch README.md .gitignore (or copy from my notebug notes)
- git init
- git add README.md
- git commit -m "first commit"
- git remote add origin git@notabug.org:myroot/os_install.git
- git push -u origin master

##### Push an existing repository from the command line

- git remote add origin git@notabug.org:myroot/os_install.git
- git push -u origin master


##### Repo link

git@notabug.org:myroot/os_install.git
