require 'spec_helper'

describe 'ucspi-tcp::default' do
  let(:chef_log) { class_spy(Chef::Log) }

  context 'on Debian 7.5' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'debian', version: '7.5')
        .converge(described_recipe)
    end

    specify { expect(chef_run).to install_package('ucspi-tcp') }
  end

  context 'on an unknown distro' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'oracle').converge(described_recipe)
    end

    it 'should log a message to Chef::Log.info', :pending do
      expect(chef_log).to have_received(:info)
    end
  end

  # specify { expect(chef_run).to run_bash('install_ucspi') }
end
