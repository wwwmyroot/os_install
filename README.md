Selecting deleted buffer### Brif

| State: | in progress |
| Stage: | scope design & first MVP dev |

Automating postinstall procedures.
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




##### Create a new repository on the command line

- touch README.md
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
