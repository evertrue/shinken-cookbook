default['shinken']['webui'] = {
  'source_url' =>
    'https://github.com/shinken-monitoring/mod-webui/archive/BS3-1.0.zip',
  'source_checksum' =>
    'fa98d65ba556f4ed7c6f77f61b25726a6cb4729aa6f42b609cf0f05fed78abb6',
  'credentials_data_bag' => 'secrets',
  'credentials_data_bag_item' => 'monitoring',
  'port' => '7767',
  'modules' => %w(
    auth-cfg-password
    SQLitedb
  )
}
