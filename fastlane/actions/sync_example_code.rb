module Fastlane
  module Actions
    module SharedValues
      SYNC_EXAMPLE_CODE_CUSTOM_VALUE = :SYNC_EXAMPLE_CODE_CUSTOM_VALUE
    end

    class SyncExampleCodeAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        UI.message "开始同步https://github.com/yaochenfeng/Example"

        sh "rm -Rf build/Example"
        sh "git clone https://github.com/yaochenfeng/Example build/Example"
        sh "rsync -av --exclude=Business  build/Example/Example  ./"
        if other_action.prompt(text: "项目生成文件同步: ", boolean: true, ci_input: "n")
          sh "rsync -av build/Example/project.yml  ./"
        end
        if other_action.prompt(text: "项目lint文件同步: ", boolean: true, ci_input: "n")
          sh "rsync -av build/Example/.swiftlint.yml  ./"
        end
        UI.message "清理临时文件"
        sh "rm -Rf build/Example"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "sync_example_code"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "同步 https://github.com/yaochenfeng/Example"
      end

      def self.available_options
        []
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['SYNC_EXAMPLE_CODE_CUSTOM_VALUE', 'A description of what this value contains']
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
