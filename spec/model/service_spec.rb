require 'spec_helper'

describe Service do

  before(:each) do
    @user = Factory(:user)
    @service = Factory(:service)
  end

  it { should belong_to(:user) }
  it { @service.should be_valid}
  it { @service.should_not be_new_record}

end
