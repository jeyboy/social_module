require "spec_helper"

describe "routes to the services controller" do
  it "routes a named route" do
    {:delete => service_path}.
      should route_to(:controller => "services", :action => "destroy")
  end
end