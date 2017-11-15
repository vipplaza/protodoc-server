if [ $1 = 'start' ];then
  rm -r node_modules/protodoc-server/proto
  cp -rf ./proto node_modules/protodoc-server
  convox start -f node_modules/protodoc-server/docker-compose.yml
elif [ $2 = 'deploy' ];then
  rm -r node_modules/protodoc-server/proto
  cp -rf ./proto node_modules/protodoc-server
  convox deploy -f node_modules/protodoc-server/docker-compose.yml
else
echo ' '
echo 'Usage: protodoc-server [commands]'
echo ' '
echo 'Commands:'
echo '  start                   Run local Convox container'
echo '  deploy                  Deploy convox container to AmazonECS via Convox'
echo ' '
fi