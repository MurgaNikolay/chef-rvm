include_recipe 'rvm::packages'
node['rvm']['users'].each do |username, rvm_settings|
  next if rvm_settings['rubies']
  rubies = rvm_settings['rubies']
  rubies = Array(rubies) if rubies.is_a?(String)
  rubies.each do |version, action|
    resource_config = {}
    resource_config['version'] = version if version.is_a?(String)
    resource_config['action'] = action if action.is_a?(String)
    resource_config.merge!(action) if action.is_a?(Hash)
    rvm_ruby "#{username}:#{resource_config['version']}" do
      user username
      version resource_config['version']
      default resource_config['default']
      patch resource_config['patch']
      action resource_config['action'] if resource_config['action']
    end
  end
end
