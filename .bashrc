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

# For "rescreen" program
trap "if [ -f "$HOME/.rescreen_environment" ]; then source $HOME/.rescreen_environment; fi" SIGUSR1

# Use pythonbrew for a locally-installed Python
if [ -s "$HOME/.pythonbrew/etc/bashrc" ]; then
    source "$HOME/.pythonbrew/etc/bashrc"
fi

# Use perlbrew for a locally-installed perl (see
# http://beta.metacpan.org/module/App::perlbrew)
# Modules inside the chosen perl's directory in ~/perl5/perlbrew/ do not
# require local::lib
perlbrew_bashrc="$HOME/perl5/perlbrew/etc/bashrc"
if [ -f "$perlbrew_bashrc" ]; then
    source "$perlbrew_bashrc"
fi

# Use the Perl 6 installed via nxadm/rakudo-pkg
if [ -d "/opt/rakudo-pkg/bin" ]; then
    PATH="/opt/rakudo-pkg/bin:$PATH"
    PATH="$HOME/.perl6/bin:$PATH"
fi

# Use rakudobrew for a locally-installed Perl 6
if [ -d "$HOME/.rakudobrew" ]; then
    PATH="$HOME/.rakudobrew/bin:$PATH"
fi

# Use local::lib for locally-installed CPAN modules (usually used when
# perlbrew is not being used)
if [ -d "$HOME/perl5/lib/perl5" ]; then
    if [ $(which perl) == '/usr/bin/perl' ]; then
        eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)
    fi
fi

if [ -d "$HOME/opt/local/pinto" ]; then
    if [[ "$(which perl)" == */perl-5.18.0/* ]]; then
        source "$HOME/opt/local/pinto/etc/bashrc"
        export PINTO_REPOSITORY_ROOT="$HOME/perl5/perlbrew/perls/perl-5.18.0/pinto/"
    fi
fi

# Node.js: allow "global" install of modules in $HOME
# http://stackoverflow.com/a/13021677/1265245
NPM_PACKAGES="$HOME/.npm-packages"
if [ -d "$NPM_PACKAGES" ]; then
    PATH="$NPM_PACKAGES/bin:$PATH"
    export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
fi

# If using nave (https://github.com/isaacs/nave), consider its
# globally-installed npm modules as well
if [ -n "$NAVEPATH" ]; then
    PATH="$NAVEPATH:$PATH"
fi

# Vert.x development: http://vertx.io/install.html
if [ -d "$HOME/opt/local/vert.x" ]; then
    PATH="$HOME/opt/local/vert.x/bin:$PATH"
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

# TODO Move json_* functions into their own shell/Perl scripts in ~/bin/

# Usage:
# $ echo '["red","green","blue"]' | json_tidy
json_tidy () {
  perl -MJSON::PP \
  -e 'local $/; binmode STDIN; $_ = <STDIN>;' \
  -e 'syswrite STDOUT, JSON::PP->new' \
  -e '->pretty(1)->indent_length(2)' \
  -e '->encode(JSON::PP->new->decode($_));'
}

alias grep='grep --color' # Highlight the search for grep in red

# Shell variable used by less(1), for configuration
export LESS='--chop-long-lines --ignore-case --RAW-CONTROL-CHARS --force'

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

# "Pop last"
# (Use 'popd' without arguments to pop off the "top" [first] directory)
popl () {
    popd -0
}

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
# TODO Truncate \W if it is too long
export PS1="[\u@\h \W]\$ "

if hash pt 2>/dev/null; then
    export PROMPT_COMMAND='export PIPTIME="$(pt)"'
    export PS1='[${PIPTIME} \W/]\$ '
fi

export PATH
