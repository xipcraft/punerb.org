require 'pune_ruby/utils'

module PuneRuby
  class Store
    class << self
      include Utils

      attr_reader  :db

      def init_db
        @db = FaultTolerantConnection.new(init_redis)
      end

      def init_redis
        uri = URI.parse(ENV['OPENREDIS_URL'] || 'redis://0.0.0.0')

        EventMachine::Synchrony::ConnectionPool.new(:size => (ENV['REDIS_CONN_POOL_SIZE'] || 36)) do
          Redis.new({
            :host          => uri.host,
            :port          => uri.port,
            :password      => uri.password,
            :driver        => :synchrony,
            :timeout       => 0,
            :tcp_keepalive => {
              :time   => 5,
              :intvl  => 5,
              :probes => 2
            }
          })
        end
      end

    private

      def new_key_for(model_plural)
        t = Time.now.to_i
        i = ''
        r = ''
        task = Proc.new do |variable|
          @global_db.multi
          @global_db.get("next_#{model_plural}_id")
          @global_db.incr("next_#{model_plural}_id")
          r = @global_db.exec
          i = r[0]
        end
        raise "Failed" if r.nil?
        task.call
        task.call if i.nil?

        "#{model_plural}:#{i}:#{t}"
      end

      def flush_db
        if ENV['RACK_ENV'] == 'test'
          EM.synchrony {
            if PuneRuby::Store.respond_to? :db
              PuneRuby::Store.db.keys.each do |key|
                PuneRuby::Store.db.del(key)
              end
            end
            EM.stop
          }
        else
          raise "Are you fking insane?!"
        end
      end
    end

    class FaultTolerantConnection
      def initialize(db, retries=20,db_error=Redis::BaseConnectionError, db_factory=PuneRuby::Store, db_constructor=:init_redis, *db_args)
        @db, @retries, @db_error, @db_factory, @db_constructor, @db_args = db, retries, db_error, db_factory, db_constructor, db_args

        @mutex = Mutex.new
      end

      def method_missing(meth, *args, &blk)
        begin
          @db.send(meth, *args, &blk)
        rescue @db_error => e
          if @retries > 0
            reconnect
            @retries -= 1
            retry
          else
            raise e
          end
        end
      end

     private

      def reconnect
        @mutex.synchronize do
          @db = @db_factory.send(@db_constructor, *@db_args)
        end
      end
    end
  end
end