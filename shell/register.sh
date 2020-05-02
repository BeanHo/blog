#!/bin/bash
psid=0
APP_PORT=8101
APP_NAME=/app/demo/target/register.jar

checkpid() {
  javaps=`/app/jdk1.8.0_241/bin/jps -1 | grep $APP_NAME`
  if [ -n "$javaps" ]; then
    psid=`echo $javaps | awk '{print $1}'`
  else
    psid=0
  fi
}

start() {
  checkpid

  if [ $psid -ne 0 ]; then
    echo "============================================="
    echo "warn: $APP_NAME already started! pid=${psid}"
    echo "============================================="
  else
    echo -n "Starting $APP_NAME ..."
    # -DlogFn=active 指的是生产日志文件名为 active
    nohup java -jar $APP_NAME > nohup.out &

    # echo "(pid=$psid) [OK]"
    checkpid
    if [ $psid -ne 0 ]; then
      echo "(pid=$psid) [OK]"
    else
      echo "[Failed]"
    fi
  fi
}

stop() {
  checkpid

  if [ $psid -ne 0 ]; then
    echo -n "Stopping $APP_NAME ...(pid=$psid)"
    kill -9 $psid

    if [ $? -eq 0 ]; then
      echo "[OK]"
    else
      echo "[Failed]"
    fi

    checkpid
    if [ $psid -ne 0 ]; then
      stop
    fi

  else
    echo "================================"
    echo "warn: $APP_NAME is not running"
    echo "================================"
  fi
}

restart() {
  stop
  sleep 1
  start
}

status() {
  checkpid

  if [ $psid -ne 0 ]; then
    echo "$APP_NAME is running! pid=${psid}"
  else
    echo "$APP_NAME is not running"
  fi
}

case "$1" in
  'start')
    start
    ;;
  'stop')
    stop
    ;;
  'restart')
    restart
    ;;
  'status')
    status
    ;;
*)

echo "Usage:$0 {start|stop|restart|status|info}"
exit 1

esac
exit 0