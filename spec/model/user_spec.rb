require 'spec_helper'

  describe User do
    before :each do
      @user = User.new
    end
    it "should have valid factory" do
      assert_nil @user.login
      @user.login = "Chuckis"
      assert_equal @user.login, "Chuckis"
      assert_nil @user.fullname
      @user.fullname = "Chuckys"
      assert_equal @user.fullname, "Chuckys"
    end
  end

  describe User do
    before(:each) do
      @user = Factory.create(:user)
      puts @user.email
    end
    it "should respond to services" do
      should have_many(:services).dependent(:destroy)
    end
    it "should be valid" do
      @user.should be_valid
    end
    it "should not be valid without password confirmation" do
      @user.password = 'sikrets'
      @user.password_confirmation = nil
      assert_not_equal(@user.password, @user.password_confirmation)
    end
    it "should not be valid with confirmation not matching password" do
      @user.password = 'password'
      @user.password_confirmation = 'not confirmed'
      assert_not_equal(@user.password, @user.password_confirmation)
    end
    it {should ensure_length_of(:password).is_at_least(6)}
    it { should validate_uniqueness_of(:login) }
    it {should ensure_length_of(:login).is_at_least(6).is_at_most(20)}
    it { should validate_uniqueness_of(:email) }
  end


