-----
copy of my repo at notabug.org , so main branch is 'master', not github's 'main'.
-----
## See 'master' branch.
-----
### Brif

**State:**  
: in progress  
**Stage:**  
: scope design  

* About
  - Aim is to make full OS and software insatallation and configuration whith no pain.  
  - Script have to automate steps after installing Arch Linux on my PC.  

### Overview

##### Script have to (general workflow) :
* **01. Upgrade/update system after installation.**  
* **02. Make base system-wide configurations.**  
* **03. Prepare infrastructure and install main packages (base env);**  
* **04. Configure main packages with user dotfiles (base env);**  
* **05. Prepare infrastructure, install VM and environments managers;**  
* **06. Install and configure user environments and VM-s;**  
* **07. Install and configure current active project environments and VM-s;**  

###### Concept notes:
  - Workflow devided into **STAGES**.  
  - Stages, which needs reboot, are located in **separate scripts**.  
  - Head .sh is to rule stages workflow via sequential execution of functions.  
  - Base actions are is in separate 'functions'.  
  - Data for messages and configs are in separate files.  

###### Repo:
  - **'exp'** folder - to store final, tested artifacts;
  - **'sh'** folder - to store scripts in development;
  - **'tests'** folder - to store tests;
  - **'in'** folder - to store additional data;
  - **'org'** folder - to store details, notes, TODO-s, ... ; 

### Important notes

- Don't panic.
- ...
- ...
