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

    configure_public_keys
    configure_private_keys
    create_tmp_dir
    create_keys_dir
    create_files
    link_packer_cache
    build_image
    remove_tmp_dir
  end

  def configure_public_keys
    unless @options[:vagrant_public_key].length > 0
      @options[:use_official_public_key] = true

      return
    end

    @options[:vagrant_public_key] = File.expand_path(
      @options[:vagrant_public_key]
    )
  end

  def configure_private_keys
    @options[:private_keys].map! do |path|
      private_key_path = File.expand_path(path)
      private_key_name = File.basename(path)
      public_key_path  = "#{ private_key_path }.pub"
      public_key_name  = "#{ private_key_name }.pub"

      {
        private_key_path: private_key_path,
        private_key_name: private_key_name,
        public_key_path: public_key_path,
        public_key_name: public_key_name
      }
    end
  end

  def tmp_path
    File.join(TMP_PATH, @id)
  end

  def keys_path
    File.join(tmp_path, 'keys')
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

  def create_keys_dir
    FileUtils.mkdir_p(keys_path)
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

  def link_packer_cache
    packer_cache_path = File.join(ROOT_PATH, 'packer_cache')
    link_cache_path   = File.join(tmp_path, 'packer_cache')

    Dir.mkdir(packer_cache_path) unless File.directory?(packer_cache_path)

    FileUtils.ln_s(packer_cache_path, link_cache_path)
  end

  def build_image
    system("cd #{ tmp_path }; packer build packer.json; cd #{ ROOT_PATH }")
  end

  def remove_tmp_dir
    FileUtils.rm_r(tmp_path)
  end
end

class Packer < Thor
  desc 'build', 'Execute the packer builder'
  option :username,           type: :string, default: 'vagrant'
  option :password,           type: :string
  option :fullname,           type: :string
  option :hostname,           type: :string, default: 'vagrant'
  option :vagrant_public_key, type: :string, default: ''
  option :private_keys,       type: :array,  default: []
  def build
    opts = options.merge({})

    opts[:password] ||= opts[:username]
    opts[:fullname] ||= opts[:username]

    Builder.new(opts)
  end
end
