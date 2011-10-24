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
if [ -f "$HOME/perl5/perlbrew/etc/bashrc" ]; then
    source $HOME/perl5/perlbrew/etc/bashrc
fi;

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

## FIXME Doesn't quite work as intended, the log ends up being
## literally: "$ !#:3-6"
#cpan-commit () {
#    if [ -d $HOME/perl5 ]; then
#        cd $HOME/perl5 && cpanm -L ~/perl5/ $1 && git add . && git commit -m "\$ !#:3-6"
#    fi
#}

# LS SHORTCUTS
alias la='ls -AF' # "list all"
alias ll='ls -lF' # "list long"
alias lla='ls -lAF' # "list long all"
alias lc='ls -1F' # "list column"
alias lca='ls -1AF' # "list column all"

alias grep='grep --color' # Highlight the search for grep in red

## FIXME
#alias svn_commit='svn commit --editor-cmd \'vim -c "set wrap" -c "set lbr"\''

# From Tim Bunce on revision 5035 at TigerLead:
# ignore case in search unless search include upper case chars
# From me:
# Always enable ANSI "color" escape sequences (for , and colored output,
# for ex.)
# Tip: it is sometimes helpful to view terminal logs (from programs like
# GNU screen and script) with 'less -r LOG_FILE'
# --force is used to surpress the '... may be a binary file.  See it
# anyway?' warning.
export LESS='--ignore-case --RAW-CONTROL-CHARS --force'

# For lynx
export TMPDIR='/tmp'

# Usage:
# $ mv -v "my file" $(to_underscores !#:2)
# mv -v "my file" $(to_underscores "my file")
# `my file' -> `my_file'
# TODO Consider http://search.cpan.org/dist/String-MFN/
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

termsize () {
    echo "Your terminal size is: $(tput cols)x$(tput lines)"
}

# PATHS FOR FOLDERS
#export log_screen=$HOME/log-screen
export log_screen=$HOME/log/screen
export ec_repos=$HOME/eulandchina.com/svn ts_repos=$HOME/tommystanton.com/svn
export httpd=/etc/httpd/conf/httpd.conf
export named=/etc/named.conf pri_dir=/var/named/chroot/var/named

## FIXME Messes up scp & sftp
#echo -e "\E[0;32m";
#cat ./.bash_logo;
#tput sgr0;
