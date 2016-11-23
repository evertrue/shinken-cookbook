default['shinken']['webui'] = {
  'source_url' =>
    'https://github.com/shinken-monitoring/mod-webui/archive/2.4.2c.zip',
  'source_checksum' =>
    '5119f504c5d467e43e0ea09f81fbedcc7a2ebf8549e531b276ed6b6b5874deaf',
  'credentials_data_bag' => 'secrets',
  'credentials_data_bag_item' => 'monitoring',
  'port' => '7767',
  'modules' => %w(
    auth-cfg-password
    SQLitedb
    ui-graphite
  )
}
