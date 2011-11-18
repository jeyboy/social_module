require 'spec_helper'

describe ServicesController, :type => :controller do
#  describe "POST new" do



  it 'should return a 401 with no basic auth to /api/v1/rewards' do
    @user = Factory.create(:user)
    @service = Factory.create(:service)
    sign_in @user
    puts @service.instance_values
    puts @user.instance_values
    #post 'create', :service => @service
    assert_not_nil(:service)
    assigns(:service).should
    #response.code.should == '401'
    #response.body.should == "Unauthorized - Please check your username and password"
  end

  #describe "GET Index" do
  #  it "gets the index view" do
  #    get "index"
  #    response.status.should be 200
  #  end
  #
  #  it "gets the correct index view template" do
  #    get "index"
  #    response.should render_template("users/index")
  #  end
end

#it 'should return a 401 with no basic auth to /api/v1/rewards' do
#  delete ':destroy'
#  response.code.should == '401'
#  response.body.should == "Unauthorized - Please check your username and password"
#end
#describe ServicesController, :type => :controller do
#  describe "POST new" do
#    it "should register the new account" do
#      post :create, @service = Factory(:service)
#      assigns[:service].provider.should == "open_id"
#    end
#  end
#end

#before(:each) do
#  @baby = Factory.build(:baby)
#end
#
#it "is valid with proper values" do
#  @baby.should be_valid
#end
#describe "DELETE destroy" do
#  before do
#    @service = mock(:service, :destroy => true)
#    Service.stub!(:get).and_return(@service)
#  end
#
#  it "should find the user" do
#    Service.should_receive(:get).with('1').and_return(@service)
#    do_request
#  end
#
#  it "should destroy the user" do
#    @user.should_receive(:destroy).and_return(true)
#    do_request
#  end
#
#  it "should redirect" do
#    do_request.should redirect_to(url(:users))
#  end
#end
#
#
#describe ServicesController do
#
#	  describe "access control" do
#	    it "should deny access to 'create'" do
#	      post :create
#	      response.should redirect_to(services_url)
#	    end
#
#	    it "should deny access to 'destroy'" do
#	      delete :destroy, :id => 1
#	      response.should redirect_to :index
#	    end
#	  end
#
#it "should be able to destroy an account" do
#     @service = Factory(:service)
#     Service.should_receive(:find).and_return(@service)
#     @service.should_receive(:destroy)
#
#     delete :destroy, :id => @service
#
#     Service.all.should == []
#     response.should be_success
#     response.should redirect_to services_url
#end
#end
#describe "widgets resource" do
#  describe "GET index" do
#    it "contains the widgets header" do
#      get "/services/create"
#      response.should have_selector("h1", :content => "Services")
#    end
#  end
#end
#
#delete("/services/id").should route_to(
#  :controller => "services",
#  :action => "destroy",
#  :id => "0"
#)

#describe "routes for Widgets" do
#  delete("assets/services/0").should route_to(
#    :controller => "services",
#    :action => "destroy",
#    :id => "0"
#  )
#end

#describe "user routes" do
#  describe "delete /" do
#    it { delete("/services/id").should route_to "services#destroy" }
#  end

#describe "POST /" do
#  it { post("/").should be_routable }
#end
#end
