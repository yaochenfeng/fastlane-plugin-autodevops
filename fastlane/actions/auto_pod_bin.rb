module Fastlane
  module Actions
    module SharedValues
      AUTO_POD_BIN_CUSTOM_VALUE = :AUTO_POD_BIN_CUSTOM_VALUE
    end

    class AutoPodBinAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        podName = params[:pod_name]
        configuration = params[:configuration]
        UI.message "PodName: #{podName} configuration: #{configuration}"

        # sh "shellcommand ./path"

        # Actions.lane_context[SharedValues::AUTO_POD_BIN_CUSTOM_VALUE] = "my_val"
        command = ['xcodebuild -project Pods/Pods.xcodeproj']#-sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone XS' ONLY_ACTIVE_ARCH=NO ARCHS='i386 x86_64' BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" ENABLE_BITCODE=YES OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE=bitcode clean build']
        command << "-scheme #{podName}"
        command << "-configuration #{configuration}"
        command << "-sdk iphonesimulator"
        command << "clean build"
        result = Actions.sh(command.join(' '))

        command = ['xcodebuild -project Pods/Pods.xcodeproj']#-sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone XS' ONLY_ACTIVE_ARCH=NO ARCHS='i386 x86_64' BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" ENABLE_BITCODE=YES OTHER_CFLAGS="-fembed-bitcode" BITCODE_GENERATION_MODE=bitcode clean build']
        command << "-scheme #{params[:pod_name]}"
        command << "-configuration #{configuration}"
        command << "-sdk iphoneos"
        command << "build"
        result = Actions.sh(command.join(' '))
        other_action.create_xcframework(frameworks: ["build/#{configuration}-iphonesimulator/#{podName}/#{podName}.framework", "build/#{configuration}-iphoneos/#{podName}/#{podName}.framework"], output: "build/#{podName}.xcframework")
        # TODO: 资源文件处理
        other_action.zip(
          path: "build/#{podName}.xcframework",
          output_path: "#{podName}.xcframework.zip"
        )
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "自动处理pod二进制化"
      end

      def self.details
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :pod_name,
                                       env_name: "AUTO_POD_NAME", # The name of the environment variable
                                       description: "二进制化pod名称", # a short description of this parameter
                                       verify_block: proc do |value|
                                          UI.user_error!("pod 名称 `pod_name: 'name'`") unless (value and not value.empty?)
                                          # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :configuration,
                                        description: "configuration", # a short description of this parameter
                                        default_value: "Release")
        ]
      end

      def self.output
        [
          ['AUTO_POD_BIN_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        ["yaochenfeng"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
