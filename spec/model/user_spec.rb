require 'spec_helper'

  describe User do

    before :each do
      @user = User.new
    end

    it "should have valid factory" do
      assert_nil @user.login
      @user.login = "Chuck"
      assert_equal @user.login, "Chuck"
      assert_nil @user.fullname
      @user.fullname = "Chucky"
      assert_equal @user.fullname, "Chucky"
    end
  end

  describe User do
    before(:each) do
      @user = Factory.create(:user)
    end
    it "should respond to services" do
      @user.should respond_to(:services)
    end
    it "should be valid" do
      @user.should be_valid
    end
    it "must have a login and fullname" do
      @user[:login].should_not be_empty
      @user[:fullname].should_not be_empty
    end
    it { should validate_uniqueness_of(:login) }
  end


