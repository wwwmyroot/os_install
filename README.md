### Brif

**State:**
: in progress
**Stage:**
: scope design

### About

Aim is to make full OS and software insatallation and configuration whith no pain.

Script have to automate steps after installing Arch Linux on my PC.

### Overview

##### Script have to (general workflow) :
**01. Upgrade/update system after installation.**
**02. Make base system-wide configurations.**
**03. Prepare infrastructure and install main packages (base env);**
**04. Configure main packages with user dotfiles (base env);**
**05. Prepare infrastructure, install VM and environments managers;**
**06. Install and configure user environments and VM-s;**
**07. Install and configure current active project environments and VM-s;**
**
##### Workflow details
**00. Arch Linux official installer finished succesfully.**
*  - only official installer ("archlinux install");
  - GRUB;
  - locale: "US";
  - host name: "pc";
  - user name: "al";
  - user is in "wheel" group & user is sudo-er;
  - bspwm (tile windows manager), sxhkd (keyboard manager);
  - ? NOTE: get json after official installer setup;
  - ?
**01. Base system config ('first steps').**
  - update keyring;
  - partial update;
  - system update/upgrade;
  - ? ...
**02. Setup timeserver, enable nth-server as a service.**
**03. Install X11, x-server.**
****04. Install Intel microcode.**
  - ? upgrade grub ->? reboot ? 
```
grub install ...                # define
grub-mkconfig -o /boot/grub.cfg
```

**05. Install solutions for unknown devices [2023-11-29].** 
```
  - gla2xx -> pkg "linux-firmware-qlogic";
  - aic94xx -> pkg _AUR_ "aic94xx-firmware";
  - qla1280 -> pkg "linux-firmware-qlogic";
  - bfa -> pkg "linux-firmware-qlogic";
  - qed -> pkg "linux-firmware-qlogic";
  - wd719x -> pkg _AUR_ "wd719x-firmware" -> ($ sudo pacman -S lha);
  - xhpci_pci *->* _AUR_ "upd72020x-fw"
```
**04. Install Nvidia drivers.**
**05. Install wacom drivers ( ? and soft ? ).**
**06. Install locale "RU".

```
  - echo "" >> .xinitrc
```
**06. Install fonts.**
**07. Install packages for base environment ('evergreens').**
**08. Setup packages for base environment (load and place dotfiles).**
**09. Install environment manager (miniconda3).**
**10. Install and setup environments.**
**11. ? ...**

Workflow devided into **STAGES**.
Stages, which needs reboot, are located in **separate scripts**.
Head .sh is to rule stages workflow via sequential execution of functions.
Base actions are is in separate 'functions'.
Data for messages and configs are in separate files.

### TODO

- [ ] Get configuration of official arch-installer (.json) in stage_00.
- [ ] Clear architecture plan.
- [ ] Define 'sanitaize'. [to read_01](https://github.com/picodotdev/alis)
- [ ] Define using separate configs for bash scripts. [to read_01](https://unix.stackexchange.com/questions/175648/use-config-file-for-my-shell-script)
- [ ] ...


### Important notes

- Don't panic.
- ...
- ...

###### Create a new repository on the command line

- touch README.md .gitignore (or copy from my notebug notes)
- git init
- git add README.md
- git commit -m "first commit"
- git remote add origin git@notabug.org:myroot/os_install.git
- git push -u origin master

###### Push an existing repository from the command line

- git remote add origin git@notabug.org:myroot/os_install.git
- git push -u origin master


###### Repo link

git@notabug.org:myroot/os_install.git
