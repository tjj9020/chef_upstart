def whyrun_support?
  true
end

action :start do
  if @current_resource.exists
    chef::Log.info "#{ @new_resource } already exists - nothing to do."
  else
    converge_by("Start #{ @new_resource }") do
      start_upstart
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::UpstartProcess.new(new_resource.name)i
  @current_resource.name(new_resource.process_name)
  @current_resource.env_name(new_resource.env_name)
  @current_resource.process_number(new_resource.process_number)

  Chef::Log.info "process name: #{new_resource.process_name}, environment: #{new_resource.env_name}, process number:#{new_resource.process_number}"

  if process_exists?(@current_resource.name)
    @current_resource.exists = true
  end
end

def check_upstart_config?(config)
  config_file = ::File.exist?("/etc/init/#{config}.conf")
  if config_file == true
    Chef::Log.info "Configuration file #{config} is found"
    true
  else
    Chef::Log.info "Configuration file #{config} is not found"
    false
  end
end

def start_upstart
  Chef::Log.info "Attempting to startup the application..."
  i = 1
  upstart_config_installed = check_upstart_config?(new_resource.process_name)
  if upstart_config_installed == true
    #get the current amount of processes running
    cmd = "initctl list | grep #{new_resource.process_name} | grep running | grep #{@new_resource.env_name} | wc -l"
    cmd = Mixlib::ShellOut.new(cmd)
    cmd.run_command
    process_count = cmd.stdout

    #only startup enough processes to meet the requirement
    until i >  (new_resource.process_number.to_i - process_count.to_i)
      cmd = "start #{new_resource.process_name} ENV=#{new_resource.env_name} INDEX=#{i}"
      Chef::Log.info "Running: #{cmd}"
      cmd = Mixlib::ShellOut.new(cmd)
      cmd.run_command
      i += 1
    end
  else
    Chef::Log.info "Missing upstart configuration file #{new_resource.process_name} in /etc/init"
  end
end

def process_exists?(name)
  Chef::Log.info "Checking the following processes: #{new_resource.process_name}, #{new_resource.env_name}, #{new_resource.process_number}"

  #get count of current running processes for given process name
  cmd = "initctl list | grep #{new_resource.process_name} | grep running | grep #{@new_resource.env_name} | wc -l"
  Chef::Log.info "Looking for processes with the following command: #{cmd}"

  cmd = Mixlib::ShellOut.new(cmd)
  cmd.run_command
  process_count = cmd.stdout

  if process_count != new_resource.process_number
    Chef::Log.info "Not enough processes running #{process_count}, we need #{new_resource.process_number}."
    false
  else
    Chef::Log.info "Right number of processes running"
    true
  end
end


