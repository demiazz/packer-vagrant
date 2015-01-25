require 'erb'
require 'fileutils'
require 'ostruct'
require 'thor'

class Builder
  ROOT_PATH      = File.dirname(__FILE__)
  TEMPLATES_PATH = File.join(ROOT_PATH, 'templates')
  TMP_PATH       = File.join(ROOT_PATH, 'tmp')

  def initialize(options)
    @id      = SecureRandom.uuid
    @options = options

    create_tmp_dir
    create_files
    build_image
    remove_tmp_dir
  end

  def tmp_path
    File.join(TMP_PATH, @id)
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

    FileUtils.mkdir_p(tmp_path)
  end

  def create_files
    Dir.glob(File.join(TEMPLATES_PATH, '**/*')).each do |template_path|
      if File.file?(template_path)
        base_path = template_path.gsub(/\A#{ TEMPLATES_PATH }\//, '')
        dest_path = File.join(tmp_path, base_path)

        FileUtils.mkdir_p(File.dirname(dest_path))

        template(template_path, dest_path)
      end
    end
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
  option :hostname, type: :string, default: 'vagrant'
  def build
    opts = options.merge({})

    opts[:password] ||= opts[:username]
    opts[:fullname] ||= opts[:username]

    Builder.new(opts)
  end
end
