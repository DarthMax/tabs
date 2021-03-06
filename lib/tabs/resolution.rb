module Tabs
  module Resolution
    include Resolutionable
    extend self

    def register(klass)
      @@resolution_classes ||= {}
      @@resolution_classes[klass.name] = klass
    end

    def unregister(resolutions)
      resolutions = Array[resolutions].flatten
      resolutions.each{ |res| @@resolution_classes.delete(res) }
    end

    def serialize(resolution, timestamp)
      resolution_klass(resolution).serialize(timestamp)
    end

    def deserialize(resolution, str)
      resolution_klass(resolution).deserialize(str)
    end

    def from_seconds(resolution, s)
      resolution_klass(resolution).from_seconds(s)
    end

    def add(resolution, ts, num)
      resolution_klass(resolution).add(ts, num)
    end

    def normalize(resolution, timestamp)
      resolution_klass(resolution).normalize(timestamp)
    end

    def all
      @@resolution_classes.keys
    end

    def expire(resolution, key, timestamp)
      resolution_klass(resolution).expire(key, timestamp)
    end

    def reset_default_resolutions
      @@resolution_classes = {}
      Tabs::Resolution.register(Tabs::Resolutions::Minute)
      Tabs::Resolution.register(Tabs::Resolutions::Hour)
      Tabs::Resolution.register(Tabs::Resolutions::Day)
      Tabs::Resolution.register(Tabs::Resolutions::Week)
      Tabs::Resolution.register(Tabs::Resolutions::Month)
      Tabs::Resolution.register(Tabs::Resolutions::Year)
    end

    private

    def resolution_klass(resolution)
      klass = @@resolution_classes[resolution]
      raise Tabs::ResolutionMissingError.new(resolution) unless klass
      klass
    end

  end
end

Tabs::Resolution.reset_default_resolutions
