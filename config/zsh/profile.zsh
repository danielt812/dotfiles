_zprof_report() {
  local elapsed=""
  if [[ -n "${_zprof_start:-}" ]]; then
    elapsed=$(( EPOCHREALTIME - _zprof_start ))
  fi

  zprof | awk -v elapsed="$elapsed" '
    BEGIN {
      bold   = "\033[1m";  reset  = "\033[0m"
      dim    = "\033[2m";  red    = "\033[31m"
      yellow = "\033[33m"; green  = "\033[32m"
      maxlen = 8  # minimum = length of "function"
    }
    /^-/ { sep++; if (sep == 2) exit; next }
    $1 !~ /^[0-9]+\)$/ { next }
    {
      n++
      rank[n] = $1; sub(/\)/, "", rank[n])
      ms[n]   = $3
      pct[n]  = $5; sub(/%/, "", pct[n])
      name[n] = $NF
      if (length(name[n]) > maxlen) maxlen = length(name[n])
    }
    END {
      div = ""
      for (i = 0; i < maxlen + 25; i++) div = div "─"

      printf "%s%-4s  %-" maxlen "s  %8s  %7s%s\n",
             bold, "rank", "function", "ms", "total%", reset
      printf "%s%s%s\n", dim, div, reset

      for (i = 1; i <= n; i++) {
        color = (pct[i]+0 >= 20) ? red : (pct[i]+0 >= 5) ? yellow : green
        printf "%-4s  %-" maxlen "s  %8.2f  %s%6.2f%%%s\n",
               rank[i], name[i], ms[i], color, pct[i], reset
      }

      printf "%s%s%s\n", dim, div, reset
      if (elapsed + 0 > 0)
        printf "%sTotal startup time: %.0f ms%s\n", bold, elapsed * 1000, reset
    }
  '
}
