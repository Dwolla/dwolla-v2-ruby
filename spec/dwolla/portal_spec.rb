require "spec_helper"

describe Dwolla::Portal do
  it 'acts as a portal for calling methods with a parent as the first arg' do
    klass = Class.new do
      def initialize parent, *args, &block
      end
    end
    parent = 'parent'
    portal = Dwolla::Portal.new parent, klass
    args = [1,2,3]
    block = Proc.new {}
    expect(klass).to receive(:new).with(parent, *args, &block)
    portal.new(*args)
  end
end
