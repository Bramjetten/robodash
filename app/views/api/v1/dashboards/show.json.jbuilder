json.partial! "api/v1/dashboards/dashboard", dashboard: @dashboard
json.widgets @dashboard.widgets.sort_by(&:name), partial: "api/v1/dashboards/widget", as: :widget
