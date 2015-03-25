chef_gem 'chef-provisioning-ssh'
require 'chef/provisioning/ssh_driver'

# require 'chef/config'
# with_chef_server "http://192.168.1.182:8889", {
#   :client_name => Chef::Config[:node_name],
#   :signing_key_filename => Chef::Config[:client_key]
# # }
# with_chef_server({ :chef_server_url => "http://192.168.1.182:8889", :options => {
#         :client_name => Chef::Config[:node_name],,
#         :signing_key_filename => Chef::Config[:client_key],
#         :local_mode => false
#       })

# with_ssh_cluster "/home/js4/metal/chef-metal/docs/examples/drivers/ssh"
# with_driver 'ssh
with_driver 'ssh'
machine "sshone" do
  # action :destroy
  action [:ready, :setup, :converge]
  machine_options :transport_options => {
    'ip_address' => '192.168.33.122',
    'username' => 'vagrant',
    'ssh_options' => {
      'password' => 'vagrant'
    }
  }
  recipe 'vagrant::sshtwo'
  converge true
end

machine_execute "touch /tmp/test.txt" do
  machine 'sshone'
end

machine_file "/tmp/install-client.sh" do
  local_path "/tmp/install-client.sh"
  machine 'sshone'
  action :upload
end

machine "sshtwo" do
  # action :destroy
  action [:ready, :setup, :converge]
  machine_options :transport_options => {
    'ip_address' => '192.168.33.123',
    'username' => 'vagrant',
    'ssh_options' => {
      'keys' => ['/Users/zzondlo/.ssh/id_rsa']
    }
  }
  recipe 'vagrant::sshtwo'
  converge true
end