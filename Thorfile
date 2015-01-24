require 'thor'

class Packer < Thor
  desc 'build', 'Execute the packer builder'
  def build
    system 'packer build packer.json'
  end
end
