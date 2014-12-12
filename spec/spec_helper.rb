require 'chefspec'
require 'chefspec/berkshelf'

# Because the pacman cookbook doesn't define these for ChefSpec
# (yet?)...
def build_pacman_aur(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:pacman_aur, :build, resource_name)
end

def install_pacman_aur(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:pacman_aur, :install, resource_name)
end

ChefSpec::Coverage.start!
