default['shinken']['webui'] = {
  'source_url' =>
    'https://github.com/shinken-monitoring/mod-webui/archive/' \
      'f074f1a247239c66ab2b0f0cfc8fa529d44be289.zip',
  'source_checksum' =>
    '9a7ea588a6327654850fd44640b26fe61ddfd1cea6873b2b88e830d6342ce5b6',
  'credentials_data_bag' => 'secrets',
  'credentials_data_bag_item' => 'monitoring',
  'port' => '7767',
  'modules' => %w(
    auth-cfg-password
    SQLitedb
  )
}
