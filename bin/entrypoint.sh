up(){
  touch Dockerfile
  echo 'node_modules/*\n!*/protodoc-server' > .dockerignore
  mkdir -p ./node_modules/protodoc-server/doc
}
down(){
  dfempty=$(wc -c <Dockerfile | xargs)
  [[ $dfempty -lt '1' ]] || rm Dockerfile
  dicontent=$(cat .dockerignore | xargs)
  [[ $dicontent != 'node_modules' ]] || rm .dockerignore
  [[ ! -f .package.json.remote ]] || rm .package.json.remote
  [[ ! -f .server.js.remote ]] || rm .server.js.remote
}
localConf(){
  # convox start's ADD declaration is looking at node_modules/ptorodoc-server
  [[ ! -f node_modules/protodoc-server/proto ]] || rm -r node_modules/protodoc-server/proto
  cp -r proto node_modules/protodoc-server
}
remoteConf(){
  # convox deploy's ADD declaration is looking at ./
  cp node_modules/protodoc-server/server.js .server.js.remote
  cp node_modules/protodoc-server/package.json .package.json.remote
}

opt=$2

if [[ $1 = 'start' ]];then
  up
  localConf
  convox start -f node_modules/protodoc-server/docker-compose.yml.local $opt
  down
elif [[ $1 = 'deploy' ]];then
  up
  remoteConf
  convox deploy -f node_modules/protodoc-server/docker-compose.yml.remote $opt
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
