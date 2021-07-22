require 'active_support'

pod_type = ENV["DG_POD_TYPE"]&.downcase
threads_count = ENV.fetch("RAILS_MAX_THREADS") {
  pod_type && pod_type == "api" ? 10 : 5
}.to_i
threads threads_count, threads_count

# threads above ends up being 5 in my local runs

puma_bind = (ENV.fetch("PUMA_BIND") { "tcp://0.0.0.0:9596" }) + "?backlog=5"
bind puma_bind

environment ENV.fetch("RAILS_ENV") { "development" }

app_dir = File.expand_path("../..", __FILE__)

unless get(:environment) == "development"
  pidfile "#{app_dir}/tmp/pids/puma.pid"
end

Thread.new do
  while(true) do
    sleep(10)
    printf Puma.stats
  end
end