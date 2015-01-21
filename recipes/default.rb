
node['upstart']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

#Example
#The configuration files for upstart go into /etc/init
#This example will assume a process call start_batch.conf
#
#
#node['upstart']['config'].each do |file|
#  template "upstart file #{file}" do
#    source file
#    path "/etc/init/#{file}"
#    owner "root"
#    group "root"
#    mode "0644"
#    variables({:base_dir => node['upstart']['base_dir'],
#      :ruby_path => "/usr/local/rvm/wrappers/default/ruby"
#      })
#    action :create
#  end
#end
#
#
#
#upstart_process "start_batch" do
#  name "start_batch"
#  env_name "production"
#  process_number 16
#  action :start
#end
