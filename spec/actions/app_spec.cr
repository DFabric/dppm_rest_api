require "../../src/actions"
require "../spec_helper"

module DppmRestApi::Actions::App
  describe DppmRestApi::Actions::App do
    describe (fmt_route "/:app_name/config/:key/get") do
      it "responds with 401 Unauthorized" do
        get fmt_route "/some-app/config/key/get"
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/config/:key/add") do
      it "responds with 401 Forbidden" do
        post fmt_route "/some-app/config/key/add"
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/config/:key/set") do
      it "responds with 401 Forbidden" do
        put fmt_route "/some-app/config/key/set"
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/config/:key/delete") do
      it "responds with 401 Forbidden" do
        delete fmt_route "/some-app/config/key/delete"
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/config") do
      it "responds with 401 Forbidden" do
        get fmt_route "/some-app/config"
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/service/boot") do
      it "responds with 401 Forbidden" do
        put (fmt_route "/some_app/service/boot")
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/service/reload") do
      it "responds with 401 Forbidden" do
        put (fmt_route "/some_app/service/reload")
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/service/restart") do
      it "responds with 401 Forbidden" do
        put (fmt_route "/some-app/service/restart")
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/service/start") do
      it "responds with 401 Forbidden" do
        put (fmt_route "/some-app/service/start")
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/service/status") do
      it "responds with 401 Forbidden" do
        get fmt_route "/some-app/service/status"
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/service/stop") do
      it "responds with 401 Forbidden" do
        put (fmt_route "/some-app/service/stop")
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/libs") do
      it "responds with 401 Forbidden" do
        get fmt_route "/some-app/libs"
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/app") do
      it "responds with 401 Forbidden" do
        get fmt_route "/some-app/app"
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/pkg") do
      it "responds with 401 Forbidden" do
        get fmt_route "/some-app/pkg"
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/logs") do
      it "responds with 401 Forbidden" do
        get fmt_route "/some-app/logs"
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/install") do
      it "responds with 401 Forbidden" do
        put fmt_route "/some-pkg/install"
        assert_unauthorized response
      end
    end
    describe (fmt_route "/:app_name/remove") do
      it "responds with 401 Forbidden" do
        delete fmt_route "/some-app/remove"
        assert_unauthorized response
      end
    end
  end
end
