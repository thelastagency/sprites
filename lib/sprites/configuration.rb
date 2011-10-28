module Sprites
  class Configuration
    FIELDS = %w{sprites_path sprite_stylesheets_path sprite_pieces_path}

    DEFAULT_CONFIGURATION = {
      'sprites_path' => 'public/images/sprites',
      'sprite_stylesheets_path' => 'public/stylesheets/sprites',
      'sprite_pieces_path' => 'public/images/sprite_images'
    }

    def initialize
      DEFAULT_CONFIGURATION.each {|k,v| self.send(k, v)}
    end

    def configure(&blk)
      instance_eval(&blk)
      self
    end

    def configured?
      FIELDS.any? do |field|
        send(field) != DEFAULT_CONFIGURATION[field]
      end
    end

    FIELDS.each do |meth|
      eval <<-EVAL
        def #{meth}(*args)
          val, *_ = args

          if val
            @#{meth} = val
            return self
          end

          @#{meth}
        end
      EVAL
    end

    def self.new_for_command_line_options(options)
      config = new
      options.each do |k, v|
        if FIELDS.include?(k.to_s)
          config.send(k, v)
        end
      end
      config
    end
  end
end
