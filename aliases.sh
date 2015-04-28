# This should be the root of your os161 git repo
OS161_CODE_DIR="${HOME}/cs161/os161"
# This is where your LHD's, bin, sbin, and testbin install to
OS161_ROOT_DIR="${HOME}/cs161/root"

os161-build() {(
    if [ -z "$1" ]; then
        echo "Usage: $0 ASSTN"
        return 22
    fi
    cd "${OS161_CODE_DIR}/kern/compile/$1"
    bmake  || return 1
    bmake install -s || return 2
)}

os161-config() {(
    if [ -z "$1" ]; then
        echo "Usage: $0 ASSTN"
        return 22
    fi
    pushd "${OS161_CODE_DIR}/kern/conf"
    ./config "$1"
    popd > /dev/null
    pushd "${OS161_CODE_DIR}/kern/compile/$1"
    bmake -s depend || return 1
    popd > /dev/null
    os161-build "$1"
)}

os161-run() {(
  cd ${OS161_ROOT_DIR} && rlwrap -aOS/161 sys161 kernel "$@"
)}


TEST161_TIME_LIMIT="60"  # time to run each test in seconds
os161-runtest() {(
	cd ${OS161_ROOT_DIR} &&
	expect -c '
   log_user 0;
   spawn sys161 -X kernel;
   expect "OS/161 kernel";
   send_user "\n\x1b\[36m❔  test161: running test \"'$@'\" ...\x1b\[0m"
   send "'$@'";
   send "\n";
   log_user 1;
   set timeout '${TEST161_TIME_LIMIT}';
   expect {
     "fail" {
       send_user "\r\x1b\[K\x1b\[33m❌  test161: test outputted \"fail\" \"'$@'\" \x1b\[0m\n";
     }
     "Operation took" {
        expect {
          "OS/161 kernel" {
            send "q\n";
            send_user "\r\x1b\[K\x1b\[32m✅  test161: PASSED \"'$@'\" \x1b\[0m\n";
            exit 0;
          }
          "Menu command failed:" {
            send_user "\r\x1b\[K\x1b\[31m❌  test161: INVALID TEST \"'$@'\" \x1b\[0m\n";
            exit 5;
          }
        }
      }

     "panic:" {
       send_user "\r\x1b\[K\x1b\[31m❌  test161: KERNEL PANIC \"'$@'\" \x1b\[0m\n";
       exit 5;
       }

     timeout {
        send_user "\r\x1b\[K\x1b\[33m❔  test161: TIMEOUT \"'$@'\" after ${TEST161_TIME_LIMIT} seconds (menu did not return) \x1b\[0m\n";
        exit 60;
     }
   }'
)}


os161-test() {(
    for i do
        os161-runtest $i
    done
)}

os161-testsuite() {(
    os161-test at bt tlt km1 km2 "km3 300" km4 tt1 tt2 tt3 sy1 sy2 sy3 sy4 "fs1 emu0:" "fs2 emu0:" "fs3 emu0:" "fs4 emu0:" "fs5 emu0:" "fs6 emu0:"
)}

os161-diskdiff() {
  if [ -z "$1" ]; then
      echo "Usage: $0 LHD-x.img LHD-y.img"
      return 22
  fi
  if [ -z "$2" ]; then
      echo "Usage: $0 LHD-x.img LHD-y.img"
      return 22
  fi

  xxd $1 > /tmp/os161-diska.tmp
  xxd $2 > /tmp/os161-diskb.tmp

  vimdiff /tmp/os161-diska.tmp /tmp/os161-diskb.tmp
}

os161-debug() {(
    cd ${OS161_ROOT_DIR} && rlwrap -aOS/161 sys161 -w kernel "$@"
)}

os161-user-build() {(
    if [ "$1" ]; then
        pushd "${OS161_CODE_DIR}/userland/$1"
        bmake depend || return 1
        bmake || return 2
        bmake install || return 3
        return 0
    fi
    pushd ${OS161_ROOT_DIR}
    bmake -s || return 4
    popd > /dev/null
    pushd "${OS161_ROOT_DIR}/userland"
    bmake -s depend || return 5
    bmake -s || return 6
    bmake install -s || return 7
    popd > /dev/null
    )}

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
alias krt='os161-runtest'
alias kt='os161-test'
alias kd='os161-debug'
alias kdebug=kd
alias kg="cd ${OS161_ROOT_DIR} && mips-harvard-os161-gdb kernel"
alias kgdb=kg
alias ub='os161-user-build'
alias ubuild=ub

# Aliases to move to common directories
alias cdk="cd ${OS161_CODE_DIR}"
alias cdr="cd ${OS161_ROOT_DIR}"
alias cdu="cd ${OS161_CODE_DIR}/userland"
