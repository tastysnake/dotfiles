# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc


# Personal entry to get a "beep" in the console
export BEEP="${HOME}/.local/share/pop.wav"
alias beep='aplay $BEEP &> /dev/null'

# As I don't like the prompt, here's mine
export PS1='\[\033[1m\]<\u@\h:\W \$> \[\033[0m\]'

# ~/bin to PATH
if [[ "$PATH" != *"$HOME/bin"* ]]; then
    export PATH="${PATH}:${HOME}/bin"
fi

# QT5 for Okular and other QT apps
export QT_QPA_PLATFORMTHEME=qt5ct

# Use Vim as editor
export EDITOR="/usr/bin/vimx"
