default['shinken']['broker'] = {
  'port' => '7772',
  'livestatus' => {
    'port' => 50_000,
    'modules' => [
      'logstore-sqlite'
    ]
  },
  'modules' => [
    'webui2',
    'livestatus'
  ]
}
