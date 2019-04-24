require 'lolcommits/platform'

module Lolcommits
  class Runner
    attr_accessor :capture_delay, :capture_stealth, :capture_device, :message,
                  :sha, :snapshot_loc, :main_image, :config, :vcs_info,
                  :capture_animate

    def initialize(attributes = {})
      attributes.each do |attr, val|
        send("#{attr}=", val)
      end

      return unless sha.nil? || message.nil?
      if GitInfo.repo_root?
        self.vcs_info = GitInfo.new
      elsif MercurialInfo.repo_root?
        self.vcs_info = MercurialInfo.new
      else
        raise('Unknown VCS')
      end

      self.sha     = vcs_info.sha if sha.nil?
      self.message = vcs_info.message if message.nil?
    end

    def execute_plugins_for(hook)
      debug "#{self.class}: running all enabled plugin hooks for #{hook}"
      enabled_plugins.each do |plugin|
        if plugin.valid_configuration?
          plugin.send("run_#{hook}")
        else
          puts "Warning: skipping plugin #{plugin.name} (invalid configuration, fix with: lolcommits --config -p #{plugin.name})"
        end
      end
    end

    # wrap run to handle things that should happen before and after
    # this used to be handled with ActiveSupport::Callbacks, but
    # now we're just using a simple procedural list
    def run
      # do plugins that need to happen before capture
      execute_plugins_for(:pre_capture)

      # do main capture to snapshot_loc
      run_capture

      # check capture succeded, file must exist
      if File.exist?(snapshot_loc)
        ## resize snapshot first
        resize_snapshot!

        # execute post_capture plugins, use to alter the capture
        execute_plugins_for(:post_capture)

        # execute capture_ready plugins, capture is ready for export/sharing
        execute_plugins_for(:capture_ready)

        # clean away any tmp files
        cleanup!
      else
        debug 'Runner: failed to capture a snapshot'
        exit 1
      end
    end

    # the main capture
    def run_capture
      puts '*** Preserving this moment in history.' unless capture_stealth
      self.snapshot_loc = config.raw_image(image_file_type)
      self.main_image   = config.main_image(sha, image_file_type)

      capturer = Platform.capturer_class(capture_animated?).new(
        capture_device: capture_device,
        capture_delay: capture_delay,
        snapshot_location: snapshot_loc,
        video_location: config.video_loc,
        frames_location: config.frames_loc,
        animated_duration: capture_animate
      )
      capturer.capture
    end

    def capture_animated?
      capture_animate > 0
    end

    private

    def enabled_plugins
      @enabled_plugins ||= config.plugin_manager.enabled_plugins_for(self)
    end

    def image_file_type
      capture_animated? ? 'gif' : 'jpg'
    end

    def resize_snapshot!
      debug 'Runner: resizing snapshot'
      image = MiniMagick::Image.open(snapshot_loc)
      if image[:width] > 640 || image[:height] > 480
        # this is hacky resize-to-fill
        image.combine_options do |c|
          c.resize '640x480^'
          c.gravity 'center'
          c.extent '640x480'
        end
        debug "Runner: writing resized image to #{snapshot_loc}"
        image.write snapshot_loc
      end
      debug "Runner: copying resized image to #{main_image}"
      FileUtils.cp(snapshot_loc, main_image)
    end

    def cleanup!
      debug 'Runner: running cleanup'
      # clean up the captured image and any other raw assets
      FileUtils.rm(snapshot_loc)
      FileUtils.rm_f(config.video_loc)
      FileUtils.rm_rf(config.frames_loc)
    end
  end
end
