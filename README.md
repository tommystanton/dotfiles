# Dotfiles

## Overview

This repo is a skeleton/template/vanilla version of my dotfiles.  It contains a
utility to help with managing and updating your dotfiles like I manage mine.

## Using this repo

First, fork this repo.

Then, add your dotfiles:

    $ git clone git@github.com:username/dotfiles.git
    $ cd dotfiles
    $  # edit files
    $  # edit files
    $ git push origin master

Finally, to install your dotfiles onto a new system:

    $ cd $HOME
    $ git clone git@github.com:username/dotfiles.git .dotfiles
    $ ./.dotfiles/bin/dfm  # creates symlinks to install files

...and for this __tstanton__-specific setup:

    $ ./.dotfiles/bin/dfm submodule init
    $ ./.dotfiles/bin/dfm submodule update
    $ vim +PluginInstall +qall

## Full documentation

For more information, check out the [wiki](http://github.com/justone/dotfiles/wiki).

You can also run <tt>dfm --help</tt>.

## My dotfiles

My dotfiles are in the <tt>personal</tt> branch.
