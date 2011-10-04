# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH="$HOME/bin:/sbin:/usr/sbin:$PATH"
for interpreter in perl python; do
    if [ -d "$HOME/local${interpreter}" ]; then
        PATH="$HOME/local${interpreter}/bin:$PATH"
    fi;
done
export PATH
