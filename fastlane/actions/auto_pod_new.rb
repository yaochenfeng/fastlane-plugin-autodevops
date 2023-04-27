require 'fileutils'
module Fastlane
  module Actions
    module SharedValues
      AUTO_POD_NAME = :AUTO_POD_NAME
      AUTO_POD_REPO = :AUTO_POD_REPO
    end

    class AutoPodNewAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        UI.message "pod name: #{params[:pod_name]} #{user_name}"
        genPodspec(params)
        genSource(params)
        Actions.sh('bundle exec pod install')
        UI.success("Successfully new pod ⬆️ ")
      end
      def self.genSource(params)
        path = "Sources/#{params[:pod_name]}/"
        FileUtils.mkdir_p(path) unless File.exists?(path)
        content = "@_exported import RXKit"
        File.open(path + "Export.swift", "w") { |file| file.puts content }
      end
      def self.genPodspec(params)
        podName = params[:pod_name]
        podspec = %Q`
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
Pod::Spec.new do |s|
  s.name = '#{podName}'
  s.author = { "#{user_name}" => "#{user_email}" }
  s.homepage = "https://github.com/#{user_name}/#{podName}"
  s.source           = { :git => "https://github.com/#{user_name}/#{podName}.git", :tag => s.version.to_s }
  
`
        podspec << %q`
  # pod
  s.version = "0.1.0"
  s.summary = "#{s.name}"
    s.description = <<-DESC
    "#{s.name}" description
  DESC
    s.license = {
      :type => "MIT",
      :text => "MIT"
  }
  s.platform = :ios, "11.0"
  s.swift_version = "5"
  s.source_files = "Sources/#{s.name}/**/*.swift"
  s.dependency "RXKit"
end
  `
      File.open("#{podName}.podspec", "w") { |file| file.puts podspec }
      end
      def self.user_name
        (ENV['GIT_COMMITTER_NAME'] || github_user_name || `git config user.name` || `<GITHUB_USERNAME>` ).strip
      end
  
      def self.github_user_name
        github_user_name = `security find-internet-password -s github.com | grep acct | sed 's/"acct"<blob>="//g' | sed 's/"//g'`.strip
        is_valid = github_user_name.empty? or github_user_name.include? '@'
        return is_valid ? nil : github_user_name
      end
  
      def self.user_email
        (ENV['GIT_COMMITTER_EMAIL'] || `git config user.email`).strip
      end
  
      def self.year
        Time.now.year.to_s
      end
  
      def self.date
        Time.now.strftime "%m/%d/%Y"
      end
      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        "pod 模板生成文件生成处理"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :pod_name,
                                       env_name: "AUTO_POD_NAME", # The name of the environment variable
                                       description: "pod名称", # a short description of this parameter
                                       verify_block: proc do |value|
                                        UI.user_error!("pod 名称 `pod_name: 'name'`") unless (value and not value.empty?)
                                        # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                     end)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['AUTO_POD_NAME', 'pod名称']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["yaochenfeng"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
