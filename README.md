cs161-bashrc
============

bashrc file for cs161 development

By Kenny Yu

## Dependencies

These tools require expect and rlwrap

### Mac

    brew install rlwrap

### Ubuntu
    sudo apt-get install rlwrap expect

## Install

    cd ~
    git clone https://github.com/kennyyu/cs161-bashrc.git
    cp ~/cs161-bashrc/bashrc ~/.bashrc && source ~/.bashrc

## Contents

* `bashrc` - contains a prompt that shows the current branch; sources aliases
* `aliases.sh` - contains useful aliases for working with os161
* `git-prompt.sh` - library for adding git information to the prompt
