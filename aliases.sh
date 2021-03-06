# Useful aliases for cs161

os161-build() {
    if [ -z "$1" ]; then
        echo "Usage: kbuild ASSTN"
        return 1
    fi
    pushd "$HOME/cs161/os161/kern/compile/$1"
    bmake -j4 && bmake install -s
    popd
}

os161-config() {
    if [ -z "$1" ]; then
        echo "Usage: kconfig ASSTN"
        return 1
    fi
    pushd "$HOME/cs161/os161/kern/conf"
    ./config "$1"
    popd
    pushd "$HOME/cs161/os161/kern/compile/$1"
    bmake -s -j4 depend
    popd
    os161-build "$1"
}

os161-run() {
    bash -c "cd ~/cs161/root && sys161 kernel \"$@\""
}

os161-debug() {
    bash -c "cd ~/cs161/root && sys161 -w kernel \"$@\""
}

os161-user-build() {
    if [ "$1" ]; then
        pushd "$HOME/cs161/os161/userland/$1"
        bmake depend -s && bmake && bmake install
        return 0
    fi
    pushd "$HOME/cs161/os161/"
    bmake -s
    popd
    pushd "$HOME/cs161/os161/userland"
    bmake -s -j4 depend && bmake -s -j4 && bmake install -s -j4
    popd
}

# Aliases for searching. Should run from top-level os161 directory
# e.g. gg "syscall"
alias gg='git grep -ni'
alias todo='gg TODO'

# Aliases to config, build, run, debug, and start gdb
# kc and kb take a configuration file in kern/conf as an argument.
# e.g. kc ASST0
# e.g. kb ASST3-OPT
alias kc='os161-config'
alias kconfig=kc
alias kb='os161-build'
alias kbuild=kb
alias kr='os161-run'
alias krun=kr
alias kd='os161-debug'
alias kdebug=kd
alias kg='cd ~/cs161/root && os161-gdb kernel'
alias kgdb=kg
alias ub='os161-user-build'
alias ubuild=ub

# Aliases to move to common directories
alias cdk='cd $HOME/cs161/os161'
alias cdr='cd $HOME/cs161/root'
alias cdu='cd $HOME/cs161/os161/userland'
