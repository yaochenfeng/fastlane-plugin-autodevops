describe Fastlane::Actions::AutodevopsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The autodevops plugin is working!")

      Fastlane::Actions::AutodevopsAction.run(nil)
    end
  end
end
