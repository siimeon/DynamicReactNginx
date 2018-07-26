#!/bin/bash
set -eu

sed_replace_nginx_conf() {
  template="/etc/nginx/conf.d/default.conf"
  echo "For file ${template}:"
  for var in $(env)
  do
    IFS="=" read -r key val <<< "$var"
    if grep -q "\${${key}}" "$template"
    then
      echo "- replacing ${key} with ${val}"
      sed -i "s/\${${key}}/${val}/g" $template
    fi
  done
}

sed_replace_main_js() {
  main_js=$(find /usr/share/nginx/html/static/js/main.*js)
  echo "For file ${main_js}:"
  for var in $(env)
  do
    IFS="=" read -r key val <<< "$var"
    if grep -q "%%variable%%${key}%%variable%%" "$main_js"
    then
      echo "- replacing ${key} with ${val}"
      sed -i "s#%%variable%%${key}%%variable%%#${val}#g" "$main_js"
    fi
  done
}

echo "Configuring nginx"
sed_replace_nginx_conf
echo "Configuring application"
sed_replace_main_js
echo "Starting nginx"
exec "$@"
