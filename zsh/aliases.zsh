#
# Aliases
#
alias ls='ls --color'
alias ll='ls -l'
alias la='ls -a'

alias dm="python manage.py"

alias digg="dig +multiline +nocomments +nocmd +noquestion +nostats +search"

# Make mkdir recursive
alias mkdir='mkdir -p'

# tmux
alias tm='tmux -u2'

# Server control
alias df='df -kH'

alias grep='grep --color=auto -I --exclude="*\.svn*"'

alias tou='top -o cpu'
alias tom='top -o vsize'

# convert newlines to LF
alias convert_newlines="perl -pi -e 's/\r\n/\n/g'"

# SVN
alias sco='svn co'
alias sup='svn up'
alias sci='svn ci -m'
alias saa='svn status | grep "^\?" | awk "{print \$2}" | xargs svn add'
alias scleann="svn status --no-ignore | grep '^\?' | sed 's/^\?      //'  | xargs rm -rf"
alias slog="python ~/.files/bin/svnlog.py"
alias smm='svn merge "^/www/branches/maint" -c'
alias smf='svn merge "^/www/branches/factory" -c'
alias sdif='svn diff'

# horse ebooks
alias horse="while true; do curl -s http://horseebooksipsum.com/api/v1/ | say; done;"

# yolo
alias git-yolo='git commit -am "`curl -s http://whatthecommit.com/index.txt`"'

# sl
alias sl='~/.files/bin/sl.sh'

# vagrant
alias vup='vagrant up'
alias vupno='vagrant up --no-provision'
alias vre='vagrant halt && vagrant up --no-provision'
alias vh='vagrant halt'
alias vp='vagrant provision'
alias vsh='vagrant ssh'
alias vst='vagrant status'
alias vgst='vagrant global-status'
