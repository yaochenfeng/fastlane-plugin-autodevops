require 'fastlane/action'
require_relative '../helper/autodevops_helper'

module Fastlane
  module Actions
    class AutodevopsAction < Action
      def self.run(params)
        UI.message("The autodevops plugin is working!")
      end

      def self.description
        "自动化"
      end

      def self.authors
        ["yaochenfeng"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "podapp 自动化处理"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :pod_name,
                                  env_name: "AUTODEVOPS_POD_NAME",
                               description: "自动化pod名称",
                                  optional: true,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
