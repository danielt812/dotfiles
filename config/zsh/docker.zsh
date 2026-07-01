# ##############################################################################
# #                               Docker Aliases                               #
# ##############################################################################

alias dps='docker ps --format "table {{.Names}} {{.Status}} {{.Ports}}"'
alias dpsa='docker ps -a'
alias dstart='docker start'
alias dstop='docker stop'
alias drestart='docker restart'
alias drm='docker rm'
alias drmf='docker rm -f'
alias dlogs='docker logs'
alias dlogsf='docker logs -f'
alias dimages='docker images'
alias drmi='docker rmi'
alias dpull='docker pull'
alias ddf='docker system df'
alias dprune='docker system prune -f'

# ##############################################################################
# #                           Docker Compose Aliases                           #
# ##############################################################################

alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcub='docker compose up -d --build'
alias dcd='docker compose down'
alias dcdv='docker compose down -v'
alias dcr='docker compose restart'
alias dcl='docker compose logs -f'
alias dcps='docker compose ps'
alias dce='docker compose exec'
alias dcb='docker compose build'

# ##############################################################################
# #                                 Functions                                  #
# ##############################################################################

dsh() { docker exec -it "$1" bash 2>/dev/null || docker exec -it "$1" sh; }
dcsh() { docker compose exec "$1" bash 2>/dev/null || docker compose exec "$1" sh; }
dclog() { docker compose logs -f --tail "${2:-100}" "$1"; }
dcservice() { docker compose up -d --build --no-deps "$1"; }
dcreset() { docker compose down -v --remove-orphans && docker compose up -d --build; }
dip() { docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$1"; }
dstats() { docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"; }
dports() { [ -z "$1" ] && docker ps --format "{{.Names}}\t{{.Ports}}" || docker port "$1"; }
dclean() { docker container prune -f && docker image prune -f && docker network prune -f && docker builder prune -f && docker system df; }
