web: bundle exec script/rails server -b ${ZAMMAD_BIND_IP:=0.0.0.0} -p ${PORT}
websocket: bundle exec script/websocket-server.rb -b ${ZAMMAD_BIND_IP:=0.0.0.0} -p ${ZAMMAD_WEBSOCKET_PORT:=6042} start
worker: bundle exec script/scheduler.rb start -t
