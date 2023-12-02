#!bin/bash
#
# ------ 01
## https://github.com/bianjp/archlinux-installer/blob/master/setup.sh
## --- for locale.conf
# Locale
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
sed -i 's/^#zh_CN.GB18030/zh_CN.GB18030/' /etc/locale.gen
sed -i 's/^#zh_CN.UTF-8/zh_CN.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
##
##
# Install intel-ucode for Intel CPU
is_intel_cpu=$(lscpu | grep 'Intel' &> /dev/null && echo 'yes' || echo '')
if [[ -n "$is_intel_cpu" ]]; then
  pacman -S --noconfirm intel-ucode --overwrite=/boot/intel-ucode.img
fi
##
##
# Config sudo
# allow users of group wheel to use sudo
sed -i 's/^# %wheel ALL=(ALL) ALL$/%wheel ALL=(ALL) ALL/' /etc/sudoers
##
##
##
# Create regular user
useradd -m -g users -G wheel -s /bin/bash $username
echo "$username:$password" | chpasswd

# Desktop Environment
# xorg
pacman -S --noconfirm xorg-server

# graphics driver
nvidia=$(lspci | grep -e VGA -e 3D | grep 'NVIDIA' 2> /dev/null || echo '')
amd=$(lspci | grep -e VGA -e 3D | grep 'AMD' 2> /dev/null || echo '')
intel=$(lspci | grep -e VGA -e 3D | grep 'Intel' 2> /dev/null || echo '')
if [[ -n "$nvidia" ]]; then
  pacman -S --noconfirm nvidia
fi

if [[ -n "$amd" ]]; then
  pacman -S --noconfirm xf86-video-amdgpu
fi

if [[ -n "$intel" ]]; then
  pacman -S --noconfirm xf86-video-intel
fi

if [[ -n "$nvidia" && -n "$intel" ]]; then
  pacman -S --noconfirm bumblebee
  gpasswd -a $username bumblebee
  systemctl enable bumblebeed
fi

##
##
# automatic date and time
sudo systemctl enable systemd-timesyncd.service
##
### SSH config
grep '^Host' /etc/ssh/ssh_config &> /dev/null || sudo tee -a /etc/ssh/ssh_config <<EOF
Host *
    ServerAliveCountMax 5
    ServerAliveInterval 10
EOF
##
##
# The given code is a bash script that modifies the SSH configuration file (/etc/ssh/ssh_config) to add or update the "ServerAliveCountMax" and "ServerAliveInterval" parameters for all hosts.

# Let's break down the code step by step:

# 1. `grep '^Host' /etc/ssh/ssh_config &> /dev/null`
# - This command searches for lines starting with "Host" in the SSH configuration file.
# - The output of this command is redirected to /dev/null, which means it is discarded and not displayed.

# 2. `||`
# - This is a logical OR operator in bash.
# - If the previous command (grep) fails to find any lines starting with "Host", the following command will be executed.

# 3. `sudo tee -a /etc/ssh/ssh_config <<EOF`
# - This command uses the `tee` command with sudo privileges to append the following lines to the SSH configuration file.
# - The `<<EOF` syntax is used to indicate the start of a multiline input.

# 4. `Host *`
# - This line specifies that the following configurations apply to all hosts.

# 5. `ServerAliveCountMax 5`
# - This line sets the maximum number of server alive messages that can be sent without receiving any response to 5.
# - Server alive messages are used to keep the SSH connection alive.

# 6. `ServerAliveInterval 10`
# - This line sets the interval (in seconds) between server alive messages to 10.
# - It determines how often the client sends a server alive message to the server.

# 7. `EOF`
# - This marks the end of the multiline input.
# - The `tee` command will write the provided lines to the SSH configuration file.

# In summary, this bash script checks if the SSH configuration file contains any lines starting with "Host". If not, it adds the specified lines (ServerAliveCountMax and ServerAliveInterval) to the file for all hosts. These lines control the number of server alive messages and the interval between them, helping to maintain a stable SSH connection.
##
##
##
##
##
##
##
##
##
##
##
##
##
##
## to work eith user input:
read -r -p "Delete /archlinux-installer folder? [y/N]" confirm
if [[ "$confirm" =~ ^(y|Y) ]]; then
  sudo rm -rf /archlinux-installer
fi
##
##
read -r -p "Have you already partitioned your disk, built filesystem, and mounted to /mnt correctly? [y/N]" confirm
if [[ ! "$confirm" =~ ^(y|Y) ]]; then
  exit
fi
##
##
##
## ############################################################################
## https://github.com/picodotdev/alis/blob/master/alis-packages.sh
##
## --- обход файлов в папке
##
script_folder="$(pwd)"
#
#
function list_pwd_3() {
    local wpath="$script_folder/*"
    for file in $wpath
    do
        if [ -d "$file" ]
        then
            echo "$file |--###-> is a directory"
        elif [ -f "$file" ]
        then
            echo "$file |--###-> is a file"
        fi
    done
}
