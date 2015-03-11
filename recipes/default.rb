
package 'python-pip'
package 'python-m2crypto'
package 'supervisor'

python_pip "shadowsocks" do
  action :install
end

node['shadowsocks']['servers'].each do |server|
  name = server.fetch('name')

  directory '/etc/shadowsocks' do
    action :create
  end

  template "/etc/shadowsocks/#{name}.json" do
    source "shadowsocks.json.erb"
    variables({
      :server_port => server.fetch('server_port').to_i,
      :local_port => server['local_port'] || 1080,
      :password => server.fetch('password')
    })
    action :create
  end

  template "/etc/supervisor/conf.d/ss_#{name}.conf" do
    source "shadowsocks.conf.erb"
    variables({
      :name => name
    })
    action :create
  end

end

ruby_block 'set supervisor ulimit' do
  block do
    file = Chef::Util::FileEdit.new('/etc/default/supervisor')
    file.insert_line_if_no_match(/^ulimit/, 'ulimit -n 51200')
    file.write_file
  end
end

service "supervisor" do
  supports :start => true, :stop => true, :restart => true
  action :start
end

execute 'supervisorctl reload' do
  action :run
end
