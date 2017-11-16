up(){
  touch Dockerfile
  mkdir -p ./node_modules/protodoc-server/doc
  rm -r ./node_modules/protodoc-server/proto
  cp -rf ./proto node_modules/protodoc-server
}
down(){
  c=$(wc -c <Dockerfile)
  if [[ $c -lt '1' ]]; then
    rm Dockerfile
  fi
}

if [[ $1 = 'start' ]];then
  up
  convox start -f node_modules/protodoc-server/docker-compose.yml
  down
elif [[ $1 = 'deploy' ]];then
  up
  convox deploy -f node_modules/protodoc-server/docker-compose.yml
  down
else
echo ' '
echo 'Usage: protodoc-server [commands]'
echo ' '
echo 'Commands:'
echo '  start                   Run local Convox container'
echo '  deploy                  Deploy convox container to AmazonECS via Convox'
echo ' '
fi
