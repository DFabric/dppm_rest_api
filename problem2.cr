# not actually a different problem just a different way of writing it
require "kemal"
require "spec-kemal"

ROUTES = [
  {"GET", "/dppmrestapi/actions/app/:app_name/config/:key"},
  {"POST", "/dppmrestapi/actions/app/:app_name/config/:key"},
  {"PUT", "/dppmrestapi/actions/app/:app_name/config/:key"},
  {"DELETE", "/dppmrestapi/actions/app/:app_name/config/:key"},
  {"GET", "/dppmrestapi/actions/app/:app_name/config"},
  {"PUT", "/dppmrestapi/actions/app/:app_name/service/boot"},
  {"PUT", "/dppmrestapi/actions/app/:app_name/service/reload"},
  {"PUT", "/dppmrestapi/actions/app/:app_name/service/restart"},
  {"PUT", "/dppmrestapi/actions/app/:app_name/service/start"},
  {"PUT", "/dppmrestapi/actions/app/:app_name/service/status"},
  {"PUT", "/dppmrestapi/actions/app/:app_name/service/stop"},
  {"GET", "/dppmrestapi/actions/app/:app_name/libs"},
  {"GET", "/dppmrestapi/actions/app/:app_name/app"},
  {"GET", "/dppmrestapi/actions/app/:app_name/pkg"},
  {"GET", "/dppmrestapi/actions/app/:app_name/logs"},
  {"PUT", "/dppmrestapi/actions/app/:package_name"},
  {"DELETE", "/dppmrestapi/actions/app/:app_name"},
  {"GET", "/dppmrestapi/actions/pkg"},
  {"DELETE", "/dppmrestapi/actions/pkg"},
  {"GET", "/dppmrestapi/actions/pkg/:id"},
  {"DELETE", "/dppmrestapi/actions/pkg/:id"},
  {"POST", "/dppmrestapi/actions/pkg/build/:package"},
  {"GET", "/dppmrestapi/actions/service"},
  {"GET", "/dppmrestapi/actions/service/status"},
  {"PUT", "/dppmrestapi/actions/service/:service/boot"},
  {"PUT", "/dppmrestapi/actions/service/:service/reload"},
  {"PUT", "/dppmrestapi/actions/service/:service/restart"},
  {"PUT", "/dppmrestapi/actions/service/:service/start"},
  {"GET", "/dppmrestapi/actions/service/:service/status"},
  {"PUT", "/dppmrestapi/actions/service/:service/stop"},
  {"GET", "/dppmrestapi/actions/src"},
  {"GET", "/dppmrestapi/actions/src/:type"},

]

{% for pair in ROUTES %}
  {%
    method = pair[0]
    route = pair[1]
  %}
  {{method.downcase.id}} {{route}} do
    log {{route}}
    {{route}}
  end
{% end %}
Kemal.run port: 12345
{% for pair in ROUTES %}
  {%
    method = pair[0]
    route = pair[1]
  %}
  describe %[{{method.downcase.id}} {{route}}] do
    it "acts on the right path" do
      {{method.downcase.id}} {{route}}.gsub ':', ""
      response.status.should eq HTTP::Status::OK
      response.body.should eq {{route}}
    end
  end
{% end %}
