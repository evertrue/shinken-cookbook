include_recipe "shinken::#{node['shinken']['install_type']}"

python_pip 'pycurl'

# For better performance for the Shinken daemons' communication
python_pip 'cherrypy'
