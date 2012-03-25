# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions

cache_ssh_key () {
    if [ -z "$SSH_AUTH_SOCK" ]; then
        eval $(/usr/bin/ssh-agent -s)
        trap "kill $SSH_AGENT_PID" 0 && \
            echo "ssh-agent (PID ${SSH_AGENT_PID}) will be killed" \
                 "when this shell is exited"
    fi

    # Cache password for private key
    /usr/bin/ssh-add "$@"
}

# Use perlbrew for a locally-installed perl (see
# http://beta.metacpan.org/module/App::perlbrew)
# Modules inside the chosen perl's directory in ~/perl5/perlbrew/ do not
# require local::lib
perlbrew_bashrc="$HOME/perl5/perlbrew/etc/bashrc"
if [ -f "$perlbrew_bashrc" ]; then
    source "$perlbrew_bashrc"
fi

# Use local::lib for locally-installed CPAN modules (usually used when
# perlbrew is not being used)
if [ -d "$HOME/perl5/lib/perl5" ]; then
    if [ $(which perl) == '/usr/bin/perl' ]; then
        eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)
    fi
fi

# ex. Do 'perl_inc -Mlib::core::only' to see how @INC is affected
perl_inc () {
    perl $1 -e 'for (@INC) { print "$_\n"; }'
}

# Get the $VERSION of a Perl CPAN module
perl_pmver () {
    # ('mversion' is provided by the Module-Version distribution)
    hash mversion 2>&-

    if (( $? == 0 )); then
        mversion $1
    else
        perl -M$1 -e "print \$$1::VERSION, \"\n\""
    fi
}

# Do a stack trace via diagnostics.pm
perl_trace () {
    perl -Mdiagnostics=-traceonly $@
}

alias grep='grep --color' # Highlight the search for grep in red

# Shell variable used by less(1), for configuration
export LESS='--ignore-case --RAW-CONTROL-CHARS --force'

# Subversion config
export SVN_EDITOR='/usr/bin/env vim'

# For lynx
export TMPDIR='/tmp'

# Usage:
# $ mv -v "my file" $(to_underscores !#:2)
# mv -v "my file" $(to_underscores "my file")
# `my file' -> `my_file'
# TODO Consider https://metacpan.org/release/String-MFN
to_underscores () {
    echo "$1" | perl -pe '$_ =~ s/\s*([:-])\s*/$1/g; $_ =~ s/ /_/g;'
}

# Returns the package name that gives an exact program
# Usage:
# $ which_pkg convert
# graphicsmagick-imagemagick-compat: /usr/bin/convert
# imagemagick: /usr/bin/convert
# imagemagick-dbg: /usr/lib/debug/usr/bin/convert
which_pkg () {
    # TODO Check for whether the system has apt or yum--if yum, use
    # $ yum whatprovides "*bin/$1"
    apt-file -x search "bin/$1\$"
}

dirs () {
    # Perl one-liner time...this was cooked up during my presentation at
    # Los Angeles Perl Mongers on 11/4/2009.
    builtin dirs -p | perl -pe '$_ = $. - 1 . q{ } . $_'
}

pushd () {
    # Don't let the builtin print the builtin dirs output (but error
    # messages via STDERR are okay)
    builtin pushd "$@" > /dev/null

    # If there was no error (and no error message)
    if (( $? == 0 )); then
        # Call the overridden dirs, for its pretty output
        dirs
    fi
}

popd () {
    builtin popd $@ > /dev/null
    if (( $? == 0 )); then
        dirs
    fi
}

# "Pop last"
popl () {
    popd -0
}

# (Use 'popd' without arguments to pop off the "top" [first] directory)

cd () {
    builtin cd "$@" && dirs
}

termsize () {
    echo "Your terminal size is: $(tput cols)x$(tput lines)"
}

# (Load original shell settings from the distribution)
dfm_bashrc_loader="$HOME/.bashrc.load"
if [ -f "$dfm_bashrc_loader" ]; then
    . "$dfm_bashrc_loader"
fi

# Force shell prompt to be the basic Red Hat style
export PS1="[\u@\h \W]\$ "

if hash pt 2>/dev/null; then
    export PROMPT_COMMAND='export PIPTIME="$(pt)"'
    export PS1='[${PIPTIME} \W/]\$ '
fi

export PATH
