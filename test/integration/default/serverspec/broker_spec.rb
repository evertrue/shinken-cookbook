require 'spec_helper'

describe 'shinken::broker' do
  describe 'livestatus' do
    describe file '/var/lib/shinken/var/rw' do
      it { is_expected.to be_owned_by 'shinken' }
    end

    describe file '/etc/shinken/modules/livestatus.cfg' do
      it { is_expected.to be_file }
      describe '#content' do
        subject { super().content }
        it do
          is_expected.to include 'define module {
    module_name     livestatus
    module_type     livestatus
    host *
    port 50000
    socket /var/lib/shinken/var/rw/live
    modules logstore-sqlite
}'
        end
      end
    end
  end
end
