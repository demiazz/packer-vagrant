require 'erb'
require 'fileutils'
require 'ostruct'
require 'thor'

class Builder
  ROOT_PATH = File.dirname(__FILE__)
  TMP_PATH  = File.join(ROOT_PATH, 'tmp')

  def initialize(options)
    @id      = SecureRandom.uuid
    @options = options

    create_tmp_dir
    create_packer_json
    create_preseed_cfg
    build_image
    remove_tmp_dir
  end

  def tmp_path
    File.join(TMP_PATH, @id)
  end

  def http_path
    File.join(tmp_path, 'http')
  end

  def packer_path
    File.join(tmp_path, 'packer.json')
  end

  def template(src_path, dest_path)
    File.open(dest_path, 'w') do |dest|
      erb    = ::ERB.new(File.read(src_path))
      result = erb.result(::OpenStruct.new(@options).instance_eval { binding })

      dest.write(result)
    end
  end

  def create_tmp_dir
    Dir.mkdir(TMP_PATH) unless File.directory?(TMP_PATH)

    FileUtils.mkdir_p(http_path)
  end

  def create_packer_json
    source      = File.join(ROOT_PATH, 'templates/packer.json')
    destination = File.join(tmp_path, 'packer.json')

    template(source, destination)
  end

  def create_preseed_cfg
    source      = File.join(ROOT_PATH, 'templates/preseed.cfg')
    destination = File.join(http_path, 'preseed.cfg')

    template(source, destination)
  end

  def build_image
    # TODO: replace with packer invoke, instead simple puts of command
    puts("packer build #{ packer_path }")
  end

  def remove_tmp_dir
    FileUtils.rm_r(tmp_path)
  end
end

class Packer < Thor
  desc 'build', 'Execute the packer builder'
  option :username, type: :string, default: 'vagrant'
  option :password, type: :string
  option :fullname, type: :string
  def build
    opts = options.merge({})

    opts[:password] ||= opts[:username]
    opts[:fullname] ||= opts[:username]

    Builder.new(opts)
  end
end
