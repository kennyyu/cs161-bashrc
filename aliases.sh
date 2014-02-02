# Useful aliases for cs161

function os161-build {
    cd ~/cs161/os161/kern/compile/${1} \
    && bmake depend \
    && bmake \
    && bmake install
    cd -
}

function os161-config {
    cd ~/cs161/os161/kern/conf \
    && ./config ${1}
    cd -
}

function os161-run {
    cd ~/cs161/root && sys161 kernel
}

function os161-debug {
    cd ~/cs161/root && sys161 -w kernel
}

function os161-user-build {
    cd ~/cs161/os161/userland \
    && bmake depend \
    && bmake \
    && bmake install
    cd -
}

# Case insensitive search. Searches relative to the current directory
function search {
    git grep -n -i ${1}
}

# Finds "todo" (case insensitive) relative to the current directory
function todo-search {
    search "todo"
}

# Aliases for searching. Should run from top-level os161 directory
alias gg='search'
alias todo='todo-search'

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
alias cdk='cd ~/cs161/os161'
alias cdr='cd ~/cs161/root'
alias cdu='cd ~/cs161/os161/userland'
