# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions

# Use perlbrew for a locally-installed perl (see
# http://beta.metacpan.org/module/App::perlbrew)
# Modules inside the chosen perl's directory in ~/perl5/perlbrew/ do not
# require local::lib
perlbrew_bashrc="$HOME/perl5/perlbrew/etc/bashrc"
if [ -f "$perlbrew_bashrc" ]; then
    source "$perlbrew_bashrc"
fi

# ex. Do 'perl-inc -Mlib::core::only' to see how @INC is affected
perl-inc () {
    perl $1 -e 'for (@INC) { print "$_\n"; }'
}

# Get the $VERSION of a Perl CPAN module
perl-pmver () {
    perl -M$1 -e "print \$$1::VERSION, \"\n\""
}

# Do a stack trace via diagnostics.pm
perl-trace () {
    perl -Mdiagnostics=-traceonly $@
}

alias grep='grep --color' # Highlight the search for grep in red

# Shell variable used by less(1), for configuration
export LESS='--ignore-case --RAW-CONTROL-CHARS --force'

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
# $ which-pkg convert
# graphicsmagick-imagemagick-compat: /usr/bin/convert
# imagemagick: /usr/bin/convert
# imagemagick-dbg: /usr/lib/debug/usr/bin/convert
which-pkg () {
    # TODO Check for whether the system has apt or yum--if yum, use
    # $ yum whatprovides "*bin/$1"
    apt-file -x search "bin/$1\$"
}

### Override dirs, along with its related functions ###
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
### Custom dirs-related functions ###
# Pop off a directory from the end of the dirs stack
pop () {
    popd -0
}
# XXX Use 'popd' without arguments to pop off the "top" (first)
# directory
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
