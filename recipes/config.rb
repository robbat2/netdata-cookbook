netdata_config = '/etc/netdata/netdata.conf'
bind_addresses = %W{
	127.0.0.1:19999
	[::1]:19999
	#{node['mgmt_ip']}:19999
	}
bind_to = 'bind to = '+bind_addresses.join(' ')

# Add listen entry to netdata
ruby_block "add binding to "+netdata_config do
  block do
	require 'chef/util/file_edit'
    f = Chef::Util::FileEdit.new(netdata_config)
    f.search_file_replace(/^\s**#?\s*bind to.*$/, bind_to)
    f.write_file
  end
  not_if { ::File.readlines(netdata_config).grep(Regexp.escape(bind_to)).any? }
end
