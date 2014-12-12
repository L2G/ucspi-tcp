require 'spec_helper'

describe 'ucspi-tcp::default' do
  let(:chef_log) { class_spy(Chef::Log) }

  # Shared examples

  shared_examples 'a default package installation' do
    specify { expect(chef_run).to install_package('ucspi-tcp') }
    specify { expect(chef_run.node['ucspi']['bin_dir']).to eq('/usr/bin') }
  end

  shared_examples 'a default source build and installation' do
    specify { expect(chef_run).to run_bash('install_ucspi') }
    specify { expect(chef_run.node['ucspi']['bin_dir']).to eq('/usr/local/bin') }
  end

  # Arch

  context 'on Arch Linux' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new do |node|
        node.automatic['platform'] = 'arch'
      end
      runner.converge('pacman')
      runner.converge(described_recipe)
    end

    specify { expect(chef_run).to build_pacman_aur('ucspi-tcp') }
    specify { expect(chef_run).to install_pacman_aur('ucspi-tcp') }
    specify { expect(chef_run.node['ucspi']['bin_dir']).to eq('/usr/bin') }
  end

  # CentOS

  context 'on CentOS 6.5' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5')
        .converge(described_recipe)
    end

    it_should_behave_like 'a default source build and installation'
  end

  # Debian

  # This version is not covered by Fauxhai
  context 'on Debian 4.0' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.automatic['platform'] = 'debian'
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform_version'] = '4.0'
      end.converge(described_recipe)
    end

    it_should_behave_like 'a default source build and installation'
  end

  context 'on Debian 7.5' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'debian', version: '7.5')
        .converge(described_recipe)
    end

    it_should_behave_like 'a default package installation'
  end

  # Gentoo

  context 'on Gentoo' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'gentoo', version: '2.1')
        .converge(described_recipe)
    end

    specify { expect(chef_run).to install_package('sys-apps/ucspi-tcp') }
    specify { expect(chef_run.node['ucspi']['bin_dir']).to eq('/usr/bin') }
  end

  # Ubuntu

  # These versions are not covered by Fauxhai
  %w(6.06 6.10 7.04 7.10 8.04).each do |ubuntu_version|
    context "on Ubuntu #{ubuntu_version}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.automatic['platform'] = 'ubuntu'
          node.automatic['platform_family'] = 'debian'
          node.automatic['platform_version'] = ubuntu_version
        end.converge(described_recipe)
      end

      it_should_behave_like 'a default source build and installation'
    end
  end

  %w(10.04 14.04).each do |ubuntu_version|
    context "on Ubuntu #{ubuntu_version}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'ubuntu', version: ubuntu_version)
          .converge(described_recipe)
      end

      it_should_behave_like 'a default package installation'
    end
  end

  # Unknown platforms

  context 'on an unknown distro' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'oracle').converge(described_recipe)
    end

    it 'should log a message to Chef::Log.info', :pending do
      expect(chef_log).to have_received(:info)
    end
  end
end
