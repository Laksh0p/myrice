if status is-interactive
# Commands to run in interactive sessions can go here
# User local bin
set -Ux fish_user_paths $HOME/.local/bin $fish_user_paths
set -gx PATH $PATH /home/laksh/wordcounter
 fastfetch
alias wcj='java -cp /home/laksh/wordcounter WordCounter'
function clear
    printf '\033c'
 end
end
