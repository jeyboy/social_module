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
      @user = Factory.build (:user)
    end
    it "should respond to services" do
      @user.should respond_to(:services)
    end
    it "should not be uniq" do
    duplicate = User.new(:login => @user.login)
    assert_not_equal(assert_equal(@user.login, duplicate.login),false)
    end
    it "should be uniq" do
    duplicate = User.new(:login => @user.login+'a')
    assert_equal(assert_not_equal(@user.login, duplicate.login),true)
    end
  end


