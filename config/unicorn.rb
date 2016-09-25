# Устанавливаем количество процессов на сервере (Чем больше поток пользователей, тем больше нужно процессов)
application = "Appname"

worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)

working_directory "/var/www/apps/#{application}/current" # available in 0.94.0+

# Слушаем Unix domain socket и TCP порт
listen "/var/www/apps/#{application}/socket/.unicorn.sock", :backlog => 64
listen 8080, :tcp_nopush => true

# уничтожаем workers после 30 секунд вместо 60 дефолтных
timeout 30

# Устанавливаем путь к PID файлу главного процесса unicorn
pid "/var/www/apps/#{application}/run/unicorn.pid"

# Направляем потоки вывода
stderr_path "/var/www/apps/#{application}/log/unicorn.stderr.log"
stdout_path "/var/www/apps/#{application}/log/unicorn.stdout.log"

# Подгружаем приложение в память до того, как произойдет форк процессов. (Типа для memory savings)
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

#При включенной опции юникорн проверяет соединения клиентов, записывая начало
#хедера HTTP запроса до того, как он вызовется приложением. Это
#предотвращает вызов приложения для соединений, которые были отключены от очереди.
#Это лишь гарантирует определение клиентов на том же хосте, что и юникорн.
check_client_connection false

before_fork do |server, worker|

  # Следующее особенно рекомендовано для Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  # The following is only recommended for memory/DB-constrained
  # installations.  It is not needed if your system can house
  # twice as many worker_processes as you have configured.
  #
  # # This allows a new master process to incrementally
  # # phase out the old master process with SIGTTOU to avoid a
  # # thundering herd (especially in the "preload_app false" case)
  # # when doing a transparent upgrade.  The last worker spawned
  # # will then kill off the old master process with a SIGQUIT.
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
  #
  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  # sleep 1
end

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  # addr = "127.0.0.1:#{9293 + worker.nr}"
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection


  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end